
namespace eval ::xoserialize::test { 

Class create TestSerializer -superclass { ::xounit::TestCase }
  
TestSerializer @doc TestSerializer {
Please describe TestSerializer here.
}
       
TestSerializer parameter {

} 
        

TestSerializer @doc NOtestSerializeCommands { 
NOtestSerializeCommands does ...
}

TestSerializer instproc NOtestSerializeCommands {  } {
        set anObj [ Object new ]

        $anObj parametercmd v

        $anObj v 1

        my assertEquals [ $anObj v ] 1 "Pre"

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj v ] 1 "Post"
    
}


TestSerializer @doc destroyAndRecreateAssociates { 
destroyAndRecreateAssociates does ...
            anObj -
}

TestSerializer instproc destroyAndRecreateAssociates { anObj } {
        set serializer [ ::xoserialize::Serializer new ]
        
        my assertTrue [ Object isobject $anObj ] "$anObj should exist"
        
        set serial [ $serializer serializeAssociates $anObj ]

        my destroyAssociates $serializer $anObj 

        $serializer deserialize $serial 
        my assertTrue [ Object isobject $anObj ] "$anObj should be back"
    
}


TestSerializer @doc destroyAndRecreateClass { 
destroyAndRecreateClass does ...
            class -
}

TestSerializer instproc destroyAndRecreateClass { class } {
        set serializer [ ::xoserialize::Serializer new ]
        
        my assertTrue [ Object isobject $class ] "$class should exist"
        my assertTrue [ Object isclass $class ] 
        
        set serial [ $serializer serializeClass $class ]

        $class destroy
        my assertFalse [ Object isobject $class ] "$class should have been destroyed"
        my assertFalse [ Object isclass $class ] 

        $serializer deserialize $serial 
        my assertTrue [ Object isobject $class ] "$class should be back"
        my assertTrue [ Object isclass $class ] 
    
}


TestSerializer @doc destroyAndRecreateObject { 
destroyAndRecreateObject does ...
            anObj -
}

TestSerializer instproc destroyAndRecreateObject { anObj } {
        set serializer [ ::xoserialize::Serializer new ]
        
        my assertTrue [ Object isobject $anObj ] "$anObj should exist"
        
        set serial [ $serializer serializeObject $anObj ]

        $anObj destroy
        my assertFalse [ Object isobject $anObj ] "$anObj should have been destroyed"

        $serializer deserialize $serial 
        my assertTrue [ Object isobject $anObj ] "$anObj should be back"
    
}


TestSerializer @doc destroyAssociates { 
destroyAssociates does ...
            serializer - 
            anObj -
}

TestSerializer instproc destroyAssociates { serializer anObj } {
        set associates [ $serializer getAssociates $anObj ]

        foreach obj $associates {

            $obj destroy
            my assertFalse [ Object isobject $obj ] "$obj should have been destroyed"

        }
    
}


TestSerializer @doc notestBracketBug { 
notestBracketBug does ...
}

TestSerializer instproc notestBracketBug {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set obj [ Object new ]
        $obj set data "\{"
        $obj set data1 "\\\{"
        $obj set data2(0) "\{"
        $obj set data2(1) "\\\{"

        set objList [ $serializer serializeAssociatesList $obj ]
        puts $objList
        set newObj [ $serializer deserializeListToNew $objList ]

        my assertEquals [ $obj set data ] [ $newObj set data ]
        my assertEquals [ $obj set data1 ] [ $newObj set data1 ]
        my assertEquals [ $obj set data2(0) ] [ $newObj set data2(0) ]
        my assertEquals [ $obj set data2(1) ] [ $newObj set data2(1) ]
    
}


TestSerializer @doc notestScalability { 
notestScalability does ...
}

TestSerializer instproc notestScalability {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set start [ Object new ]
        set current $start

        for { set loop 0 } { $loop < 30 } { incr loop } {

            $current set loop $loop

            set next [ Object new ]
            $current set next $next
            set current $next
        }

        set objList [ $serializer serializeAssociatesList $start ]
        set newStart [ $serializer deserializeListToNew $objList ]

        set current $newStart

        for { set loop 0 } { $loop < 30 } { incr loop } {

            my assertEquals [ $current set loop ] $loop

            set current [ $current set next ]
        }
    
}


