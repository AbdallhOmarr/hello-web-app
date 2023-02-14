{ pkgs ? import <nixpkgs> { } }:

pkgs.python3.withPackages (ps: with ps; [
  django
  gunicorn
]) // {
  buildInputs = [ pkgs.gcc ];
}
