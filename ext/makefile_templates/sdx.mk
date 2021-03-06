#
# Copyright 2019 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This makefile configures the SDx tool.

# MK_BEGIN

TOOL_VERSION ?= 2018.3

ifeq (,$(XILINX_SDX))
XILINX_SDX = /opt/xilinx/SDx/$(TOOL_VERSION)
ifeq (,$(wildcard $(XILINX_SDX)/bin/xocc))
$(error "Cannot locate SDx installation. Please set XILINX_SDX variable.")
endif
endif
export XILINX_SDX

ifeq (,$(XILINX_XRT))
XILINX_SDX = /opt/xilinx/xrt
ifeq (,$(wildcard $(XILINX_SDX)/lib/libxilinxopencl.so))
$(error "Cannot locate XRT installation. Please set XILINX_XRT variable.")
endif
endif
export XILINX_XRT

export PATH := $(XILINX_SDX)/bin:$(XILINX_XRT)/bin:$(PATH)

ifeq (,$(LD_LIBRARY_PATH))
export LD_LIBRARY_PATH := $(shell $(XILINX_SDX)/bin/ldlibpath.sh $(XILINX_SDX)/lib/lnx64.o):$(XILINX_XRT)/lib
else
export LD_LIBRARY_PATH := $(shell $(XILINX_SDX)/bin/ldlibpath.sh $(XILINX_SDX)/lib/lnx64.o):$(XILINX_XRT)/lib:$(LD_LIBRARY_PATH)
endif

# Target check
TARGET ?= sw_emu
ifeq ($(filter $(TARGET),sw_emu hw_emu hw),)
$(error TARGET is not sw_emu, hw_emu or hw)
endif

