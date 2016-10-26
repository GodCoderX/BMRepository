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
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)` # cwd=/path/to/Default
cd ${cwd}
find Mod -name "*.zip" | while read ModZip # ModZip="Mod/gfx.drivearrow.transparent50.zip"
do
	echo "Processing "${ModZip}" ..."
	ModDir="Mod"
	OriZip=`echo "Original/"${ModZip#*/}` # OriZip="Original/gfx.drivearrow.transparent50.zip"
	OriDir="Original"
	cd ${cwd}
	cd ${ModDir} # cd "Mod"
	unzip ${ModZip#*/} > /dev/null
	find Data -type f | while read FileName # FileName="Data/Sfx/GUI_battle_streamed.fsb"
	do
		cd ${cwd}
		echo "-- "${ModDir}"/"${FileName}
		FileName=`escape ${FileName}`
		if [ -e ${FileName} ]; then
			FilePath="${OriDir}/${FileName}" # FilePath="Original/1/6/5/Data/Sfx/GUI_battle_streamed.fsb"
			mkdir -p "${FilePath%/*}" # mkdir -p Original/1/6/5/Data/Sfx
			cp "${FileName}" "${FilePath}" # cp "Data/Sfx/GUI_battle_streamed.fsb" "Original/1/6/5/Data/Sfx/GUI_battle_streamed.fsb"
		fi
	done
	cd ${cwd}
	cd ${ModDir} # cd "Mod/1/6/5"
	rm -rf Data
	cd ${cwd}
	cd ${OriDir} # cd "Original/1/6/5"
	echo "Archiving ${ModZip%/*}"
	zip -r ${ModZip#*/} Data > /dev/null
	rm -rf Data
	cd ${cwd}
done
