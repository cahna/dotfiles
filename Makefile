#
# My dotfiles installer
#

HOSTNAME = $(shell hostname)
DEST_DIR = ./test-zone
DOTFILES_SRC = vimrc bashrc

# Look for available user programs
ECHO ?= echo
TPUT ?= tput
MKDIR_P ?= mkdir -p
CURL_SSO ?= curl -Sso
VIM_EXECUTABLE ?= $(shell which vi)

# This ensures that even when echo is a shell builtin, we still use the binary
# (the builtin doesn't always understand -n)
FIXED_ECHO := $(if $(findstring -n,$(shell $(ECHO) -n)),$(shell which echo),$(ECHO))
ECHO := $(if $(FIXED_ECHO),$(FIXED_ECHO),$(ECHO))

# Handle terminal colors (if available)
ifdef NO_COLOR
tput =
else
tput = $(shell $(TPUT) $1)
endif

# Colors and styles
black   := $(call tput,setaf 0)
red     := $(call tput,setaf 1)
green   := $(call tput,setaf 2)
yellow  := $(call tput,setaf 3)
blue    := $(call tput,setaf 4)
magenta	:= $(call tput,setaf 5)
cyan    := $(call tput,setaf 6)
white   := $(call tput,setaf 7)
bold    := $(call tput,bold)
uline   := $(call tput,smul)
reset   := $(call tput,sgr0)

# Combine colors and styling here
DOT_WARNING       ?= magenta
DOT_ERROR         ?= red
DOT_INFO          ?= green
DOT_DEBUG         ?= cyan
DOT_SUCCESS       ?= green
DOT_FAILURE       ?= red

# Generate style combinations with: $(call get-color,THE_COLOR_NAME)
get-color         = $(subst $(space),,$(foreach c,$(DOT_$1),$($c)))

# Set usable colors
C_WARNING         := $(call get-color,WARNING)
C_ERROR           := $(call get-color,ERROR)
C_INFO            := $(call get-color,INFO)
C_DEBUG           := $(call get-color,DEBUG)
C_SUCCESS         := $(call get-color,SUCCESS)
C_FAILURE         := $(call get-color,FAILURE)
C_R               := $(reset)

help:
	@$(ECHO) ''
	@$(ECHO) 'Makefile wrapping common ansible setup tasks'
	@$(ECHO) 'Usage:'
	@$(ECHO) '   $(C_INFO)make check$(C_R)               show diff (are updates needed?)'
	@$(ECHO) '   $(C_INFO)make install$(C_R)             provision localhost configuration with ansible'
	@$(ECHO) '   $(C_INFO)make info$(C_R)                show ansible information'
	@$(ECHO) ''

check:
	/usr/bin/env ansible-playbook -i hosts site.yml --check --diff

install:
	/usr/bin/env ansible-playbook -i hosts site.yml

facts:
	/usr/bin/env ansible ass -i hosts -m setup

