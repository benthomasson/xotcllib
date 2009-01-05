namespace eval ::xoide {

    Class XOTclShell

    XOTclShell parameter {
        console
        text
        { history "" }
        script
        currentCommand
        { objectIndex 0 }
        { classIndex 0 }
        { errorIndex 0 }
        inspectWindow
        popupMenu
        { popupIndex 0 }
        inspectCommand
        currentFileName
        packageDoc
        { root "" }
    }

    XOTclShell proc newWindow { } {

        set tclShell [ ::xoide::XOTclShell new -root ".[ my autoname window ]" ]
        $tclShell show
    }

    XOTclShell instproc init { } {

        package require Tk
        tk_setPalette gray
    }

    XOTclShell instproc prompt { } {

        my instvar history
        return "xotcl [ llength $history ]>"
    }

    XOTclShell instproc getRoot { } {

        my instvar root

        if { "" == "$root" } {

            return "."
        }

        return $root
    }

    XOTclShell instproc show { } {

        my instvar prompt text script console popupMenu packageDoc root

        catch { toplevel [ my getRoot ] }

        wm minsize [ my getRoot ] 30 5
        my updateTitle

        set popupMenu [ menu ${root}.popupMenu -tearoff 0 ]

        set menubar [ menu ${root}.menubar -tearoff 0 ]
        [ my getRoot ] configure -menu $menubar
        foreach m { File Exec Doc } {
            set $m [ menu $menubar.m$m -tearoff 0 ]
            $menubar add cascade -label $m -menu $menubar.m$m
        }
        $File add command -label "New         Ctrl-N" -command "::xoide::XOTclShell newWindow"
        $File add command -label "Open        Ctrl-O" -command "[self] openScript"
        $File add command -label "Save        Ctrl-S" -command "[self] saveScript"
        $File add command -label "Save As" -command "[self] saveScriptAs"
        if { $root != "" } {
            $File add command -label "Close       Ctrl-W" -command "[self] closeWindow"
        }
        $File add command -label "Quit        Ctrl-Q" -command exit

        $Exec add command -label "Run         Ctrl-Enter" -command "[ self ] executeScript"
        #$Exec add command -label "Reset" -command "[ self ] resetEnvrionment"
        set packageDoc [ menu $Doc.package -tearoff 0 ]
        $Doc add command -label "Help"
        $Doc add cascade -label "Packages" -menu $packageDoc

        set pane [ panedwindow ${root}.p -orient vertical -showhandle 1 ]
        pack $pane -expand yes -fill both

        set frame [ frame $pane.frame ]

        set st [ ::xoide::Shell new -name $frame.eval ]
        set st2 [ ::xoide::Script new -name $frame.history ]
        set st3 [ ::xoide::Console new -name $pane.console ]

        set text [ $st text ]
        set script [ $st2 script ]
        set console [ $st3 console ]

        pack $frame.eval $frame.history -fill both -expand true -side left

        $pane add $frame $pane.console 

        bind [ my getRoot ] <Control-Key> "
            #Control-W
            if { %k == 25 } {

                [ self ] closeWindow
                break
            }
            #Control-N
            if { %k == 57 } {

                ::xoide::XOTclShell newWindow
                break
            }
            #Control-O
            if { %k == 32 } {

                [ self ] openScript
                break
            }
            #Control-S
            if { %k == 39 } {

                [ self ] saveScript
                break
            }
            #Control-Q
            if { %k == 24 } {

                exit
                break
            }
            #Control-Enter
            if { %k == 36 } {

                [ self ] executeScript
                break
            }
        "

        my updatePackageDoc
    }

    XOTclShell instproc updatePackageDoc { } {

        my instvar packageDoc

        set packages [ ::xox::Package info instances ] 

        $packageDoc delete 0 end

        foreach package [ lsort -dictionary $packages ] {

            $packageDoc add command -label $package -command "[self] inspectPackage $package"
        }
    }

    XOTclShell instproc closeWindow { } {

        my instvar root

        if { "" == "$root" } { return }
        destroy $root
    }

    XOTclShell instproc newScript { } {

        my instvar text history console script 

        set history ""
        catch { my unset currentFileName }
        $text delete 1.0 end
        $console delete 1.0 end
        $script delete 1.0 end
        my insertPrompt
        my updateTitle
    }

    XOTclShell instproc openScript { } {

        my instvar history

        set filename [ tk_getOpenFile ]
        if { "$filename" == "" } { return }
        my newScript
        my openFile $filename

    }

    XOTclShell instproc updateTitle { } {

        my instvar currentFileName 

        if [ my exists currentFileName ] {
            wm title [ my getRoot ] "XOTcl Shell - $currentFileName"
        } else {
            wm title [ my getRoot ] "XOTcl Shell - New"
        }
    }

    XOTclShell instproc openFile { filename } {

        my instvar script currentFileName

        my set currentFileName $filename
        my updateTitle

        $script delete 1.0 end

        set file [ open $filename ]
        set code [ read $file ]
        close $file

        $script insert insert $code
    }

    XOTclShell instproc saveScriptAs { } {

        my instvar script currentFileName 

        set code [ $script get 1.0 end ]

        set filename [ tk_getSaveFile ]
        if { "$filename" == "" } { return }

        my set currentFileName $filename
        my updateTitle

        set file [ open $filename w ]
        puts $file $code
        flush $file
        close $file
    }

    XOTclShell instproc saveScript { } {

        my instvar script currentFileName 

        set code [ $script get 1.0 end ]

        if { ! [ my exists currentFileName ] } {

        set filename [ tk_getSaveFile ]
        if { "$filename" == "" } { return }

        my set currentFileName $filename
        my updateTitle

        } else {
            set filename $currentFileName
        }

        set file [ open $filename w ]
        puts $file $code
        flush $file
        close $file
    }

    XOTclShell instproc executeScript { } {

        my instvar script text console

        $text delete 1.0 end
        $console delete 1.0 end

        set code [ $script get 1.0 end ]

        my history ""
        my updateScript

        foreach line [ split $code "\n" ] {

            my insertPrompt
            my insertCommand $line
            my runACommand $line
        }
        my insertPrompt
        return
    }

    XOTclShell instproc insertCommand { command } {

        my instvar text

        $text insert end "$command\n"
        $text mark set limit insert
    }

    XOTclShell instproc updateScript { } {

        my instvar history script

        set buffer ""

        foreach line $history {

            append buffer "$line\n"
        } 

        $script delete 1.0 end 

        $script insert insert $buffer
    }

    XOTclShell instproc viewHistory { } {

        my instvar history 
        set history [ lrange $history 0 end-1 ]

        my updateScript

        return [ join $history "\n" ]
    }

    XOTclShell instproc removeLastLine { } {

        my instvar history 
        set history [ lrange $history 0 end-2 ]

        my updateScript

        return [ join $history "\n" ]
    }

    XOTclShell instproc putsAlias { args } {

        my instvar console

        if {[ llength $args] > 3 } {
            error "invalid arguments"
        }
        set newline "\n"
        if {[ string match "-nonewline" [ lindex $args 0 ]] } {
            set newline ""
            set args [lreplace $args 0 0 ]
        }
        if { [llength $args] == 1 } {
            set chan stdout
            set string [ lindex $args 0 ]$newline
        } else {
            set chan [ lindex $args 0 ]
            set string [ lindex $args 1 ]$newline
        }
        if [ regexp (stdout|stderr) $chan] {
            $console insert insert $string output
            $console see insert
        } else {
            puts -nonewline $chan $string
        }
    }

    XOTclShell instproc evalTypeIn { } {

        my instvar text 

        $text insert insert \n
        set command [ $text get limit end ]
        $text mark set limit insert

        my runACommand $command
        my insertPrompt
        return
    }


    XOTclShell instproc runACommand { command } {

        my instvar currentCommand

        my lappend history [ string trimright $command ]
        my updateScript
        my append currentCommand "[ string trimright $command ]\n"
        
        if [ info complete $currentCommand ] {
            my Eval $currentCommand
            catch { my unset currentCommand }
        } 
    }

    XOTclShell instproc insertPrompt { } {

        my instvar text
        $text insert insert [ my prompt ] prompt
        $text see insert
        $text mark set limit insert
    }

    XOTclShell instproc Eval { command } {

        my instvar text objectIndex classIndex errorIndex popupMenu

        if { [ string first "package require" $command ] != -1 } {

            catch { eval $command }
            my updatePackageDoc
        }

        $text mark set insert end
        if [catch { uplevel #0 $command } result] {
            global errorInfo
            my set errors($errorIndex) $errorInfo
            $text tag bind inspectError$errorIndex <Double-1> [ list [ self ] inspectError $errorIndex $result ]
            $text insert insert $result [ list error inspectError$errorIndex ]
            my incr errorIndex
        } elseif [ Object isclass $result ] {
            $text tag bind inspect$result <Double-1> "[ self ] inspectClass $result"
            $text tag bind inspect$result <ButtonPress-2> "[ self ] classPopup $result; tk_popup $popupMenu %X %Y"
            $text insert insert $result [ list class inspect$result ]
        } elseif [ Object isobject $result ] {
            $text tag bind inspect$result <Double-1> "[ self ] inspectObject $result"
            $text tag bind inspect$result <ButtonPress-2> "[ self ] objectPopup $result; tk_popup $popupMenu %X %Y"
            $text tag bind inspect$result <ButtonPress-2> "[ self ] objectPopup $result; tk_popup $popupMenu %X %Y"
            $text insert insert $result [ list object inspect$result ]
        } else {
            $text insert insert $result result
        }

        if {[$text compare insert != "insert linestart"]} {
            $text insert insert \n
        }
        return
    }

    XOTclShell instproc makePopup { } {
        
        my instvar popupMenu popupIndex

        $popupMenu delete 0 end 
        my set popupIndex 0

        foreach child [ winfo children $popupMenu  ] {

            destroy $child
        }
    }

    XOTclShell instproc addPopupMenu { name } {

        my instvar popupMenu popupIndex

        set menu [ menu $popupMenu.$popupIndex -tearoff 0 ]

        $popupMenu add cascade -label $name -menu $menu

        my incr popupIndex

        return $menu
    }

    XOTclShell instproc consolePopup { } {

        my instvar popupMenu

        my makePopup

        $popupMenu add command -label "Clear" -command "[ self ] clearConsole"
    }

    XOTclShell instproc clearConsole { } {

        my instvar console 

        $console delete 1.0 end
    }

    XOTclShell instproc editPopup { } {

        my instvar popupMenu

        my makePopup

        set insertMenu [ my addPopupMenu Insert ]
        $insertMenu add command -label "#" -command "[ self ] insertScript {#\n#\n#}"
        $insertMenu add command -label "if" -command "[ self ] insertScript {if { } {\n    \n}}"
        $insertMenu add command -label "for" -command "[ self ] insertScript {for {set loop 0} {\$loop < \$limit} {incr loop} {\n    \n}}"
        $insertMenu add command -label "foreach" -command "[ self ] insertScript {foreach item \$list {\n    \n}}"
        $insertMenu add command -label "catch" -command "[ self ] insertScript {if \[ catch {\n    \n} result \] {\n    \n}}"
        $insertMenu add command -label "while" -command "[ self ] insertScript {while { ! \$done } {\n    \n}}"
        $insertMenu add command -label "switch" -command "[ self ] insertScript {switch \$switch {\n    case1 { }\n    case2 { }\n    default {}\n}}"
        $insertMenu add command -label "list" -command "[ self ] insertScript {set list \[ list a b c \]}"
        $insertMenu add command -label "proc" -command "[ self ] insertScript {#\n#\n#\nproc someProc { someArg } {\n\n\n}\n }"
    }

    XOTclShell instproc classPopup { class } {

        my instvar popupMenu

        if {![ Object isclass $class ]} { return }

        my makePopup
        $popupMenu add command -label Inspect -command "puts $class"
    }

    XOTclShell instproc objectPopup { object } {

        my instvar popupMenu 

        if {![ Object isobject $object ]} { return }

        my makePopup

        set inspectMenu [ my addPopupMenu Inspect ]
        set childrenMenu [ my addPopupMenu Children ]
        set assertMenu [ my addPopupMenu Assert ]
        set testMenu [ my addPopupMenu Test ]
        set actionMenu [ my addPopupMenu Action ]
        set methodMenu [ my addPopupMenu Method ]

        $inspectMenu add command -label "?" -command "[ self ] insertRunCommand {$object ? $object}"

        foreach var [ lsort -dictionary [ $object info vars ] ] {

            catch {
                $inspectMenu add command -label "$var" -command "[ self ] insertEdit {${object} set $var}"
                set methodsUsed($var) 1
            }
        }

        foreach child [ lsort -dictionary [ $object info children ] ] {

            catch {
                $childrenMenu add command -label "$child" -command "[ self ] insertEdit $child"
            }
        }

        foreach method [ lsort -dictionary [ $object info methods assert* ]  ] {

            catch {
                $assertMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            }
        }

        foreach method [ lsort -dictionary [ $object info methods test* ]  ] {

            catch {
                $testMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            }
        }

        foreach method [ lsort -dictionary [ $object info methods ]  ] {

            catch {
                set class [ ::xox::ObjectGraph findFirstImplementationClass $object $method ]
                if { [ $class info instargs $method ] != "" } { continue }
                $actionMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
                set methodsUsed($method) 1
            } 
        }

        foreach method [ lsort -dictionary [ $object info methods ]  ] {

            if [ info exists methodsUsed($method) ] { continue }

            catch {
                $methodMenu add command -label "$method" -command "[ self ] insertMethod $object $method"
            }
        }
    }

    XOTclShell instproc createDialog { name title } {

        my instvar root

        catch { toplevel $root.$name }
        wm title $root.$name $title
        return $root.$name
    }

    XOTclShell instproc insertMethodButton { button dialog object method } {

        my instvar insertMethodButton

        set class [ ::xox::ObjectGraph findFirstImplementationClass $object $method ]

        my set insertMethodButton $button

        foreach arg [ $class info instargs $method ] {

            set value [ $dialog.e$arg get ]
            my set insertMethodArgs($arg) $value
        }
        
        destroy $dialog
    }

    XOTclShell instproc insertMethod { object method } {

        my instvar insertMethodButton

        set class [ ::xox::ObjectGraph findFirstImplementationClass $object $method ]

        set bufferArgs ""
        catch { my unset insertMethodArgs }

        catch {
        foreach arg [ $class info instargs $method ] {

            append bufferArgs "<$arg> "
        }
        }

        set dialog [ my createDialog insertMethod "$object $method" ]
        set stDoc [ ScrolledText new $dialog.doc -width 60 -height 10 ]
        set doc [ $stDoc text ]
        $doc insert insert [ $class get# $method ]
        label $dialog.msg -text "$class $method $bufferArgs"
        bind $dialog.msg <1> "[self] inspectMethod $class $method"
        set list [ list $dialog.msg $dialog.doc ]
        catch {
            foreach arg [ $class info instargs $method ] {

                set arg$arg "<$arg>"

                lappend list [ entry $dialog.e$arg -textvariable arg$arg ]
                $dialog.e$arg delete 0 end
                $dialog.e$arg insert insert "<$arg>"
            }
        }
        eval pack $list -fill x -expand true
        set buttons [ frame $dialog.buttons ]
        pack $buttons
        button $buttons.run -text Run -command "[self] insertMethodButton Run $dialog $object $method"
        button $buttons.insert -text Insert -command "[self] insertMethodButton Insert $dialog $object $method"
        button $buttons.cancel -text Cancel -command "[self] insertMethodButton Cancel $dialog $object $method"
        pack $buttons.run $buttons.insert $buttons.cancel -side left
        set insertMethodButton ""
        tkwait window $dialog

        set bufferArgs ""

        if [ my array exists insertMethodArgs ] {
        foreach arg [ $class info instargs $method ] {

            append bufferArgs "[ my set insertMethodArgs($arg) ] "
        }
        }

        switch $insertMethodButton {

            Run { my insertEdit "$object $method $bufferArgs" ; my evalTypeIn }
            Insert { my insertEdit "$object $method $bufferArgs" }
            Cancel { } 
        }
    }

    XOTclShell instproc insertEdit { command } {

        my instvar script text

        $text insert end "$command"
    }

    XOTclShell instproc insertScript { command } {

        my instvar script 

        $script insert insert "$command"
    }

    XOTclShell instproc insertRunCommand { command } {

        my insertCommand "$command"
        my runACommand $command
        my insertPrompt
    }

    XOTclShell instproc inspectError { index result } {

        my instvar inspectWindow error root

        my inspectCommand [ list [ self ] inspectError $index $result ]

        ::xoide::ErrorInspector new -name ${root}.inspect \
                                    -result $result \
                                    -index $index
    }

    XOTclShell instproc inspectPackage { package } {
        
        my instvar inspectWindow root

        ::xoide::PackageInspector new -name ${root}.inspect \
                                      -package $package \
                                      -application [ self ]
    }

    XOTclShell instproc inspectClass { class } {

        my instvar inspectWindow root

        my inspectCommand [ list [ self ] inspectClass $class ]

        ::xoide::ClassInspector new -name ${root}.inspect \
                                    -inspectClass $class \
                                    -application [ self ]
    }

    XOTclShell instproc inspectMethod { class method } {

        my instvar inspectWindow root

        ::xoide::MethodInspector new -name ${root}.inspect \
                                     -inspectClass $class \
                                     -method $method \
                                     -application [ self ]
    }

    XOTclShell instproc inspectObject { object } {
        
        my instvar inspectWindow root

        ::xoide::ObjectInspector new -name ${root}.inspect \
                                    -object $object \
                                    -application [ self ]
    }

    XOTclShell instproc resetEnvrionment { } {

        my instvar text console history 

        $text delete 1.0 end
        $console delete 1.0 end

        my updateScript
        my insertPrompt

        return
    }
}
