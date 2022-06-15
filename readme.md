# Building PHP with Nix and Docker

This repository contains a couple of ways to build a PHP app with Nginx using Nix in a Docker container. The app is located at [app](app), and contains a couple of simple PHP files.

Here are the currently implemented examples:
- [build-with-nix](build-with-nix): the idomatic way - building the Docker container using Nix's `dockerTools`.