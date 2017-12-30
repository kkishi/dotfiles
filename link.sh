#!/bin/bash

for file in $(ls -a ~/dotfiles); do
  if test -f ~/dotfiles/$file && [[ $file == .* ]]; then
      echo "Linking $file"
      ln -s -f ~/dotfiles/$file ~/$file;
  fi;
done
