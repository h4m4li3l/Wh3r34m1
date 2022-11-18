<h1> Client for the C2C </h1>
<h2># BlackArchClient </h2>

<h2>La idea es hacer un pequeño reverse del Script de instalación de BlackArch
. Implemetarle estos cambios. para automatizar la instalaci
</h2>

<h1> **Objetivos** </h1>
<h2> ** Step 1: Set up client.** </h2>
*Por qué primero el client*:
 Porque es más fácil.


<h3></h3>
    <p>Sin embargo aun esta incompleto. </p>
    <p>No me da un booteable system. </p>
    <p>Estoy fallando al implementar el boot desde un sistema encryptado. </p>
    <p>Ya no quiero hacer la GRUB partition, por razones de seguredad. </p>
    
<h3> Hacer la ISO solo de i3 por ahora, que es el que uso.</h3>
    <p> Encrypted system. </p>
    <p> Encrypted filesystem to store keys?? (ssh, pgp, etc...) </p>
    <p> Linux Hardened Kernel. </p>

<h3> - Futuro: </h3>
    <p>Pasar a un sistema sin SystemD</p>
    - Esqueletarlo para un sistema sin systemd Gentoo, Void, LFS (Superficie de ataque como pid1 insana)
    <p>From Source </p>
    <p>Y sin X</p>
    <p>Sin sudo </p>
    
<h3> - Cotainer </h3>
    <p> Hacer un container para agilizar el deploy </p>
    <p> O mejorar script de instalacion </p>
