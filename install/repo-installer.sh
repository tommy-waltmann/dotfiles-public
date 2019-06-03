#!/bin/bash

# Clone Glotzer lab repositories

if [ -d "$CODE_DIR" ]; then

    function ghclone() {
        if [ -d ${3:-"$CODE_DIR/${1}"} ]; then
            echo "${1} is already cloned."
        else
            git clone --recurse-submodules https://${USER}@github.com/${2:-"glotzerlab"}/${1}.git ${3:-"$CODE_DIR/${1}"}
        fi
    }

    # glotzerlab GitHub repositories
    for REPO in fresnel freud fsph gsd hoomd-blue plato signac signac-flow signac-dashboard; do
        ghclone $REPO
    done

else
    echo "Environment variable \$CODE_DIR not set or does not exist."
fi
