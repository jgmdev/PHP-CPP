#
#   PHP-CPP Makefile
#
#   This makefile has a user friendly order: the top part of this file contains 
#   all variable settings that you may alter to suit your own system, while at
#   the bottom you will find instructions for the compiler in which you will
#   probably not have to make any changes
#   

#
#   Zend header files
#
#   The variable PHP_DIR contains the location on your system where the regular
#   header files of the Zend engine can be found. Usually this is either
#   /usr/include/php5 or /usr/local/include/php5. Inside this directory you
#   will find sub-directories named TSRM, Zend, ext and main.
#

PHP_DIR         =   /usr/include/php5


#
#   PHP binary file
#
#   The path to the executable PHP binary file.
#   Need to run tests.
#   You can see the command "whereis php"
#

PHP_BIN         =   /usr/bin/php


#
#   Installation directory
#
#   When you install the PHP-CPP library, it will place a number of C++ *.h 
#   header files in your system include directory, and a libphpcpp.so shared
#   library file in your system libraries directory. Most users set this to
#   the regular /usr/include and /usr/lib directories, or /usr/local/include
#   and /usr/local/lib. You can of course change it to whatever suits you best
#   

INSTALL_PREFIX  =   /usr
INSTALL_HEADERS =   ${INSTALL_PREFIX}/include
INSTALL_LIB     =   ${INSTALL_PREFIX}/lib


#
#   Name of the target library name
#
#   The PHP-CPP library will be installed on your system as libphpcpp.so.
#   This is a brilliant name. If you want to use a different name for it,
#   you can change that here
#

RESULT          =   libphpcpp.so


#
#   Compiler
#
#   By default, the GNU C++ compiler is used. If you want to use a different
#   compiler, you can change that here. You can change this for both the 
#   compiler (the program that turns the c++ files into object files) and for
#   the linker (the program that links all object files into a single .so
#   library file. By default, g++ (the GNU C++ compiler) is used for both.
#

COMPILER        =   g++
LINKER          =   g++


#
#   Compiler flags
#
#   This variable holds the flags that are passed to the compiler. By default, 
#   we include the -O2 flag. This flag tells the compiler to optimize the code, 
#   but it makes debugging more difficult. So if you're debugging your application, 
#   you probably want to remove this -O2 flag. At the same time, you can then 
#   add the -g flag to instruct the compiler to include debug information in
#   the library (but this will make the final libphpcpp.so file much bigger, so
#   you want to leave that flag out on production servers).
#

COMPILER_FLAGS  =   -Wall -c -I. -I${PHP_DIR} -I${PHP_DIR}/main -I${PHP_DIR}/ext -I${PHP_DIR}/Zend -I${PHP_DIR}/TSRM -g -std=c++11 -fpic -o


#
#   Linker flags
#
#   Just like the compiler, the linker can have flags too. The default flag
#   is probably the only one you need.
#

LINKER_FLAGS    =   -shared `php-config --ldflags`


#
#   Command to remove files, copy files and create directories.
#
#   I've never encountered a *nix environment in which these commands do not work. 
#   So you can probably leave this as it is
#

RM              =   rm -f
CP              =   cp -f
MKDIR           =   mkdir -p


#
#   The source files
#
#   For this we use a special Makefile function that automatically scans the
#   src/ directory for all *.cpp files. No changes are probably necessary here
#

SOURCES         =   $(wildcard src/*.cpp)


#
#   The object files
#
#   The intermediate object files are generated by the compiler right before
#   the linker turns all these object files into the libphpcpp.so shared library.
#   We also use a Makefile function here that takes all source files.
#

OBJECTS         =   $(SOURCES:%.cpp=%.o)


#
#   End of the variables section. Here starts the list of instructions and
#   dependencies that are used by the compiler.
#

all: ${OBJECTS} ${RESULT}
	@echo
	@echo "Build complete."
	@echo "Don't forget to run 'make test'."
	@echo

${RESULT}: ${OBJECTS}
	${LINKER} ${LINKER_FLAGS} -o $@ ${OBJECTS}

clean:
	${RM} ${OBJECTS} ${RESULT}

${OBJECTS}: 
	${COMPILER} ${COMPILER_FLAGS} $@ ${@:%.o=%.cpp}

install:
	${MKDIR} ${INSTALL_HEADERS}/phpcpp
	${CP} phpcpp.h ${INSTALL_HEADERS}
	${CP} include/*.h ${INSTALL_HEADERS}/phpcpp
	${CP} ${RESULT} ${INSTALL_LIB}
test:
	cd tests && ./test.sh -p ${PHP_BIN}

