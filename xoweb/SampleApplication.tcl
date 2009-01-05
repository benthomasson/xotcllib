# Created at Thu Oct 23 11:46:03 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create SampleApplication -superclass ::xoweb::Application

    SampleApplication @doc SampleApplication {

        Please describe the class SampleApplication here.
    }

    SampleApplication parameter {

    }

    SampleApplication instproc initialLoad { } {

        return [ ::xoweb::makePage { } {
                h1 ' Hi 
                h1 ' Other Pages
                ul foreach page {basicPage tablePage} {

                    li a -href "?method=$page" ' $page
                }
        } ]
    }

    SampleApplication instproc basicPage { } {

        return [ ::xoweb::makePage { } {

            add ::xoweb::XowebLanguage
            basicPage -title "A Title" { 

                h1 ' Hi there
            }
        } ]
    }

    SampleApplication instproc tablePage { } {

        return [ ::xoweb::makePage { } {

            add ::xoweb::XowebLanguage
            ajaxPage -title "Table Page" {
                new TableCSS

                table -id items {
                    thead {
                        tr {
                            th ' A
                            th ' B
                            th ' C
                        }
                    }
                    tbody {
                        tr -class even {
                            td ' A11
                            td ' B12
                            td ' 1
                        }
                        tr {
                            td ' B21
                            td ' A22
                            td ' 11
                        }
                        tr -class even {
                            td ' C31
                            td ' C32
                            td ' 101
                        }
                    }
                }
            }
        } ]
    }
}


