require "io.k"
require "shared.k"
module ERRORS
	imports IO
	imports SHARED //SM because of mapConcat

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

// An error is displayed, and the program is aborted
syntax K ::= "ERROR" "(" String ")"

rule [error]:	
	<k> (ERROR(ErrorMsg:String) => 
            print("\nFatal error: ") ~> print(ErrorMsg) ~> Bot) ~> K:K </k>
	<errorManagement> _ => 2 </errorManagement>
	<trace> Trace:List => Trace ListItem("error") </trace>
        <errorDump> ... (. => mapConcat((ListItem("<error-trace>") Trace ListItem("</error-trace>")),"\n"))</errorDump> 
        //SM we should dump the whole confing here ideally
	<status> X => ERR </status>
        when X =/=K ERR
	[internal]

rule [error]:	
	<k> ERROR(ErrorMsg:String) => Bot ... </k> 
	<status> ERR </status>
	[internal]

// This also aborts the program, but it's meant to be an internal thing (not in PHP).
// The error code says out test running script that the feature is unsupported
syntax K ::= "NOT-SUPPORTED" "(" String ")"
rule [not-supported]:	
	<k> NOT-SUPPORTED(ErrorMsg:String) ~> K:K => print("Unsupported feature: ") ~> print(ErrorMsg) </k>
	<errorManagement> _ => 3 </errorManagement>
	<trace> Trace:List => Trace ListItem("not-supported") </trace>
	[internal]
endmodule


