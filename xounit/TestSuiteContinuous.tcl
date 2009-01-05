# Created at Fri Jun 01 07:39:09 EDT 2007 by bthomass

namespace eval ::xounit {

    namespace import -force ::xotcl::*

    Class TestSuiteContinuous -superclass { ::xounit::TestSuite }

    TestSuiteContinuous instmixin add ::xox::NotGarbageCollectable                       

    TestSuiteContinuous # TestSuiteContinuous {

        TestSuiteContinuous is a test runner that can repeatedly
        run tests after a delay to support continous testing.
    }

    TestSuiteContinuous # location { The directory to place the generated
    web pages in}

    TestSuiteContinuous # webPath { The url of the generate pages }
    TestSuiteContinuous # title { The of the web page generated }
    TestSuiteContinuous # url { A link from the title }
    TestSuiteContinuous # times { The number of iterations to run. -1 for infinite}
    TestSuiteContinuous # delay { The number of minutes to wait between iterations }

    TestSuiteContinuous parameter {
        
        location
        webPath
        title
        url
        { times -1 }
        { delay 30 }
    }

    TestSuiteContinuous # runSuite {

        Run the test suite and increment the number of times run.
    }

    TestSuiteContinuous # reloadPackages {

        Reload all the packages that are being tested.
    }

    TestSuiteContinuous instproc reloadPackages { } {

        foreach package [ my packages ] {

            my forgetAll $package
        }

        foreach package [ my packages ] {

            package require $package
        }
    }

    TestSuiteContinuous # forgetAll {

        Package forget all the subpackages that are contained in a super package.
    }

    TestSuiteContinuous instproc forgetAll { package } {

        set subs [ ::xox::removeIfNot { string match $package $name } name [ package names ] ]

        foreach sub $subs {

            package forget $sub
        }
    }

    TestSuiteContinuous # closeFileChannels { } {

        Forcibly closes all the open file channels that might have been
        left open by poorly written tests (especially mine).   It does
        not close stdout, stderr, or stdin.
    }

    TestSuiteContinuous instproc closeFileChannels { } {

        set channels [ ::xox::removeIf {
            expr {  [ ::xox::startsWith "$x" "sock" ] ||
                    "$x" == "stdout" ||
                    "$x" == "stdin" || 
                    "$x" == "stderr" }
        } x [ file channels ] ]

        foreach channel $channels {

            catch { close $channel }
        }
    }
}


