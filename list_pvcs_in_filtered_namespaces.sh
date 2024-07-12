#!/bin/bash

# Script name: list_pvcs_in_filtered_namespaces.sh
# Description: This script lists all PersistentVolumeClaims (PVCs) in namespaces
#              whose names begin with "filebrowser-hub".

for ns in $(oc get namespaces --no-headers -o custom-columns=":metadata.name" | grep '^filebrowser-hub'); do
  echo "Namespace: $ns"
  oc get pvc -n "$ns"
  echo "-----------------------"
done