TestSerializer @doc testFlattenList { 
testFlattenList does ...
}

TestSerializer instproc testFlattenList {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set aList [ list a b c d e f g ]
        set bList [ list [ list h i j k l m n ] ]
        set cList [ list { o p } {{{ q }}} {} { r s t {{{{{u }}}}} } ]
        set dList " \{ o p \} \{\{\{ q \}\}\} \{\} \{ r s t \{\{\{\{\{u \}\}\}\}\} \} "
        set bugList "\{"

        set flatAList [ $serializer flattenList $aList ]
        set flatBList [ $serializer flattenList $bList ]
        set flatCList [ $serializer flattenList $cList ]
        set flatDList [ $serializer flattenList $dList ]
        set flatBugList [ $serializer flattenList $bugList ]


        my assertEquals $flatAList [ list a b c d e f g ]
        my assertEquals $flatBList [ list h i j k l m n ]
        my assertEquals $flatCList " o p   q    r s t u  "
        my assertEquals $flatDList "  o p   q    r s t u   "
        my assertEquals $flatBugList ""
    
}


TestSerializer @doc testGetAllAssociates { 
testGetAllAssociates does ...
}

TestSerializer instproc testGetAllAssociates {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set thirdObj [ Object new ]
        set anObj [ Object new ]
        set anotherObj [ Object new ]

        $anObj set another $anotherObj
        $anotherObj set third $thirdObj

        set associates [ $serializer getAllAssociates $anObj ]

        my assertEquals $associates "$thirdObj $anObj $anotherObj"
    
}


TestSerializer @doc testGetAllAssociates2 { 
testGetAllAssociates2 does ...
}

TestSerializer instproc testGetAllAssociates2 {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set a [ Object create ::a ]
        set b [ Object create ::b ]
        set c [ Object create ::c ]
        set d [ Object create ::d ]
        set e [ Object create ::e ]
        set f [ Object create ::f ]

        $a set a $b
        $b set a $d
        $b set b $c
        $d set a $e
        $d set b $f

        set associates [ $serializer getAllAssociates $a ]

        my assertNotEquals [ lsearch $associates $a ] -1 "a"
        my assertNotEquals [ lsearch $associates $b ] -1 "b"
        my assertNotEquals [ lsearch $associates $c ] -1 "c"
        my assertNotEquals [ lsearch $associates $d ] -1 "d"
        my assertNotEquals [ lsearch $associates $e ] -1 "e"
        my assertNotEquals [ lsearch $associates $f ] -1 "f"
    
}


TestSerializer @doc testGetAllAssociates3 { 
testGetAllAssociates3 does ...
}

TestSerializer instproc testGetAllAssociates3 {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set a [ Object create ::a ]
        set b [ Object create ::b ]
        set c [ Object create ::c ]
        set d [ Object create ::d ]
        set e [ Object create ::e ]
        set f [ Object create ::f ]

        $a set a $b
        $b set a $a
        $b set b $c
        $c set a $a
        $b set c $d
        $d set a $e
        $e set a $f

        set associates [ $serializer getAllAssociates $a ]

        my assertNotEquals [ lsearch $associates $a ] -1 "a"
        my assertNotEquals [ lsearch $associates $b ] -1 "b"
        my assertNotEquals [ lsearch $associates $c ] -1 "c"
        my assertNotEquals [ lsearch $associates $d ] -1 "d"
        my assertNotEquals [ lsearch $associates $e ] -1 "e"
        my assertNotEquals [ lsearch $associates $f ] -1 "f"
    
}


TestSerializer @doc testGetAssociates { 
testGetAssociates does ...
}

TestSerializer instproc testGetAssociates {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set anObj [ Object new ]
        set anotherObj [ Object new ]

        $anObj set another $anotherObj

        set associates [ $serializer getAssociates $anObj ]

        my assertEquals $associates "$anObj $anotherObj"
    
}


