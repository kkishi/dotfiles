#!/bin/bash

for file in $(ls -a ~/dotfiles); do
  if [[ -f ~/dotfiles/$file ]] && [[ $file == .* ]]; then
      if [[ -L ~/$file ]]; then
        echo "$file already exists as a symlink; skip"
        continue
      fi
      if [[ -f ~/$file ]]; then
        echo "$file already exists as a regular file; keeping it as ~/$file.old"
        mv ~/$file ~/$file.old
      fi
      ln -s ~/dotfiles/$file ~/$file;
      echo "Linked $file"
  fi;
done
