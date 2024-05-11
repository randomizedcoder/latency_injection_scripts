#!/usr/bin/bash
#
# check_sysctls_and_fix.bash
#

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

if [ ! -f /usr/bin/sha1sum ]; then
    echo "/usr/bin/sha1sum not found"
    apt install coreutils
fi

file1=./sysctl.conf
file2=/etc/sysctl.conf

shasum1=$(sha1sum $file1 | cut -d ' ' -f 1)
shasum2=$(sha1sum $file2 | cut -d ' ' -f 1)

if [ "$shasum1" = "$shasum2" ]; then
    echo "sysctl files match"
else
    echo $shasum1
    echo $shasum2
    echo "sysctl files are different!"
    echo "Copying ${file1} to ${file2}"
    cp "${file1}" "${file2}"
    sysctl -p
fi
# end
