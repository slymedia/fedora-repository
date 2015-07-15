#!/bin/bash -x

#
# Source environment
#
. ../etc/env.sh
. ../etc/database.sh


#
## Set the permissions on the whole installation
#

## Note: should put this in a loop and check if the directory exists first
# set ownership and permissions
chown -R ${FEDORA_USER}:${FEDORA_USER} ${REPOSITORY_HOME}
chown -R ${FEDORA_USER}:${FEDORA_USER} ${FEDORA_HOME}
if [ $INSTALL_DRUPAL == "Yes" ]; then
  chown -R ${FEDORA_USER}:${FEDORA_USER} ${DRUPAL_ROOT}
  chmod -R 755 $DRUPAL_ROOT
  chmod -R 775 $DRUPAL_ROOT/sites/default/files
fi
#if [ $INSTALL_SOLR == "Yes" ]; then
  chown -R ${FEDORA_USER}:${FEDORA_USER} ${SOLR_HOME}
#fi
chmod -R 755 ${REPOSITORY_HOME} 
#chmod -R 755 ${FEDORA_HOME} 
chmod 755 /etc/init.d/fedora
chmod -R 640 ${REPOSITORY_HOME}/etc
chmod 755 ${REPOSITORY_HOME}/etc
chmod -R 644 ${REPOSITORY_HOME}/etc/env.sh
