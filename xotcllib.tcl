
package require xox
::xox::Package create ::xotcllib

::xotcllib requires {
    xounit
    xoexception
    xointerp
    xodsl
    xodocument
    simpletest
}

::xotcllib requireDependencies

package provide xotcllib 1.0
package provide xotcllib::test 1.0

