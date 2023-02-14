{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  src = fetchFromGitHub {
    owner = "AbdallhOmarr";
    repo = "hello-web-app";
    rev = "latest-commit-sha";
    sha256 = "sha256-hash-of-latest-commit";
  };

in
python38.mkDerivation {
  pname = "simple-web-app";
  version = "1.0";
  src = src;
  buildInputs = [
    uwsgi
    postgresql
    nginx
    git
    openssl
    zlib
  ];
  preBuild = ''
    . ${pkgs.python38}/bin/activate
    pip install -r ${./simple_web_app/requirements.txt}
  '';
  postInstall = ''
    mkdir -p $out/nginx/conf
    echo '
    worker_processes 1;

    events {
        worker_connections 1024;
    }

    http {
        include mime.types;
        default_type application/octet-stream;
        sendfile on;
        keepalive_timeout 65;
        gzip on;

        server {
            listen 8080;

            location / {
                uwsgi_pass unix:///run/uwsgi.sock;
                include uwsgi_params;
            }
        }
    }' > $out/nginx/conf/nginx.conf
  '';
  meta = with pkgs.stdenv.lib; {
    description = "A simple Django web app";
    maintainers = [ "AbdallhOmar AbdallhOmarr@gmail.com" ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
