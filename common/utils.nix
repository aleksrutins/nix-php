{ pkgs ? import <nixpkgs> {} }:
{
  writeIndex = {path ? "index.php"}: pkgs.writeTextDir path (builtins.readFile ./index.php);
}