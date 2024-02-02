#!/bin/bash
#exec /bin/start.sh &
#exec /bin/launch-edgestore.sh &
DAOS=$(uname -s | tr '[:upper:]' '[:lower:]')
# echo $DAOS
if [ "$DAOS" == "linux" ]; then
  echo "Running on Linux"
  FNOS="linux"
else
  echo "Running on Mac"
  FNOS="darwin"
fi

DAARCH=$(uname -p | tr '[:upper:]' '[:lower:]')
# echo $DAARCH
if [ "$DAARCH" == "x86_64" ]; then
  echo "Running on x86_64"
  FNARCH="amd64"
else
  echo "Running on ARM"
  FNARCH="arm64"
fi
# echo $FNOS
# echo $FNARCH

FNVER="v0.17.4-beta.rc1"

LNDFN="lnd-$FNOS-$FNARCH-$FNVER.tar.gz"
echo $LNDFN

wget -O /tmp/lnd.tar.gz https://github.com/lightningnetwork/lnd/releases/download/$FNVER/$LNDFN
tar xzf /tmp/lnd.tar.gz -C /tmp
cp /tmp/lnd-linux-arm64-v0.17.4-beta.rc1/lncli /usr/local/bin

exec /usr/bin/gotty --port 8080 --permit-write --reconnect /bin/bash