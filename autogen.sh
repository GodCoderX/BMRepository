#!/bin/bash

escape() {
	escaped=`echo $1 | sed -e "s/ /\\ /g"`
	echo ${escaped}
}

if [ -e Original ]; then
	echo "Initializing started."
	rm -rf Original
	find Mod -name "Data" -type d | while read DataPath
	do
		rm -rf ${DataPath}
	done
	echo "Initializing finished."
fi

if [ ! -e Data ]; then
	echo "Data directory does NOT exist in the current directory."
	exit
fi

cwd=`dirname ${0}`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`
cd ${cwd}
find Mod -name "*.zip" | while read ModZip
do
	echo "Processing "${ModZip}" ..."
	ModDir="Mod"
	OriZip=`echo "Original/"${ModZip#*/}`
	OriDir="Original"
	cd ${cwd}
	cd ${ModDir} # cd "Mod"
	unzip ${ModZip#*/} > /dev/null
	find Data -type f | while read FileName
	do
		cd ${cwd}
		echo "-- "${ModDir}"/"${FileName}
		FileName=`escape ${FileName}`
		if [ -e ${FileName} ]; then
			FilePath="${OriDir}/${FileName}"
			mkdir -p "${FilePath%/*}"
			cp "${FileName}" "${FilePath}"
		fi
	done
	cd ${cwd}
	cd ${ModDir}
	rm -rf Data
	cd ${cwd}
	cd ${OriDir}
	echo "Archiving ${ModZip%/*}"
	zip -r ${ModZip#*/} Data > /dev/null
	rm -rf Data
	cd ${cwd}
done
