

::xohtml::widgets {

    defineWidget ObjectInspectorLink { object url } { } {

        foreach anObject $object {
            a -href "$url?object=[ cleanUpLink $anObject ]" ' $anObject
            ' " "
        }
    }
}

