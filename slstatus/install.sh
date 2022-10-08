#!/bin/bash

rm config.h
make && sudo make clean install
cp ./fetch_sound_text ~/.local/bin/
