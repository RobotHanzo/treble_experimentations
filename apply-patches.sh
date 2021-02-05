#!/bin/bash

set -e

patches="$(readlink -f -- $1)"

for project in $(cd $patches/patches; echo *);do
	p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
	[ "$p" == build ] && p=build/make
	repo sync -l --force-sync $p || continue
	pushd $p
	git clean -fdx; git reset --hard
	for patch in $patches/patches/$project/*.patch;do
		#Check if patch is already applied
		if patch -f -p1 --dry-run -R < $patch > /dev/null;then
			continue
		fi

		if git apply --check $patch > /dev/null;then
			git am $patch
		elif patch -f -p1 --dry-run < $patch > /dev/null;then
			#This will fail
			git am $patch || true
			patch -f -p1 < $patch > /dev/null
			git add -u > /dev/null
			git am --continue > /dev/null
		else
			git am $patch
			echo ""
			echo "Failed applying $patch"
			echo ""
		fi
	done
	popd
done

