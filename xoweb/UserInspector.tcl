# Created at Mon Oct 27 18:28:44 EDT 2008 by ben

namespace eval ::xoweb {

    ::xoweb::MultiuserApplicationClass create UserInspector -superclass ::xoweb::Application

    UserInspector @doc UserInspector {

        Please describe the class UserInspector here.
    }

    UserInspector parameter {

    }

    UserInspector instproc initialLoad { } {

        my instvar user

        return [ ::xoweb::makePage { } {

            html {
                new XowebCSS -width 80%
                div -class object {
                    h1 ' Welcome, [ $user name ]
                    form -action "" -method GET {
                        input -name "name" -type text -value "[ $user name ]"
                        input -name "method" -value Change_Name -type submit
                    }
                    ' "id = [ $user id ]"
                }
            }
        } ]
    }

    UserInspector instproc Change_Name { -name } {

        my instvar user url

        $user name $name

        return [ my initialLoad ]
    }
}


