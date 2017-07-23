#!/bin/sh
#
# ironic sync db.
#

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=5
  local delay=15
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}

cat > /tmp/create_database.sql <<-EOF
CREATE DATABASE IF NOT EXISTS ironic CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'localhost' \
       IDENTIFIED BY '$MYSQL_IRONIC_PASSWORD';
GRANT ALL PRIVILEGES ON ironic.* TO 'ironic'@'%' \
       IDENTIFIED BY '$MYSQL_IRONIC_PASSWORD';
EOF

retry mysql -u root -p$MYSQL_ROOT_PASSWORD -h mariadb < /tmp/create_database.sql
ironic.conf.sh

# start sync db
retry ironic-dbsync
