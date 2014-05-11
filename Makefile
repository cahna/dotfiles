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
	@$(ECHO) 'Makefile for dotfiles (including OS-specific porting of configs)'
	@$(ECHO) 'Usage:'
	@$(ECHO) '   $(C_INFO)make diff$(C_R)                diff src dotfiles & installed dotfiles (are updates needed?)'
	@$(ECHO) '   $(C_INFO)make check$(C_R)               check environment to see if make will succeed'
	@$(ECHO) '   $(C_INFO)make test$(C_R)                verify that install procedure succeeded'
	@$(ECHO) '   $(C_INFO)make clean$(C_R)               remove temp files, dependencies, and sources from build directory'
	@$(ECHO) '   $(C_INFO)make uninstall$(C_R)           remove dotfiles completely from user environment'
	@$(ECHO) ''
	@$(ECHO) '   $(C_INFO)make fonts$(C_R)               install custom fonts'
	@$(ECHO) '   $(C_INFO)make bash$(C_R)                install bashrc'
	@$(ECHO) '   $(C_INFO)make vim$(C_R)                 install vim files'
	@$(ECHO) '   $(C_INFO)make vim-plugins$(C_R)         fetch vim pathogen plugins'
	@$(ECHO) ''
	@$(ECHO) '   $(C_INFO)make$(C_R)	                   fetch and prepare everything'
	@$(ECHO) '   $(C_INFO)make install$(C_R)             make all, then install to DEST_DIR ($(DEST_DIR))'
	@$(ECHO) ''

all: vim
	# Protect against committing changes directly to master on a new host
	git checkout -b $(HOSTNAME) || git checkout $(HOSTNAME)

vim: vim/autoload/pathogen.vim vim/bundle/command-t/ruby

$(HOME)/.vim:
	ln -s $(CURDIR)/vim $(HOME)/.vim

$(HOME)/.vimrc:
	ln -s $(CURDIR)/vimrc $(HOME)/.vimrc

vim/autoload/pathogen.vim:
	mkdir -p $(CURDIR)/vim/autoload
	wget --no-check-certificate -O $(CURDIR)/vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

vim/bundle/command-t/ruby: vim/autoload/pathogen.vim
	mkdir -p $(CURDIR)/vim/bundle
	git submodule init
	git submodule update
	cd $(CURDIR)/vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make

git-config:
	git config --global user.name 'Conor Heine'
	git config --global user.email 'conor.heine@gmail.com'
	git config --global push.default simple

diff:
	@for f in $(DOTFILES_SRC); do \
		diff -q $(CURDIR)/$$f $(HOME)/.$$f;\
	done

install: $(HOME)/.vim $(HOME)/.vimrc

test: diff

clean:
	rm -rf $(CURDIR)/vim/autoload
	rm -rf $(CURDIR)/vim/bundle

uninstall:
	unlink $(HOME)/.vimrc
	unlink $(HOME)/.vim

