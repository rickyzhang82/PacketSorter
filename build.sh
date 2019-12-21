clear

cd build

if [ "$1" == "test" ];
    then
        make -j 8
        make test
    else
        make -j 8
fi
