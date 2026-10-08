# weathercli en Nix

`weathercli` es un programa de terminal que consulta el clima de una ciudad. Está empaquetado con Nix.

## Qué hay aquí

- `flake.nix`: el código que empaqueta el programa. **Es el único archivo que debes editar.**
- `weathercli.sh`: el programa. No lo edites.
- Los demás archivos son configuración del entorno. No los edites.

## Cómo probar tu código

Guarda el archivo (`Ctrl+S`) y, en una terminal de este Codespace (menú *Terminal → New Terminal*), ejecuta:

```sh
nix build                  # construye el paquete en ./result
./result/bin/weathercli    # ejecuta el programa construido
nix run                    # construye y ejecuta el programa
nix develop                # entra a la dev shell (sal con: exit)
```

`weathercli` imprime la URL que consulta y luego el clima.

## Antes de cada ejercicio

El Codespace empieza con el código inicial del primer ejercicio. En los siguientes, **reemplaza todo el
contenido de `flake.nix`** con el "Código inicial" que muestra la encuesta.

## Cuando termines

Copia **todo** el contenido de `flake.nix` y pégalo en la encuesta.

## A tener en cuenta

- Nix solo ve archivos registrados en git: si creas un archivo nuevo, ejecuta `git add -A`.
- No está permitido usar asistentes de inteligencia artificial.
- Al terminar la encuesta puedes cerrar el Codespace.
