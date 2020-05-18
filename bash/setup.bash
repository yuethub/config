for file in $(ls ~/bash/);
do
    if [ $file != setup.bash ]; then
        source ~/bash/$file
    fi
done
