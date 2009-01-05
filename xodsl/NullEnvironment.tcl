# Created at Mon Dec 15 12:52:08 EST 2008 by ben

namespace eval ::xodsl {

    Class NullEnvironment -superclass ::xotcl::Object

    NullEnvironment @doc NullEnvironment {

        Please describe the class NullEnvironment here.
    }

    NullEnvironment parameter {
        scope
        namespace
    }

    NullEnvironment instproc set { args } {

        my instvar scope
        uplevel $scope set $args
    }

    NullEnvironment instproc eval { script } {

        my instvar scope
        uplevel $scope $script
    }

    NullEnvironment instproc forward { name object method } {

        my instvar namespace
        proc ${namespace}::${name} { args } [ subst {
            eval $object $method \$args
        } ] 
    }

    NullEnvironment instproc exists { variable } {

        my instvar scope
        uplevel $scope info exists $variable
    }

    NullEnvironment instproc lappend { args } {

        my instvar scope
        uplevel $scope lappend $args
    }
}


