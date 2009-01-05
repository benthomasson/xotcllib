
namespace eval ::server::test { 

Class create TestIndexApplication -superclass { ::xounit::TestCase }
  
TestIndexApplication @doc TestIndexApplication {
Please describe TestIndexApplication here.
}
       
TestIndexApplication parameter {

} 
        

TestIndexApplication @doc test { 
test does ...
}

TestIndexApplication instproc test {  } {
        set ia [ ::server::IndexApplication new ]

        set response [ ::server::MockResponse new ]

        $response expectedOutput  {<html><head><title>IndexApplication</title>
<script language="Javascript" src="prototype.js"></script>
<script language="Javascript" src="xopro.js"></script>
<LINK REL ="stylesheet" TYPE="text/css" HREF="/stylesheet.css" TITLE="Style">
</head>
<body>
<a href="default">default</a> -&gt; <a href="default">::server:NotFound</a> <br />
<a href="nextChildNodeOrder">nextChildNodeOrder</a> -&gt; <a href="nextChildNodeOrder">0</a> <br />
<a href="nodeOrder">nodeOrder</a> -&gt; <a href="nodeOrder">0</a> <br />
<a href="root">root</a> -&gt; <a href="root">::server:IndexApplication</a> <br />
</body></html>}
        $ia initialLoad $response
    
}
}


