#!/bin/bash

VERSION=2

for i in {1..6} 
do
   python getData.py action $VERSION $i 
done

for i in {0..6}
do
    python getData.py quest $VERSION $i
done