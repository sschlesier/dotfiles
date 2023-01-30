# shellcheck source=/dev/null
export LESS=-RFMXJ
if [[ -z $LESSOPEN ]] && type batpipe > /dev/null; then
    eval "$(batpipe)"
fi
