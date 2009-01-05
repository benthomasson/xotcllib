# Created at Tue Jul 22 09:45:12 EDT 2008 by bthomass

namespace eval ::xohtml {

    ::xodsl::ModelBuildingLanguageClass create SiteBuilder -superclass ::xohtml::PageBuilder

    SiteBuilder @doc SiteBuilder {

        Please describe the class SiteBuilder here.
    }

    SiteBuilder parameter {
        { packages {xohtml xohtml::widget} }
    }

    SiteBuilder instproc buildSite { script } {

        my instvar environment object

        my useObject [ ::xohtml::Site new ]

        $environment eval $script 

        return $object 
    }

    SiteBuilder instproc writeSite { script } {

        set site [ my buildSite $script ]
        $site writePages 

        return $site
    }
}


