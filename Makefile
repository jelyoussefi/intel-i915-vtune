#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash
CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
KERNEL_DIR = ${CURRENT_DIR}/intel-gpu-i915-backports


KERNEL_VERSION=5.15.0-75


#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
default: install 


install_prerequisite:
	@$(call msg, Installing Prerequisite  ...)
	@sudo apt install dkms make debhelper devscripts build-essential flex bison gawk

install_kernel_sources:
	@$(call msg, Installing the Kernel source  ...)
	@sudo apt install linux-headers-${KERNEL_VERSION}-generic 

		
install: 
	@if [ ! -f "${KERNEL_DIR}/.done" ]; then \
		rm -rf ${CURRENT_DIR}/intel-gpu-i915-backports/ && \
		git clone -b ubuntu/main https://github.com/intel-gpu/intel-gpu-i915-backports && \
		touch ${KERNEL_DIR}/.done; \
	fi
	@make -C ${KERNEL_DIR} i915dkmsdeb-pkg OS_DISTRIBUTION=UBUNTU_20.04_GENERIC && \
	sudo dpkg -i intel-i915-dkms_*.deb

	

clean:
	@$(call msg, Cleaning   ...)
	@rm -rf intel-i915-dkms*

#----------------------------------------------------------------------------------------------------------------------
# helper functions
#----------------------------------------------------------------------------------------------------------------------
define msg
	tput setaf 2 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo  "" && \
	echo "         "$1 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo "" && \
	tput sgr0
endef

