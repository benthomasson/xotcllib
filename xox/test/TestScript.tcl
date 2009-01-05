
namespace eval ::xox::test { 

Class create TestScript -superclass { ::xounit::TestCase }
  
TestScript @doc TestScript {
Please describe TestScript here.
}
       
TestScript parameter {

} 

TestScript instproc testObjectEvalVar { } {

    set o [ Object new ]

    $o eval {
        set a 5
    }

    my assertEquals [ $o set a ] 5
}

TestScript instproc testObjectEvalProcUplevel { } {

    set o [ Object new ]

    $o proc do { } {

       uplevel set a 5
    }

    $o eval {
        do
    }

    my assertEquals [ $o set a ] 5
}
        
TestScript instproc testObjectEvalInstprocsFail { } {

    set o [ ::xox::Node new ]

    my assertError {
        
        $o eval {

            nodeName X
        }
    }

    $o nodeName Z

    my assertEquals [ $o getNodeName ] Z
}

TestScript instproc testGetScope { } {

    set script [ ::xox::Script new ]

    my assertObject [ $script getScope ]

    set scope [ $script getScope ]

    my assertEquals [ $script getScope ] $scope
}

TestScript instproc testEvalCommands { } {

    set script [ ::xox::Script new -commands {

        { set a 5 }
    } ]

    $script evalCommands

    my assertEquals [ [ $script scope ] set a ] 5
}

TestScript instproc testEvalCommandsProc { } {

    set script [ ::xox::Script new -commands {

        { proc do { } {
            uplevel set a 5
        } }

        { do }
    } ]

    $script evalCommands

    my assertEquals [ [ $script scope ] set a ] 5
}

TestScript instproc testInstallMethods { } {

    set script [ ::xox::Script new \
            -scopeClass ::xox::Node ]
    set scope [ $script getScope ]

    $script commands [ subst {

        { my mixin add ::xounit::Assert }
        { my nodeName X }
    } ] 

    my assertSetEquals [ $scope info procs ] \
    {nodeName dumpTreeData parentNode nodeNameFromClass createAutoNamedChildInternal copyNewNode addNodeNoConfigureNode setParentNode createChildInternal createAutoNamedChild copyNodeInternal getNodeName nextName configureNode dumpData createChild nodes addAutoNameNode fixedName copyNode hasNode createNewChild treeView getChild getAllSubNodes path childName findRoot addAutoNameNodeNoConfigureNode getNode cleanUpNode / addNode}

    my assertSetEquals [ $scope eval { info procs } ] \
    {dumpTreeData parentNode nodeNameFromClass createAutoNamedChildInternal copyNewNode addNodeNoConfigureNode setParentNode createChildInternal createAutoNamedChild copyNodeInternal getNodeName nextName configureNode dumpData createChild nodes addAutoNameNode fixedName copyNode hasNode createNewChild treeView getChild getAllSubNodes path childName findRoot addAutoNameNodeNoConfigureNode getNode cleanUpNode / addNode nodeName}

    $script evalCommands

    my assertEquals [ $scope nodeName ] X
    my assertEquals [ $scope getNodeName ] X

    set methods [ ::xox::ObjectGraph findAllMethods $scope ]
    foreach method $methods {

        my assertEquals [ interp alias {} $method ] ""
    }
}

TestScript instproc testAddCommand { } {

    set script [ ::xox::Script new ]

    $script addCommand "set a 5"
    $script addCommand "set b 6"
    $script addCommand "set c 7"

    my assertListEquals  [$script commands ] "{set a 5} {set b 6} {set c 7}"
}

TestScript instproc testRegsubCommand { } {

    set script [ ::xox::Script new ]

    my assertEquals [ $script regsubCommand "puts hey" hey \$message ] {puts $message}
}

TestScript instproc testParameterize { } {

    set script [ ::xox::Script new \
                    -commands {
                        { puts hey }
                    } ]

    $script parameterize hey message

    my assertListEquals [ $script commands ] { { puts $message } }
    my assertListEquals [ $script parameters ] { {message hey} }
}


}


