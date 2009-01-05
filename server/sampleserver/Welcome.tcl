# Created at Mon Jul 21 18:37:14 EDT 2008 by bthomass

namespace eval ::sampleserver {

    Class Welcome -superclass ::server::Application2

    Welcome @doc Welcome {

        Please describe the class Welcome here.
    }

    Welcome parameter {

    }

    Welcome instproc initialLoad { response } {

        $response puts "Welcome!"
        $response send200
    }
}


