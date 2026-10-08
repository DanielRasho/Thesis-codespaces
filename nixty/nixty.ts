import { Definition, Nixpkgs, Package, Path, Source, System, nix } from "nixty-lib"

const NIX_PKGS = new Nixpkgs({ tag: "nixos-unstable" })

const DefaultConfig = (system: System) =>
    NIX_PKGS.getExpresion("writeText", system)(
        "weathercli-config.json",
        JSON.stringify({
            city: "Tokyo",
            units: "metric",
            format: "compact",
        }),
    )

const weathercli = new Package("weathercli", [System.x86_64Linux], (system) => ({
    version: "1.0.0",
    src: new Source(Path.fetchInternalPath(".")),
    deps: {
        atRuntime: NIX_PKGS.getPackages(["curl", "jq"], system),
    },
    phases: (out) => ({
        install: nix`
            mkdir -p ${out}/bin ${out}/share/weathercli
            install -m755 weathercli.sh ${out}/bin/weathercli
            install -m644 ${DefaultConfig(system)} ${out}/share/weathercli/config.json
        `,
        postFixup: nix`
            wrapProgram ${out}/bin/weathercli \
                --set-default WEATHERCLI_CONFIG ${out}/share/weathercli/config.json
        `,
    }),
}))

export default new Definition({
    description: "weathercli — reporte del clima en la terminal",
    nixpkgs: NIX_PKGS,
    packages: [weathercli],
})
