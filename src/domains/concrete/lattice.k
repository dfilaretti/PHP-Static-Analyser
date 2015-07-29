module LATTICE


    syntax  AInt ::= Int
    syntax  AFloat ::= Float
    syntax  ABool ::= Bool
    syntax  AString ::= String
    syntax  ARefCount ::= Int


	// valid 
	syntax 	Bool ::= "valid" "(" ABool ")"	        [function]
	rule 	valid(B:Bool) => B ==Bool true

	// unsatisfiable
	syntax 	Bool ::= "unsatisfiable" "(" ABool ")"	[function]
	rule 	unsatisfiable(B:Bool) => B ==Bool false






syntax 	Bool ::= K "<Lattice" K		[function]

rule _ <Lattice _ => false

syntax Bool ::= K "==Lattice" K [function]
rule A ==Lattice B => A ==K B





/*@ \subsection{Lattice Operations} */

// LUB

syntax AInt ::= "lub_AInt" "(" AInt "," AInt ")" [function]
syntax AFloat ::= "lub_AFloat" "(" AFloat "," AFloat ")" [function]
syntax ABool ::= "lub_ABool" "(" ABool "," ABool ")" [function]
syntax AString ::= "lub_AString" "(" AString "," AString ")" [function]
syntax ARefCount ::= "lub_ARefCount" "(" ARefCount "," ARefCount ")" [function]

rule AisString(X) => isString(X)
rule AisNull(X) => isNull(X)
rule AisBoolean(X) => isBool(X)	   

rule AisObject( Array(_,_)) =>false
rule AisObject(OID(_,_,_)) =>true
rule AisObject(X:AInt) =>false
rule AisObject(X:AFloat) =>false
rule AisObject(X:ABool) =>false
rule AisObject(X:AString) =>false
rule AisObject(NULL) =>false
	   
rule AisArray( Array(_,_)) =>true
rule AisArray(OID(_,_,_)) =>false
rule AisArray(X:AInt) =>false
rule AisArray(X:AFloat) =>false
rule AisArray(X:ABool) =>false
rule AisArray(X:AString) =>false
rule AisArray(NULL) =>false

rule AisNumericString(X) => isNumericString(X)

endmodule
