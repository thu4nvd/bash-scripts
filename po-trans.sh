#!/bin/bash
#************************************************#
# File:    po-trans.sh
# Author:  thuanvd@outlook.com
# Date:    Juin 03, 2017
#
# Translate every line using trans tool
# Requirement: translate cli tools (https://github.com/soimort/translate-shell/)
# Parameter: -i input-file -o output-file -l languages
# Returns: 0 on success, $E_BADFILE if something went wrong.
#--------------------------------------------------------- #

#define constant
E_BADFILE=85                       # No such directory.

## Define function() here
#print help information
help(){
  echo -e "Usage:\t po-trans.sh -i input-file [-o output-file ] [-l langue-src:langue-dest]"
  echo -e "Example:\t po-trans.sh -i input.po -o output.po -l en:vi"
}

#check Requirement
trans_tools=$(which trans)
if [[ -z "$trans_tools" ]]; then
  echo -e "Translation tools not found \n"
  echo -e "Install at (https://github.com/soimort/translate-shell/)"
  exit 0
fi

#get prarameters and check
while getopts i:o:l: opt ; do
  case "$opt" in
    i) file_in="$OPTARG" ;;
    o) file_out="$OPTARG" ;;
    l) lang="$OPTARG" ;;
    *) help ;;
  esac
done

if [[ -z "$file_in" ]]; then
  echo -e "Param -i with input file not found \n"
  help
  exit 0
fi

if [[ -z "$file_out" ]]; then
  file_out="/dev/stdout"
fi

if [[ -z "$lang" ]]; then
  lang="en:vi"
fi


##main procedure main(){}
#analyse each line
#if line start by msgid ->
#     if next line start by msgstr -> copy it and copy it's translation to output-file
#           and ignore that msgstr line
#     else read copy line to tmp until msgstr line and copy them to destination file.
#            and ignore following msgstr line

while IFS='' read -r line; do
  if grep -q -e "^msgid" <<< "$line" ; then
      IFS='' read -r next_line
      if grep -q -e "^msgstr" <<< "$next_line" ; then
        id="${line##msgid}"
        dest=$(trans "$lang" -b "${id}")
        echo "$line" >> "$file_out"
        echo "msgstr ${dest}" >> "$file_out"
      else
        echo "$line" >> "$file_out"
        tmp_file="$(mktemp)"
        echo "msgstr ${line##msgid}" >> "$tmp_file"
        echo "$next_line" >> "$file_out"
        echo "$next_line" >> "$tmp_file"
        while IFS='' read -r next_line; do
          if grep -q -e "^msgstr" <<< "$next_line"; then
            break
          else
            echo "$next_line" >> "$file_out"
            echo "$next_line" >> "$tmp_file"
          fi
        done
        #echo -e "msgid $block\nmsgstr $block\n" >> "$file_out"
        cat "$tmp_file" >> "$file_out"
      fi
  else
    echo "$line" >> "$file_out"
  fi
done < $file_in
