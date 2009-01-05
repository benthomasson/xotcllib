# Created at Mon Oct 20 11:27:01 EDT 2008 by ben

namespace eval ::xodsl {

    Class ModelEnvironment -superclass ::xotcl::Object

    ModelEnvironment @doc ModelEnvironment {

        Please describe the class ModelEnvironment here.
    }

    ModelEnvironment parameter {

    }

    ModelEnvironment instproc localSet { __var __value } {

        my instvar $__var
        return [ set $__var $__value ]
    }

    ModelEnvironment instproc localGet { __var } {

        my instvar $__var
        return [ set $__var ]
    }
}


