# hiding ugly ineer syntax
s/\(.*\)'`(_,_`)\(.*\)/\1\2/g

# hiding some cells
#/<trace>/,/<\/trace>/d
/<tables>/,/<\/tables>/d
/<instrumentation>/,/<\/instrumentation>/d
/<gc>/,/<\/gc>/d
/<control>/,/<\/control>/d

# improve memory presentation
s/[ ]*ListItem("\([^"]*\)")/<t>\1<\/t>/g
s/[ ]*#symLoc(\([^)]*\)) |-> #symLoc(\([^)]*\))/<x>\1 > \2<\/x>/g
s/[ ]*#symLoc(\([^)]*\)) |-> zval /<\/m><m>\1 > /g

# Clarify empty arrays
s/Array ( none \, \.List )/EmptyArray/g 

# hide this
s/ListItem//g

# match xml tags
s/<heap>/<heap><m>/g
s/<\/heap>/<\/m><\/heap>/g
