#
# My dotfiles installer
#

DEST_DIR = ./test-zone
DOTFILES_SRC = vimrc bashrc

# Look for available user programs
ECHO ?= echo
TPUT ?= tput

# This ensures that even when echo is a shell builtin, we still use the binary
# (the builtin doesn't always understand -n)
FIXED_ECHO	:= $(if $(findstring -n,$(shell $(ECHO) -n)),$(shell which echo),$(ECHO))
ECHO		    := $(if $(FIXED_ECHO),$(FIXED_ECHO),$(ECHO))

# Handle terminal colors (if available)
ifdef NO_COLOR
tput		=
else
tput		= $(shell $(TPUT) $1)
endif

# Colors and styles
black	  := $(call tput,setaf 0)
red	    := $(call tput,setaf 1)
green	  := $(call tput,setaf 2)
yellow	:= $(call tput,setaf 3)
blue	  := $(call tput,setaf 4)
magenta	:= $(call tput,setaf 5)
cyan	  := $(call tput,setaf 6)
white	  := $(call tput,setaf 7)
bold	  := $(call tput,bold)
uline	  := $(call tput,smul)
reset	  := $(call tput,sgr0)

# Combine colors and styling here
DOT_WARNING	  ?= magenta
DOT_ERROR	    ?= red
DOT_INFO	    ?= green
DOT_DEBUG     ?= cyan
DOT_SUCCESS	  ?= green
DOT_FAILURE	  ?= red

# Generate style combinations with: $(call get-color,THE_COLOR_NAME)
get-color	= $(subst $(space),,$(foreach c,$(DOT_$1),$($c)))

# Set usable colors
C_WARNING	  := $(call get-color,WARNING)
C_ERROR		  := $(call get-color,ERROR)
C_INFO		  := $(call get-color,INFO)
C_DEBUG     := $(call get-color,DEBUG)
C_SUCCESS	  := $(call get-color,SUCCESS)
C_FAILURE	  := $(call get-color,FAILURE)
C_R   		  := $(reset)

help:
	@$(ECHO) 'Makefile for dotfiles (including OS-specific porting of configs)'
	@$(ECHO) ''
	@$(ECHO) 'Usage:'
	@$(ECHO) '   make diff                diff src dotfiles & installed dotfiles (are updates needed?)'
	@$(ECHO) '   make check               check environment to see if make will succeed'
	@$(ECHO) '   make test                verify that install procedure succeeded'
	@$(ECHO) '   make clean               remove temp files, dependencies, and sources from build directory'
	@$(ECHO) '   make uninstall           remove dotfiles completely from user environment'
	@$(ECHO) ''
	@$(ECHO) '   $(C_DEBUG)make fonts$(C_R)               install custom fonts'
	@$(ECHO) '   $(C_DEBUG)make bash$(C_R)                install bashrc'
	@$(ECHO) '   $(C_DEBUG)make vim$(C_R)                 install vim files'
	@$(ECHO) '   $(C_DEBUG)make vim-plugins$(C_R)         fetch vim pathogen plugins'
	@$(ECHO) ''
	@$(ECHO) '   $(C_FAILURE)make$(C_R)                 fetch and prepare everything'
	@$(ECHO) '   $(C_FAILURE)make install$(C_R)             make all, then install to DEST_DIR ($(DEST_DIR))'

vim:
ifeq ($(shell uname),Darwin)
	echo "ITSAMAC!"
	exit 1
else
	echo "Not a mac..."
endif

vim-plugins: vim
	git submodule init
	git submodule update

	# Build command-t's c-plugin
	cd ./vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make

diff:
	@for f in $(DOTFILES_SRC); do \
		diff -q ./$$f ~/.$$f;\
	done

install: update dotfiles

test: diff

clean:
	# TODO: Sanely clean up

