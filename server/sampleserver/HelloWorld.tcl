# Created at Mon Jul 21 18:28:49 EDT 2008 by bthomass


namespace eval ::sampleserver {

    Class HelloWorld -superclass ::server::Application2

    HelloWorld @doc HelloWorld {

        Please describe the class HelloWorld here.
    }

    HelloWorld parameter {

    }

    HelloWorld instproc  initialLoad { response } {

        $response puts "Hello World!"
        $response send200
    }
}


