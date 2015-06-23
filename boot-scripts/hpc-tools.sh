#!/bin/bash

# Set up /opt
OPT_TARBALL_URL=https://s3-us-west-2.amazonaws.com/dmdu-cloudlab/hpc-opt.tar.gz
OPT_TARBALL_DIR=/local
OPT_TARBALL_PATH="$OPT_TARBALL_DIR/hpc-opt.tar.gz"
OPT_TARBALL_MD5=2ac5412b2b4c57a383318f31447f4712
mkdir $OPT_TARBALL_DIR
if [ ! -f $OPT_TARBALL_PATH ] ; then
  echo "Tarball $OPT_TARBALL_PATH doesn't exist. Downloading"
  wget $OPT_TARBALL_URL -P $OPT_TARBALL_DIR
  rm -rf /opt*
  tar xzvf $OPT_TARBALL_PATH -C /opt
else
  m=`md5sum $OPT_TARBALL_PATH | awk '{ print $1 }'`
  if [ "$OPT_TARBALL_MD5" != "$m" ] ; then
    echo "Existing tarball $OPT_TARBALL_PATH doesn't match the specified md5sum. Updating."
    mv $OPT_TARBALL_PATH "$OPT_TARBALL_PATH-OUTDATED"
    wget $OPT_TARBALL_URL -P $OPT_TARBALL_DIR
    mv /opt /opt-OUTDATED
    mkdir /opt
    tar xzvf $OPT_TARBALL_PATH -C /opt
  else
    echo "Exisitng tarball $OPT_TARBALL_PATH is up to date."
  fi
fi

# Set up /scratch
mkdir /scratch
# hpc-cluster-tools repo is cloned in /etc/rc.local
rsync -av /root/hpc-cluster-tools/ /scratch/ --exclude=.git --exclude=.gitignore --exclude=boot-scripts --exclude=README.md
chown -R slurm:slurm /scratch
