# Created at Fri Oct 17 15:54:09 EDT 2008 by ben

namespace eval ::xodsl {

    ::xodsl::LanguageClass create SampleLanguage -superclass ::xodsl::Language

    SampleLanguage @doc SampleLanguage {

        Please describe the class SampleLanguage here.
    }

    SampleLanguage instproc hello { args } {

        puts hello
    }

    SampleLanguage instproc hi { } {

        puts hi
        return "a return value"
    }

    SampleLanguage instproc throwError { } {

        error "error thrown"
    }

    SampleLanguage instproc useLanguageLocalVar { } {

        my set local value
    }

    SampleLanguage instproc useEnvironmentVar { } {

        my instvar environment
        $environment set local value
    }

    SampleLanguage instproc <do> { } {
        my instvar environment
        $environment set a 5
    }

    SampleLanguage instproc <do2> { } {
        my instvar environment
        $environment set a 2
    }

    SampleLanguage instproc <do3> { arg } {

        return [ expr { $arg + 1 } ]
    }

    SampleLanguage instproc xyz { a b c } {

        return [ expr { $a + $b + $c } ]
    }

}


