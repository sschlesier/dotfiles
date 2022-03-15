export LESS=-RFMX
if [[ -z $LESSOPEN ]] && type batpipe > /dev/null; then
    eval "$(batpipe)"
fi
