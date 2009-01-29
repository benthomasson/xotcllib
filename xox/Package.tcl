package require XOTcl

namespace eval ::xox {

    Class Package -superclass ::xox::NotGarbageCollectable

    Package instmixin add ::xox::CVS
    Package instmixin add ::xox::MetaData


    Package @doc Package {

        Package represents information about tcl packages. Currently
        this is just used to add comments about a package in xodocument.
        In the future Package could provide methods for building
        pkgIndex.tcl files from the directory where the package lives.
        It could also provide methods for package requiring all subpackages.

        To add a package description to the generated add the following
        to your superpackage file:

        xox.tcl:

        Package xox
        xox @doc Package description {

            xox is an extension of XOTcl.  xox adds instprocs, and instmixins to ::xotcl::Class and ::xotcl::Object.
        }

        This creates an object that represents the xox package.  Use
        the "namespace tail" of the namespace for the object name.  
        xodocuement looks for this object at the location:

        ${namespace}::[ namespace tail $namespace ]

        For ::xox this is ::xox::xox

        You should also the same namespace and package name, except
        leave the :: off of the beginning of the package name.

        Thus ::xox is the namespace name, xox is the package name.
    }

    Package @doc executables {  A list of paths to executable scripts in this package }
    Package @doc packagePath { The absolute path to the directory containing the package }
    Package @doc packageFile { The name of the file containing the package }

    Package parameter {
        { requires "" }
        { failedDependencies }
        { executables "" }
        { loadFirst "" }
        packagePath
        packageFile
        { id "" } 
        { versions "" }
        { imports "" }
        { exports "" }
    }

    Package @doc init {

        Saves the location of the package in packageFile and packagePath
    }

    Package instproc init { } {

        my requireNamespace
        my packageFile [ file tail [ info script ] ]
        my packagePath [ file dirname [ info script ] ]
        namespace eval [ self ]::test {

        }
    }

    Package instproc getID { } {

        my instvar id
        if { "" == "$id" } {

            return "Id:"
        }
        return [ string trim [ string range $id 1 end-1 ] ]
    }

    Package instproc version { { version "" } } {

        if { "" != "$version" } {
            return [ my set version $version ]
        }

        if [ my exists version ] {
            return [ my set version ]
        }

        my instvar id
        set version [ lindex $id 2 ]

        if { "" == "$version" } {

            return 1.0
        }

        return $version
    }

    Package instproc packageName { } {

        return [ string range [ self ] 2 end ]
    }

    Package instproc namespaceVariables { } {

        set nsVars [ my info vars ]
        set params [ ::xox::mapcar {

            lindex $param 0
            
        } param [ ::xox::Package info parameter ] ]

        lappend params #

        set nsVars [ ::xox::removeIf {

            expr { [ lsearch $params $var ] != -1 }

        } var $nsVars ]
    
        return $nsVars
    }

    Package instproc requireDependencies { } {

        foreach package [ my requires ] {

            if { [ my isobject ::${package} ] } continue

            #puts "Loading $package"

            if [ catch { 

                package require $package
            } ] {

                my lappend failedDependencies $package
            }
        }
    }

    Package instproc checkDependencies { } {

        my instvar failedDependencies

        if { ![ my exists failedDependencies ] } { return 1 }

        puts "Package [ self ] is missing these dependencies:"

        foreach failure $failedDependencies {

            puts "\t$failure"
        }

        return 0
    }

    Package instproc assertDependencies { } {

        if { ! [ my checkDependencies ] } {

            error "[ self ] dependencies failed"
        }
    }

    Package @doc load { 

        Forces a package to package require all of its
        sub-packages and calls package provide for this
        package. Package load does not load the test sub-package.
        This is loaded by Package loadAll.
    }

    Package instproc declarePackage { } {

        my instvar imports exports

        my requireDependencies
        my checkDependencies

        #my debug "Loading [ self ]"

        set packageName [ my packageName ]

        ##puts "Loading: $packageName"

        package provide $packageName [ my version ]
        #puts "Provide: $packageName 1.0"
        namespace eval ::${packageName} {
            namespace import -force ::xotcl::*
        }
        foreach import $imports {
            namespace eval ::${packageName} "
                namespace import -force $import
            "
        }
        foreach export $exports {
            namespace eval ::${packageName} "
                namespace export $export
            "
        }
        #puts "Namespace: ::${packageName}"

        namespace eval ::${packageName}::test {
            namespace import -force ::xotcl::*
        }
        #puts "Namespace: ::${packageName}::test"
        foreach import $imports {
            namespace eval ::${packageName}::test "
                namespace import -force $import
            "
        }

    }

