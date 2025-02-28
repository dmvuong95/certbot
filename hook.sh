#!/bin/bash

for hook_file in ./hooks/*.sh; do
  if [ -f "$hook_file" ]; then
    echo "------------- Running hook $hook_file -------------"
    bash $hook_file
  fi
done

echo "------------- All hooks executed -------------"
