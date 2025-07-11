#########################################################################
     # Simple makefile for packaging Listen Boise channel
     #
     # Makefile Usage:
     # > make
     # > make install
     # > make remove
     #
     # Important Notes: 
     # To use the "install" and "remove" targets to install your
     # application directly from the shell, you must do the following:
     #
     # 1) Make sure that you have the curl command line executable in your path
     # 2) Set the variable ROKU_DEV_TARGET in your environment to the IP 
     #    address of your Roku box. (e.g. export ROKU_DEV_TARGET=192.168.1.1.
     #    Set in your this variable in your shell startup (e.g. .bashrc)
     ##########################################################################  
     APPNAME = ListenBoise
     VERSION = 1.0
     APP_CHECK_DISABLED=true
     ZIP_EXCLUDE= -x \*.pkg -x storeassets\* -x keys\* -x \*/.\*
     include ./app.mk