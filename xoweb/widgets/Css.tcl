

::xohtml::widgets {

    @@doc XowebCSS {

        Purpose: CSS for Xoweb applications
    }

    defineWidget XowebCSS { { width 500px } } { } {

        style -type "text/css" ' "
            body {
                font-family: Helvetica,Arial,Sans-Serif;
                background-color: #CCC;
            }
            .object {
                border: thin solid blue;
                padding: 1em;
                width: ${width};
                background-color: #fff;
                margin-left: auto;
                margin-right: auto;
            }
            .procedure pre { 
                padding: 20px;
                border: 1px solid #dadada;
                font-size: 9pt;
                color: #220088;
                overflow: auto;
            }
            .text {
                padding: 20px;
                width: 75%;
                word-spacing: 2px;
                line-height: 150%;
            }
            .name {
                background-color: #eee;
                padding: 20px;
            }
        "
    }

    defineWidget TableCSS { } { } {

        css {

            thead th.sort-asc {
                background: #E0EEEE url('/images/SortAsc.png') no-repeat right center;
            }

            thead th.sort-desc {
                background: #E0EEEE url('/images/SortDesc.png') no-repeat right center;
            }

            table { 
                margin: 0 0 1em;
                background: #FFF;
                border-collapse: collapse;
            }       

            td, th {
                padding: 0.5em 1em;
            }       

            th { border-bottom: thin solid black; }
            .even { 
                background: #E0EEEE;
            }       
        }


    }
}
