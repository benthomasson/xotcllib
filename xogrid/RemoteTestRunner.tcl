
namespace eval ::xogrid { 

Class create RemoteTestRunner -superclass { ::xogrid::RemoteInterp ::xounit::TestRunner }
  
RemoteTestRunner @doc RemoteTestRunner {
Please describe RemoteTestRunner here.
}
       
RemoteTestRunner parameter {

} 
        

RemoteTestRunner @doc init { 
init does ...
            host - 
            port -
}

RemoteTestRunner instproc init { host port } {
        ::xotcl::my instvar serializer

        set serializer [ ::xoserialize::Serializer new ]

        ::xotcl::next

        ::xotcl::my remoteEval { 

            package require XOTcl
            package require xounit
            package require xoserialize

            ::xoserialize::Serializer remoteSerializer
        }
    
}


RemoteTestRunner instproc runATest { aTestClass } {
        ::xotcl::my instvar serializer
        ::xotcl::my instvar results

        set serialized [ $serializer serialize $aTestClass ]

        ::xotcl::my remoteEval "remoteSerializer deserialize {$serialized}"

        ::xotcl::my remoteEval { ::xounit::TestRunner ::aRunner }
        ::xotcl::my remoteEval " ::aRunner runTests $aTestClass "

        set remoteResults [ ::xotcl::my remoteEval { ::aRunner results } ]

        set serial [ ::xotcl::my remoteEval "remoteSerializer serializeAssociatesList $remoteResults" ]

        lappend results [ $serializer deserializeListToNew $serial ]
    
}
}


