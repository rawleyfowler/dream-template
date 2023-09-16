#!/bin/sh

eval $(opam env)

while read line; do
    eval "$line"
done < .env

dune exec application.exe "$1"
