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
rule AisBoolean(X) => isBoolean(X)	   rule AisObject( Array(_,_)) =>ABoolFalse
rule AisObject(OID(_,_,_)) =>ABoolTrue
rule AisObject(X:AInt) =>ABoolFalse
rule AisObject(X:AFloat) =>ABoolFalse
rule AisObject(X:ABool) =>ABoolFalse
rule AisObject(X:AString) =>ABoolFalse
rule AisObject(Null) =>ABoolFalse
rule AisObject(Top) =>ABoolTop
	   
rule AisArray( Array(_,_)) =>ABoolTrue
rule AisArray(OID(_,_,_)) =>ABoolFalse
rule AisArray(X:AInt) =>ABoolFalse
rule AisArray(X:AFloat) =>ABoolFalse
rule AisArray(X:ABool) =>ABoolFalse
rule AisArray(X:AString) =>ABoolFalse
rule AisArray(Null) =>ABoolFalse
rule AisArray(Top) =>ABoolTop

endmodule
