# Código de docker-compose
Indica la versión de docker-compose:
* version: "3.3"

_La sección servicios hace referencia a las propiedades del contenedor como su nombre, imagen, puerto asignado, volumenes..._

## asir_bind9

Define el nombre del conenedor, la imagen y us puertos. Los puertos están separados por ":" ya que la parte de la izquierda es el puerto de la máquina local y el puerto de la derecha es el del contenedor de Docker.

La parte de "volumes" dicta la ruta absoluta de la carpeta de configuración del contenedor del servidor DNS en Docker y la configuración en la máquina local, otra vez, separados por ":".

Por último, la sección de **Networks** contiene la IP del cliente **Xd**, en este caso.
```
container_name: asir_bind9
   image: internetsystemsconsortium/bind9:9.16
   ports:
     - 5300:53/udp
     - 5300:53/tcp
   volumes:
     - /home/asir2a/Escritorio/SRI/tuto/bind9/conf:/etc/bind
     - /home/asir2a/Escritorio/SRI/tuto/bind9/zonas:/var/lib/bind
   networks:
      Xd:
        ipv4_address: 10.1.1.254 
```

## Docker-Compose: Cliente

Esta sección del código muestra la información del cliente **Xd**.
Por una parte, el nombre del contenedor del cliente y su imagen ,y, por otra, información de **Networks**: Stdin_open,tty(True: ejecuta "docker run -t"),dns(IP cliente: "10.1.1.254")
```
 Xd_cliente:
  container_name: Xd_cliente
  image: alpine
  networks:
    - Xd
  stdin_open: true
  tty: true
  dns:
   - 10.1.1.254
```
## Networks

Esta opción permite al contenedor
```
networks:
  Xd:
    external: true
```

# Procedimiento de creación de servicios (contenedores)

   ```
   docker up 
   ```

# Modificación de la configuración, arranque y parada de servicio bind9

   docker-compose up
   docker-compose down

# Configuración zona y como comprobar que funciona

   /zonas

# Entregar enlace al repositorio

# Práctica DNS

1. **Volumen por separado de la configuración.**

      La configuración del contenedor viene escrita en named.conf. El truco está en dividir esta configuración en dos partes y cada parte dejarla en dos archivos.
      Uno llamado:
      
      **"named.conf.local"** 
      
      y otro llamado:
      
      **"named.conf.local"**
      
      Una vez esto esté hecho, en el archivo _named.conf_   (archivo original donde estaba la configuración completa) hay que borrar todo y escribir:

      ```
      include /ruta/absoluta/named.conf.options

      include /ruta/absoluta/named.conf.local
      ```

2. **Red propia interna para todos los contenedores.**
  
    Con el comando:

    docker network create --subnet 10.0.0.0/24 --gateway 10.0.0.1 Subnet_Contenedores
    
    Además, entro al documento.yml y añado una nueva subred en la sección **Networks** (explicada anteriormente).

3. **IP fija en el servidor.**

   En el mismo documento, hay que añadir una nueva linea de código para que el servidor obtenga una IP fija:
   
   ```
   ipv4_address: X.X.X.X (en mi caso, pongo la IP "10.1.1.254")
   ```

4. **Configurar Forwarders.**

   En el documento llamado "named.conf.options" se encuentra la sección llamada "forwarders" y es ahí donde se ha de    añadir o modificar la IP para el servidio DNS. En mi caso queda de esta manera:
   
   ```
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
   ```

5. **Crear Zona propia.**

   En la misma ruta donde se encuentra el documento del apartado anterior se encuentra el archivo "named.conf.local", en el cual, hay que añadir una nueva línea de código (en mi caso se llamará, "asircastelao.com"):
   
   ```
   zone "asircastelao.com"  {
    type master;
    file "/var/lib/bind/db.asircastelao.com";
    allow-query {
        any;
     };
   };
   ```

6. **Registros a configurar: NS, A, CNAME, TXT, SOA, MX.**

   En el documento "db.asircastelao.int" está todo lo relacionado con las zonas, es aquí donde se tiene que configurar el alias que se le quiera dar.

7. **Cliente con herramientas de red.**

   Para realizar esta tarea hay que dirigirse al documento "docker-compose.yml" y crear un nuevo cliente indicando la network que se utilizará, además de indicar el nombre o el modo de arranque, por ejemplo.
