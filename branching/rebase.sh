#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
=======
>>>>>>> 50a8b15... git-rebase 2
    count=$(( $count + 1 ))
done

echo "====="
