# hiding ugly inner syntax
s/\(.*\)'`(_,_`)\(.*\)/\1\2/g

# hiding some cells
#/<trace>/,/<\/trace>/d
/<tables>/,/<\/tables>/d
/<instrumentation>/,/<\/instrumentation>/d
/<gc>/,/<\/gc>/d
/<control>/,/<\/control>/d

#xml tag nesting problems with error-trace
s/[ ]*ListItem("<error-trace>")/<error-trace>/g
s/[ ]*ListItem("<\/error-trace>")/<\/error-trace>/g
s/[ ]*ListItem("\\n")//g

# improve memory presentation
s/[ ]*ListItem("\([^"]*\)")/<t>\1<\/t>/g
s/[ ]*#symLoc(\([^)]*\)) |-> #symLoc(\([^)]*\))/<x>\1 > \2<\/x>/g
s/[ ]*#symLoc(\([^)]*\)) |-> zval /<\/m><m>\1 > /g

# improve functions presentation
s/[ ]*"\([^"]*\)" |-> setWrap /<\/f><f><name>\1<\/name>  /g

# Clarify empty arrays
#s/Array ( none \, \.List )/EmptyArray/g 
s/Array ( \'none(\.KList) \, \.List )/EmptyArray/g 

# hide this
s/ListItem//g

# match xml tags
s/<heap>/<heap><m>/g
s/<\/heap>/<\/m><\/heap>/g
s/<functions>/<functions><f>/g
s/<\/functions>/<\/f><\/functions>/g

