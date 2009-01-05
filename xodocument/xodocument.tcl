#Created by bthomass using ::xox::Template
 
package require xox
::xox::Package create ::xodocument
::xodocument id {$Id: xodocument.tcl,v 1.6 2008/10/20 16:27:53 bthomass Exp $}
::xodocument @doc xodocument {
    xodocument is an XOTcl API documentation generation utility.
}
::xodocument requires {
    xodsl
}
::xodocument loadFirst {
    
}
::xodocument executables {
    xodocument
    simpleDoc
}
namespace eval ::xodocument {
}

::xodocument loadAll

::xodocument @doc UsersGuide {

    xodocument generates HTML and other forms of documentation
    from the code structure and code documentation.  xodocument
    extracts the information stored by @doc calls on Classes
    and Objects.  Specifically xodocument looks for certain tokens
    when building documentation.  These tokens are the name
    as the proc or instproc, the name of the Class or Object, the
    name of the package (without the leading ::), UsersGuide
    on packages, and the names of parameters on Classes. 

    xodocument also looks for the first sentence in the documentation
    as a brief summary of the longer form.  This is used in
    building summaries of classes and methods. 

    Example:

    Class XYZ

    XYZ @doc XYZ {

        This is the class documentation.
    }

    XYZ @doc a { parameter a documentation }
    XYZ @doc b { parameter b documentation }

    XYZ parameter {
        a
        b
    }

    XYZ @doc init {
        
        This is the constructor documentation.
    }

    XYZ @doc init { args } {

        #construct an instance of XYZ
    }

    XYZ @doc someMethod {

        This the documentation for someMethod.  
        This is part of the longer form of the documentation.
    }

    XYZ @doc someMethod { args } {

        puts "do something"
    }


    xodocument is called from the command line and all generated
    HTML documentation to files in the directory xodoc under
    the current working directory.

    xodocument xox xox::test yourpackage otherpackages
}

