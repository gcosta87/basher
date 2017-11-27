# basher
basher es un pequeño pseudo-servidor web escrito en Bash que se apoya en socat para levantar el servicio. Actualmente tiene fines puramente experimentales.

Nació de la inspiracion de un servidor de muy silmilares caracteristicas, BashHttp ([avleen/bashttpd](https://github.com/avleen/bashttpd)), para ser usado en diversos dispositivos basados en Linux para conocer variables del entorno y/o estadisticas del mismo (Raspberry Pi, PC dedicadas,...).

##Estado
En desarrollo (inmaduro / experimental)

## Caracteristicas 
- **Configurable y facil de usar**: Posee un conjunto de funciones minimas y un sitio de ejemplo para que sea «Ready to Use», y pueda verse como puede usarse.
- Posee un manager (***basherCtl***) para poder iniciarlo, detenerlo y conocer su estado. Incluso es posible obtener el resultado, orientativo, de una prueba de rendimiento (**benchmark**).
- Soporte para publicar un sitio web estatico: util para landing page, paginas de mantenimiento o bien sitio con informacion estática (html,js).
- Flujo web inspirado en «Routing+Controllers»: Se definio una capa de abstraccion para separar la logica requerida por el usuario.
- Diversos tipos de respuestas: Se brindan algunas funciones que simplifan el envio de respuesta al cliente
  - HTML
  - Texto plano
  - Archivo (cuando este no sea de acceso público)
  - JSON (muy precaria actualmente)
- Manejo de errores: basher muestra (actualmente de forma precaria) errores 404 («Page not Found»), y de manera experimental intenta capturar los errores 500 («Internal Server Error») cuando ocurrán. Aun asi es muy simple lanzarlos "manualmente"  por el usuario.


## Requerimientos
- **Socat** >= 1.7.2.3 
- **Bash** >= 4.3
- **libwww-perl**: Libreria de Perl con "helpers" para acceder a URLs,  instalada por defecto en varias distros de Linux (Debian, Ubuntu,..) 


## Posibles Usos
- Levantar una landing page o página de mantenimiento.
- Publicar un sitio web estatico
- Implementar un pequeño servicio web: descarga de archivos y/o pequeña API Rest JSON.

## Manejo
El manejo de basher se realiza atraves de su administrador: basherCtl (*Basher Control*) . Este permite iniciarlo, detenerlo y/o conocer su estado.

Ejecutando ./basherCtl muestra todos comandos dispibles.
 
### Iniciar basher (start)
```
./basherCtl start [puerto | (direccion ip | localhost) puerto]
```
Este comando inicializa basher segun los parametros (opcionales) indicados. Por defecto, si no se pasan parametros, escucha peticiones (bindeo) en localhost:80.

### Detener basher (stop)
```
./basherCtl stop
```

### Conocer el estado (status)
```
./basherCtl status
```
Muestra si basher esta ejecutandose, respondiendo a peticiones (tras consultar al "/" del sitio), su uptime y cual es su configuracion (ip y puerto bindeado) . 

Adicionalmente en caso de que esté detenido, lo indica diferenciando si fue detenido correctamente (a través de basherCtl) o bien de manera externa (**kill** de proceso o error externo).

### Prueba orientativa de rendimiento (benchmark)
```
./basherCtl benchmark [N]
```
Hace una pequeña prueba de rendimiento al solicitar el "/" del sitio e informa el tiempo que se tardó en obtener esa respuesta.

Si se ejecuta sin parámetros, ejecuta por defecto 1.000 peticiones, sino es posible indicarle las N peticiones deseadas. 

## Estructura
La estructrua de directorios de Basher es la siguiente
```

├── basherCtl
├── public
│   ├── ejemplos.html
│   ├── favicon.ico
│   ├── index.html
│   └── style.css
├── resources
│   └── index.html
├── server
│   ├── basher.sh
│   ├── constants.sh
│   └── functions.sh
└── webApp
    ├── config.sh
    └── controller.sh
```

- «public»: es el directorio de acceso publico. Cualquier peticion realizada desde el navegador accedera a esta ubicacion (y sus subdirectorios).
- «resourses»: directorio privado (no accesible via navegador) utilizado para ubicar archivos que se quieran enviar al cliente a partir de una ruta definida.
- «server»: logica de Basher, 
- «webApp»: el espacio de trabajo del usuario. el archivo ***controller.sh*** es el archivo donde se definen rutas y los controllers (funciones) a ejecutar. Mientras que ***config.sh*** posibilita sobreescribir las configuraciones por default.
