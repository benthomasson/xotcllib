
package require XOTcl

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class Reload 

    Reload # Reload {

        Reload is a mixin that can be added to Class to allow
        Classes to be redefined without destroying object-class
        relationships.
    }

    Reload # recreate {

        Reload overloads recreate to allow for redefinition of 
        classes without destroying the relationship of instances
        to classes.  In normal xotcl redefinition of a class
        destroys the class-object.  This makes all class pointers
        on object to be invalid.  Thus all instances of a redefined
        class have their class changed to ::xotcl::Object.

        This recreate method solves this problem, by not destroying
        the class-object, but just erasing all its properties and
        methods and then they can be redefined.

        This allows resourcing of libraries or packages while
        the code is running without corrupting the program state. 

        See the xotcl documentation for other recreate docs.
    }

    Reload instproc recreate {o args} {
        if {[$o isclass]} {
            catch { $o array unset @return }
# class redefiniton, delete commands and instcommands ...
            foreach cmd [$o info instcommands] {$o instproc $cmd "" ""}
            foreach cmd [$o info commands] {$o proc $cmd "" ""}
# ... and delete all kind of interceptors ...
            foreach interceptor {filter instfilter mixin instmixin} {
                $o $interceptor set [list]
            }
# ... and delete parameters ...
            $o parameter ""
# ... and evaluate provided flags (parameters, class rels, etc.)
            set nrInitArgs [eval $o configure $args]
# ... finally call constructor with arguments
            eval $o init [lreplace $args $nrInitArgs end]
# return fully qualified name
            return [$o self]
        } else {
# it is a plain object redefinition, do standard stuff
            next
        }
    }

    ::xotcl::Class instmixin add ::xox::Reload
}


