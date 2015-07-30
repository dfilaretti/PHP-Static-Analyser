require "lattice.k"
require "../../lang/type-conversions.k"

module FORWARD-OPS
	imports LATTICE
	imports TYPE-CONVERSIONS
	imports INIT
	
syntax K ::= "stopDebug"


//@ \section{Reference counter operations}

syntax  ARefCount ::= ARefCount "+ARefCount" ARefCount [function]
rule    R1 +ARefCount R2 => R1 +Int R2 

syntax  ARefCount ::= ARefCount "-ARefCount" ARefCount [function]
rule    R1 -ARefCount R2 => R1 -Int R2 

syntax  Bool ::= ARefCount "<ARefCount" ARefCount [function]
rule    R1 <ARefCount R2 => R1 <Int R2 


//@ \section{Arithmetic operations}

	// Plus
syntax  AInt ::= AInt "+AInt" AInt	[function]	
rule    I1:Int +AInt I2:Int => I1 +Int I2

syntax  AFloat ::= AFloat "+AFloat" AFloat	[function]
rule    F1:Float +AFloat F2:Float => F1 +Float F2
 
	// Min TODO: not user??
syntax  AInt ::= AInt "-AInt" AInt	[function]	
rule    I1:Int -AInt I2:Int => I1 -Int I2

syntax  AFloat ::= AFloat "-AFloat" AFloat	[function]
rule    F1:Float -AFloat F2:Float => F1 -Float F2

	// Mul
syntax  AInt ::= AInt "*AInt" AInt	[function]	
rule    I1:Int *AInt I2:Int => I1 *Int I2

syntax  AFloat ::= AFloat "*AFloat" AFloat	[function]
rule    F1:Float *AFloat F2:Float => F1 *Float F2

	// Div (TODO) 

    // Mod (TODO) 
syntax 	AInt ::= "negative_AInt" "(" AInt ")" [function]
rule	negative_AInt(X) => 0 -Int X

syntax 	AFloat ::= "negative_AFloat" "(" AFloat ")" [function]
rule	negative_AFloat(X) => 0.0 -Float X



//@ \section{Type conversion primitives}

syntax String ::= "*toString" "(" LanguageValue ")"  [function]

rule *toString(true) => "1" [internal]

rule *toString(false) => "" [internal]

rule *toString(I:Int) => Int2String(I) [internal]

rule *toString(F:Float) => Float2String(F) [internal]

rule *toString(S:String) => S [internal]

rule *toString(Arr:Array) => "Array" [internal]
	
rule *toString(Obj:Object) => ERROR("Object of class %s could not be converted to string in %s on line %d") [internal, error]

rule *toString(NULL) => "" [internal]


// to boolean
syntax Bool ::= "*toBoolean" "(" LanguageValue ")" [function]

rule *toBoolean(B:Bool) => B [internal]
	
rule *toBoolean(0) => false [internal]

rule *toBoolean(N:Int) => true 
when notBool (N ==Int 0)
	[internal]

rule *toBoolean(F:Float) => false 
when (F ==Float 0.0)
	[internal]

rule *toBoolean(F:Float) => true 
when notBool (F ==Float 0.0)
	[internal]

rule *toBoolean("") => false [internal]

rule *toBoolean("0") => false [internal]

rule *toBoolean(S:String) => true 
when notBool ((S ==String "") orBool (S ==String "0"))
	[internal]

rule *toBoolean(Array(_,Elems)) => false 
when (Elems ==List .List)
	[internal]

rule *toBoolean(Array(_,Elems)) => true   
when (notBool (Elems ==List .List))
	[internal]

// Object case: we add it, even if the online docs says this behaviour is "PHP 4 only"
// Since the expected behaviour for PHP 5 is not mentioned, I guess it is undefined..?

rule *toBoolean(OID(L,_,_) => convertToLanguageValue(L))   
[internal]

rule *toBoolean(NULL) => false 
[internal]

// to float
syntax Float ::= "*toFloat" "(" LanguageValue ")"  [function]

rule *toFloat(false) => 0.0 [internal]
	
rule *toFloat(true) => 1.0 [internal]

rule *toFloat(I:Int) => Int2Float(I) [internal]

rule *toFloat(F:Float) => F [internal]

rule *toFloat(S:String) => *toFloat( string2Number(S) ) [internal]
	
rule *toFloat(O:CompoundValue) => WARNING("conversion of compound types to integer is undefined (http://www.php.net/manual/en/language.types.integer.php)\n") ~> 1.0 [internal, error]

//@ \section{Logic operations}

syntax  ABool ::= "notABool" ABool

rule    notABool B:Bool => notBool B

//@ \section{Comparisons}

syntax  ABool ::= AInt "==AInt" AInt  [function]
rule    I1:Int ==AInt I2:Int => I1 ==Int I2

syntax  ABool ::= "greater" "(" K "," K ")" [function]
rule    greater(I1:Int, I2:Int) => I1 >Int I2

syntax  ABool ::= "lessEqual" "(" K "," K ")" [function]
rule    lessEqual(I1:Int, I2:Int) => I1 <=Int I2



 
syntax  ABool ::= AFloat "==AFloat" AFloat  [function]
rule F1:Float ==AFloat F2:Float => F1 ==Float F2

