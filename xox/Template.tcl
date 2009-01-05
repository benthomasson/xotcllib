# Created at Tue Jul 03 08:05:45 -0400 2007 by ben

namespace eval ::xox {

    namespace import -force ::xotcl::*

    Class Template -superclass ::xotcl::Object

    Template @doc Template {

        Template genertes code for classes and objects.
    }

    Template @doc getTime {

        Returns the current time in year-month-day-hour-minute-seconds format.
    }


    Template instproc getTime { } {

        return [ clock format [ clock seconds ] -format "%Y%m%d%H%M%S" ]
    }

    Template instproc writePackageFile { package } {

        if { ! [ my isobject $package ] } {

            error "Cannot find package object: $package"
        }

        if { ! [ $package hasclass ::xox::Package ] } {

            error "$package is not an ::xox::Package"
        }

        set path [ $package packagePath ]

        set packageFile "[ ::xox::Package getClassPackage $package ].tcl"
        set oldFile "[ ::xox::Package getClassPackage $package ].[ my getTime ].old"

        set file [ file join $path $packageFile ]

        file mkdir [ file dirname $file ]

        if [ file exists $file ] {

            puts "Copying $file to $oldFile"
            file copy -force $file [ file join $path $oldFile ]
        }

        puts "Writing $file"

        ::xox::withOpenFile $file w out {

            puts $out "#Created by $::env(USER) using [ my info class ]"
            puts $out [ my generatePackageFile $package ]
        }
    }

    Template instproc writeFile { object } {

        set package "::[ ::xox::Package getMainPackage $object ]"

        #my debug $package

        set path [ $package packagePath ]

        #my debug $path

        set classFile [ ::xox::Package getClassFile $object ]

        set file [ file join $path $classFile ]

        file mkdir [ file dirname $file ]

        #my debug $file

        puts "Writing $file"

        ::xox::withOpenFile $file w out {

            puts $out [ my generateFileCode $object ]
        }
    }

    Template instproc writeNewFile { object } {

        set package "::[ ::xox::Package getMainPackage $object ]"

        set path [ $package packagePath ]

        #my debug $path

        set classFile [ my getClassFile $object ]
        set oldFile [ my getOldClassFile $object ]

        set file [ file join $path $classFile ]

        if [ file exists $file ] {

            puts "Copying $file to $oldFile"
            file copy -force $file [ file join $path $oldFile ]
        }

        my writeFile $object
    }

    Template instproc generateFileCode { object } {

        return [ subst {
namespace eval [ namespace qualifiers $object ] { 

[ my st [ my generateCode $object ] ]
}

} ]
    }

    Template instproc generateCode { object } {

        if [ my isclass $object ] {
            return [ my generateClassCode $object ]
        } else {
            return [ my generateObjectCode $object ]
        }
    }

    Template instproc generateClassCode { class } {

        return [ subst {
[ my generateClassCreate $class ] \
[ my generateObjectDocumentation $class ] \
[ my generateInstMixins $class ] \
[ my generateParametersDocumentation $class ] \
[ my generateClassParameter $class ] \
[ my generateParameterCmds $class ] \
[ my generateVars $class "id"] \
[ my generateProcs $class ] \
[ my generateInstprocs $class ] \
}]
    }

