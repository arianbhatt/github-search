#!/bin/bash
# github@arianbhatt
# Dependencies - curl, sed, awk, git, grep, dmenu

mkdir -p $HOME/.cache/github_search

menu="dmenu -i -l 10"
cachedir="$HOME/.cache/github_search"

if [ -z $1 ]; then
	query=$(dmenu -p "Search Github: " <&-)
else
	query=$1
fi

query="$(echo $query | sed 's/ /+/g')"

# reference curl 'https://github.com/search?q=python&ref=simplesearch' -H 'User-Agent:Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/2010010 Firefox/95.0'
# search="https://github.com/search?q=$query&ref=simplesearch"
curl -s "https://github.com/search?q=$query&ref=simplesearch" -H 'User-Agent:Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/2010010 Firefox/95.0' > $cachedir/temp.html
grep v-align-middle $cachedir/temp.html | cut -d' ' -f13 | awk 'NF' | cut -d'"' -f2 | grep / > $cachedir/results.txt
result_count=$(wc -l $cachedir/results.txt | awk '{print $1}')
notify-send "$result_count Results Found"
selected_repo=$(cat $cachedir/results.txt | dmenu -p "Select Repository to clone: " -l 10)
if test -z "$selected_repo"
then
	echo Valid Repo not selected
else
	git clone "https://github.com/$selected_repo"
fi
