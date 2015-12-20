#!/bin/sh

# A simple shell to add headers (like copyright statements) in files

for f in *.cpp; do
	echo Processing $f
	cat header $f > $f.new
	mv $f.new $f
done
echo Process finished  
