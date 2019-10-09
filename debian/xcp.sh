#!/bin/bash

xcp()
{
   echo "sour: $1"
   echo "dest: $2"
   cp -f $1 $2
}

export -f xcp
