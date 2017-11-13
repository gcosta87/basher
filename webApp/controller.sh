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
#Ejemplo de respuesta de satisfactoria (200) en HTML con datos del request
#index(){
#	sendHTMLResponse $HTTP_STATUS_200 "<!doctype html><html><h1>Request</h1>original=${REQUEST["$REQUEST_ORIGINAL"]}<br/>method=${REQUEST["$REQUEST_METHOD"]}<br/>path=${REQUEST["$REQUEST_PATH"]}</html>";
#}

#Ejemplo de respuesta de archivo HTML del directorio «no publico» (/resources)
#html(){
#	sendRawFileResponse "${CONFIG[resources_dir_root]}/index.html";
#}

#Ejemplo de respuesta de texto plano
#holaMundo(){
#	sendPlainTextResponse 'Hola mundo!';
#}


serverUptime(){
	uptimePretty=`uptime -p | sed -e 's:up ::' -e 's:hour:hora:' -e 's:minute:minuto:' -e 's:second:segundo:'`;
	uptimeDesde=`uptime -s`;
	sendJSONResponse "{\"uptime\":\"$uptimePretty\",\"desde\":\"$uptimeDesde\"}";
}

serverInfo(){
	hostname=`hostname`;
	ipLocal=`hostname -I`;
	ipRemota=`wget -qO- ifconfig.co`;
	kernel=`uname --kernel-release`;
	sendJSONResponse "{\"hostname\":\"$hostname\",\"ip\":{\"local\":\"$ipLocal\",\"remota\":\"$ipRemota\"},\"kernel\":\"$kernel\"}";
}


serverResources(){
	memoriaLibre=`free -h | sed -n 3p | tr -s ' ' | sed -r -e 's;^[^:]+:\s+;;' | cut -f2 -d' '`;
	memoriaUsada=`free -h | sed -n 3p | tr -s ' ' | sed -r -e 's;^[^:]+:\s+;;' | cut -f1 -d' '`;
	sendJSONResponse "{\"memoria\":{\"libre\":\"$memoriaLibre\",\"usada\":\"$memoriaUsada\"}}";
}


##
##	ROUTING
##
ROUTING['/api/uptime']='serverUptime';
ROUTING['/api/info']='serverInfo';
ROUTING['/api/recursos']='serverResources';