    Template instproc generateObjectDocumentation { object {fullName 0 }} {

        set doc [ my st [ $object get# [ my nt $object ] ] ]

        if { "" == "$doc" } {
           set doc "Please describe [ my nt $object ] here."
        }

        if $fullName {

            set name $object
        } else {

            set name [ my nt $object ]
        }

        return [ subst {
$name @doc [ my nt $object ] {
$doc
}
}]
    }
    
    Template instproc generateInstMixins { class } {

        set buffer ""

        foreach instmixin [ $class info instmixin ] {

            append buffer [ my generateInstMixin $class $instmixin ]
        }

        if { "" == "$buffer" } { return }

        return "\n$buffer"
    }

    Template instproc generateInstMixin { class instmixin } {

        return [ subst {[ my nt $class ] instmixin add $instmixin 
} ]
    }

    Template instproc generateParametersDocumentation { class } {

        set buffer ""

        foreach parameter [ $class info parameter ] {

            append buffer [ my generateParameterDocumentation $class $parameter ]
        }

        return $buffer
    }
    
    Template instproc generateParameterDocumentation { class parameter } {
        return [ subst {
[ my nt $class ] @doc [ lindex $parameter 0 ] { [ my st [ $class get# [ lindex $parameter 0 ] ] ]}
} ]
    }

    Template instproc generateClassCreate { class } {

        set metaclass [ $class info class ]

        if { "$metaclass" == "::xotcl::Class" } {

            set metaclass Class
        }
        
        set cvsId [ $class getID ]

        return [ subst {
$metaclass create [ my nt $class ] -superclass { [ $class info superclass ] }

[ my nt $class ] id {\$$cvsId \$}
}]
    }

    Template instproc generateObjectCreate { object } {

        return [ subst {
[ my nt [ $object info class ] ] create [ my nt $object ] 
}]
    }

    Template instproc generateClassParameter { class } {

        set buffer ""

        foreach param [ $class info parameter ] {

            append buffer "   {$param}\n"
        }
    
        return [ subst { 
[ my nt $class ] parameter {
$buffer
} 
}]
    }

    Template instproc generateProcs { class } {

        set buffer ""

        foreach instproc [ lsort [ $class info procs ] ] {

            append buffer [ my generateMethod $class $instproc proc ]
        }
        
        return $buffer
    }

    Template instproc generateInstprocs { class } {

        set buffer ""

        foreach instproc [ lsort [ $class info instprocs ] ] {

            append buffer [ my generateMethod $class $instproc instproc ]
        }
        
        return $buffer
    }

    Template instproc generateMethod { class method type } {

        return [ subst {
[ my generateMethodDocumentation $class $method $type ]
[ my nt $class ] $type $method [ my generateNonPosArgList $class $method $type ]{ [ my generateArgList $class $method $type ] } {
[ my generateMethodBody $class $method $type ]
}
} ]
    }

    Template instproc generateMethodBody { class method type } {

        if { "instproc" == "$type" } {
            return [ string trim [ $class info instbody $method ] "\n" ]
        } else {
            return [ string trim [ $class info body $method ] "\n" ]
        }
    }

    Template instproc generateMethodDocumentation { class method type {fullClassName 0} } {

        set doc [ my st [ $class get# $method ] ]

        if { "instproc" == "$type" } {
            set args [ $class info instargs $method ]
        } else {
            set args [ $class info args $method ]
        }

        if { "" == "$doc" } {

            if { "" != "[ ::xox::ObjectGraph findFirstComment $class $method ]" } {

                return
            }
        }

        if { "" == "$doc" } {

            set arguments ""

            foreach arg $args {

                append arguments \
"            $arg - \n"

            } 

            set doc [ subst {
        $method does ...
$arguments
            } ]
            set doc [ my st $doc ]
        }

        if { $fullClassName } {
            set className $class
        } else {
            set className [ my nt $class ]
        }
        
        return [ subst {
$className @doc $method { 
$doc
}
} ]
    }

    Template instproc generateArgList { class method type } {

        set list ""

        if { "instproc" == "$type" } {
            set args [ $class info instargs $method ]
        } else {
            set args [ $class info args $method ]
        }

        foreach arg $args {

            set default ""

            if { "instproc" == "$type" } {
                if [ $class info instdefault $method $arg default ] {
                    lappend list " $arg \"$default\" "
                } else {
                    lappend list $arg
                }
            } else {
                if [ $class info default $method $arg default ] {
                    lappend list " $arg \"$default\" "
                } else {
                    lappend list $arg
                }
            }
        }

        return $list
    }


    Template instproc generateNonPosArgList { class method type } {

        if { "instproc" == "$type" } {
            set list [ $class info instnonposargs $method ]
        } else {
            set list [ $class info nonposargs $method ]
        }

        if { "" == "$list" } {

            return ""
        }

        return "{ $list } "
    }
    

    Template instproc generateObjectCode { object } {

        return [ subst { \
[ my generateObjectCreate $object ] \
[ my generateObjectDocumentation $object ] \
[ my generateParameterCmds $object ] \
[ my generateVars $object ] \
[ my generateProcs $object ] \
}]
    }

    Template instproc generateParameterCmds { object } {

        set procs [ $object info procs ]

        lappend procs slot

        set parameterCmds [ ::xox::removeIf {

            expr { [ lsearch $procs $command ] != -1 }

        } command [ $object info commands ] ]

        set buffer ""

        foreach command $parameterCmds {

            append buffer "\n[ my nt $object ] parametercmd $command\n"
        }

        return $buffer
    }

    Template instproc generateVars { object { except "" } } {

        set buffer ""

        foreach var [ $object info vars ] {

            if [ ::xox::startsWith $var "__" ] { continue }
            if [ ::xox::startsWith $var "#" ] { continue }
            if { [ lsearch -exact $except $var ] != -1 } { continue } 

            append buffer [ my generateVar $object $var ]
        }
        
        return $buffer
    }

    Template instproc generateArrayVar { object array } {

        set buffer ""

        foreach var [ lsort [ $object array names $array ] ] {

            append buffer [ my generateVar $object "$array\($var\)" ]
        }

        return $buffer
    }
    
    Template instproc generateValue { value } {

        if { "" == "$value" } {

            return "{}"
        }

        if { [ string first " " $value ] != -1 } {
            return "{$value}"
        }
        
        if { [ string first "\$" $value ] != -1 } {
            return "{$value}"
        }

        return $value
    }

    Template instproc generateVar { object var } {

        if [ $object array exists $var ] {

            return [ my generateArrayVar $object $var ]
        }

        set value [ $object set $var ]

        return [ subst {
[ my nt $object ] set $var [ my generateValue $value ] } ]
}
    
    Template instproc generatePackageFile { package } {

        set cvsId [ $package getID ]

        return [ subst { 
package require xox
::xox::Package create $package
$package id {\$$cvsId $}
[ my st [ my generateObjectDocumentation $package 1 ] ]
$package @doc UsersGuide {
[ my st [$package get# UsersGuide ] ]
}
$package requires {
    [ my st [ $package requires ] ]
}
$package imports {
    [ my st [ $package imports ] ]
}
$package loadFirst {
    [ my st [ $package loadFirst ] ]
}
$package executables {
    [ my st [ $package executables ] ]
}
[ my st [ my generateNamespaceVariables $package ] ]
[ my st [ my generateNamespaceProcs $package ] ]
$package loadAll

} ]
    }

    Template instproc generateVersions { package } {

        set buffer ""

        foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {
            if { [ string first $package $object ] != 0 } { continue }

            append buffer "    $object [ $object version ]\n"
        }

        return $buffer
    }

    Template instproc generateNamespaceProcs { package } {

        set buffer ""

        foreach proc [ lsort [ $package info procs ] ] {

            append buffer [ my generateNamespaceProc $package $proc ]
        }

        return $buffer
    }

    Template instproc generateNamespaceProc { package proc } {

        return [ subst { \
[ my generateMethodDocumentation $package $proc proc 1 ]
proc ${package}::${proc} { [ my generateArgList $package $proc proc ] } {
    [ my generateMethodBody $package $proc proc ]
}
} ]

    }

    Template instproc generateNamespaceVariables { package } {

        set buffer "namespace eval $package {\n"

        foreach var [ lsort [ $package namespaceVariables ] ] {
            
            if [ $package array exists $var ] {

                append buffer "    variable $var\n"
                
                foreach index [ $package array names $var ] {

                    append buffer \
                    "    set $var\($index\) [ my generateValue [ $package set $var\($index\) ] ]\n"
                }

            } else {

            append buffer "    variable $var [ my generateValue [ $package set $var ] ]\n"
            }
        }

        append buffer "}\n"

        return $buffer
    }

    Template instproc createPackage { package directory } {

        if { ! [ my isobject $package ] } {

            ::xox::Package create $package -noinit

            $package requireNamespace
            $package packagePath $directory
            $package packageFile [ $package packageName ].tcl
        }

        namespace eval ${package}::test {

        }
    }

    Template instproc buildPackage { package } {

        file mkdir [ $package packagePath ]
        file mkdir [ file join [ $package packagePath ] test ]

        set testPackageFile [ file join [ $package packagePath ] test \
            [ $package packageName].tcl ]

        if { ! [ file exists $testPackageFile ] } {

            ::xox::withOpenFile $testPackageFile w file {

                puts $file "package provide [ $package packageName]::test 1.0"
                puts $file "$package loadAll"
            }
        }

        my writePackageFile $package

        foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {
            if { [ string first $package $object ] != 0 } { continue }

            my writeNewFile $object
        }

        $package buildPkgIndex
    }

    Template instproc buildClass { object } {

        my writeNewFile $object
        my writeTest $object

       [ ::xox::Package getMainPackage $object ] buildPkgIndex
    }

    Template instproc buildTests { package } {

        foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {
            if { [ string first $package $object ] != 0 } { continue }
            if { [ string first ${package}::test $object ] == 0 } { continue }

            my writeTest $object
        }

        my buildPackageTest $package

        $package buildPkgIndex
    }

    Template instproc getTestName { classToTest } {

        return "::[ ::xox::Package getMainPackage $classToTest ]::test::Test[ namespace tail $classToTest ]"
    }

    Template instproc getTestMethodName { methodName } {

        return "test[ string totitle $methodName 0 0]"
    }

    Template instproc buildTest { classToTest } {

        set parent [ $classToTest info parent ]

        if [ my isclass $parent ] {
            return
        }

        #my debug $classToTest

        set testClass [ my getTestName $classToTest ]

        #my debug $testClass

        if { ! [ my isclass $testClass ] } {

            Class create $testClass -superclass ::xounit::TestCase

            $testClass @doc [ my nt $testClass ] "
        $testClass tests $classToTest

            "
        }

        if [ my isclass $classToTest ] {
            set type instprocs
        } else {
            set type procs
        }

        foreach instproc [ $classToTest info $type ] {

            set testMethod [ my getTestMethodName $instproc ]

            if { "[ $testClass info instprocs $testMethod ]" == "" } {

                $testClass instproc $testMethod { } {

                    my fail "Please implement me"
                }
            }
        }

        return $testClass
    }

    Template instproc writeTest { classToTest } {

        my writeNewFile [ my buildTest $classToTest ]
    }

    Template instproc buildPackageTest { package } {

        set testClass ${package}::test::TestPackage[ string totitle [ $package packageName ] 0 0 ]

        if { ! [ my isclass $testClass ] } {

            Class create $testClass -superclass ::xounit::TestCase

            $testClass @doc [ my nt $testClass ] "
        $testClass tests the package $package

            "
        }

        foreach instproc [ $package info procs ] {

            set testMethod [ my getTestMethodName $instproc ]

            if { "[ $testClass info instprocs $testMethod ]" == "" } {

                $testClass instproc $testMethod { } {

                    my fail "Please implement me"
                }
            }
        }

        my writeNewFile $testClass
    }

    Template instproc generateClassTests { package } {

        set buffer ""

        foreach object [ ::xox::ObjectGraph findAllInstances ::xotcl::Class ] {
            if { [ string first $package $object ] != 0 } { continue }

            append buffer "        my assertClass $object \"$object has been removed\"\n"
        }

        return $buffer
    }

    Template instproc generateVarTests { object vars } {

        set buffer ""

        set vars [ ::xox::removeIf {
            expr { "$var" == "#" }
        } var $vars ]

        foreach var [ lsort $vars ] {

            if [ $object array exists $var ] {
            
            append buffer "        my assertEquals \[ $object array get $var \] {[ $object array get $var ]} \"$var changed\"\n"

            } else {

            append buffer "        my assertEquals \[ $object set $var \] {[ $object set $var ]} \"$var changed\" \n"
            }

        }

        return $buffer
    }

    Template instproc nt { object } {

        return [ namespace tail $object ]
    }

    Template instproc st { object } {

        return [ string trim $object ]
    }

    Template instproc getClassFile { class } {

        regsub -all {::} $class { } path

        set subpackage [ lrange $path 1 end-1 ]
        set class [ lindex $path end ]

        return "[ eval file join $subpackage $class ].tcl"
    }

    Template instproc getOldClassFile { class } {

        regsub -all {::} $class { } path

        set subpackage [ lrange $path 1 end-1 ]
        set class [ lindex $path end ]

        return "[ eval file join $subpackage $class ].[ my getTime ].old"
    }
}


