
namespace eval ::xogrid { 

Class create Protocol -superclass { ::xogrid::Receiver }
  
Protocol @doc Protocol {
Please describe Protocol here.
}
       
Protocol parameter {

} 
        

Protocol @doc closedConnection { 
closedConnection does ...
            id -
}

Protocol instproc closedConnection { id } {
        ::xotcl::my instvar clients

        set clients($id) ""
    
}


Protocol @doc encapsulateData { 
encapsulateData does ...
            data -
}

Protocol instproc encapsulateData { data } {
        set data [ ::xotcl::my escapeBrackets $data ]

        return "\{$data\}"
    
}


Protocol @doc escapeBrackets { 
escapeBrackets does ...
            data -
}

Protocol instproc escapeBrackets { data } {
        regsub -all {\\} $data {\\\\} data
        regsub -all {\\} $data {\\\\} data

        regsub -all {\{} $data "\\\{" data
        regsub -all {\}} $data "\\\}" data

        return $data
    
}


Protocol @doc extractData { 
extractData does ...
            script -
}

Protocol instproc extractData { script } {
        set script [ string trim $script ]

        set script [ string range $script 1 end-1 ]

        return [ ::xotcl::my unEscapeBrackets $script ]
    
}


Protocol @doc init { 
init does ...
}

Protocol instproc init {  } {
        ::xotcl::next 

        ::xotcl::my instvar clients

        set clients(nobody) 0 
    
}


Protocol @doc newConnection { 
newConnection does ...
            id -
}

Protocol instproc newConnection { id } {
        ::xotcl::my instvar clients

        set clients($id) [ ClientConnection new $id ]
    
}


Protocol @doc processError { 
processError does ...
            id - 
            anError -
}

Protocol instproc processError { id anError } {
if {![::xotcl::self isnextcall]} {
error "Abstract method processError  id anError  called"} else {::xotcl::next}
}


Protocol @doc processExecute { 
processExecute does ...
            id - 
            script -
}

Protocol instproc processExecute { id script } {
if {![::xotcl::self isnextcall]} {
error "Abstract method processExecute  id script  called"} else {::xotcl::next}
}


Protocol @doc processReturn { 
processReturn does ...
            id - 
            returnData -
}

Protocol instproc processReturn { id returnData } {
if {![::xotcl::self isnextcall]} {
error "Abstract method processReturn  id returnData  called"} else {::xotcl::next}
}


Protocol @doc receiveLine { 
receiveLine does ...
            id - 
            line -
}

Protocol instproc receiveLine { id line } {
        ::xotcl::my instvar clients

        set client $clients($id)

        $client append command $line
        $client append command "\n"

        if { ![ info complete [$client command] ] } {

            return
        }

        $client command [ ::xotcl::my extractData [$client command ] ]

        $client doStateAction [ ::xotcl::self ]
        $client advanceState 

        $client command ""
    
}


Protocol @doc sendData { 
sendData does ...
            id - 
            data -
}

Protocol instproc sendData { id data } {
        puts $id [ ::xotcl::my encapsulateData $data ]
        flush $id
    
}


Protocol @doc sendError { 
sendError does ...
            id - 
            anError -
}

Protocol instproc sendError { id anError } {
        puts $id "\{error\}"
        ::xotcl::my sendData $id $anError
    
}


Protocol @doc sendExecute { 
sendExecute does ...
            id - 
            script -
}

Protocol instproc sendExecute { id script } {
        puts $id "\{execute\}"
        ::xotcl::my sendData $id $script
    
}


Protocol @doc sendReturn { 
sendReturn does ...
            id - 
            returnData -
}

Protocol instproc sendReturn { id returnData } {
        puts $id "\{return\}"
        ::xotcl::my sendData $id $returnData
    
}


Protocol @doc unEscapeBrackets { 
unEscapeBrackets does ...
            data -
}

Protocol instproc unEscapeBrackets { data } {
        regsub -all {\\\\} $data {\\} data
        regsub -all {\\\\} $data {\\} data

        regsub -all {\\\{} $data "\{" data
        regsub -all {\\\}} $data "\}" data

        return $data
    
}
}


