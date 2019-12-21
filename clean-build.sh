clear

echo "Deleting build/ folder"
rm -rf build/
echo "Creating build/ folder"
mkdir build
cd build
echo "Entering build/ folder"

if [ "$1" == "test" ];
    then
        cmake -DCMAKE_BUILD_TYPE=Debug ..
        make -j 8
        make test
elif [ "$1" == "test-coverage-publish" ]
    then
        cmake -DCMAKE_BUILD_TYPE=Debug -DENABLE_COVERAGE=On ..
        make -j 8
        make test
        make lcov
else
        cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF ..
        make VERBOSE=1 -j 8
fi
