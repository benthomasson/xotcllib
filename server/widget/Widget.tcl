
namespace eval ::server::widget { 

Class create Widget -superclass { ::server::HtmlGenerator }
  
Widget @doc Widget {
Widget is the base class for all web app widgets.
}
       
Widget parameter {
    {code ""}
}

Widget instproc format { response } {

}


}