syntax  ABool ::= ABool "==ABool" ABool  [function]
rule B1:Bool ==ABool B2:Bool => B1 ==Bool B2

syntax  ABool ::= AString "==AString" AString  [function]
rule S1:String ==AString S2:String => S1 ==String S2

//@ \section{Input and output}

// basic output
syntax  K ::= "print" "(" K ")"     [strict]

rule    [internal-print]:    
	    <k> print (V:Float => Float2Int(V))  ... </k>
//	    when (hasNoDecimalPart(V))
	    [internal, output]
	
rule    [internal-print]:    
	    <k> print (V:Float => *toString(V))  ... </k> 
//	    when notBool (hasNoDecimalPart(V))
	    [internal, output]
	
rule    [internal-print]:    
	    <k> print (V:LanguageValue => *toString(V))  ... </k> 
	    when notBool(isFloatType(V) orBool isStringType(V))
	    [internal, output]

rule    [internal-print]:    
	    <k> print (V:String)  => . ... </k>
	    <out> ... . => ListItem(V) </out>  
	    [internal, output]

//string2Number

syntax PlainLanguageValue ::= "string2Number" "(" AString ")" [function]

rule  string2Number("") => 0 
	
	[internal]

// one character string

rule  string2Number(S:String) => 0 
when (lengthString(S) ==Int 1 orBool lengthString(S) ==Int 2) andBool (notBool #isDigit(substrString(S, 0, 1)))
	[internal]

rule string2Number(S:String) => String2Int(S) 
when (lengthString(S) ==Int 1) andBool (#isDigit(substrString(S, 0, 1)))
	[internal]

// non numeric 

rule string2Number(S:String) => 0 
when notBool (
	((lengthString(S) >Int 1) andBool #isDigit(substrString(S, 0, 1))) orBool	
	((substrString(S, 0, 1) ==String "-" orBool substrString(S, 0, 1) ==String ".") andBool (#isDigit(substrString(S, 1, 2)))) orBool
	((substrString(S, 0, 2) ==String "-.") andBool (#isDigit(substrString(S, 2, 3)))))
	[internal]
	
// integer 

rule string2Number(S:String) => extractIntSubstring(S, substrString(S, 0, 1), 1, int) 
when ((lengthString(S) >Int 1) andBool
	#isDigit(substrString(S, 0, 1))) orBool
	((substrString(S, 0, 1) ==String "-") andBool (#isDigit(substrString(S, 1, 2))))
	[internal]

// string starting with ".N" 

rule string2Number(S:String) => extractIntSubstring(S, substrString(S, 0, 1), 1, float) 
when ((lengthString(S) >Int 1) andBool
	#isDigit(substrString(S, 0, 1))) orBool
	((substrString(S, 0, 1) ==String ".") andBool (#isDigit(substrString(S, 1, 2))))
	[internal]

// string starting with "-." 

rule string2Number(S:String) => extractIntSubstring(S, substrString(S, 0, 2), 2, float) 
when ((lengthString(S) >Int 2) andBool
	#isDigit(substrString(S, 0, 1))) orBool
	((substrString(S, 0, 2) ==String "-.") andBool (#isDigit(substrString(S, 2, 3))))
	[internal]
		
		
syntax PlainLanguageValue ::= "extractIntSubstring" "(" String "," String "," Int "," Type ")" [function]

// digit
rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int,
		T:Type
	) =>
	extractIntSubstring(
		Origin:String, 
		Number +String substrString(Origin, Index, Index +Int 1),
		Index +Int 1,
		T:Type
	) 
	when 	#isDigit(substrString(Origin, Index, Index +Int 1)) andBool 
			(Index <Int lengthString(Origin))
	[internal]
		
// "."
rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int,
		int
	) =>
	extractIntSubstring(
		Origin:String, 
		Number +String substrString(Origin, Index, Index +Int 1),
		Index +Int 1,
		float
	) 
	when 	(substrString(Origin, Index, Index +Int 1) ==String ".") andBool
			(#isDigit(substrString(Origin, Index +Int 1, Index +Int 2))) andBool
			((Index +Int 1) <Int lengthString(Origin))
	[internal]

rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int,
		float
	) => String2Float(Number) 
	when notBool (#isDigit(substrString(Origin, Index, Index +Int 1)) andBool 
	(Index <Int lengthString(Origin)))
	[internal]
				
rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int,
		int
	) => String2Int(Number) 
	when notBool (#isDigit(substrString(Origin, Index, Index +Int 1)) andBool 
			(notBool (substrString(Origin, Index, Index +Int 1) ==String ".")) andBool
			(Index <Int lengthString(Origin)))
	[internal]

/* the entire string represent a number  */

rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int, 
		int
	) => String2Int(Number)	
	when Index ==Int lengthString(Origin)
	[internal]
		
rule extractIntSubstring(
		Origin:String, 
		Number:String, 
		Index:Int, 
		float
	) => String2Float(Number) 			
	when Index ==Int lengthString(Origin)
	[internal]

// input 
syntax K ::= "user_input"
	
rule    [input]:
        <k> user_input => V ...</k>
	    <in> ListItem(V:K) => . ...</in>


rule [init-domain]:
		<k> initDomain => . ... </k>
		<domain> .K => Concrete </domain>

syntax Bool ::= "isNumericString" "(" AString ")" [function]

rule isNumericString(S:String) => S isNumeric
		



endmodule
