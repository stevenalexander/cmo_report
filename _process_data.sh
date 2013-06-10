#!/bin/bash
echo "Processing data to create pages with data"

START=$(date +%s)

ruby -r "./_processors/data_generator.rb" -e "DataGenerator.new.generate"

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Finished Processing: $DIFF seconds"