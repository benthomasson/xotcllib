
namespace eval ::xode {

    ::xodsl::LanguageClass create XodeLanguage -superclass ::xodsl::Language

    XodeLanguage instmixin add ::xox::NotGarbageCollectable

    XodeLanguage @doc XodeLanguage {

        Please describe the class XodeLanguage here.
    }

    XodeLanguage parameter {

    }

    XodeLanguage @@doc load {

        Purpose: Loads a package.

        Arguments: {
            package The package name to load.
        }

        Example: {
            load xounit
        }

        Tags: xode
    }


    XodeLanguage instproc load { package } {

        package require $package

        ::${package} load
    }

    XodeLanguage @@doc loadAll {

        Purpose: Loads a package and all subpackages.

        Arguments: {
            package The package name to load.
        }

        Example: {
            loadAll xounit
        }

        Tags: xode
    }

    XodeLanguage instproc loadAll { package } {

        package require $package

        ::${package} loadAll
    }

    XodeLanguage @@doc loadLib {

        Purpose: Loads a package and its lib subpackage.

        Arguments: {
            package The package name to load.
        }

        Example: {
            loadLib xounit
        }

        Tags: xode
    }

    XodeLanguage instproc loadLib { package } {

        package require $package

        ::${package} loadLib
    }

    XodeLanguage @@doc loadTest {

        Purpose: Loads a package and its test subpackage.

        Arguments: {
            package The package name to load.
        }

        Example: {
            loadTest xounit
        }


        Tags: xode
    }

    XodeLanguage instproc loadTest { package } {

        package require $package

        ::${package} loadTestFiles
    }

    XodeLanguage @@doc reload {

        Purpose: Reloads a package.

        Arguments: { 
            package The package to reload.
        }

        Example: {
            reload xounit
        }

        Tags: xode
    }

    XodeLanguage instproc reload { package } {

        package require $package
        ::${package} reload
    }

