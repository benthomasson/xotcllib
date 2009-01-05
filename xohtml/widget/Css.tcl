

::xohtml::widgets {

    @@doc XohtmlCss {

        Purpose: Default CSS for Xohtml Pages
    }

    defineWidget XohtmlCss { { width 500px } } { } {

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
}
