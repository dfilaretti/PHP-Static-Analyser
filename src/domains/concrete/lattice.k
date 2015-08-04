module LATTICE


    syntax  AInt ::= Int
    syntax  AFloat ::= Float
    syntax  ABool ::= Bool
    syntax  AString ::= String
    rule isAStringConcrete => true // avoid confusion String = AString
   
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

rule AisString(X) => isStringType(X)

rule AisBoolean(X) => isBoolType(X)	   

rule AisNull( Array(_,_)) =>false
rule AisNull(OID(_,_,_)) =>false
rule AisNull(X:AInt) =>false
rule AisNull(X:AFloat) =>false
rule AisNull(X:ABool) =>false
rule AisNull(X:AString) =>false
rule AisNull(NULL) =>true

rule AisNumber( Array(_,_)) =>false
rule AisNumber(OID(_,_,_)) =>false
rule AisNumber(X:AInt) =>true
rule AisNumber(X:AFloat) =>true
rule AisNumber(X:ABool) =>false
rule AisNumber(X:AString) =>false
rule AisNumber(NULL) =>false

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

rule intersects(X,H) => X ==K H


syntax K ::= "gamma(" PlainLanguageValue ")" [function] //SM should not be K really
rule gamma(X) = X

endmodule
