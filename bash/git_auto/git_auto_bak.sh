#!/bin/bash

# created by Sebastian G AKA Gabbs 

# create directory and if exists a directory delete it and create another. 

git_auto () {
  read -p "Select the name of your directory for git: " directory
    if [[ -a $directory ]]; then
      rm -rf $directory
    else
      mkdir $directory
      cd $directory
      git init
      current_path=$(pwd)
    fi
}

# Basic authentication for Git repository

authentication () {
  cd $current_path
  read -p "name: " name
  read -p "email: " email
  git config --global user.name "$name"
  git config --global user.mail "$email"
    if [[ $? -eq 0 ]]; then
      echo "authentication succesfully"
    else
      echo "authentication error"
    fi
}
  

remote_connection () {
  ssh -T git@github.com >> /dev/null 2>&1
  if [[ $? -eq 1 ]]; then
    echo "authentication succesfully"
  else
    echo "You don't have a connection here"
    read -p "Do you want continue: " ssh_conf_for_github
    read -p "Introduce your email: " email
    #  Generation of the new key
    if [ $ssh_conf_for_github  ==  "Yes" || "yes" || "Si" || "si"]; then
      read -p "cipher_algorithm" cipher_algorithm
      if [ $cipher_algorithm == "RSA" ]; then
         ssh-keygen -t rsa -b 4096 -C "${email}"
      elif [ $cipher_algorithm == "ed25519" ]; then
        ssh-keygen -t ed25519 -C "${email}"
    eval "$(ssh-agent -s)"
    if [ $ssh_conf_for_github == "RSA" ]; then
      ssh-add ~/.ssh/id_rsa
    elif [ $ssh_conf_for_github == "ed25519" ]; then
     ssh-add ~/.ssh/id_ed25519
    fi
    # adding the new key to your github key conf
    echo "Copy and paste this key to your github settings "
    if [ $ssh_conf_for_github == "RSA" ]; then
      cat ~/.ssh/id_rsa
    elif [ $ssh_conf_for_github == "ed25519" ]; then
      cat ~/.ssh/id_ed25519
    fi
    # Now Test your new connection and have to give you a succesfully remote_connection
    ssh -T git@github.com
    if [[ $? -eq 1 ]]; then
      echo "succesfully connection"
    else
      echo "Upps... Do it Again"
    fi
      fi
    fi
  fi
}

# for any repository Github/Bitbucket/Gitlab

deploying_to_repository () {  
  cd $current_path
  cd $current_path/$directory
  read -p "add your commit: " git_commit_y
  read -p "select your branch: " branch
  if [[ -a *.* ]]; then
    git add .
    git commit "$git_commit_y"
    git pull
    git push origin $branch
  fi
}


remote_connection

# use an argument authenticate or deploy your changes to the repository
if [[ $1 == "first_step" ]]; then
  git_auto
  authentication
elif [[ $1 == "deploy" ]]; then
  deploying_to_repository
else
  echo "select an option"
fi
