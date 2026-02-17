# Procedimiento de Instalacion de Git
## Base de Datos para Negocios Digitales
## Unidad l
###### Elienay Ivana Cantera Martinez 8EVND G1
## Procedimiento

1. Nos vamos a nuestro navegador y buscamos 'git install', seleccionamos Windows y descargamos Git for Windows x64 Setup.
 HEAD
    1. ![Imagen](./img\image.png "This is a sample image.")
=======
![Base de Datos para Negocios Digitales](/img/1.png "BD.")
2. Para verificar la correcta instalación de Git, se ejecutaremos la consola Git Bash. Y ejecutamos el siguiente comando:
![Base de Datos para Negocios Digitales](/img/2.png "BD.")

```
git --version
--Se mostrará la versión instalada en el equipo.
```
3. A continuación, se realiza la configuración global de Git.

```
git config --global user.name "Elienay Ivana"

git config --global user.email"elienaycanteramartinez@gmail.com" (Poner el mismo correo que en GitHub)
git config --global core.editor "code --wait"
git config --global core autocrlf true
git config --global -e

```
4. Se abrirá Visual Studio; seleccionamos la opción Open.
![Base de Datos para Negocios Digitales](/img/3.png "BD.")
Deberá aparecer:
```
[core]
editor = code --wait
autocrlf = true
[user]
name = (tu nombre)
email = (tu correo)
```
Cerramos la pestaña en Visual y regresamos a la consola.

Ponemos:
```
clear
```

5.Ahora la carpeta que creamos especialmente para Visual la arrastramos a GitBash.
![Base de Datos para Negocios Digitales](/img/4.png "BD.")

```
cd (y la ruta de la carpeta)
git init
```
6. Cambiamos de `master` a `main`
```
git branch -m master main
git config --global init.DefaultBranch main
```
![Base de Datos para Negocios Digitales](/img/5.png "BD.")

Nos debe de aparecer esta nueva carpeta.

7. Para comprobar en la consola, ponemos:
```
ls -a
```
8. Otra manera de verificar es en Visual Studio; algunos de los archivos deberán aparecer con la U de Untracked.
![Base de Datos para Negocios Digitales](/img/6.png "BD.")
9. Por ultimo, para que Git le dé seguimiento a nuestros proyectos, creamos un archivo en cada carpeta llamado:
![Base de Datos para Negocios Digitales](/img/7.png "BD.")



 rama-ma
