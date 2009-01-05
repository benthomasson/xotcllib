
namespace eval ::server::test { 

Class create Testbase64 -superclass { ::xounit::TestCase }
  
Testbase64 @doc Testbase64 {
Please describe Testbase64 here.
}
       
Testbase64 parameter {

} 
        

Testbase64 @doc test { 
test does ...
}

Testbase64 instproc test {  } {
        my assertEquals [ ::server::base64::encode "Aladdin:open sesame" ]  "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="

        my assertEquals [ ::server::base64::decode "QWxhZGRpbjpvcGVuIHNlc2FtZQ==" ]  "Aladdin:open sesame" ]

        my assertEquals [ ::server::base64::encode "ben:pass" ]  "YmVuOnBhc3M="
                        
        my assertEquals [ ::server::base64::decode "YmVuOnBhc3M=" ]  "ben:pass"
    
}
}


