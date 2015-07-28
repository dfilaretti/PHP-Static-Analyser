require "lattice.k"

module ALPHA
	imports LATTICE

	syntax K ::= "alpha" "(" K ")" [function]

	rule alpha(N:Int) => specify(VE(AInt, .List)) [structural]

	rule alpha(F:Float) => specify(VE(AFloat, .List)) [structural]	

	rule alpha(true) => specify(VE(ABoolTrue, .List))	 [structural]
	
	rule alpha(false) => specify(VE(ABoolFalse, .List))	 [structural]

	rule alpha(S:String) => specify(VE(S, .List)) [structural]

	rule alpha(NULL) => NULL [structural]
	
	
	
	// abstraction of reference counters
	syntax K ::= "alphaRC" "(" K ")" [function]
	
	rule	alphaRC(N:Int) => 
			#if (N ==Int 0) #then
				ARC0
			#else
				#if (N ==Int 1) #then
					ARC1
				#else
					#if (N ==Int 2) #then
						ARC2
					#else
						ARC>2
					#fi
				#fi
			#fi
			
	
syntax Bool ::= "isGammaSingleton" "(" K ")" [function]

rule isGammaSingleton(NULL) => true

rule isGammaSingleton(N:ANum)=> false

rule isGammaSingleton(B:ABool) => false

rule isGammaSingleton( (S:String, L) ) => valueOfErrs(L) ==K Bot

rule isGammaSingleton ( (AStringTop, _) ) => false


rule isGammaSingleton(Top) => false

	// reference counters
	rule 	isGammaSingleton(ARC0)  => true
	rule 	isGammaSingleton(ARC1)  => true
	rule 	isGammaSingleton(ARC2)  => true
	rule 	isGammaSingleton(ARC>2) => false


//what about Bot ?


endmodule
