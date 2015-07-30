require "lattice.k"
require "../../lang/arith-ops.k"
module OPS
       imports LATTICE
	   imports ARITH-OPS
	   imports INIT
	   
	   // Domain value manipulation
	   
	   syntax AIntValue ::= "AIntOfErr" "(" ErrFlag ")" [function]
	   
	   rule AIntOfErr(E) => *valueToInteger(valueOfErr(E)) //Always AInt in this domain, but useful to make a library at some point
	   
	   syntax AIntValue ::= "AIntOfErrs" "(" List ")" [function]
	   
	   rule AIntOfErrs(.List) => AIntBot
	   
	   rule AIntOfErrs( ListItem(E)  L) =>  lub_Value(AIntOfErr(E), AIntOfErrs(L))
	   
	   syntax AIntValue ::= "AIntOfTuple" "(" DomainValue ")" [function]
	   
	   rule AIntOfTuple(NULL) => AInt
	   rule AIntOfTuple( (V:AIntValue, E):AInt ) => lub_Value(*valueToInteger(V), AIntOfErrs(E)) 
	   rule AIntOfTuple( (V:AFloatValue, E):AFloat ) => lub_Value(*valueToInteger(V), AIntOfErrs(E)) 
	   rule AIntOfTuple( (V:AStringValue, E):AString) => lub_Value(*valueToInteger(V), AIntOfErrs(E)) 
	   rule AIntOfTuple( (V:ABoolValue, E):ABool) => lub_Value(*valueToInteger(V), AIntOfErrs(E)) 
	   
	   syntax AFloatValue ::= "AFloatOfErr" "(" ErrFlag ")" [function]
	   
	   rule AFloatOfErr(E) => *valueToFloat(valueOfErr(E)) 
	   
	   syntax AFloatValue ::= "AFloatOfErrs" "(" List ")" [function]
	   
	   rule AFloatOfErrs(.List) => AFloatBot
	   
	   rule AFloatOfErrs( ListItem(E)  L) =>  lub_Value(AFloatOfErr(E), AFloatOfErrs(L))
	   
	   syntax AFloatValue ::= "AFloatOfTuple" "(" DomainValue ")" [function]
	   
	   rule AFloatOfTuple(NULL) => AFloat
	   rule AFloatOfTuple( (V:AIntValue, E):AInt ) => lub_Value(*valueToFloat(V), AFloatOfErrs(E)) 
	   rule AFloatOfTuple( (V:AFloatValue, E):AFloat ) => lub_Value(*valueToFloat(V), AFloatOfErrs(E)) 
	   rule AFloatOfTuple( (V:AStringValue, E):AString ) => lub_Value(*valueToFloat(V), AFloatOfErrs(E)) 
	   rule AFloatOfTuple( (V:ABoolValue, E):ABool ) => lub_Value(*valueToFloat(V), AFloatOfErrs(E)) 
	   
	   syntax AStringValue ::= "AStringOfErr" "(" ErrFlag ")" [function]
	   
	   rule AStringOfErr(E) => *valueToString(valueOfErr(E)) 
	   
	   syntax AStringValue ::= "AStringOfErrs" "(" List ")" [function]
	   
	   rule AStringOfErrs(.List) => AStringBot
	   
	   rule AStringOfErrs( ListItem(E)  L) =>  lub_Value(AStringOfErr(E), AStringOfErrs(L))
	   
	   syntax AStringValue ::= "AStringOfTuple" "(" K ")" [function]
	 
	   rule AStringOfTuple(NULL) => ""
	   rule AStringOfTuple( (V:AIntValue, E):AInt ) => lub_Value(*valueToString(V), AStringOfErrs(E)) 
	   rule AStringOfTuple( (V:AFloatValue, E):AFloat ) => lub_Value(*valueToString(V), AStringOfErrs(E)) 
	   rule AStringOfTuple( (V:AStringValue, E):AString ) => lub_Value(*valueToString(V), AStringOfErrs(E)) 
	   rule AStringOfTuple( (V:ABoolValue, E):ABool ) => lub_Value(*valueToString(V), AStringOfErrs(E)) 
	   
	   syntax ABoolValue ::= "ABoolOfErr" "(" ErrFlag ")" [function]
	   
	   rule ABoolOfErr(E) => *valueToBool(valueOfErr(E)) 
	   
	   syntax ABoolValue ::= "ABoolOfErrs" "(" List ")" [function]
	   
	   rule ABoolOfErrs(.List) => ABoolBot
	   
	   rule ABoolOfErrs( ListItem(E)  L) =>  lub_Value(ABoolOfErr(E), ABoolOfErrs(L))
	   
	   syntax ABoolValue ::= "ABoolOfTuple" "(" DomainValue ")" [function]
	   
	   rule ABoolOfTuple(NULL) => ABoolFalse
	   rule ABoolOfTuple( (V:AIntValue, E):AInt ) => lub_Value(*valueToBool(V), ABoolOfErrs(E)) 
	   rule ABoolOfTuple( (V:AFloatValue, E):AFloat ) => lub_Value(*valueToBool(V), ABoolOfErrs(E)) 
	   rule ABoolOfTuple( (V:AStringValue, E):AString ) => lub_Value(*valueToBool(V), ABoolOfErrs(E)) 
	   rule ABoolOfTuple( (V:ABoolValue, E):ABool ) => lub_Value(*valueToBool(V), ABoolOfErrs(E)) 
	   
	   // Domain operations
	   
       syntax AIntValue ::= AIntValue "+AIntValue" AIntValue [function]
       syntax AIntValue ::= AIntValue "-AIntValue" AIntValue [function]
       syntax AIntValue ::= AIntValue "*AIntValue" AIntValue [function]
       syntax AIntValue ::= AIntValue "/AIntValue" AIntValue [function]
       syntax AIntValue ::= AIntValue "modAIntValue" AIntValue [function]
       syntax AIntValue ::= "negative_AIntValue" "(" AIntValue ")" [function]       

	   rule AInt +AIntValue AInt => AInt
       rule AInt -AIntValue AInt => AInt
       rule AInt *AIntValue AInt => AInt
       rule AInt /AIntValue AInt => AInt
       rule AInt modAIntValue AInt => AInt
       rule negative_AIntValue(AInt) => AInt
	   
	   
	   //TODO : move syntax decls to lang ? (required for any domain)
	   
	   syntax AInt ::= AInt "+AInt" AInt [function]
       syntax AInt ::= AInt "-AInt" AInt [function]
       syntax AInt ::= AInt "*AInt" AInt [function]
       syntax AInt ::= AInt "/AInt" AInt [function]
       syntax AInt ::= AInt "modAInt" AInt [function]
       syntax AInt ::= "negative_AInt" "(" AInt ")" [function]       
	   
	   rule (V1:AIntValue, E1) +AInt (V2:AIntValue, E2) => (AIntOfTuple( (V1, E1) ) +AIntValue AIntOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AIntValue, E1) -AInt (V2:AIntValue, E2) => (AIntOfTuple( (V1, E1) ) -AIntValue AIntOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AIntValue, E1) *AInt (V2:AIntValue, E2) => (AIntOfTuple( (V1, E1) ) *AIntValue AIntOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AIntValue, E1) /AInt (V2:AIntValue, E2) => (AIntOfTuple( (V1, E1) ) /AIntValue AIntOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AIntValue, E1) modAInt (V2:AIntValue, E2) => (AIntOfTuple( (V1, E1) ) modAIntValue AIntOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule negative_AInt((V1:AIntValue, E1)) => (negative_AIntValue(AIntOfTuple((V1, E1))), FilterErrFlags(E1))
       

	   syntax AFloatValue ::= AFloatValue "+AFloatValue" AFloatValue	[function]
       syntax AFloatValue ::= AFloatValue "-AFloatValue" AFloatValue [function]
       syntax AFloatValue ::= AFloatValue "*AFloatValue" AFloatValue [function]
       syntax AFloatValue ::= AFloatValue "/AFloatValue" AFloatValue [function]
       syntax AFloatValue ::= "negative_AFloatValue" "(" AFloatValue ")" [function]
	   
       syntax AFloat ::= AFloat "+AFloat" AFloat	[function]
       syntax AFloat ::= AFloat "-AFloat" AFloat [function]
       syntax AFloat ::= AFloat "*AFloat" AFloat [function]
       syntax AFloat ::= AFloat "/AFloat" AFloat [function]
       syntax AFloat ::= "negative_AFloat" "(" AFloat ")" [function]

       rule  AFloat +AFloatValue AFloat => AFloat
       rule  AFloat -AFloatValue AFloat => AFloat
       rule  AFloat *AFloatValue AFloat => AFloat
       rule  AFloat /AFloatValue AFloat => AFloat
       rule negative_AFloatValue(AFloat) => AFloat

	   
	   rule (V1:AFloatValue, E1) +AFloat (V2:AFloatValue, E2) => (AFloatOfTuple( (V1, E1) ) +AFloatValue AFloatOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AFloatValue, E1) -AFloat (V2:AFloatValue, E2) => (AFloatOfTuple( (V1, E1) ) -AFloatValue AFloatOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AFloatValue, E1) *AFloat (V2:AFloatValue, E2) => (AFloatOfTuple( (V1, E1) ) *AFloatValue AFloatOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule (V1:AFloatValue, E1) /AFloat (V2:AFloatValue, E2) => (AFloatOfTuple( (V1, E1) ) /AFloatValue AFloatOfTuple( (V2, E2) ), mergeList(FilterErrFlags(E1), FilterErrFlags(E2)) )
	   rule negative_AFloat((V1:AFloatValue, E1)) => (negative_AFloatValue(AFloatOfTuple((V1, E1))), FilterErrFlags(E1))
	   
	   
	  
	rule greater(I1:AInt, I2:AInt) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(I1)), FilterErrFlags(getErrFlags(I2)))) [internal]
		
	rule greater(F1:AFloat, F2:AFloat) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(F1)), FilterErrFlags(getErrFlags(F2)))) [internal]
	
	//RR-FIXME : True > False, same for other comparisons
	rule greater(B1:ABool, B2:ABool) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(B1)), FilterErrFlags(getErrFlags(B2)))) [internal]
	   
	rule greater(S1:AString, S2:AString) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2))))  [internal]
	   
	rule less(I1:AInt, I2:AInt) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(I1)), FilterErrFlags(getErrFlags(I2)))) [internal]
		
	rule less(F1:AFloat, F2:AFloat) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(F1)), FilterErrFlags(getErrFlags(F2)))) [internal]
	
	rule less(B1:ABool, B2:ABool) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(B1)), FilterErrFlags(getErrFlags(B2)))) [internal]
	   
	rule less(S1:AString, S2:AString) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2)))) [internal]


	rule greaterEqual(I1:AInt, I2:AInt) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(I1)), FilterErrFlags(getErrFlags(I2)))) [internal]

	rule greaterEqual(F1:AFloat, F2:AFloat) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(F1)), FilterErrFlags(getErrFlags(F2)))) [internal]

	rule greaterEqual(B1:ABool, B2:ABool) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(B1)), FilterErrFlags(getErrFlags(B2))))[internal]
	   
	rule greaterEqual(S1:AString, S2:AString) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2)))) [internal]

	rule lessEqual(I1:AInt, I2:AInt) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(I1)), FilterErrFlags(getErrFlags(I2))))[internal]

	rule lessEqual(F1:AFloat, F2:AFloat) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(F1)), FilterErrFlags(getErrFlags(F2)))) [internal]

	rule lessEqual(B1:ABool, B2:ABool) =>(ABoolTop, mergeList(FilterErrFlags(getErrFlags(B1)), FilterErrFlags(getErrFlags(B2)))) [internal]
	   
	rule lessEqual(S1:AString, S2:AString) => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2))))   [internal]
 

	rule *toInteger(I:AInt) => I [internal]
	rule *toInteger(Top) =>(AInt,  ListItem(ImplicitTypeConversion)) [internal]
	
	rule *toInteger(F:AFloat) => (AIntOfTuple(F), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(F))))	[internal]
	
	rule *toInteger(B:ABool) => (AIntOfTuple(B), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(B))))	[internal]
 
	rule *toInteger(S:AString) => (AIntOfTuple(S), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(S))))	[internal]
	
	rule *toInteger(NULL) => (AInt, ListItem(NullTypeConversion))	[internal]
	
	rule *toInteger(Array(_, Elems)) => (AInt, ListItem(ImplicitTypeConversion))
	
	rule *toInteger(O:CompoundValue) => WARNING("conversion of compound types to integer is undefined (http://www.php.net/manual/en/language.types.integer.php)\n") ~> (AInt, ListItem(ImplicitTypeConversion))
 
 // to boolean
    syntax  ABool ::= "*toBoolean" "(" K ")" [function]

    rule  *toBoolean(B:ABool) => B [internal]

    rule  *toBoolean(N:AInt) => (ABoolOfTuple(N), addErrFlag(ImplicitTypeConversion,FilterErrFlags(getErrFlags(N))))    [internal]

    rule  *toBoolean(F:AFloat) => (ABoolOfTuple(F), addErrFlag(ImplicitTypeConversion,FilterErrFlags(getErrFlags(F))))   [internal]

    rule  *toBoolean(S:AString) => (ABoolOfTuple(S), addErrFlag(ImplicitTypeConversion,FilterErrFlags(getErrFlags(S))))   [internal]


    rule  *toBoolean(Array(_,Elems)) => (ABoolTop, ListItem(ImplicitTypeConversion)) 	        [internal]
			
	rule  *toBoolean(true) => (ABoolTrue, .List)        [internal]
	
	rule  *toBoolean(false) => (ABoolFalse, .List)      [internal]
			
	rule *toBoolean(Top) => (ABoolTop,  ListItem(ImplicitTypeConversion)) 		    [internal]

