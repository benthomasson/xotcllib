# Created at Sat Oct 18 18:19:52 EDT 2008 by ben

namespace eval ::xodsl {

    ::xodsl::LanguageClass create SampleStringLanguage -superclass ::xodsl::StringBuildingLanguage

    SampleStringLanguage instmixin add ::xodsl::StringBuilding

    SampleStringLanguage @doc SampleStringLanguage {

        Please describe the class SampleStringLanguage here.
    }

    SampleStringLanguage parameter {

    }

    SampleStringLanguage instproc hello { } {

        return hello
    }

    SampleStringLanguage instproc howdy { } {

        return "hi there"
    }

    SampleStringLanguage instproc h1 { script } {

        return "<h1>[ my evaluateInternalStringScript $script ]</h1>"
    }
}


