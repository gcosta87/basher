#!/bin/bash
# 
# constants.sh
# 	Archivo para definir constantes que sean accedidas por los distintos modulos / componentes
# 	de Basher.
#
#
##
##	CONSTANTES
##

#version de Basher
declare -r BASHER_VERSION='0.1';

#Archivo para almacenar el process id
declare -r PID_FILE=".pid"

# Paths relativos a los archivos definidos por el usuario
declare -r BASHER_USER_CONFIG='./webApp/config.sh';
declare -r BASHER_USER_CONTROLLER='./webApp/controller.sh';
