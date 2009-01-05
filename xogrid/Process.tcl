
namespace eval ::xogrid { 

Class create Process -superclass { ::xotcl::Object }
  
Process @doc Process {
Please describe Process here.
}
    
Process @doc spawnId { }

Process @doc name { }

Process @doc pid { }
   
Process parameter {
   {spawnId}
   {name}
   {pid}

} 
        

Process @doc close { 
close does ...
}

Process instproc close {  } {
        my instvar spawnId pid

        close -i $spawnId
        wait -i $spawnId
}


Process @doc isAlive { 
isAlive does ...
}

Process instproc isAlive {  } {
        my instvar spawnId

        if [ catch {
            expect -i $spawnId -re .*
        } ] {

            return 0
        }

        return 1
    
}


Process @doc printStdout { 
printStdout does ...
}

Process instproc printStdout {  } {
        my instvar spawnId name pid

        set spawnId [ my spawnId ]

        expect {
            -i $spawnId
            -timeout 0
            -re .+ {  puts "stdout: ${name}\(${pid}\) \{\n$expect_out(buffer)\n\}" }
        }
    
}


Process @doc start { 
start does ...
}

Process instproc start {  } {
        my instvar name spawnId pid
        
        set pid [ eval "spawn $name" ]
        my set spawnId $spawn_id
        after 1000

        if { $pid == 0 } { error "Did not spawn $name" }
    
}
}


