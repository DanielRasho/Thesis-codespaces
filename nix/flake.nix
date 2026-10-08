{
  description = "weathercli — reporte del clima en la terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      packages.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          defaultConfig = pkgs.writeText "weathercli-config.json" (
            builtins.toJSON {
              city = "Tokyo";
              units = "metric";
              format = "compact";
            }
          );
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "weathercli";
            version = "1.0.0";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/bin $out/share/weathercli
              install -m755 weathercli.sh $out/bin/weathercli
              install -m644 ${defaultConfig} $out/share/weathercli/config.json
            '';

            postFixup = ''
              wrapProgram $out/bin/weathercli \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.curl
                    pkgs.jq
                  ]
                } \
                --set-default WEATHERCLI_CONFIG "$out/share/weathercli/config.json"
            '';
          };
        };
    };
}
