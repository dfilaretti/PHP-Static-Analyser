require "memory.k"

module SHARED
	imports MEMORY

// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
/*@ \section{Shared Definitions} */
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Helper constructs} */ 
// ---------------------------------------------------------------------------------------------

syntax K ::= "*Cond" "(" K "," K "," K ")"			[strict(1)]

rule [cond-true]:
	<k> *Cond(true, ActionTrue:K,_) => ActionTrue ... </k>
	<trace> Trace:List => Trace ListItem("cond-true") </trace>
	[internal]

rule [cond-false]:
	<k> *Cond(false,_, ActionFalse:K) => ActionFalse ... </k>
	<trace> Trace:List => Trace ListItem("cond-false") </trace>
	[internal]
  	
syntax K ::= "*or" "(" K "," K ")" 					[strict(1)]

rule [spec-or-true]:
	<k> *or(true, _) => true ... </k>
	<trace> Trace:List => Trace ListItem("spec-or-true") </trace>
	[internal]

rule [spec-or-false]:
	<k> *or(false, K:K) => K ... </k>
	<trace> Trace:List => Trace ListItem("spec-or-false") </trace>
	[internal]

// ---------------------------------------------------------------------------------------------
/*@ \subsection{Macros for solving references} */ 
// ---------------------------------------------------------------------------------------------

syntax ConvertibleToLoc ::= LiteralValue | Ref | ThisTag
syntax ConversionMode ::= "l" | "r"
syntax OptionConversionMode ::= ConversionMode | None

syntax Loc ::= "convertToLoc" "(" ConvertibleToLoc "," OptionConversionMode ")" [function]
rule convertToLoc(V:LiteralValue,_) => allocValue(V)
rule convertToLoc(R:Ref,l) => sref2loc(Lget(R)) // extract loc if it's an sref
rule convertToLoc(R:Ref,r) => sref2loc(Rget(R)) // extract loc if it's an sref
rule convertToLoc(thisTag(L),_) => L

syntax BasicRef ::= "toBasicRef" "(" LRef ")" [function]
rule toBasicRef(lref(R:Ref,X:Key,T:RefType)) => ref(LgetRef(R, T), X)

syntax BasicRef ::= "readBasicRef" "(" LRef ")" [function]
rule readBasicRef(lref(R:Ref,X:Key,T:RefType)) => ref(RgetRef(R, T), X)

syntax ConvertibleToLanguageValue ::= Loc | ConvertibleToLoc
syntax LanguageValue ::= "convertToLanguageValue" "(" ConvertibleToLanguageValue ")" [function]

rule convertToLanguageValue(L:Loc) => read(L)
rule convertToLanguageValue(V:ConvertibleToLoc) => read(convertToLoc(V,r))

// ---------------------------------------------------------------------------------------------
/*@ \subsection{Internal "arithmetic"} */ 
// ---------------------------------------------------------------------------------------------

syntax K ::= "isEqualScalar" "(" K "," K ")" [seqstrict]

/* TODO: remove
rule [isEqual-scalar-RHS2LangValue]:
	<k> isEqualScalar(_, (R2:ConvertibleToLanguageValue => convertToLanguageValue(R2))) ... </k>
	<trace> Trace:List => Trace ListItem("isEqual-scalar-RHS2LangValue") </trace>
	[intermediate]

rule [isEqual-scalar-LHS2LangValue]:
	<k> isEqualScalar((R1:ConvertibleToLanguageValue => convertToLanguageValue(R1)), _) ... </k>
	<trace> Trace:List => Trace ListItem("isEqual-scalar-LHS2LangValue") </trace>
	[intermediate]
*/

rule [isEqual-scalar]:
	<k> isEqualScalar(I1:Int, I2:Int) => I1 ==Int I2 ... </k>
	<trace> Trace:List => Trace ListItem("isEqual-scalar") </trace>
	[internal]

// ---------------------------------------------------------------------------------------------
/*@ \subsection{Visibility 2 string} */ 
// ---------------------------------------------------------------------------------------------

syntax String ::= "visibility2String" "(" ArrayItemVisibility ")" [function]

rule visibility2String(public) => "public"
rule visibility2String(protected) => "protected"
rule visibility2String(private(_)) => "private"


// ---------------------------------------------------------------------------------------------
/*@ \subsection{List functions} */ 
// ---------------------------------------------------------------------------------------------

syntax Int ::= "listLen" "(" List ")" [function]
rule	listLen(.List) => 0
rule	listLen(ListItem(_) L:List) => 1 +Int listLen(L)

syntax List ::= "mapConcat(" List "," K ")" [function]
rule mapConcat(.,_) => .
rule mapConcat(H T,X) => (H ListItem(X) mapConcat(T,X))


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Set functions} */ 
// ---------------------------------------------------------------------------------------------

syntax Set ::= "removeFromSet" "(" Set "," K ")" [function]
rule 	removeFromSet(.Set,_) => .Set
rule 	removeFromSet(SetItem(Y) S,X) => removeFromSet(S,X)
	when X ==K Y
rule 	removeFromSet(SetItem(Y) S, X) => SetItem(Y) removeFromSet(S,X) 
	when X =/=K Y


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Lattice functions} */ 
// ---------------------------------------------------------------------------------------------

// given a lattice element and a set of lattice elements, computes the set of lattice elements that intersect with the given one, and transitively with each other
// example: give [5] and {[2..5],[6..8],[1..3]} it returns {[2..5],[1..3]}
syntax  List ::= "intersectClose" "(" K "," List ")" [function]
rule intersectClose(K,L) => _iC(K,L,L)

syntax  List ::= "_iC" "(" K "," List "," List ")" [function]
rule 	_iC(X,ListItem(H) T,L) => (ListItem(H) _iC(lub(X,H),T,T))
	when Bot =/=Lattice glb(X,H)
rule 	_iC(X,ListItem(H) T,L) => _iC(X,T ListItem(H),L)
	when (Bot ==Lattice glb(X,H)) andBool ((T ListItem(H)) =/=List L)
rule 	_iC(X,ListItem(H) T,L) => .List
	when (Bot ==Lattice glb(X,H)) andBool ((T ListItem(H)) ==List L)


endmodule
