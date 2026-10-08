# weathercli en Nixty

`weathercli` es un programa de terminal que consulta el clima de una ciudad. Está empaquetado con Nixty.

## Qué hay aquí

- `nixty.ts`: el código que empaqueta el programa. **Es el único archivo que debes editar.**
- `weathercli.sh`: el programa. No lo edites.
- `flake.nix`: lo genera Nixty a partir de `nixty.ts` en cada comando `nixty`. No lo edites.
- Los demás archivos son configuración del entorno. No los edites.

## Cómo probar tu código

Guarda el archivo (`Ctrl+S`) y, en una terminal de este Codespace (menú *Terminal → New Terminal*), ejecuta:

```sh
nixty build weathercli     # construye el paquete en ./result
./result/bin/weathercli    # ejecuta el programa construido
nixty run weathercli       # construye y ejecuta el programa
nixty develop <nombre>     # entra a la dev shell <nombre> (sal con: exit)
```

`weathercli` imprime la URL que consulta y luego el clima.

## Antes de cada ejercicio

El Codespace empieza con el código inicial del primer ejercicio. En los siguientes, **reemplaza todo el
contenido de `nixty.ts`** con el "Código inicial" que muestra la encuesta.

## Cuando termines

Copia **todo** el contenido de `nixty.ts` y pégalo en la encuesta.

## A tener en cuenta

- Nix solo ve archivos registrados en git: si creas un archivo nuevo, ejecuta `git add -A`.
- No está permitido usar asistentes de inteligencia artificial.
- Al terminar la encuesta puedes cerrar el Codespace.