TestSerializer @doc testGetAssociatesInArrayValues { 
testGetAssociatesInArrayValues does ...
}

TestSerializer instproc testGetAssociatesInArrayValues {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set anObj [ Object new ]
        set one [ Object new ]
        set two [ Object new ]
        set three [ Object new ]

        $anObj set anArray(one) $one
        $anObj set anArray(two) $two
        $anObj set anArray(three) $three

        set associates [ $serializer getAssociates $anObj ]

        my assertNotEquals [ lsearch $associates $anObj ] -1 
        my assertNotEquals [ lsearch $associates $one ] -1 
        my assertNotEquals [ lsearch $associates $two ] -1 
        my assertNotEquals [ lsearch $associates $three ] -1 
        my assertEquals [ lsearch $associates notthere ] -1 
    
}


TestSerializer @doc testGetAssociatesInList { 
testGetAssociatesInList does ...
}

TestSerializer instproc testGetAssociatesInList {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set anObj [ Object new ]
        set one [ Object new ]
        set two [ Object new ]
        set three [ Object new ]

        $anObj set aList [list $one $two $three]

        set associates [ $serializer getAssociates $anObj ]

        my assertEquals $associates "$anObj $one $two $three"
    
}


TestSerializer @doc testGetAssociatesInListOfLists { 
testGetAssociatesInListOfLists does ...
}

TestSerializer instproc testGetAssociatesInListOfLists {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set anObj [ Object new ]
        set one [ Object new ]
        set two [ Object new ]
        set three [ Object new ]

        $anObj set aList [list [list $one] [list [list $two $three]]]

        set associates [ $serializer getAssociates $anObj ]

        my assertEquals $associates "$anObj $one $two $three"
    
}


TestSerializer @doc testGetOnlyGlobalHandleAssociates { 
testGetOnlyGlobalHandleAssociates does ...
}

TestSerializer instproc testGetOnlyGlobalHandleAssociates {  } {
        set serializer [ ::xoserialize::Serializer new ]

        uplevel #0 namespace import -force ::xotcl::*
        uplevel #0 Object create thirdObj
        set anObj [ Object new ]
        set anotherObj [ Object new ]

        $anObj set another $anotherObj
        $anotherObj set third thirdObj

        set associates [ $serializer getAllAssociates $anObj ]

        my assertEquals $associates "$anObj $anotherObj"
    
}


TestSerializer @doc testInit { 
testInit does ...
}

TestSerializer instproc testInit {  } {
        set serializer [ ::xoserialize::Serializer new ]
    
}


TestSerializer @doc testMultipleMixin { 
testMultipleMixin does ...
}

TestSerializer instproc testMultipleMixin {  } {
        Class create ::SomeMixin1
        Class create ::SomeMixin2

        set anObj [ Object new ]

        $anObj mixin add ::SomeMixin1
        $anObj mixin add ::SomeMixin2

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info mixin ] "::SomeMixin1 ::SomeMixin2"
    
}


TestSerializer @doc testReferenceToClass { 
testReferenceToClass does ...
}

TestSerializer instproc testReferenceToClass {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set a [ Object new ]
        Class ::SomeClass

        $a set classReference ::SomeClass

        set objList [ $serializer serializeAssociatesList $a ]
        set newA [ $serializer deserializeListToNew $objList ]

        my assertEquals [ $newA set classReference ] ::SomeClass
    
}


TestSerializer @doc testResultsBug { 
testResultsBug does ...
}

