#!/bin/bash

# Script made by Gabbs

auto_download_ymlpods () {

  # only if you want to delete the compressed

  if [[ $1 == "del" ]]; then
    rm -rf pod_ymls.zip
  fi

  # delete the directory if exists
  if [[ -d pod_ymls ]]; then
    rm -rf pod_ymls
    mkdir pod_ymls
  else
    mkdir pod_ymls
  fi

  # pods in the namespaces
  
  store_pods=$(kubectl get pod  | grep -vi "name" | awk '{print $1}')

  # iterate every pod 
  
  for pod in $store_pods; do 
    #convert the pods in pod .yml
    kubectl get pod $pod -o yaml  > "pod_ymls/$pod.yaml"
  done
  # compress the file
  zip -r  pod_ymls.zip pod_ymls > /dev/null
   echo -ne "First Step: "
   echo -ne "Compressed"
   echo -ne "\n"
   # verify if the file was executed correctly and delete the before directory
  if [[ $? -eq 0 ]]; then
    rm -rf pod_ymls
  else
     echo -ne "error"
    break
  fi
}

auto_download_ymlpods

compressed_info () {
  
   # info
   echo -ne "\n"
   echo -ne "Second step: "
   echo -ne "pods were exported in yaml extension and compressed in a zip file"
   echo -ne "\n"

   echo -ne "\n"
   echo -ne "Third Step: "
   echo -ne "zip file content"
   echo -ne "\n"
   echo -ne "\n"
   # listing files  of the zip 
   
  7z l pod_ymls.zip | grep -iE "*.yaml" | awk '{print $NF}' | sed 's/pod_ymls\/\(.*\)/Directory: pod_ymls\n   File: \1/g'
  echo -ne "Content: \n\n"

  ls -lh
  
  # descompress the file and listen the files

  read -p  "Do you want to decompress your .zip?: " decompress
  if [[ $decompress == "yes" ]]; then
    7z x pod_ymls.zip > /dev/null
    ls -lh pod_ymls
  fi
}

compressed_info
