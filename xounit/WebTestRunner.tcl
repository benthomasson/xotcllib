

namespace eval xounit {

    ::xotcl::Class create WebTestRunner -superclass {
        ::xounit::TestResultsWebFormatter 
        ::xounit::TestRunner 
    }

    WebTestRunner # WebTestRunner {

        TestRunner that has the ability to write results
        in a format viewable via the web.
    }

    WebTestRunner # location { location to write html file to }
    WebTestRunner # webPath { url where html file will be served }
    WebTestRunner # title { title to use in html file  }
    WebTestRunner # url { url to more project information }

    WebTestRunner parameter {
        location
        webPath
        title
        url
    }
}

