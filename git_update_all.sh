#!/bin/bash

usage() {
	echo "$0 <root directory>"
}

echo $#

if [ $# != 1 ]; then
	usage
	exit -1
fi

root_dir=$1
echo $root_dir


RED='\033[0;31m'
NC='\033[0m' # No Color

# Assume all repos are at the same level, so that we can stop traversing once we find a repo.
# Traverse in DFS.

traverse() {
	dir=$1
	func=$2
	echo -e "${RED}Checking $dir ...${NC}"
	# check if the current directory is a repo
	ls .git &> /dev/null
	if [ $? == 0 ]; then
		$func
		return 1
	fi

	# not a repo, then iterate over all directories
	for d in `ls -d */`; do
		pushd $d
		traverse $d $func
		popd
	done
}

update_git() {
	#git pull
	echo -e "${RED}Pulling the latest code in $PWD${NC}"
	git pull
}

traverse $root_dir update_git

