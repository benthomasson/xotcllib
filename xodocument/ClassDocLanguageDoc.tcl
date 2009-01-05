

namespace eval ::xodocument {

    ::xodocument loadClass ::xodocument::Class
    ::xodocument loadClass ::xodocument::ClassDocLanguage

    ClassDocLanguage @@doc Author: {

        Purpose: To define the authors of a class. This may be called multiple times.

        Arguments: {

            args The name of one author of the class.
        }

        Example: {

        Class X 

        X @@doc X {

            Author: John Doe
        }
        }
    }

    ClassDocLanguage @@doc Date: {

        Purpose: To define when this class was first created.

        Arguments: {
            args The creation date.
        }

        Example: {

        Class X

        X @@doc X {

            Author: John Doe
            Date: 1/1/1970
        }
        }
    }

    ClassDocLanguage @@doc Purpose: {

        Purpose: To define the need, usage, or behavior of a method or class. 

        Arguments: {
            args Either a string of text or a block of text that describes the method's or class's purpose for being.
        }

        Example: {

        Class X

        X @@doc X {

            Purpose: Class X is just an example of how to use @@doc and ClassDoc language.
        }
        }
    }

    ClassDocLanguage @@doc Args: {

        Purpose: Specifies a list of arguments to be used as a replacement for args.

        Arguments: {
            arguments: A list of arguments to be used as a replacement for args.
        }

        Example: {

            X@@doc addAll {

                Args: x y z

                Arguments: {
                    x  
                    y
                    z
                }
            }

            X instproc addAll { args } { 
                ... 
            }
        }
    }

    ClassDocLanguage @@doc Arguments: {

        Purpose: { 
            
            To define the arguments for a method. One argument is defined per line in the arguments block. The first word
            on the line should be the argument name.  The rest of the line is the documentation for that argument.  Also
            blocks may be used to describe an argument. 
        }

        Arguments: {
            block The block of arguments where each line starts with an argument name. See example.
        }

        Example: {

        Class X

        X @@doc sum {

            Arguments: {
                addend The first number to be added to the second.
                summand {
                    The second number to be added to the first.
                }
            }
            Returns: {
                The sum of the addend and summand.
            }
        }
        }
    }

    ClassDocLanguage @@doc Parameter: {

        Purpose: { 
            
            To define the parameters for a class. One parameter is defined per line in the parameters block. The first word
            on the line should be the parameter name.  The rest of the line is the documentation for that parameter.  Also
            blocks may be used to describe an parameter. 
        }

        Arguments: {
            block The block of parameters where each line starts with an parameter name. See example.
        }

        Example: {

        Class X

        X parameter {
            a
            b
            c
        }

        X @@doc X {

            Parameter: {
                a A variable
                b { Another variable }
                c Yet another variable
            }
        }
        }
    }

    ClassDocLanguage @@doc Returns: {

        Purpose: { 
            
            To define the returns from a method. Each line in the block is a separate return value.
        }
        Arguments: {

            block The block of returns where each line defines one return or one class of return.
        }

        Example: {

        Class X

        X @@doc sum {

            Arguments: {
                addend The first number to be added to the second.
                summand {
                    The second number to be added to the first.
                }
            }
            Returns: {
                The sum of the addend and summand.
            }
        }
        }
    }

    ClassDocLanguage @@doc Example: {

        Purpose: To define an example for a class or method.

        Arguments: {

            block The block of code used as an example.
        }

        Example: {

            Class X

            X @@doc sum {

                Example: {

                    sum 1 5
                    (returns 6)
                }
            }
        }
    }

    ClassDocLanguage @@doc Change: {

        Purpose: Defines a change in a class by a date. This should be called for each change.

        Arguments: {
            date The date of the change
            args A block or line of text describing the change
        }

        Example: {

            Class X 

            X @@doc X {

                Change: 1/1/1970 Added sum
                Change: 1/2/1970 Added minus
            }
        }
    }

    ClassDocLanguage @@doc See: {

        Purpose: Defines a class, method, or web page that should be linked from the documentation. 

        Arguments: {
            link A class name, an object name, or a URL to link to.
        }

        Example: {

        Class X 

        X @@doc X {

            See: ::xodocument::ClassDocLanguage 
            See: http://xotcl.org
        }
        }
    }

    ClassDocLanguage @@doc Tags: {

        Purpose: Defines a set of tags that would be useful in searching for this method.

        Arguments: {
            args A list of tags
        }

        Example: {

        Class X 

        X @@doc X {

            Tags: example doc X
        }
        }
    }

}


