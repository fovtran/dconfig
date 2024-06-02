# Setup of libreadtoml (autoconf)

## APT libtoml
## apt install libtoml-dev

## C++ libtoml
git clone https://github.com/marzer/tomlplusplus.git

## Go
go get github.com/BurntSushi/toml

## Cargo file

Cargo.toml```
[package]
name = "readtoml"
version = "0.0.2"
authors = ["Yo camposn <yo@localhost.localdomain>"]

[dependencies]
toml = "0.5.8"
```
