#!/bin/bash

FALSE=0;
TRUE=1;

srcFileExtensions=(
	java	# Java 
#	cpp	# C++
#	cc	# C++
#	h	# C, C++
#	hh	# C++
#	hpp 	# C++
#	c 	# C
#	py	# Python
#	pl	# Perl
#	sh	# Shell
	flex	# flex
#	lex	# lex
#	y	# yacc
#	yy	# yacc
#	cs	# C#
#	ml	# OCaml
#	mli	# OCaml
#	ll	# OCamllex
#	mly	# OCamlyacc
	cup	# Java cup
); # File name extensions which will be considered as source files. Remove/add as needed. Keep the list to minimum to keep the speed good.
 
function loc_dir(){
	local prefix=$1;
	
	if [ ! -d ${prefix} ]; then
		echo "${prefix} is not a directory. Quitting...";
		exit 1;
	fi

	local names=( `ls ${prefix}` );

	for name in ${names[@]}; do
		local fullName=${prefix}/${name};
		if [ -d "${fullName}" ]; then
			loc_dir "${fullName}"
		elif [ -f "${fullName}" ]; then
			isSrcFile ${fullName};
			local result=$?;
			if [ "${result}" == "${TRUE}" ]; then
				echo "including ${fullName} ...";
				cat "${fullName}" >> "${locFile}";
			fi
		else
			echo "Something wrong with ${fullName}";
		fi
	done;
}

function remove_empty_lines(){
	local prefix=$1;

	echo "Removing empty lines...";

	local loc="${prefix}/loc.dat";
	local loc1="${prefix}/loc1.dat";
	mv ${loc} ${loc1};
	
	while read line
	do
		if [ "${line}" != "" ]; then
			echo ${line} >> ${loc};
		fi
	done <${loc1}
	rm ${loc1};
}

function isSrcFile(){
	local fileName=$1;

	for ext in ${srcFileExtensions[@]}; do
		local extLength=`expr length ".${ext}"`;
		local nameLength=`expr length "${fileName}"`;
		local startPosition=`expr ${nameLength} - ${extLength}`;
		local len=`expr ${nameLength} - 1`;
		local subString=`echo ${fileName:${startPosition}:${len}}`;
		if [ "${subString}" == ".${ext}" ]; then
			return ${TRUE};
		fi
	done;
	return ${FALSE};
}

# main
dirname="";
if [ $# == 0 ]; then
	dirname="\.";
else
	dirname=$1;
fi

locFile="${dirname}/loc.dat";

loc_dir ${dirname};

# remove_empty_lines ${dirname};

if [ -f "${locFile}" ]; then
	result=( `wc -l "${locFile}"` );
else
	result=0;	
fi

loc=${result[0]};
echo "${loc} lines of code."
rm "${locFile}";
