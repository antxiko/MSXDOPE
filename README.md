# MSX DOPE WARS

Reinterpretacion del juego Dope Wars para MSX en BASIC.

Requisitos: MSX con 64Kb de RAM

Controles:
En el menú del barrio V para ir al menú de viaje.
En el menú de viaje cursores Arriba y Abajo para seleccionar el barrio de destino y barra espaciadora para aceptar.

De momento esto es un mockup reinterpretando el Dope Wars. Juego basado en Drug Wars de 1983.

Está implementado el control de porcentajes aleatorios para los precios.
Viaje entre barrios implementado.

WIP.

## How to run the BASIC code

Run the bundled testbas.sh script for easy development:

```shell
sh ./testbas.sh
```

## How to build the asm code (WIP)

- You need to download the [sjasm](https://github.com/Konamiman/Sjasm/releases) executable in order to compile this code to a z80 binary executable.

- [OpenMSX](https://sourceforge.net/projects/openmsx/files/latest/download) or someother emulator for run the code (ROM cartridge at the moment, .rom format)

Run the bundled build.sh script for easy development:

```shell
cd src
./build.sh
```
