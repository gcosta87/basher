#!/bin/bash
#
# controller.sh
# 	Controladores + Routing definidos por el Usuario
#
# Autor: Gonzalo Gabriel Costa (twitter.com/gcosta87)
# Ver el archivo LICENSE para la informacion del liberación del codigo de este proyecto.
# web: https://github.com/gcosta87/basher

##
##	CONTROLLERS
##
index(){
	sendHTMLResponse $HTTP_STATUS_200 "<!doctype html><html><h1>Request</h1>original=${REQUEST["$REQUEST_ORIGINAL"]}<br/>method=${REQUEST["$REQUEST_METHOD"]}<br/>path=${REQUEST["$REQUEST_PATH"]}</html>";
}

html(){
	sendRawFileResponse "${CONFIG[resources_dir_root]}/index.html";
}


hola(){
	sendPlainTextResponse 'Hola mundo!';
}


##
##	ROUTING
##
ROUTING['/']='index';
ROUTING['/hola']='hola';
ROUTING['/html']='html';

