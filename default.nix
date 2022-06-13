{ pkgs, fakeNss }:

with pkgs;
let 
  nginxPort = 80;
  nginxConf = pkgs.writeText "nginx.conf" ''
    user nobody nobody;
    daemon off;
    error_log /dev/stdout info;
    pid /dev/null;
    events {}
    http {
      access_log /dev/stdout;
      server {
        listen ${nginxPort};
        index index.php index.html;
        charset utf-8;

        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-Content-Type-Options "nosniff";

        location ~ \.php$ {
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:${pkgs.phpfpm.socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        }
      }
    }
  '';
in rec {
  image = dockerTools.buildLayeredImage {
    name = "nix-php-test";
    tag = "latest";
    contents = [
      fakeNss
      pkgs.nginx
      pkgs.php81
    ];

    extraCommands = ''
      mkdir -p var/log/nginx
      mkdir -p var/cache/nginx
    '';

    config = {
      Cmd = [ "nginx" "-c" nginxConf ];
      ExposedPorts = {
        "${nginxPort}/tcp" = {};
      };
    };
  };
}