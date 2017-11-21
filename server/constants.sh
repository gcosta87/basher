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

#Archivo para almacenar el las propiedades mas importantes de la instancia que esta corriendo
declare -r PROPERTY_FILE='instance.properties';

declare -r PROPERTY_KEY_PID='pid';
declare -r PROPERTY_KEY_PORT='port';
declare -r PROPERTY_KEY_IP='ip';

declare -r BASHER_SCRIPT='./server/basher.sh';

# Paths relativos a los archivos definidos por el usuario
declare -r BASHER_USER_CONFIG='./webApp/config.sh';
declare -r BASHER_USER_CONTROLLER='./webApp/controller.sh';