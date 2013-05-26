#!/bin/bash
echo 'deleting existing data'
rm -rf _plugins/data/*

echo 'downloading CMO data from dropbox'
curl -L -o _plugins/data/maps.zip   https://www.dropbox.com/sh/n9ihy0149fmbw7l/NLE02GGDVD?dl=1
curl -L -o _plugins/data/graphs.zip https://www.dropbox.com/sh/cv31v6lax837qze/EboeRBOnMj?dl=1

echo 'extracting to data folder'
unzip _plugins/data/maps.zip -d _plugins/data
unzip _plugins/data/graphs.zip -d _plugins/data