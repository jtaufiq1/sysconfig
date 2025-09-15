#!/bin/bash

if [ -x "$filename" ]; then 

	echo "File $filename exists."; cp $filename $filename.bk
else
	echo "File $filename not found."; touch $filename
fi;

echo "File test complete."