TestSerializer instproc testResultsBug {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set obj [ Object new ]
        $obj set data {Test Results: ::est::mpls::intraextra::estmpls2::IntraExtraEstMpls2
Error: ::est::mpls::intraextra::estmpls2::IntraExtraEstMpls2 storySetUp couldn't read file "/users/mbrown/extra/other/mmpls/config/device.exp": no such file or directory
couldn't read file "/users/mbrown/extra/other/mmpls/config/device.exp": no such file or directory
    while executing
"source $MMPLS/config/device.exp"
    (procedure "storySetUp" line 13)
    invoked from within
"::xotcl::next "
    (procedure "storySetUp" line 5)
    ::xotcl::__#J ::est::mpls::intraextra::estmpls2::IntraExtraEstMpls2->storySetUp
    invoked from within
"::xotcl::my storySetUp "
    invoked from within
"set context [ ::xotcl::my storySetUp ]"
    ("uplevel" body line 3)
    invoked from within
"uplevel [ subst \{ $script \} ] "
    invoked from within
"if [ catch \{ uplevel [ subst \{ $script \} ] \} result ] \{
 
        if \{ ![ ::xotcl::Object isobject $result ] \} \{
 
            global errorInfo
        ..."
    (procedure "::xoexception::try" line 3)
    invoked from within
"::xoexception::try \{
 
            set context [ ::xotcl::my storySetUp ]
 
        \} result "
Errors : 1
Failures : 0
Passes : 0
=================
Total tests error: 1
Total tests fail: 0
Total tests pass: 0
Total tests ran: 1
Total results reported: 1}


        set objList [ $serializer serializeAssociatesList $obj ]
        puts $objList
        set newObj [ $serializer deserializeListToNew $objList ]

        #my assertEquals [ $obj set data ] [ $newObj set data ]
    
}


TestSerializer @doc testSerialize { 
testSerialize does ...
}

TestSerializer instproc testSerialize {  } {
        set serializer [ ::xoserialize::Serializer new ]

        $serializer serialize [ Object new ]
    
}


TestSerializer @doc testSerializeAssociations { 
testSerializeAssociations does ...
}

TestSerializer instproc testSerializeAssociations {  } {
        set anObj [ Object new ]
        set anotherObj [ Object new ]

        $anObj set another $anotherObj

        my destroyAndRecreateAssociates $anObj
    
}


TestSerializer @doc testSerializeClass { 
testSerializeClass does ...
}

TestSerializer instproc testSerializeClass {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info superclass ] $ASuperClass 
    
}


TestSerializer @doc testSerializeClassNamespace { 
testSerializeClassNamespace does ...
}

TestSerializer instproc testSerializeClassNamespace {  } {
        
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass requireNamespace

        my assert [ $AClass info hasNamespace ] "1"

        my destroyAndRecreateClass $AClass

        my assert [ $AClass info hasNamespace ] "2"
    
}


TestSerializer @doc testSerializeDeserializeNew { 
testSerializeDeserializeNew does ...
}

TestSerializer instproc testSerializeDeserializeNew {  } {
        set serializer [ ::xoserialize::Serializer new ]

        set thirdObj [ Object new ]
        set anObj [ Object new ]
        set anotherObj [ Object new ]

        $anObj set another $anotherObj
        $anotherObj set third $thirdObj
        $thirdObj set name ThirdOfThree

        set objList [ $serializer serializeAssociatesList $anObj ]
        set newObj [ $serializer deserializeListToNew $objList ]

        my assertTrue [ $newObj exists another ]
        set newAnother [ $newObj set another ]
        my assertTrue [ $newAnother exists third ]
        set newThird [ $newAnother set third ]
        my assertTrue [ $newThird exists name ]
        my assertEquals [ $newThird set name ] "ThirdOfThree"
    
}


TestSerializer @doc testSerializeFilter { 
testSerializeFilter does ...
}

TestSerializer instproc testSerializeFilter {  } {
        set anObj [ Object new ]

        $anObj proc aFilter { args } {

            next
        }

        $anObj set a 5

        $anObj filter aFilter

        my assertEquals [ $anObj info filter ] {aFilter} "1.1"
        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info filter ] {aFilter} "3.1"
    
}


TestSerializer @doc testSerializeFilterGuard { 
testSerializeFilterGuard does ...
}

TestSerializer instproc testSerializeFilterGuard {  } {
        set anObj [ Object new ]

        $anObj proc aFilter { args } {

            next
        }

        $anObj set a 5

        $anObj filter aFilter
        $anObj filterguard aFilter 1

        my assertEquals [ $anObj info filter ] {aFilter} "1.1"
        my assertEquals [ $anObj info filterguard aFilter ] {1} "1.2"
        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info filter ] {aFilter} "2.1"
        my assertEquals [ $anObj info filterguard aFilter ] {1} "2.2"
    
}


