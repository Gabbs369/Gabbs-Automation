#!/bin/bash

# Script made by Gabbs

auto_download_ymlpods () {


  if [[ -d pod_ymls ]]; then
    rm -rf pod_ymls
    mkdir pod_ymls
  else
    mkdir pod_ymls
  fi

  store_pods=$(kubectl get pod  | grep -vi "name" | awk '{print $1}')

  for pod in $store_pods; do 
    kubectl get pod $pod -o yaml  > "pod_ymls/$pod.yaml"

  done
  zip -r  pod_ymls.zip pod_ymls > /dev/null
  echo "First Step: "
  echo " Compressed"
  echo " "
  echo " "
  if [[ $? -eq 0 ]]; then
    rm -rf pod_ymls
  else
    echo "error"
    break
  fi
}

auto_download_ymlpods

echo " "
echo "Second step: "
echo "pods were exported in yaml extension and compressed in a zip file"
echo " "

echo " "
echo "Third Step: "
echo " Zipped file content"
echo " "
echo " "
7z l pod_ymls.zip | grep -iE "*.yaml" | awk '{print $NF}' | sed 's/pod_ymls\/\(.*\)/Directory: pod_ymls\n   File: \1/g'

ls
