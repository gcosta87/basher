#!/bin/bash
#
# functions.sh
# 	Funcones comunes a todos los componetes de Basher
#
# Autor: Gonzalo Gabriel Costa (twitter.com/gcosta87)
# Ver el archivo LICENSE para la informacion del liberación del codigo de este proyecto.
# web: https://github.com/gcosta87/basher

basherUptime(){
	ps -p $(cat .pid) -o etime | tail -n1 | tr -s ' ' | sed -r  's:^\s+::';
}