TestSerializer @doc testSerializeInstFilter { 
testSerializeInstFilter does ...
}

TestSerializer instproc testSerializeInstFilter {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass instproc aFilter { args } {

            next
        }

        $AClass instfilter aFilter

        my assertEquals [ $AClass info instfilter ] {aFilter} "1.1"
        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info instfilter ] {aFilter} "3.1"
    
}


TestSerializer @doc testSerializeInstFilterGuard { 
testSerializeInstFilterGuard does ...
}

TestSerializer instproc testSerializeInstFilterGuard {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass instproc aFilter { args } {

            next
        }

        $AClass instfilter aFilter
        $AClass instfilterguard aFilter 1

        my assertEquals [ $AClass info instfilter ] {aFilter} "1.1"
        my assertEquals [ $AClass info instfilterguard aFilter ] {1} "1.2"
        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info instfilter ] {aFilter} "2.1"
        my assertEquals [ $AClass info instfilterguard aFilter ] {1} "2.2"
    
}


TestSerializer @doc testSerializeInstInvars { 
testSerializeInstInvars does ...
}

TestSerializer instproc testSerializeInstInvars {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass instinvar { 1 }

        my assertEquals [ $AClass info instinvar ] "\{1\}" "1.1"

        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info instinvar ] "\{1\}" "2.1"
    
}


TestSerializer @doc testSerializeInstMixin { 
testSerializeInstMixin does ...
}

TestSerializer instproc testSerializeInstMixin {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        Class ::xoserialize::test::AMixin
        

        $AClass instmixin ::xoserialize::test::AMixin

        my assertEquals [ $AClass info instmixin ] {::xoserialize::test::AMixin} "1.1"
        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info instmixin ] {::xoserialize::test::AMixin} "1.1"
    
}


TestSerializer @doc testSerializeInstProcs { 
testSerializeInstProcs does ...
}

TestSerializer instproc testSerializeInstProcs {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass instproc simpleProc {} {

        }

        $AClass instproc procWithArgs { a b c } {

        }

        $AClass instproc procWithArgsAndBody { a b c } {

            return $a
        }

        $AClass instproc procWithNonPosArgs {-a {-b 1} -c} { } {

        }

        $AClass instproc procWithPreAndPost { } {

        } {1} {1}

        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info instargs simpleProc ] {}
        my assertEquals [ $AClass info instbody simpleProc ] {

        }
        my assertEquals [ $AClass info instargs procWithArgs ] {a b c}
        my assertEquals [ $AClass info instbody procWithArgs ] {

        }
        my assertEquals [ $AClass info instargs procWithArgsAndBody ] {a b c}

        my assertEquals [ $AClass info instnonposargs procWithNonPosArgs ] "-a \{-b 1\} -c"
        my assertEquals [ $AClass info instpre procWithPreAndPost ] "\{1\}"
        my assertEquals [ $AClass info instpost procWithPreAndPost ] "\{1\}"
    
}


TestSerializer @doc testSerializeMixin { 
testSerializeMixin does ...
}

TestSerializer instproc testSerializeMixin {  } {
        Class ::xoserialize::test::AMixin
        
        set anObj [ Object new ]

        $anObj set a 5

        $anObj mixin ::xoserialize::test::AMixin

        my assertEquals [ $anObj info mixin ] {::xoserialize::test::AMixin} "1.1"
        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info mixin ] {::xoserialize::test::AMixin} "1.1"
    
}


TestSerializer @doc testSerializeObject { 
testSerializeObject does ...
}

TestSerializer instproc testSerializeObject {  } {
        set anObj [ Object new ]

        my destroyAndRecreateObject $anObj
    
}


TestSerializer @doc testSerializeObjectInvars { 
testSerializeObjectInvars does ...
}

TestSerializer instproc testSerializeObjectInvars {  } {
        set anObj [ Object new ]

        $anObj set a 5
        $anObj invar { 1 }

        my assertEquals [ $anObj info invar ] "\{1\}" "1.1"

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info invar ] "\{1\}" "2.1"
    
}


