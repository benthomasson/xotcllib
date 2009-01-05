# Created at Sun Oct 19 16:00:30 EDT 2008 by bthomass

namespace eval ::xodsl {

    Class ModelBuildingLanguageClass -superclass ::xodsl::LanguageClass

    ModelBuildingLanguageClass @doc ModelBuildingLanguageClass {

        Please describe the class ModelBuildingLanguageClass here.
    }

    ModelBuildingLanguageClass parameter {

    }

    ModelBuildingLanguageClass instproc newLanguage { args } {

        set environment [ ::xodsl::ModelEnvironment new ]
        set language [ eval my new $args [ list -set environment $environment ] ]

        my updateEnvironment $language

        return $language
    }

    ModelBuildingLanguageClass instproc updateObjectEnvironment { language } {

        set environment [ $language set environment ]
        set globalProcs [ lsort -unique [ $language set globalProcs ] ]

        if [ $language exists object ] {

            set object [ $language set object ]
        
            foreach method [ $object info methods ] {

                if { [ lsearch -sorted $globalProcs $method ] == -1 } {
                    $environment forward $method $object $method
                }
            }

            $environment forward - $object set
        }
    }
}


