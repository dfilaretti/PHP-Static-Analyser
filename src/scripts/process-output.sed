s/\(.*\)'`(_,_`)\(.*\)/\1\2/g
/<tables>/,/<\/tables>/d
/<instrumentation>/,/<\/instrumentation>/d
/<gc>/,/<\/gc>/d
/<control>/,/<\/control>/d
s/[ ]*ListItem("\([^"]*\)")/<t>\1<\/t>/g
s/[ ]*#symLoc(\([^)]*\)) |-> #symLoc(\([^)]*\))/<x>\1 > \2<\/x>/g
s/[ ]*#symLoc(\([^)]*\)) |-> zval /<\/m><m>\1 > /g
s/<heap>/<heap><m>/g
s/<\/heap>/<\/m><\/heap>/g
#s/Array ( \[ \([^]]*\)\] \,/Array ( /g 
s/Array ( none \, \.List )/EmptyArray/g 
#s/( Array ( \[ .*ListItem/Array ( ListItem/g 
#/( Array (/,/ListItem/d 
#s/\(.*\)ListItem(\[\(.*\)\])/\1\[\2\]/g
s/ListItem//g