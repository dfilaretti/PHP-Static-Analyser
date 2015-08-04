require "type-conversions.k"

module IO 
       imports TYPE-CONVERSIONS


// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
/*@ \section{Input and Output} */
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=

// ---------------------------------------------------------------------------------------------
/*@ \subsection{Exit, Die} */
// ---------------------------------------------------------------------------------------------

syntax KLabel ::= "'Exit" | "'Die"

rule [die-desugar]:
	<k> ('Die => 'Exit)(_) ... </k>
	<trace> Trace:List => Trace ListItem("die-desugar") </trace>
	[structural]

context 'Exit(HOLE)

rule [exit-arg2LangValue]: 
	<k> 'Exit(R:ConvertibleToLanguageValue => convertToLanguageValue(R)) ... </k>
	<trace> Trace:List => Trace ListItem("exit-arg2LangValue") </trace>
	[intermediate]

rule [exit]:
	<k> 'Exit(V:LanguageValue) ~> _ => print(V) </k>
	<exitStatus> _ => V </exitStatus>
	<trace> Trace:List => Trace ListItem("exit") </trace>
	[step]

	
// ---------------------------------------------------------------------------------------------
/*@ \subsection{Auxiliary stuff} */
// ---------------------------------------------------------------------------------------------


syntax  K ::= "print" "(" K ")"     [strict]

//SM: before uncommenting resolve issue with hasNoDecimalPart on abstract values
/*
rule [internal-print]:    
	<k> print (V:Float => Float2Int(V))  ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	when (hasNoDecimalPart(V))
	[internal, output]
	
rule [internal-print]:    
	<k> print (V:Float => *toString(V))  ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	when notBool (hasNoDecimalPart(V))
	[internal, output]
*/

rule [internal-print]:    
	<k> print(B:ABool  => *toString(B)) ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]

rule [internal-print]:    
	<k> print (I:AInt  => *toString(I)) ... </k>
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]

rule [internal-print]:    
	<k> print(S:AString => gamma(S)) ... </k> // pretty-print abstract strings
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
        when notBool(isAStringConcrete) // to avoid loop when String = AString
	[internal, output]

rule [internal-print]:    
	<k> print(V:String)  => . ... </k>
	<out> ... . => ListItem(V) </out>  
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]

rule [internal-print]:    
	<k> print(V:Int)  => . ... </k>
	<out> ... . => ListItem(Int2String(V)) </out>  
	<trace> Trace:List => Trace ListItem("internal-print") </trace>
	[internal, output]
	


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Echo} */
// ---------------------------------------------------------------------------------------------

context [echo-args-strict]: 
	'Echo('ListWrap(_:KList,,HOLE,,_:KList))
	[structural]
	
rule [echo-args2LangValue]: 	
	<k> 'Echo('ListWrap((R:ConvertibleToLanguageValue => convertToLanguageValue(R)),,_:KList)) ... </k>
	<trace> Trace:List => Trace ListItem("echo-args2LangValue") </trace>
	[intermediate]

rule [echo-cons]:
	<k> 'Echo('ListWrap(V:LanguageValue,,Args:KList)) => print(V) ~> 'Echo('ListWrap(Args)) ... </k>
	<trace> Trace:List => Trace ListItem("echo-cons") </trace>
	[intermediate] // Or step?
	
rule [echo-nil]: 
	<k> 'Echo('ListWrap(.KList)) => . ... </k>
	<trace> Trace:List => Trace ListItem("echo-nil") </trace>
	[step]

rule [echo-more-args]:	
	<k> 'Echo(Args:K,, "") => 'Echo(Args) ... </k>
	<trace> Trace:List => Trace ListItem("echo-more-args") </trace>
	[structural]
	
// ---------------------------------------------------------------------------------------------
/*@ \subsection{Inline Echo} */
// ---------------------------------------------------------------------------------------------

rule [inline-echo]: 
	<k> 'InlineEcho('EchoOpenTag(.KList),,K:K,,_,,'CloseTag(.KList)) => 
               // 'Echo('ListWrap(K)) // use this for conventional semantics of inline echo  
	       peek(K)                // use this to enable debugging by peeking at memory locations
	       ... 
	</k>
	<trace> Trace:List => Trace ListItem("inline-echo") </trace>
	[structural] 

rule 'Expr(peek(K),,_) => 'Echo('ListWrap(peek(K))) //SM unblock 'Expr
syntax K ::= "peek(" K ")" // intentionally NOT strict
rule peek('FunctionCall('FunctionName(C:String),,Params,,_)) => peek1(ListItem(C),Params)


syntax K ::= "peek1(" List "," K ")"
rule peek1(L,'ListWrap(.KList)) => peek2(L)
rule peek1(L,'ListWrap('Param(V:Value),, Args:KList)) => peek1(L ListItem(V),'ListWrap(Args:KList)) 
context peek1(L:List,'ListWrap('Param(HOLE),, Args:KList))


syntax K ::= "peek2(" List ")"
rule peek2(ListItem(P1) ListItem(P2) ListItem(P3) ListItem(P4)) => peek3(P1,gamma(P2),P3,P4)


syntax K ::= "peek3(" K "," K "," K "," K ")" 
context peek3(C:String,M:String,HOLE,V:K) //SM allowing resolution of srefs here
context peek3(C:String,M:String,V:K,HOLE) 

rule peek3(C,M,V1:ConvertibleToLoc,V2:ConvertibleToLoc) => peek3(C,M,convertToLoc(V1,r),convertToLoc(V2,r))

rule <k> peek3("h",M,L1':Loc,L2':Loc) => peek3("h1",M,L1,L2) ... </k>
     <thematrix> ... L1' |-> L1 L2' |-> L2 ... </thematrix> 	 

rule peek3("v",M,V1:ConvertibleToLanguageValue,V2:ConvertibleToLanguageValue)  
     => peek3("v",M,convertToLanguageValue(V1),convertToLanguageValue(V2))

// compare matrix addresses
rule peek3("m",M,L1':Loc,L2':Loc) => 'Literal("m ==> " +String M +String ": OK\n" ) 
     when L1' ==K L2'
rule peek3("m",M,L1':Loc,L2':Loc) => 'Literal("m ==> " +String M +String ": KO\n" )
     when L1' =/=K L2'

// compare heap addresses
rule peek3("h1",M,L1,L2) => 'Literal("h ==> " +String M +String ": OK\n" )
     when L1 ==K L2
rule peek3("h1",M,L1:Loc,L2:Loc) => 'Literal("h ==> " +String M +String ": KO\n" )
     when L1 =/=K L2

 // compare values
rule peek3("v",M,V1:PlainLanguageValue,V2:PlainLanguageValue) => 'Literal("v ==> " +String M +String ": OK\n" ) 
     when V1 ==K V2
rule peek3("v",M,V1:PlainLanguageValue,V2::PlainLanguageValue) => 'Literal("v ==> " +String M +String ": KO\n" )
     when V1 =/=K V2



// ---------------------------------------------------------------------------------------------
/*@ \subsection{Print} 
		Same as 'Echo, but also returns a nice "1". */
// ---------------------------------------------------------------------------------------------

rule [print]:
	<k> 'Print(Item:K) => 'Echo('ListWrap(Item)) ~> 1 ... </k>
	<trace> Trace:List => Trace ListItem("print") </trace>
	[structural]
	
endmodule 
