pushd $1
find . | while read name; do
  pushd $2
  if [ -f $2/$name ]; then
    cp $1/$name $2/$name
  else
    echo "Not found: $name"
  fi
  popd
done
popd
