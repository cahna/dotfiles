#
# Build/install for my dotfiles
#

all:
	# Get vim plugins
	git submodule init
	git submodule update

	# Build command-t's c-plugin
	cd ./vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make

install:
	#TODO: Copy files to where they should be

clean:
	#TODO: Sanely clean up