    Package instproc load { } {

        my declarePackage

        foreach class [ my loadFirst ] {

            #my debug "Loading: $class"

            my loadClass $class
        }

        my loadFiles [ concat [ my loadFirst ] CVS test ]
        #puts "Loaded [ my packageName ] [ my version ]"
    }

    Package @doc loadAll { 

        Forces a package to package require all of its
        sub-packages and calls package provide for this
        package. Package loadAll does load the test sub-package.
    }

    Package instproc loadAll { } {

        my instvar imports exports

        #my debug "[self] Imports: $imports"

        my requireDependencies
        my checkDependencies

        #my debug "Loading [ self ]"

        set packageName [ my packageName ]

        #my debug "Loading: $packageName"

        package provide $packageName [ my version ]
        package provide ${packageName}::test 1.0
        #puts "Provide: $packageName 1.0"
        namespace eval ::${packageName} {
            namespace import -force ::xotcl::*
        }
        foreach import $imports {
            namespace eval ::${packageName} "
                namespace import -force $import
            "
        }
        foreach export $exports {
            namespace eval ::${packageName} "
                namespace export $export
            "
        }
        #puts "Namespace: ::${packageName}"

        namespace eval ::${packageName}::test {
            namespace import -force ::xotcl::*
        }
        foreach import $imports {
            namespace eval ::${packageName} "
                namespace import -force $import
            "
        }
        #puts "Namespace: ::${packageName}::test"

        foreach class [ my loadFirst ] {

            #my debug "Loading: $class"

            my loadClass $class
        }

        my loadFiles [ my loadFirst ]
        #puts "Loaded all [ my packageName ] [ my version ]"

        #my debug "done"
    }

    Package instproc loadLib { } {

        my instvar packageName

        my declarePackage
        package provide [ my packageName ]::test 1.0

        set lib [ file join [ my packagePath ] lib ]
        set test [ file join [ my packagePath ] test ]

        foreach dir [ list $lib $test ] {

            if { [ file exists $dir ] && [ file isdirectory $dir ] } {

                foreach file [ glob -nocomplain [ file join $dir *.tcl ] ] {

                    my loadFile $file
                }
            }
        }

        #puts "Loaded lib [ my packageName ] [ my version ]"
    }

    Package instproc loadClass { class } {

        set package [ ::xox::Package getPackageObject $class ]
        my loadFile [ file join [ $package packagePath ] [ ::xox::Package getClassFile $class ] ]
    }

    Package proc getFullPathClass { class } {

        set package [ ::xox::Package getPackageObject $class ]
        return [ file join [ $package packagePath ] [ ::xox::Package getClassFile $class ] ]
    }

    Package @doc reload {

        Reload the package.
    }

    Package instproc reload { } {

        my debug "[ self ] reloading"

        my loadAll

        my debug "[ self ] reloaded all files"
    }

    Package instproc forgetAll { } {
        
        my debug "[ self ] forgetting all"

        set packageName [ my packageName ]

        set subs [ ::xox::removeIfNot { string match "${packageName}*" $name } name [ package names ] ]

        foreach sub $subs {

            my debug "forget $sub"

            package forget $sub
        }

        my debug "[ self ] forgot all"
    }

    Package instproc findPackages { } {

        catch { package require notapackage }
    }

    Package @doc export {


        Exports all the procedures defined on this package to a target namespace.
    }

    Package instproc export { namespace } {

        namespace eval $namespace {

            foreach proc [ my info procs ] {

                proc $proc { args } "
                    uplevel [ self ]::$proc \$args
                "
            }
        }
    }

    Package @doc import {

        Imports all the procedures defined on this package to the current namespace.
    }


    Package instproc import { } {

        namespace eval [ uplevel namespace current ] {

            foreach proc [ my info procs ] {

                proc $proc { args } "
                    uplevel [ self ]::$proc \$args
                "
            }
        }
    }

    Package @doc getPackageFromClass {

        A simple conversion method that produces the package name from a full class name.

        Package names are of the form:

        package::subpackage

        Whereas classes are of the form:

        ::package::subpackage::ClassName

        So this method deletes the leading colons and returns
        the namespace qualifiers on the class name.

        Example:

        ::xox::Package getPackageFromClass ::package::subpackage::ClassName 

        Returns:

        package::subpackage
    }

    Package proc getPackageFromClass { class } {

        set package [ namespace qualifiers $class ]

        if [ string match "::*" $package ] {

            set package [ string range $package 2 end ]
        }

        return $package
    }

