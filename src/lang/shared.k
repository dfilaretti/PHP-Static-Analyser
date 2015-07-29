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

//syntax K ::= "stopDebug(" List ")" 
syntax K ::= "stopDebug(" Map "," Map ")"

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

syntax List ::= "elems2keys(" List ")" [function]
rule elems2keys(.List) => .List
rule elems2keys(ListItem([K,_,_]) T) => (ListItem(K) elems2keys(T))

syntax List ::= "set2list(" Set ")" [function]
rule set2list(.Set) => .List
rule set2list(SetItem(E) S) => ListItem(E) set2list(S)


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Set functions} */ 
// ---------------------------------------------------------------------------------------------

syntax Set ::= "removeFromSet" "(" Set "," K ")" [function]
rule 	removeFromSet(.Set,_) => .Set
rule 	removeFromSet(SetItem(Y) S,X) => removeFromSet(S,X)
	when X ==K Y
rule 	removeFromSet(SetItem(Y) S, X) => SetItem(Y) removeFromSet(S,X) 
	when X =/=K Y


//SM rename to removeSetDuplicates
syntax Set ::= "makeSet" "(" Set ")" [function]

rule makeSet(.Set) => .Set
rule makeSet(SetItem(I) S:Set) => SetItem(I) makeSet(S) 
	when notBool (I in S) 
rule makeSet(SetItem(I) S:Set) => makeSet(S) 
	when I in S


// ---------------------------------------------------------------------------------------------
/*@ \subsection{Lattice functions} */ 
// ---------------------------------------------------------------------------------------------

// given a lattice element and a set of lattice elements, computes the set of lattice elements that intersect with the given one, and transitively with each other
// example: give [5] and {[2..5],[6..8],[1..3]} it returns {[2..5],[1..3]}

syntax Set ::= "intersectClose" "(" K "," List ")" [function]
rule intersectClose(K,L) => intersectClose1(K,L,L)

syntax Set ::= "intersectClose1" "(" K "," List "," List ")" [function]
rule 	intersectClose1(X,.List,.List) => .Set
rule 	intersectClose1(X,ListItem(H) T,L) => (SetItem(H) intersectClose1(lub(X,H),T,T))
	when intersects(X,H) //SM ideally =/=Lattice but it gets stuck
rule 	intersectClose1(X,ListItem(H) T,L) => intersectClose1(X,T ListItem(H),L)
	when (notBool intersects(X,H)) andBool ((T ListItem(H)) =/=List L)
rule 	intersectClose1(X,ListItem(H) T,L) => .Set
	when (notBool intersects(X,H)) andBool ((T ListItem(H)) ==List L)

syntax Bool ::= "intersects" "(" K "," K ")" [predicate] // defined in the domains

syntax Bool ::= K "=/=Lattice" K [function]
rule V =/=Lattice U => notBool(V ==Lattice U)

syntax Bool ::= K "<=Lattice" K [function]
rule V <=Lattice U => (V <Lattice U) orBool (V ==Lattice U)

syntax Bool ::= K ">Lattice" K [function]
rule V >Lattice U => U <Lattice V

syntax Bool ::= K ">=Lattice" K [function]
rule V >=Lattice U => U <=Lattice V


syntax List ::= "mapglb=/=LatticeBot(" K "," List ")" [function]
rule mapglb=/=LatticeBot(_,.) => .
rule mapglb=/=LatticeBot(X,ListItem(H) T) => ListItem(glb(H,X) =/=K Bot) mapglb=/=LatticeBot(X,T) 

syntax List ::= "map<=LatticeX(" K "," List ")" [function]
rule map<=LatticeX(_,.) => .
rule map<=LatticeX(X,ListItem(H) T) => ListItem(H <=Lattice X) map<=LatticeX(X,T) 

syntax List ::= "mapX<=Lattice(" K "," List ")" [function]
rule mapX<=Lattice(_,.) => .
rule mapX<=Lattice(X,ListItem(H) T) => ListItem(X <=Lattice H) mapX<=Lattice(X,T) 

syntax Bool ::= "foldrorBool(" K "," List ")" [function]
rule foldrorBool(X,.) => X
rule foldrorBool(X,ListItem(H) T) => H orBool foldrorBool(X,T) 


endmodule
