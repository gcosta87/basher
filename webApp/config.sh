#!/bin/bash
# 
# config.sh
# 	Archivo para sobreescribir los valores default y/o
# 	definir nuevos según sea conveniente
#
# raiz del directorio publico: assets, js, public data
#CONFIG[public_dir_root]='./public'

#raiz del direcotorio recursos  (acceso no publico / no compartidos): hidden files,etc.
#CONFIG[resources_dir_root]='./resources'

#alias or name of default index file, when user access to a directory
#CONFIG[default_index_filename]='index.html'

#404 template response
#CONFIG[template_404]='<!doctype html><html><center>Error 404 :(<br/><small>(Not Found)</small></center></html>'
#CONFIG[template_fileNotFound]='<!doctype html><html><center>File not found! :(</center></html>'

#CONFIG[template_500]='<!doctype html><html><center>Error 500 :(<br/><small>(Internal Server Error)</small></center></html>'

#Control de la cache en el browser: tiempo (en segundos) par indicar que el contenido deba descartarse. Defualt 15 minutos (54000)
#CONFIG[cache_refresh_time]=60;