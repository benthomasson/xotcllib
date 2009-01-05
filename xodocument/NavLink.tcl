
namespace eval ::xodocument { 

Class create NavLink -superclass { ::xotcl::Object }
  
NavLink @doc NavLink {
Please describe NavLink here.
}
    
NavLink @doc name { }

NavLink @doc link { }

NavLink @doc state { }
   
NavLink parameter {
   {name}
   {link}
   {state}

} 
        

NavLink @doc getLink { 
getLink does ...
}

NavLink instproc getLink {  } {
        set state [ ::xotcl::my state ]
        set name [ ::xotcl::my name ]
        set link [ ::xotcl::my link ]

        return [ $state getLink $name $link ]
    
}


NavLink @doc init { 
init does ...
            name - 
            link - 
            state -
}

NavLink instproc init { name link state } {
        ::xotcl::my name $name
        ::xotcl::my link $link
        ::xotcl::my state $state
    
}
}


