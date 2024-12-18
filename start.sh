#!/bin/bash

# Run your other command here
export PATH=/usr/local/bin:/root/go/bin:/usr/lib/jvm/java-17-openjdk/bin:/work_dir/blackcartenv/bin:/usr/local/go/bin:/sbin:/usr/bin:/root/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin:/usr/bin/core_perl:/root/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin:/usr/bin/core_perl:/usr/games/bin:/usr/local/spotbugs/bin
blackdagger server &
blackdagger pull cart

# Run gotty in the foreground
gotty -p 8090 -w --credential keychainharbor:sast-keychain /bin/bash
