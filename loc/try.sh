#!/bin/bash

FALSE=0;
TRUE=1;

function completePathName(){
	if [ ! $# == 1 ]; then
		echo "completePathName : function takes 1 parameters; your provided $#.";
	fi

	local name=$1;
	local completeName="";
	echo "first character = ${name}.";
	if [ ! ${name[0]} == "/" ]; then
		completeName="`pwd`/${name}";
	else
		completeName=${name};
	fi
	echo "Complete name = ${completeName}";
}

completePathName /sujit;