    Package proc getClassFile { class } {

        regsub -all {::} $class { } path

        set package "::[ lindex $path 0 ]"

        if { ! [ my isobject $package ] } {

            error "Cannot find package $package"
        }

        set isClass 0
        set current $package

        set file ""

        foreach sub [ lrange $path 1 end-1 ] {

            if $isClass {
                set file "${file}::${sub}"
            } else {
                set file [ file join $file $sub ]
            }

            set current "${current}::${sub}"

            catch {
                if { ! [ my isobject $current ] } {
                    ::xox loadClass $current
                }
            }

            if { [ my isclass $current ] } {

                set isClass 1
            }
        }

        if $isClass {
            set file "${file}::[ lindex $path end ]"
        } else {
            set file [ file join $file [ lindex $path end ] ]
        }

        return "${file}.tcl"
    }

    Package proc getClassPackage { class } {

        if [ string match "::*" $class ] {

            set class [ string range $class 2 end ]
        }

        return $class
    }

    Package proc isPackage { package } {

        set found [ ::xox::removeIfNot { 
            string match "${package}" $name 
            } name [ package names ] ]

        return [ expr { "$found" != "" } ]
    }

    Package proc getMainPackage { packageName } {

        regsub -all {::} $packageName { } path

        #puts ">>>$packageName $path"

        return [ lindex $path 0 ]
    }

    Package proc getPackageObject { class } {

        set package [ my getMainPackage $class ]

        set packageObject ::${package}

        #puts ">>>$package $packageObject"

        if { ! [ my isobject $packageObject ] } { 

           catch { package require $package }
        }

        if { ! [ my isobject $packageObject ] } { 

            error "Could not find $package"
        }

        if { ! [ $packageObject hasclass ::xox::Package ] } {

            error "Could not find $package"
        }

        return $packageObject
    }

    Package @doc makeClass {

        Creates a new class file from the generic class template. Package makeClass
        will also create a unit test for this class in the test directory.

        See Also: ::xox::Package makeTest
    }

    Package @arg makeClass package { the package to create the class in. }
    Package @arg makeClass name {  the name of the class. }
    Package @arg makeClass superclass {  the superclass of the new class (OPTIONAL). }

    Package @example makeClass {

        makeClass abc Car  
        makeClass abc Ferrari ::abc::Car  
    }

    Package proc makeClass { package name { superclass ::xotcl::Object } } {

        global env

        package require [ my getMainPackage $package ]

        cd [ ::[ my getMainPackage $package ] packagePath ]

        regsub -all {::} $package { } path

        set path [ lrange $path 1 end ]

        set full [ eval file join $path $name.tcl ]

        set file [ open $full w ]
        puts "Writing $full"
        puts $file \
"# Created at [ clock format [ clock seconds ] ] by $env(USER)

namespace eval ::${package} {

    Class $name -superclass $superclass

    $name @doc $name {

        Please describe the class $name here.
    }

    $name parameter {

    }

    $name instproc someMethod { someArg } {

       #Please add some implementation here.
    }
}

"    

        flush $file
        close $file

        my makeTest [ my getMainPackage $package ] Test$name
    }

    Package @doc makeTest {

        Creates a new unit test file from the generic unit test template.
    }

    Package @arg makeTest package { the package to create the class in. }
    Package @arg makeTest name {  the name of the class. }
    Package @arg makeTest superclass {  the superclass of the new class (OPTIONAL). }

    Package @example makeTest {

        makeTest package TestClassName

        Will create a unit test: test/TestClassName.tcl
    }

    Package proc makeTest { package name {superclass ::xounit::TestCase}} {

        package require $package

        global env

        set pwd [ pwd ]

        set tail [ file tail $pwd ]

        if { "$tail" != "test" } { 

            set prefix "test/"
        } else {
            set prefix ""
        }

        set packageRequire [ my getPackageFromClass $superclass ]

        set file [ open ${prefix}${name}.tcl w ]
        puts "Writing ${prefix}$name.tcl"
        puts $file \
"# Created at [ clock format [ clock seconds ] ] by $env(USER)

namespace eval ::${package}::test {

    Class $name -superclass $superclass

    $name parameter {

    }

    $name instproc setUp { } {

        #add set up code here
    }

    $name instproc test { } {

        #implement test here
    }

    $name instproc tearDown { } {

        #add tear down code here
    }
}

"    

        flush $file
        close $file
    }

    Package @doc makePackage {

        Creates a new package directory, a pkgIndex.tcl file, a package.tcl file to
        package require the subpackages, and a test directory for unit tests. 

        Creates:

        ./packagename
        ./packagename/pkgIndex.tcl
        ./packagename/packagename.tcl
        ./packagename/test
    }

    Package @arg makePackage package { the name of the package to create. }

    Package @example makePackage {

        makePackage abc
    }

