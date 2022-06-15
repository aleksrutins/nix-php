{ pkgs ? import <nixpkgs> {} }:
{
  writeIndex = { name ? "index.php" }: (pkgs.writeTextDir name (builtins.readFile ./index.php));
}