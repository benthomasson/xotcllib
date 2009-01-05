
namespace eval ::server::test { 

Class create TestApplication -superclass { ::xounit::TestCase }
  
TestApplication @doc TestApplication {
Please describe TestApplication here.
}
       
TestApplication parameter {

} 
        

TestApplication instproc setUp {  } {
        
        my instvar app response

        set app [ ::server::Application new ]
        set response [ ::server::MockResponse new ]
    
}


TestApplication @doc testInitialLoad { 
testInitialLoad does ...
}

TestApplication instproc testInitialLoad {  } {
        my instvar app response


        my assertEquals [ $app title ] "" 
        my assertEquals [ $app head ] "" 

        $app initialLoad [ ::server::MockResponse new ]
    
}


TestApplication @doc testInspectLink { 
testInspectLink does ...
}

TestApplication instproc testInspectLink {  } {
        my instvar app response

        set object [ Object new ]

        $response expectedOutput  "<a href=\"/inspect?method=inspect&object=[ $app cleanUpLink $object ]\">
some text
</a>"
        $app inspectLink $response $object "some text"
        $response send200
    
}


TestApplication @doc testRputs { 
testRputs does ...
}

TestApplication instproc testRputs {  } {
        my instvar app response

        $response expectedOutput "hello world"
        $app rputs "hello world"
        $response send200
    
}


TestApplication @doc testWithCheckbox { 
testWithCheckbox does ...
}

TestApplication instproc testWithCheckbox {  } {
        my instvar app response

        $response expectedOutput  {<input type="checkbox" name="AAA" value="BBB" >
inner
</input>}
    
        $app withCheckbox response AAA BBB { $response puts inner }
        
        $response send200
    
}


TestApplication @doc testWithHtml { 
testWithHtml does ...
}

TestApplication instproc testWithHtml {  } {
        my instvar app response

        $app title "My Title"
        $app head "<meta />"

        $response expectedOutput  {<html><head><title>My Title</title>
<script language="Javascript" src="prototype.js"></script>
<script language="Javascript" src="xopro.js"></script>
<LINK REL ="stylesheet" TYPE="text/css" HREF="/stylesheet.css" TITLE="Style">
<meta /></head>
<body>
inner
</body></html>}

        $app withHtml response { $response puts "inner" }
    
}


TestApplication @doc testWithMyWebForm { 
testWithMyWebForm does ...
}

TestApplication instproc testWithMyWebForm {  } {
        my instvar app response

        $response expectedOutput  {<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />}
    
        $app br $response 
        $app br $response 10
        
        $response send200
    
}


TestApplication @doc testWithOLList { 
testWithOLList does ...
}

TestApplication instproc testWithOLList {  } {
        my instvar app response

        $response expectedOutput  {<ol>
<li>
1
</li>
<li>
2
</li>
</ol>}

        $app withOLList response {

            $app rputs "1"
        } {
            $app rputs "2"
        }

        $response send200
    
}


TestApplication @doc testWithUL { 
testWithUL does ...
}

TestApplication instproc testWithUL {  } {
        my instvar app response

        $response expectedOutput  {<ul>
<li>1</li>
</ul>}

        $app withUL response {

            $app rputs "<li>1</li>"
        }

        $response send200
    
}
}


