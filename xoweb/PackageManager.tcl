# Created at Sat Oct 25 17:13:07 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::ApplicationClass create PackageManager -superclass ::xoweb::Application

    PackageManager @doc PackageManager {

        Please describe the class PackageManager here.
    }

    PackageManager parameter {

    }

    PackageManager instproc initialLoad { } { } {

        my instvar root

        #::xoweb reload

        return [ ::xoweb::makePage { } { 

            html {
                new XowebCSS -width 80%
                div -class object {

                    h1 ' Tcl Packages

                    ul foreach package [ lsort -dictionary [ package names ] ] {

                        if [ catch { package present $package } ] {
                            li { 
                                ' $package 
                                a -href "?method=load&package=$package" ' " \[ load \] "
                            }
                        } else {
                            li { 
                                a -href "$root/packageinspector?package=$package" ' $package
                                if [ my isobject ::${package} ] {
                                    a -href "?method=reload&package=$package" ' " \[ reload \] "
                                }
                            }
                        }
                    }
                }
            }
        } ]
    }

    PackageManager instproc load { -package } { } {

        my instvar url

        return [ ::xoweb::makePage { } {

            html {
                new XowebCSS
                div -class object {

                    h1 ' Loading $package ...

                    if [ catch {

                        package require $package

                    } error ] {

                        h1 ' Failed to load $package 
                        pre ' $error

                    } else {

                        h1 ' Successfully loaded $package !
                    }

                    a -href "$url" ' Return

                }
            }
        } ]
    }

    PackageManager instproc reload { -package } {

        my instvar url

        return [ ::xoweb::makePage {

            html {

                new XowebCSS 
                div -class object {

                    h1 ' Reloading $package ...

                    if [ catch {

                        ::${package} reload

                    } error ] {

                        h1 ' Failed to reload $package
                        pre  ' $error

                    } else {

                        h1 ' Successfully reloaded $package

                    }

                    a -href "$url" ' Return

                }
            }

        } ]
    }
}