    XodeLanguage instproc getValues@reload@package { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage @@doc runTests {

        Purpose: Runs all xounit tests in a packge.

        Arguments: { 
            args A list of packages
        }

        Example: {
            runTests xounit xoexception xox
        }

        Tags: xode
    }

    XodeLanguage instproc runTests { args } {

        foreach package $args {

            my reload $package
        }
        
        eval ::xounit::RunTests new $args
    }

    XodeLanguage instproc getValues@runTests@args { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage @@doc runTest {

        Purpose: Runs all xounit tests in one test class in a package.

        Arguments: {
            package A package to load
            args A list of test classes to run
        }

        Example: {
            runTest xounit TestAssert
        }

        Tags: xode
    }

    XodeLanguage instproc runTest { package args } {

        my reload $package
        eval [ list ::xounit::RunTest new $package ] $args
    }

    XodeLanguage instproc getValues@runTest@package { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage instproc getValues@runTest@args { package args } {
        return [ ::xounit::TestCase findAllTestNames ${package} ]
    }

    XodeLanguage @@doc runATest {

        Purpose: Runs a single xounit test method in one test class in a package.

        Arguments: {
            package A package to load
            class A test class
            method A test method to run
        }

        Example: {
            runTest xounit TestAssert testAssert0
        }

        Tags: xode
    }

    XodeLanguage instproc runATest { package class method } {

        my reload $package
        ::xounit::RunATest new $package $class $method
    }

    XodeLanguage instproc getValues@runATest@package { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage instproc getValues@runATest@class { package args } {
        return [ ::xounit::TestCase findAllTestNames ${package} ]
    }

    XodeLanguage instproc getValues@runATest@method { package class args } {
        return [ ::${package}::test::${class} info instprocs test* ]
    }

    XodeLanguage @@doc runSuite {

        Purpose: Runs a suite of tests.

        Arguments: {
            suiteFile A suite file to run.
        }

        Example: {
            runSuite XOTclLib.xml
        }

        Tags: xode
    }

    XodeLanguage instproc runSuite { suiteFile } {

        ::xounit::RunSuite new $suiteFile
    }

    XodeLanguage instproc getValues@runSuite@args { } {

        return [ glob -nocomplain *.xml ]
    }

    XodeLanguage @@doc printResultsFile {

        Purpose: Prints the results file testResults.xml

        Example: {
            printResultsFile
        }

        Tags: xode
    }

    XodeLanguage instproc printResultsFile { } {

        ::xounit::PrintResults new 
    }

    XodeLanguage @@doc inspectVariables {

        Purpose: Inspects an the variables on an object.

        Arguments: {
            object Inspect this object
            varPattern Select variables that match this pattern
        }

        Example: {
            
            inspectVariables ::xotcl::__#0o
        }

        Tags: xode
    }

    XodeLanguage instproc inspectVariables { -novalues:switch } { object { varPattern * } } {

        if { ! [ my isobject $object ] } {
            puts "Not an object"
            return
        }

        if { "" != [ $object info vars ] } { puts "Variables matching $varPattern " }
        foreach var [ $object info vars ] {
            if { ! [ string match $varPattern $var ] } { continue }
            if [ $object array exists $var ] {
                puts -nonewline "\t$var"
                if { ! $novalues } { puts ": [ $object array get $var]" } else { puts "" } 
            } else {
                puts -nonewline "\t$var"
                if { ! $novalues } { puts ": [ $object set $var ]" } else { puts "" }
            }
        }
    }

    XodeLanguage @@doc inspectProcs {

        Purpose: Inspects an the procedures on an object.

        Arguments: {
            object Inspect this object
            procPattern Select procedures that match this pattern
        }

        Example: {
            
            inspectProcs ::xotcl::__#0o
        }

        Tags: xode
    }

    XodeLanguage instproc inspectProcs { -nobody:switch } { object { procPattern * } } {

        if { ! [ my isobject $object ] } {
            puts "Not an object"
            return
        }
    }

    XodeLanguage @@doc inspect {

        Purpose: Inspects an object.

        Arguments: {
            object Inspect this object
            varPattern Select variables that match this pattern
            procPattern Select procedures that match this pattern
        }

        Example: {
            
            inspect ::xotcl::__#0o
        }

        Tags: xode
    }

    XodeLanguage instproc inspect { -novalues:switch -nobody:switch } { object { varPattern * } { procPattern * } } {

        if { ! [ my isobject $object ] } {
            puts "Not an object"
            return
        }

        if { [ my isclass $object ] } {

            puts "Class: [ $object info class ] $object"

            if $novalues {
                my inspectVariables -novalues $object $varPattern
            } else {
                my inspectVariables $object $varPattern
            }

            if $nobody {
                my inspectProcs -nobody $object $procPattern
            } else {
                my inspectProcs $object $procPattern
            }
           
        } else {

            puts "Object: [ $object info class ] $object"

            if $novalues {
                my inspectVariables -novalues $object $varPattern
            } else {
                my inspectVariables $object $varPattern
            }

            if $nobody {
                my inspectProcs -nobody $object $procPattern
            } else {
                my inspectProcs $object $procPattern
            }
        }
    }

    XodeLanguage @@doc objects {

        Purpose: Prints a list of objects that start with a prefix.

        Arguments: {
            namespace Select objects by a certain namespace.
        }

        Example: {
            objects ::xox
        }

        Tags: xode
    }

    XodeLanguage instproc objects { { namespace "" } } {

        foreach instance [ ::xox::ObjectGraph findAllInstances ::xotcl::Object $namespace ] {

            puts $instance
        }
    }

    XodeLanguage @@doc instances {

        Purpose: Prints a list of instances of a class.

        Arguments: {
            class Find the instances of this class.
            namespace Select instances by a certain namespace.
        }

        Example: {
            instances ::xotcl::Object ::xox
        }

        Tags: xode
    }

    XodeLanguage instproc instances { class { namespace "" } } {

        foreach instance [ ::xox::ObjectGraph findAllInstances $class $namespace ] {

            puts $instance
        }
    }

    XodeLanguage @@doc ls {

        Purpose: Lists the current directory.

        Arguments: {
            args ls arguments
        }

        Example: {
            ls -la
        }

        Tags: xode
    }

    XodeLanguage instproc ls { args } {

        eval exec ls $args
    }

    XodeLanguage instproc getValues@ls@args { args } {

        return [ glob -nocomplain * ]
    }

    XodeLanguage @@doc vi {

        Purpose: Open the VIM editor.

        Arguments: {
            args VIM Arguments
        }

        Example: {
            vim
        }

        Tags: xode
    }

    XodeLanguage instproc vi { args } {

        eval my vim $args
    }

    XodeLanguage @@doc vim {

        Purpose: Open the VIM editor.

        Arguments: {
            args VIM Arguments
        }

        Example: {
            vim
        }

        Tags: xode
    }

    XodeLanguage instproc vim { args } {

        package require Expect
        spawn -noecho vim $args
        interact
    }

    XodeLanguage instproc getValues@vim@args { args } {

        return [ glob -nocomplain * ]
    }

    XodeLanguage @@doc packages {

        Purpose: Prints a list of XOTcl packages.

        Arguments: {
            pattern A pattern to use to match packages.
        }

        Example: {
            tclPackages xo*
        }

        Tags: xode
    }

    XodeLanguage instproc packages { {pattern *} } {

        foreach package [ ::xox::ObjectGraph findAllInstances ::xox::Package ] {

            set package [ string range $package 2 end ]

            if { ! [ string match $pattern $package ] } continue
            puts $package
        }
    }

    XodeLanguage @@doc tclPackages {

        Purpose: Prints a list of Tcl packages.

        Arguments: {
            pattern A pattern to use to match packages.
        }

        Example: {
            tclPackages xo*
        }

        Tags: xode
    }

    XodeLanguage instproc tclPackages { {pattern *} } {

        foreach package [ lsort [ package names ] ]  {

            if { ! [ string match $pattern $package ] } continue
            puts $package
        }
    }

    XodeLanguage @@doc destroyAllTemporaryObjects {

        Purpose: Destroys all temporary objects.

        Example: {

            destroyAllTemporaryObjects
        }

        Tags: xode
    }

    XodeLanguage instproc destroyAllTemporaryObjects { } {

        ::xox::GarbageCollector destroyAllTemporaryObjects
    }

    XodeLanguage @@doc cvs {

        Purpose: Runs a CVS command.

        Arguments: {
            subcommand A cvs subcommand.
            args The arguments to the cvs subcommand.
        }

        Example: {
            cvs update
            cvs commit -m "a message" x.tcl
        }

        Tags: xode
    }

    XodeLanguage instproc cvs { subcommand args } {

        catch {
            eval exec cvs $subcommand $args >&@ stdout
        }
    }

    XodeLanguage instproc getValues@cvs@subcommand { args } {

        return [ list add commit update diff ]
    }

    XodeLanguage instproc getValues@cvs@args { args } {

        return [ glob -nocomplain * ]
    }

    XodeLanguage @@doc getCommands {

        Purpose: Gets the commands for Xode.
    }

    XodeLanguage instproc getCommands { } {

        return [ ::xode::XodeLanguage getTagged xode ]
    }

    XodeLanguage @@doc makeClass {

        Purpose: Makes a new XOTcl class file.

        Arguments: {
            package The main package where the class will reside.
            name The name of the class.
            superclass The superclass of the new class.
        }

        Example: { 

            makeTest abc TestABC
        }

        Tags: xode
    }

    XodeLanguage instproc makeClass { package name { superclass ::xotcl::Object } } {

        ::xox::Package makeClass $package $name $superclass
    }

    XodeLanguage instproc getValues@makeClass@package { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage @@doc makeTest {

        Purpose: Makes a new XOTcl test class file.

        Arguments: {
            package The main package where the test will reside.
            name The name of the test class.
        }

        Example: { 

            makeTest abc TestABC
        }

        Tags: xode
    }

    XodeLanguage instproc makeTest { package name } {

        ::xox::Package makeTest $package $name
    }

    XodeLanguage instproc getValues@makeTest@package { args } {
        return [ ::xox::Package getAllPackageNames ]
    }

    XodeLanguage @@doc makePackage {

        Purpose: { 

            Creates a new package directory, a pkgIndex.tcl file, a package.tcl file to
            package require the subpackages, and a test directory for unit tests. 

            Creates:

            ./packagename
            ./packagename/pkgIndex.tcl
            ./packagename/packagename.tcl
            ./packagename/test
        }

        Arguments: {
            package
        }

        Example: {

            makePackage abc
        }

        Tags: xode
    }

    XodeLanguage instproc makePackage { package } {

        ::xox::Package makePackage $package
    }

    XodeLanguage @@doc cd {

        Purpose: Change directory

        Arguments: {
            directory The name of the directory to change to.
        }

        Example: {

            cd
            cd /tmp
        }

        Tags: xode
    }

    XodeLanguage instproc cd { { directory "" } } {

        if { "" == "$directory" } {
            
            catch {
                set directory /
                set directory $::env(HOME)
            }
        }

        if { [ my isobject $directory ] && [ $directory hasclass ::xox::Package ] } {

            cd [ $directory packagePath ]
        } else {
            ::cd $directory
        }
    }

    XodeLanguage instproc getValues@cd@directory { args } {

        return [ concat [ glob -nocomplain * ] [ ::xox::Package getAllPackageNames ] ]
    }

    XodeLanguage @@doc editObject {

        Tags: xode
    }

    XodeLanguage instproc editObject { object } {

        [ ::xode::ObjectEditor getInstance ] edit $object
    }

    XodeLanguage instproc getValues@editObject@object { args } {

        return [ ::xox::ObjectGraph findAllInstances ::xotcl::Object ]
    }

    XodeLanguage @@doc git {

        Purpose: Runs a Git command.

        Arguments: {
            subcommand A git subcommand.
            args The arguments to the git subcommand.
        }

        Example: {
            git pull
            git commit -a -m "a message"
        }

        Tags: xode
    }

    XodeLanguage instproc git { subcommand args } {

        catch {
            eval exec git $subcommand $args >&@ stdout
        }
    }

    XodeLanguage instproc getValues@git@subcommand { args } {

        return [ list add bisect branch checkout clone commit diff fetch grep init log merge mv pull push rebase reset rm show status tag ]
    }
}


