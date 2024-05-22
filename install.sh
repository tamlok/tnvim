#!/bin/sh
rsync -av --exclude='.git*' . ~/.config/nvim
