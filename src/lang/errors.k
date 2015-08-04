require "io.k"
require "shared.k"
module ERRORS
	imports IO
	imports SHARED 

// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
/*@ \section{Error management} 
		We define here some basic error management operations.
		For the future we plan to add support for more detailed error messages, i.e. 
		line number, etc. */
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
// =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=

// A warning is displayed, after that the program keeps going
syntax K ::= "WARNING" "(" String ")"
rule [warning]:	
	<k> WARNING(Msg:String) => print("\nWarning: ") ~> print(Msg) ... </k>
	<errorManagement> _ => 1 </errorManagement>
	<trace> Trace:List => Trace ListItem("warning") </trace>
	[internal]
	
syntax K ::= "DEPRECATED" "(" String ")"
rule [deprecated]:	
	<k> DEPRECATED(Msg:String) => print("\nDeprecated: ") ~> print(Msg) ... </k>
	<errorManagement> _ => 1 </errorManagement>
	<trace> Trace:List => Trace ListItem("deprecated") </trace>
	[internal]
		
// A notice is displayed, after that the program keeps going
syntax K ::= "NOTICE" "(" String ")"
rule [notice]:	
	<k> NOTICE(Msg:String) => print("\nNotice: ") ~> print(Msg) ... </k>
	<errorManagement> _ => 1 </errorManagement>
	<trace> Trace:List => Trace ListItem("notice") </trace>
	[internal]

// A fatal error is displayed, and then propagated to abort the current execution branch
syntax K ::= "ERROR" "(" String ")"
rule [error]:	
	<k> ERROR(Msg:String) => print("\nFatal error: ") ~> print(Msg) ~> Bot ... </k>
	<errorManagement> _ => 2 </errorManagement>
        <errorDump> ... . => mapConcat((ListItem("<error-trace>") Trace ListItem("</error-trace>")),"\n")</errorDump> //SM or dump whole confing
	<status> X => ERR </status>
	<trace> Trace:List => Trace ListItem("error") </trace>
        when X =/=K ERR
	[internal]

// Already in ERR state: just propagate Bot
rule [error-propagate]: 
	<k> ERROR(_) => Bot ... </k> 
	<status> ERR </status>
	<trace> Trace:List => Trace ListItem("error-propagate") </trace>
	[internal]

// This also aborts the program, but it's meant to be an internal thing (not in PHP).
// The error code says outer test running script that the feature is unsupported
syntax K ::= "NOT-SUPPORTED" "(" String ")"
rule [not-supported]:	
	<k> NOT-SUPPORTED(Msg:String) ~> K:K => print("Unsupported feature: ") ~> print(Msg) </k>
	<errorManagement> _ => 3 </errorManagement>
	<trace> Trace:List => Trace ListItem("not-supported") </trace>
	[internal]

endmodule


