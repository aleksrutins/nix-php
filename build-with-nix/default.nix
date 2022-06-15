{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let 
  utils = import ../common/utils.nix {};
  nginxPort = "80";
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
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        }
      }
    }
  '';
  nginxWebRoot = utils.writeIndex {};
in dockerTools.buildLayeredImage {
    name = "nix-php-test";
    tag = "latest";
    contents = [
      pkgs.bash
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
  }