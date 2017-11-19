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


basher(){
	version=` grep -m1 'VERSION' server/basher.sh | cut -f2 -d'=' | tr -d "';"`;
	#se calcula el comienzo y tiempo transcurrido de basher (segun su pid).info: uptime start
	uptimeBasher=`ps -p $(cat .pid) -o etime | tail -n1 | tr -s ' ' | sed -r  's:^\s+::'`;

	#rutas definidas por el usuario
	rutasDinamicas=` grep -E  'ROUTING\[[^\]+]' webApp/controller.sh | wc -l`;
	#se listan recursivamente los archivos, excluyendo del conteo a los directorios
	rutasEstaticas=`ls -AR  "${CONFIG[public_dir_root]}" | grep -vE ':$' | grep -vE '^$' | wc -l`;
	recursosCantidadArchivos=`ls -AR "${CONFIG[resources_dir_root]}" | grep -vE ':$' | grep -vE '^$' | wc -l`;

	controladores=`grep -E  'ROUTING\[[^\]+]' webApp/controller.sh | cut -f2 -d'=' | sort | uniq | wc -l`;
	sendJSONResponse "{\"version\":$version,\"uptime\":\"$uptimeBasher\",\"rutas\":{\"dinamicas\":$rutasDinamicas,\"estaticas\":$rutasEstaticas},\"recursos\":$recursosCantidadArchivos,\"controladores\":$controladores}";
}


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
	memoriaLibre=`free | sed -n 3p | tr -s ' ' | sed -r -e 's;^[^:]+:\s+;;' | cut -f2 -d' '`;
	memoriaUsada=`free | sed -n 3p | tr -s ' ' | sed -r -e 's;^[^:]+:\s+;;' | cut -f1 -d' '`;

	memoriaPorcUsada=`echo -e "scale = 2\n($memoriaUsada * 100) / ($memoriaLibre + $memoriaUsada)" | bc `;

	nombreCPU=`cat /proc/cpuinfo | grep 'model name' | head -n1 | sed -r 's;^model name\s+:\s+;;'`;
	cantidadCores=`cat /proc/cpuinfo | grep 'processor' | wc -l`;
	cpuPorcUso=`(echo "scale = 2"; ps -A -o pcpu | tail -n+2 | paste -sd+ ;) | bc`;
	cantidadProcesos=`ps -A | tail -n+2 | wc -l`;

	sendJSONResponse "{\"memoria\":{\"libre\":\"$memoriaLibre\",\"usada\":\"$memoriaUsada\",\"uso\":\"$memoriaPorcUsada\"},\"cpu\":{\"nombre\":\"$nombreCPU\",\"cores\":$cantidadCores,\"uso\":$cpuPorcUso,\"procesos\":$cantidadProcesos}}";
}


##
##	ROUTING
##
ROUTING['/api/basher']='basher';
ROUTING['/api/uptime']='serverUptime';
ROUTING['/api/info']='serverInfo';
ROUTING['/api/recursos']='serverResources';