    Package proc makePackage { package } {

        global env

        file mkdir $package
        file mkdir [ file join $package test ]

        set file [ open [ file join $package $package.tcl ] w ]

        puts "Writing [ file join $package $package.tcl ]"
        puts $file \
"# Created at [ clock format [ clock seconds ] ] by $env(USER)

package require xotcllib

::xox::Package create ::${package}
::${package} loadAll
"
        flush $file
        close $file


        set file [ open [ file join $package test $package.tcl ] w ]

        puts "Writing $package/test/$package.tcl"
        puts $file \
"# Created at [ clock format [ clock seconds ] ] by $env(USER)
"

        flush $file
        close $file

        set pwd [ pwd ]

        cd $package
        my buildPkgIndex $package
        cd $pwd
    }

    Package @doc buildPkgIndex {

        Creates a new pkgIndex.tcl file for the package located in
        the current working directory. This method will create a pkgIndex.tcl
        file with one package ifneeded line for each .tcl file for all
        files in the current directory and its directory subdirectories. This
        only works for one subdirectory currently. It is not recursive yet.

        Arguments:

        package - the name of the package to index.

        Creates:

        ./pkgIndex.tcl
    }

    Package instproc buildPkgIndex { } {

        set pwd [ pwd ]

        cd [ my packagePath ]

        ::xox::Package buildPkgIndex [ my packageName ]

        cd $pwd
    }

    Package proc buildPkgIndex { package } {

        set version 1.0

        catch {
            catch { package require $package }
            set version [ ::${package} version ]
        }

        ::xox::withOpenFile pkgIndex.tcl w out {

        puts $out "package ifneeded ${package} $version \[list source \[file join \$dir ${package}.tcl \]\]"
        puts $out "package ifneeded ${package}::test 1.0 \[list source \[file join \$dir test ${package}.tcl \]\]"

        }
    }

    Package instproc loadTestFiles { } {

        set packageName [ my packageName ]

        set files ""

        set dir [ file join [ my packagePath ] test ]

        foreach file [ glob -nocomplain [ file join $dir *.tcl ] ] {

            set tail [ file tail $file ]

            if { "$tail" == "${packageName}.tcl" } continue
            if { "$tail" == "pkgIndex.tcl" } continue

            lappend files $file
        }

        foreach file $files {

            my loadFile $file
        }
    }

    Package instproc getFiles { { except "CVS" } } {

        set packageName [ my packageName ]

        set files ""

        foreach file [ glob -nocomplain [ file join [ my packagePath ] *.tcl ] ] {

            set tail [ file tail $file ]

            if { "$tail" == "${packageName}.tcl" } continue
            if { "$tail" == "pkgIndex.tcl" } continue

            lappend files $file
        }

        foreach dir [ glob -nocomplain -types d [ file join [ my packagePath ] * ] ] {
            set tail [ file tail $dir ]

            if { [ lsearch -exact $except $tail ] != -1 } { continue }

            foreach file [ glob -nocomplain [ file join $dir *.tcl ] ] {

                set tail [ file tail $file ]

                if { "$tail" == "${packageName}.tcl" } continue
                if { "$tail" == "pkgIndex.tcl" } continue

                lappend files $file
            }
        }

        return [ lsort $files ]
    }

    Package instproc loadFiles { { except "CVS" } } {

        foreach file [ my getFiles $except ] {

            my loadFile $file
        }
    }

    Package instproc loadFile { file } {

        #my debug "loading $file"
        uplevel #0 source $file
    }

    Package proc buildSuperPkgIndex { } {

        ::xox::withOpenFile pkgIndex.tcl w file {

            puts $file {
foreach dir [ glob -nocomplain -types d [ file join $dir * ] ] {
    if {[file exists [file join $dir pkgIndex.tcl]]} {
        source [file join $dir pkgIndex.tcl]
    } 
} 
            }
        }
    }

    Package @doc makeTcl {

        Creates a new plain-old Tcl file in a package.
    }

    Package @arg makeTcl package { The package to create the Tcl file in.}
    Package @arg makeTcl name { The name of the Tcl file without the .tcl extension.}

    Package @example makeTcl {

        makeTcl abc ATclLibrary
    }

    Package proc makeTcl { package name } {

        global env

        package require $package

        regsub -all {::} $package { } path

        set path [ lrange $path 1 end ]

        set full [ eval file join $path $name.tcl ]

        set file [ open $full w ]
        puts "Writing $full"
        puts $file \
"# Created at [ clock format [ clock seconds ] ] by $env(USER)

namespace eval ::${package} {

}

"    
        flush $file
        close $file

        my makeTest [ my getMainPackage $package ] Test$name
    }

    Package proc loadMainPackage { object } {

        set mainPackage [ my getMainPackage $object ]

        if [ my isobject "::${mainPackage}" ] { return }

        package require $mainPackage
    }

    Package proc getAllPackageNames {  } {

        set names ""

        foreach package [ ::xox::Package info instances ] {

            if [ string match ::* $package ] {

                lappend names [ string range $package 2 end ]
            } else {
                lappend names $package
            }
        }

        return $names

    }
}