TestSerializer @doc testSerializeObjectNamespace { 
testSerializeObjectNamespace does ...
}

TestSerializer instproc testSerializeObjectNamespace {  } {
        set anObj [ Object new -requireNamespace ]

        $anObj set a 5
        my assert [ $anObj info hasNamespace ] "1"

        my destroyAndRecreateObject $anObj

        my assert [ $anObj info hasNamespace ] "2"
    
}


TestSerializer @doc testSerializeObjectOfClass { 
testSerializeObjectOfClass does ...
}

TestSerializer instproc testSerializeObjectOfClass {  } {
        Class ::SomeClass

        set anObj [ ::SomeClass new ]

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info class ] "::SomeClass"
    
}


TestSerializer @doc testSerializeParameter { 
testSerializeParameter does ...
}

TestSerializer instproc testSerializeParameter {  } {
        set AClass ::xoserialize::test::AClass
        set ASuperClass ::xoserialize::test::ASuperClass

        Class create $ASuperClass 
        Class create $AClass -superclass $ASuperClass

        $AClass parameter {a b} 

        my assertEquals [ $AClass info parameter ] "a b" 

        my destroyAndRecreateClass $AClass

        my assertEquals [ $AClass info parameter ] "a b" 
    
}


TestSerializer @doc testSerializeProcs { 
testSerializeProcs does ...
}

TestSerializer instproc testSerializeProcs {  } {
        set anObj [ Object new ]

        $anObj set a 5
        $anObj proc simpleProc {} {

        }

        $anObj proc procWithArgs { a b c } {

        }

        $anObj proc procWithArgsAndBody { a b c } {

            return $a
        }

        $anObj proc procWithNonPosArgs {-a {-b 1} -c} { } {

        }

        $anObj proc procWithPreAndPost { } {

        } {1} {1}

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj info args simpleProc ] {}
        my assertEquals [ $anObj info body simpleProc ] {

        }
        my assertEquals [ $anObj info args procWithArgs ] {a b c}
        my assertEquals [ $anObj info body procWithArgs ] {

        }
        my assertEquals [ $anObj info args procWithArgsAndBody ] {a b c}

        my assertEquals [ $anObj procWithArgsAndBody 1 2 3 ] 1
        my assertEquals [ $anObj info nonposargs procWithNonPosArgs ] "-a \{-b 1\} -c"
        my assertEquals [ $anObj info pre procWithPreAndPost ] "\{1\}"
        my assertEquals [ $anObj info post procWithPreAndPost ] "\{1\}"
    
}


TestSerializer @doc testSerializeSomething { 
testSerializeSomething does ...
}

TestSerializer instproc testSerializeSomething {  } {
        Class ::xoserialize::test::Something

        set anObj [ ::xoserialize::test::Something new ]

        $anObj set a 5

        my assertTrue [ $anObj istype ::xoserialize::test::Something ] "1.1"

        my destroyAndRecreateObject $anObj

        my assertTrue [ $anObj istype ::xoserialize::test::Something ] "3.1"
    
}


TestSerializer @doc testSerializeVars { 
testSerializeVars does ...
}

TestSerializer instproc testSerializeVars {  } {
        set anObj [ Object new ]

        $anObj set a 5
        $anObj set b 6
        $anObj set c {booga booga boo}
        $anObj set {c d} {booga booga boo}
        $anObj set e(0) 1
        $anObj set {e e(0)} 1
        $anObj set {e e({0 0})} 1

        my assertEquals [ $anObj set a ] 5 

        my destroyAndRecreateObject $anObj

        my assertEquals [ $anObj set a ] 5 
        my assertEquals [ $anObj set b ] 6 
        my assertEquals [ $anObj set {c d} ] {booga booga boo} 
        my assertEquals [ $anObj set c ] {booga booga boo} 
        my assertEquals [ $anObj set e(0) ] 1
        my assertEquals [ $anObj set {e e(0)} ] 1
        my assertEquals [ $anObj set {e e({0 0})} ] 1
    
}
}


