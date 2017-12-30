#!/bin/bash

for file in $(ls -a ~/dotfiles); do
  if [[ -f ~/dotfiles/$file ]] && [[ $file == .* ]]; then
      if [[ -f ~/$file ]]; then
        echo "$file already exists; skipping"
        continue
      fi
      ln -s ~/dotfiles/$file ~/$file;
      echo "Linked $file"
  fi;
done
