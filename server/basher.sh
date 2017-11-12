#!/bin/bash
#
# Basher
# 	Un pequeño servicio web escrito en Bash!.
#	Inspirado en bashHHTP https://github.com/avleen/bashttpd/
#
# Autor: Gonzalo Gabriel Costa (twitter.com/gcosta87)
# Ver el archivo LICENSE para la informacion del liberación del codigo de este proyecto.
# web: https://github.com/gcosta87/basher
#

##
##	CONSTANTES / CONFIGURACIONES
##

declare -r BASHER_SERVER='Basher version 0.1';
# Paths relativos a los archivos definidos por el usuario
declare -r BASHER_USER_CONFIG='./server/config.sh';
declare -r BASHER_USER_CONTROLLER='./webApp/controller.sh';

# Posibles estados de respuesta HTTP
declare -r HTTP_STATUS_200=200;
declare -r HTTP_STATUS_404=404;
declare -r HTTP_STATUS_500=500;

declare -A HTTP_STATUS=(
	[200]='200 OK'
	[404]='404 Not Found'
	[500]='500 Internal Server Error'
)


# Atributos de un request
declare -r REQUEST_ORIGINAL='original'
declare -r REQUEST_PATH='path'
declare -r REQUEST_METHOD='method'


declare -r CONTENT_TYPE_HTML='text/html; charset=utf-8';
declare -r CONTENT_TYPE_TEXT='text/plain; charset=utf-8';

declare -A CONFIG=(
	# public resources root: assets, js, public data
	[public_dir_root]='./public'

	#private web resources: hidden files,etc.
	[resources_dir_root]='./resources'

	#alias or name of default index file, when user access to a directory
	[default_index_filename]='index.html'

	#404 template response
	[template_404]='<!doctype html><html><center>Error 404 :(<br/><small>(Not Found)</small></center></html>'
	[template_fileNotFound]='<!doctype html><html><center>File not found! :(</center></html>'

	[template_500]='<!doctype html><html><center>Error 500 :(<br/><small>(Internal Server Error)</small></center></html>'
)

# Configuracion del ruteo/routing
declare -A ROUTING;

# definicion de una solicitud
declare -A REQUEST;



##
##	FUNCIONES
##

# Envia una respuesta de texto plano customizable (util para html,texto plano,...)
# $1 (string): constante HTTP_STATUS_XXX  
# $2 (string): constante CONTENT_TYPE_ABC 
# $3 (string): el contenido
# Ejemplo sendRawTextResponse $HTTP_STATUS_200 "$CONTENT_TYPE_TEXT" 'Hola Mundo!';
sendRawTextResponse(){
		now=`date -R`;

		#calcula la longitud en bytes!
		lenght=`echo "$3" | wc -c`;
		echo -en "HTTP/1.0 ${HTTP_STATUS[$1]}\r\nServer: $BASHER_SERVER\r\nDate: $now\r\nContent-Type: $2\r\nContent-Length: $lenght\r\nConnection: close\r\n\r\n";
		echo "$3";
}

# Envia una respuesta satisfactoria (HTTP 200) de texto plano
# $1 (string): el contenido (texto plano) 
# Ejemplo sendPlainTextResponse 'Hola Mundo!';
sendPlainTextResponse(){
	sendRawTextResponse $HTTP_STATUS_200 "$CONTENT_TYPE_TEXT" "$1";
}

# Envia una respuesta HTML con determinado estado HTTP.
# $1 (string): constante HTTP_STATUS_XXX 
# $2 (string): contenido/código HTML
# Ejemplo sendHTMLResponse $HTTP_STATUS_200 '<html><h1>Bienvenido!</h1><body>Hola mundo!</body></html>';
sendHTMLResponse(){
	sendRawTextResponse "$1" "$CONTENT_TYPE_HTML" "$2";
}

# Envia una respuesta 404 en HTML
send404HTMLResponse(){
	sendHTMLResponse $HTTP_STATUS_404 "${CONFIG[template_404]}";
}

# Envia una respuesta 500 en HTML
send500HTMLResponse(){
	sendHTMLResponse $HTTP_STATUS_500 "${CONFIG[template_500]}";
}

#Detecta el tipo mime. Si es conocido, se retorna un valor prestablecido sino se intenta determinar analizando
#el archivo con el comando file.
#$1 (string): archivo 
#return mime type
detectMimeType(){
	extension=${1##*.};

	case $extension in
		html)
			echo 'text/html; charset=utf-8';;
		js)
			echo 'application/javascript; charset=utf-8';;
		css)
			echo 'text/css; charset=utf-8';;
		json)
			echo 'application/json; charset=utf-8';;
		*)
			file -b --mime-type "$1";;
	esac
}


#Envia un archivo como respuesta, en caso de que no exista envia un 404.
#$1 (string): path al archivo
#Ejemplo sendRawFileResponse 'miArchivo.txt'
sendRawFileResponse(){
	if [ -f "$1" ]
	then
		now=`date -R`;
		#calculate the byte lenght!
		lenght=`stat -c%s "$1"`;

		#mimeType=`file -b --mime-type "$1"`;
		mimeType=`detectMimeType "$1"`;
		
		echo -en "HTTP/1.0 ${HTTP_STATUS[200]}\r\nServer: $BASHER_SERVER\r\nDate: $now\r\nContent-Type: $mimeType\r\nContent-Length: $lenght\r\nConnection: close\r\n\r\n";
		cat "$1";
	else
		#dont exist the file...
		sendHTMLResponse $HTTP_STATUS_404 "${CONFIG[template_fileNotFound]}";
	fi	
}



##
##	MAIN
##

read -r REQUEST[$REQUEST_ORIGINAL];
parsedRequest=`echo ${REQUEST[$REQUEST_ORIGINAL]} | sed -r -e 's: HTTP/1.1::' -e 's:[\n\r]::g'`;
REQUEST[$REQUEST_PATH]=`echo "$parsedRequest" | cut -f2 -d' '`
REQUEST[$REQUEST_METHOD]=`echo "$parsedRequest" | cut -f1 -d' '`


if [ "${REQUEST[$REQUEST_PATH]}" == '' ]
then
	REQUEST[$REQUEST_PATH]='/';
fi

#Se incluyen los archivos con configuraciones y/o controladores definidos por el usuario
source $BASHER_USER_CONFIG;
source $BASHER_USER_CONTROLLER;

if [[ "${ROUTING[${REQUEST[$REQUEST_PATH]}]}" != '' ]]
then
	set -e
	(eval ${ROUTING[${REQUEST[$REQUEST_PATH]}]} & wait $!) || send500HTMLResponse;


else
	#intenta recuperar un archivo posiblemente existente del directorio publico
	#renderiza la ruta considerando los caracteres urlencoded y la eliminación de posibles parámetros (utilizados en callbacks/js de librerias)
	publicFilePath=`echo "${CONFIG[public_dir_root]}${REQUEST[$REQUEST_PATH]}" | sed -e "s:/$:/${CONFIG[default_index_filename]}:" -e 's@+@ @g;s@%@\\\\x@g' | xargs -0 printf '%b' | sed -r 's:[?][a-zA-Z0-9_\-]+[=].*+$::'`;
	
	if [ -f "$publicFilePath" ]
	then
		sendRawFileResponse "$publicFilePath"
	else
		send404HTMLResponse;
	fi
fi

exit 0;
