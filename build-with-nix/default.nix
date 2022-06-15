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
        location / {
          root ${nginxWebRoot};
        }
        location ~ \.php$ {
          root ${nginxWebRoot};
          fastcgi_pass 127.0.0.1:9000;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        }
      }
    }
  '';
  nginxWebRoot = utils.writeIndex {};
  startScript = pkgs.writeText "start.sh" ''
    #!/bin/sh
    php-fpm -y /etc/php-fpm.d/www.conf.default & nginx -c ${nginxConf};
  '';
in dockerTools.buildLayeredImage {
    name = "nix-php-test";
    tag = "latest";
    contents = [
      pkgs.bash
      pkgs.nginx
      pkgs.php81
      pkgs.coreutils
      pkgs.fakeNss
      pkgs.gnugrep
    ];

    extraCommands = ''
      mkdir -p var/log/nginx
      mkdir -p var/cache/nginx
      mkdir -p tmp
      chmod 1777 tmp
    '';

    config = {
      Cmd = [ "/bin/sh" startScript ];
      ExposedPorts = {
        "${nginxPort}/tcp" = {};
      };
    };
  }