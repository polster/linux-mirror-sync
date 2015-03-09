#!/bin/bash

# The Linux versions to be synced, in brackets space separated
MINOR_VERSIONS=(7.0.1406)
# The lock file
LOCK_FILE=/var/lock/subsys/centos_mirror
# The repo host to be mirrored (must support rsync protocol)
NETWORK_MIRROR=linuxsoft.cern.ch
# The local target
DESTINATION_TOP=/var/www/html/yummirror/centos

# check to make sure we're not already running
if [ -f $LOCK_FILE ]; then
    echo "CentOS mirror script already running."
    exit 1
fi

# sync all versions
for version in ${MINOR_VERSIONS[@]}; do
    if [ -d $DESTINATION_TOP/$version ] ; then
        touch $LOCK_FILE
        echo "Starting with the repo sync for CentOS $version with target $DESTINATION_TOP/$version"
        rsync -v --progress -avSHP --timeout=300 --delete --exclude "local*" --exclude "isos" $NETWORK_MIRROR::centos/$version/ $DESTINATION_TOP/$version/
        /bin/rm -f $LOCK_FILE
    else
        echo "Target directory $DESTINATION_TOP/$version not present."
        exit 1
    fi
done

exit 0
