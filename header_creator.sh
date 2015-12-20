#!/bin/sh

for f in *.cpp; do
	echo Processing $f
	cat header $f > $f.new
	mv $f.new $f
done
echo Finished process 
