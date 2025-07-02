# Mathflake

This project is intended to help install mathematical software on NixOS.

## Installation

Make sure to enable flakes, they are considered experimental by default.

Refer to this document to enable flakes.
<https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled>

Installing from GitHub:

    nix profile install github:proski/mathflake#prmers

Installing from checked out repository:

    nix profile install .#prmers

## Supported software

PrMers: GPU-accelerated Mersenne Primality Test

    nix profile install github:proski/mathflake#prmers

mfakto: OpenCL based trial factoring program for Mersenne Primes

    nix profile install github:proski/mathflake#mfakto

## Enabling GPU support

To enable support for your GPU, configure `hardware.graphics.extraPackages` in
your `/etc/nixos/configuration.nix`. For instance, add this for Intel GPU.

    hardware.graphics.extraPackages = with pkgs; [
      intel-compute-runtime
    ];
