#!/bin/bash

escape() {
	escaped=`echo $1 | sed -e "s/ /\\ /g"`
	echo ${escaped}
}

if [ -e Remove ]; then
	echo "Initializing started."
	rm -rf Remove
	mkdir Remove
	echo "Initializing finished."
fi

if [ ! -e Data ]; then
	echo "Data directory does NOT exist in the current directory."
	exit
fi

cwd=`dirname ${0}`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`
cd ${cwd}
find Install -name "*.zip" | while read InstallZip
do
	echo "Processing "${InstallZip}" ..."
	InstallDir="Install"
	RemoveZip=`echo "Remove/"${InstallZip#*/}`
	RemoveDir="Remove"
	cd ${cwd}
	cd ${InstallDir}
	unzip ${InstallZip#*/} > /dev/null
	find Data -type f | while read FileName
	do
		cd ${cwd}
		echo "-- "${InstallDir}"/"${FileName}
		FileName=`escape ${FileName}`
		if [ -e ${FileName} ]; then
			FilePath="${RemoveDir}/${FileName}"
			mkdir -p "${FilePath%/*}"
			cp "${FileName}" "${FilePath}"
		fi
	done
	cd ${cwd}
	cd ${InstallDir}
	rm -rf Data
	cd ${cwd}
	cd ${RemoveDir}
	echo "Archiving ${InstallZip%/*}"
	zip -r ${InstallZip#*/} Data > /dev/null
	rm -rf Data
	cd ${cwd}
done