// Object case: we add it, even if the online docs says this behaviour is "PHP 4 only"
// Since the expected behaviour for PHP 5 is not mentioned, I guess it is undefined..?

    rule  *toBoolean(OID(L,_,_) => convertToLanguageValue(L))   [internal]

    rule  *toBoolean(NULL) => (ABoolFalse, ListItem(NullTypeConversion))  [internal]

    // to float

	
    syntax  AFloat ::= "*toFloat" "(" K ")"  [function]
	
    rule  *toFloat(I:AInt) => (AFloatOfTuple(I), addErrFlag(ImplicitTypeConversion,FilterErrFlags(getErrFlags(I)))) [internal]
    rule  *toFloat(Top) => (AFloat,  ListItem(ImplicitTypeConversion)) [internal]
    
	rule  *toFloat(B:ABool) => (AFloatOfTuple(B), addErrFlag(ImplicitTypeConversion,FilterErrFlags(getErrFlags(B)))) [internal]
			
    rule  *toFloat(F:AFloat) => F			 [internal]

    rule  *toFloat(S:AString) => *toFloat(string2Number(S)) [internal]
	
    rule  *toFloat(O:CompoundValue) => WARNING("conversion of compound types to integer is undefined (http://www.php.net/manual/en/language.types.integer.php)\n") ~> AFloat 	[internal, error]

	
	//to string		
			
	syntax AIntValue ::= "*valueToInteger" "(" Scalar ")" [function]
	
	rule *valueToInteger(Bot) => AIntBot
	rule *valueToInteger(Top) => AInt
	
	rule *valueToInteger(V) => AInt
	when V =/=K Bot
	
	syntax AFloatValue ::= "*valueToFloat" "(" Scalar ")" [function]
	
	rule *valueToFloat(Bot) => AFloatBot
	rule *valueToFloat(Top) => AFloat
	
	rule *valueToFloat(V) => AFloat
	when V =/=K Bot
	
	syntax ABoolValue ::= "*valueToBool" "(" Scalar ")" [function]
	
	rule *valueToBool(Bot) => ABoolBot
	rule *valueToBool(Top) => ABoolTop
	
	rule *valueToBool(NULL) => ABoolFalse
	
	rule *valueToBool(B:ABoolValue) => B
	rule *valueToBool(B:ANumValue) => ABoolTop
	rule *valueToBool(AStringTop) => ABoolTop
	rule *valueToBool("") => ABoolFalse
	rule *valueToBool("0") => ABoolFalse
	
	rule *valueToBool(S:String) => ABoolTrue
	when (S =/=String "") andBool (S =/=String "0")
	
	
	syntax AStringValue ::= "*valueToString" "(" Scalar ")" [function]
	
	rule *valueToString(Bot) => AStringBot
	rule *valueToString(Top) => AStringTop
	
	rule *valueToString(I:AIntValue) => AStringTop
	when I =/=K AIntBot
	
	rule *valueToString(F:AFloatValue) => AStringTop
	when F =/=K AFloatBot
	
	rule *valueToString(S:AStringValue) => S
	
	rule *valueToString(ABoolTrue) => "1"
	rule *valueToString(ABoolFalse) => ""
	rule *valueToString(ABoolTop) => AStringTop
	
	rule *valueToString(NULL) => ""
	
	syntax AString ::= "*toString" "(" LanguageValue ")" [function]

	//TODO : change this when numeric strings get added
	//TODO : find a way to add traces ?
	
	rule  *toString(I:AInt) => (*valueToString(AIntOfTuple(I)), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(I)))) [internal]

	rule *toString(B:ABool) => (*valueToString(ABoolOfTuple(B)), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(B))))	[internal]
			
	rule  *toString(F:AFloat) => (AStringOfTuple(F), addErrFlag(ImplicitTypeConversion, FilterErrFlags(getErrFlags(F)))) [internal]
	
	rule *toString(S:AString) => S [internal]

	rule *toString(Arr:Array) => (AStringTop, ListItem(ImplicitTypeConversion))	[internal] // concrete string is "Array" ?
	
	rule *toString(Top) => (AStringTop, ListItem(ImplicitTypeConversion)) [internal]
	
	// TODO: put correct error msg
	// TODO: use magic method __toString()

	rule *toString(Obj:Object) => ERROR("Object of class %s could not be converted to string in %s on line %d") [internal, error]

	rule *toString(NULL) => ("", ListItem(NullTypeConversion)) [internal]

	syntax PlainLanguageValue ::= "string2Number" "(" AString ")" [function]

	
	rule *toObject(Top) => Top
	rule *toArray(Top) => Top
	
	rule string2Number((S:AStringValue, E):AString) => (AInt, addErrFlag(ImplicitTypeConversion, FilterErrFlags(E))) //RR-FIXME: should be Anum

	
	// String concatenation operation
	
	syntax AStringValue ::= "AStringValueConcat" "(" AStringValue "," AStringValue ")" [function]

	
	rule AStringValueConcat(S1:String, S2:String) => S1 +String S2 [step]
	
	rule AStringValueConcat(AStringTop,_) => AStringTop [step]
	
	rule AStringValueConcat(_, AStringTop) => AStringTop [step]

	
	rule 'Concat(S1:AString,, S2:AString) => specify(VE(AStringValueConcat(AStringOfTuple(S1), AStringOfTuple(S2)), mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2)))))
	
    syntax  ABool ::= "notABool" ABool [function]

    rule notABool (ABoolTrue, E) => (ABoolFalse, FilterErrFlags(E))
    rule notABool (ABoolFalse, E) => (ABoolTrue, FilterErrFlags(E))
    rule notABool (ABoolTop, E) => (ABoolTop, FilterErrFlags(E))

    syntax  ABool ::= AInt "==AInt" AInt [function]

    rule I1 ==AInt I2 => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(I1)), FilterErrFlags(getErrFlags(I2)))) 

    syntax  ABool ::= AFloat "==AFloat" AFloat [function]
    
    rule F1 ==AFloat F2 => (ABoolTop, mergeList(FilterErrFlags(getErrFlags(F1)), FilterErrFlags(getErrFlags(F2))))
    
    syntax  ABool ::= ABool "==ABool" ABool [function]
    
    rule B1 ==ABool B2 => (ABoolOfTuple(B1) ==ABoolValue ABoolOfTuple(B2), mergeList(FilterErrFlags(getErrFlags(B1)), FilterErrFlags(getErrFlags(B2))))    
    
	syntax ABoolValue ::= ABoolValue "==ABoolValue" ABoolValue [function]
	
	rule ABoolBot ==ABoolValue _ => ABoolBot
	rule _ ==ABoolValue ABoolBot => ABoolBot
	
	rule ABoolTop ==ABoolValue X => ABoolTop
	when X =/=K ABoolBot
	
	rule X ==ABoolValue ABoolTop => ABoolTop
	when X =/=K ABoolBot
	
	rule ABoolTrue ==ABoolValue ABoolTrue => ABoolTrue
	rule ABoolTrue ==ABoolValue ABoolFalse => ABoolFalse
	rule ABoolFalse ==ABoolValue ABoolTrue => ABoolFalse
	rule ABoolFalse ==ABoolValue ABoolFalse => ABoolTrue
	
	
    syntax  ABool ::= AString "==AString" AString [function]
    
    rule S1 ==AString S2 => (AStringOfTuple(S1) ==AStringValue AStringOfTuple(S2), mergeList(FilterErrFlags(getErrFlags(S1)), FilterErrFlags(getErrFlags(S2))))
    
	syntax ABoolValue ::= AStringValue "==AStringValue" AStringValue [function]
	
	rule AStringBot ==AStringValue _ => ABoolBot
	rule _ ==AStringValue AStringBot => ABoolBot
	
	rule AStringTop ==AStringValue AStringTop => ABoolTop
	rule S:String ==AStringValue AStringTop => ABoolTop
	rule AStringTop ==AStringValue S:String => ABoolTop
	rule S1:String ==AStringValue S2:String => ABoolTrue
	when S1 ==String S2
	
	rule S1:String ==AStringValue S2:String => ABoolFalse
	when notBool(S1 ==String S2)
	
    rule    [internal-print]:
            <k> print (V:AString)  => . ... </k>
            <out> ... . => ListItem(V) </out>
            [internal, output]   
	rule print(S:String) => print(specify(VE(S, .List)))		
	
	rule [internal-print]:    
	<k> print (I:AInt  => *toString(I)) ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]


	rule [internal-print]:    
	<k> print (B:ABool  => *toString(B)) ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]

	
    // input
    syntax K ::= "user_input"
	
    rule [input]:
    	<k>  user_input => specify(VE(AStringTop, .List)) ...</k>
	
	
	//can't be resolved in this domain
	
	syntax Bool ::= "isNumericString" "(" AString ")" [function]	
				| "isIntString" "(" AString ")" [function]	
				| "isFloatString" "(" AString ")" [function]	
	
	rule strlen(S:AString) => (AInt, .List)
	
	rule [init-domain]:
		<k> initDomain => . ... </k>
		<domain> .K => Types </domain>
	
	
	// valid/unsatisfiable
	
	syntax Bool ::= "valid" "(" ABool ")"	                [function]   
	syntax Bool ::= "unsatisfiable" "(" ABool ")"    		[function]
	syntax Bool ::= "valid_value" "(" ABoolValue ")" [function]
	syntax Bool ::= "unsatisfiable_value" "(" ABoolValue ")" [function]
	
	rule valid(B) => valid_value(ABoolOfTuple(B))
	rule unsatisfiable(B:ABool) => unsatisfiable_value(ABoolOfTuple(B))
	   
	rule valid_value(ABoolTop) => false
	rule valid_value(ABoolTrue) => true
	rule valid_value(ABoolFalse) => false
	rule unsatisfiable_value(ABoolTop) => false
	rule unsatisfiable_value(ABoolTrue) => false
	rule unsatisfiable_value(ABoolFalse) => true
	
	//RR-FIXME : quick fix, should be removed when a proper array comparison algorithm is implemented (probably in lang)
	rule greater(Array(_,_), Array(_,_)) => (ABoolTop, .List)
	rule greaterEqual(Array(_,_), Array(_,_)) => (ABoolTop, .List)
	rule less(Array(_,_), Array(_,_)) => (ABoolTop, .List)
	rule lessEqual(Array(_,_), Array(_,_)) => (ABoolTop, .List)
	
	rule greater(OID(_,_,_), OID(_,_,_)) => (ABoolTop, .List)
	rule greaterEqual(OID(_,_,_), OID(_,_,_)) => (ABoolTop, .List)
	rule less(OID(_,_,_), OID(_,_,_)) => (ABoolTop, .List)
	rule lessEqual(OID(_,_,_), OID(_,_,_)) => (ABoolTop, .List)
	
	
	//@ \section{Operations on reference counters}

	//copied from mySigns
	
	syntax 	ARefCount ::= ARefCount "+ARefCount" ARefCount [function]

	rule	ARC0 +ARefCount ARC0   => ARC0
	rule	ARC0 +ARefCount ARC1   => ARC1
	rule	ARC0 +ARefCount ARC2   => ARC2
	rule	ARC0 +ARefCount ARC>2  => ARC>2

	rule	ARC1 +ARefCount ARC0   => ARC1
	rule	ARC1 +ARefCount ARC1   => ARC2
	rule	ARC1 +ARefCount ARC2   => ARC>2
	rule	ARC1 +ARefCount ARC>2  => ARC>2

	rule	ARC2 +ARefCount ARC0   => ARC2
	rule	ARC2 +ARefCount ARC1   => ARC>2
	rule	ARC2 +ARefCount ARC2   => ARC>2
	rule	ARC2 +ARefCount ARC>2  => ARC>2

	rule	ARC>2 +ARefCount ARC0  => ARC>2
	rule	ARC>2 +ARefCount ARC1  => ARC>2
	rule	ARC>2 +ARefCount ARC2  => ARC>2
	rule	ARC>2 +ARefCount ARC>2 => ARC>2

	syntax 	ARefCount ::= ARefCount "-ARefCount" ARefCount [function] 

	rule	ARC0 -ARefCount ARC0   => ARC0
	//rule	ARC0 -ARefCount ARC1   => ARC1
	//rule	ARC0 -ARefCount ARC2   => ARC2
	//rule	ARC0 -ARefCount ARC>2  => ARC>2

	rule	ARC1 -ARefCount ARC0   => ARC1
	rule	ARC1 -ARefCount ARC1   => ARC0
	//rule	ARC1 -ARefCount ARC2   => ARC>2
	//rule	ARC1 -ARefCount ARC>2  => ARC>2

	rule	ARC2 -ARefCount ARC0   => ARC2
	rule	ARC2 -ARefCount ARC1   => ARC1
	rule	ARC2 -ARefCount ARC2   => ARC0
	//rule	ARC2 -ARefCount ARC>2  => ARC>2

	rule	ARC>2 -ARefCount ARC0  => ARC>2
	rule	ARC>2 -ARefCount ARC1  => ARC>2
	rule	ARC>2 -ARefCount ARC2  => ARC>2
	rule	ARC>2 -ARefCount ARC>2 => ARC>2
	

	syntax 	Bool ::= ARefCount "<ARefCount" ARefCount [function] 

	rule	ARC0 <ARefCount ARC0   => false
	rule	ARC0 <ARefCount ARC1   => true
	rule	ARC0 <ARefCount ARC2   => true
	rule	ARC0 <ARefCount ARC>2  => true

	rule	ARC1 <ARefCount ARC0   => false
	rule	ARC1 <ARefCount ARC1   => false
	rule	ARC1 <ARefCount ARC2   => true
	rule	ARC1 <ARefCount ARC>2  => true

	rule	ARC2 <ARefCount ARC0   => false
	rule	ARC2 <ARefCount ARC1   => false
	rule	ARC2 <ARefCount ARC2   => false
	rule	ARC2 <ARefCount ARC>2  => true

	rule	ARC>2 <ARefCount ARC0  => false
	rule	ARC>2 <ARefCount ARC1  => false
	rule	ARC>2 <ARefCount ARC2  => false
	rule	ARC>2 <ARefCount ARC>2 => false // ?!?
	
	
	
endmodule
