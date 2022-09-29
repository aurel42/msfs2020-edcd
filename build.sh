#!/bin/bash

PATH=$PATH:/mnt/c/MSFStk

case "$1" in
    cleanonly)
	rm -rfv Temp Output
	exit
	;;
    clean*)
	rm -rfv Temp Output
	# echo "aerial: runway 25 (2013)"
	# powershell.exe msfs aerial -border '.\Sources\edcd-rwy25.shp' \
	# 	       -imagery '.\Sources\dop20-2013\edcd-2013-64k.tif' \
	# 	       -blend 5 -res 0.2 -epsg 25833 \
	# 	       '.\PackageSources\aerial\tiles\'

	echo "aerial: runway 25 ALS"
	powershell.exe msfs aerial -border '.\Sources\edcd-rwy25-als.shp' \
		       -imagery '.\Sources\dop20-2013\edcd-2013-64k.tif' \
		       -blend 10 -res 0.2 -epsg 25833 \
		       '.\PackageSources\aerial\tiles\'
	for i in PackageSources/aerial/tiles/*.png; do convert $i -level 0%,90% -modulate 50,120,100 $i; done

	# echo "aerial: reference"
	# powershell.exe msfs aerial -border '.\Sources\edcd-premises-outer.shp' \
	# 	       -imagery '.\Sources\dop20-2013\edcd-2013-64k.tif' \
	# 	       -blend 10 -res 0.5 -epsg 25833 \
	# 	       '.\PackageSources\aerial\tiles\'
	# for i in PackageSources/aerial/tiles/*.png; do convert $i -level 0%,90% -modulate 80,120,100 $i; done

	echo mesh: outer airfield premises in 5m
	powershell.exe msfs elev -border '.\Sources\edcd-premises-outer.shp' \
		       -imagery '.\Sources\dem\dgm-edcd.tif' \
		       -res 5 -falloff 100 -priority 2 \
		       'PackageSources\mesh\mesh-edcd-premises-outer.xml'

	echo mesh: runways and aprons in 1m
	powershell.exe msfs elev -border '.\Sources\edcd-runway-apron.shp' \
		       -imagery '.\Sources\dem\dgm-edcd.tif' \
		       -res 1 -falloff 20 -priority 3 \
		       -airport 'PackageSources\scene\EDCD.xml' \
		       'PackageSources\mesh\mesh.xml'

	echo shelters in the northeast in 1m
	powershell.exe msfs elev -border '.\Sources\edcd-shelters-northeast.shp' \
		       -imagery '.\Sources\dem\dgm-edcd.tif' \
		       -res 1 -falloff 20 -priority 3 \
		       'PackageSources\mesh\mesh-edcd-shelters-northeast.xml'
	;;
esac

# msfs project -type scenery -id EDCD -name "charliebravo-airport-edcd-cottbus-drewitz" -title "Flugplatz Cottbus-Drewitz" -creator aurel -version 0.1.0 -aerial -scene -mesh -services EDCD "edcd"

fspackagetool.exe -mirroring -nopause '.\charliebravo-airport-edcd-cottbus-drewitz.xml'
