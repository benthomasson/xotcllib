

namespace eval ::xodocument {

    ::xodocument loadClass ::xodocument::Class
    ::xodocument loadClass ::xodocument::SimpleDocLanguage

    SimpleDocLanguage @@doc document {

        Purpose: To define the title and body of a document.

        Arguments: {

            title The title of the document.
            body The body of the document which contains other SimpleDoc commands.
        }

        Example: {

            document "Example" {

                section "Introduction" {

                    text {
                        This is an example of SimpleDoc
                    }
                }
            }
        }
    }

    SimpleDocLanguage @@doc section {

        Purpose: {
            To define a section or subsection of the document. Sections can be used inside other
            section blocks to define subsections of any depth.
        }
    }

    SimpleDocLanguage @@doc text {

        Purpose: To define a block of text.
    }

    SimpleDocLanguage @@doc example {

        Purpose: To define an example that should appear exactly as it is.

        Arguments: {
            title The title of this example.
            body The body of the example that should be preserved as is.
        }
    }

    SimpleDocLanguage @@doc code {

        Purpose: To define a section of code that should appear exactly as it is without a title.

        Arguments: {
            body The block of code.
        }

    }

    SimpleDocLanguage @@doc qset {

        Purpose: To quietly set a variable to a value.

        Arguments: {
            var The name of the variable to set.
            value The value to set.
        }
    }

    SimpleDocLanguage @@doc link {

        Purpose: To define a hyperlink.

        Arguments: {
            text The text that will appear as the link.
            href The location the link should point to e.g. http://xotcl.org
        }
    }

    SimpleDocLanguage @@doc unorderedList {

        Purpose: Defines an unorderedList where each line in the list is an item.

        Arguments: {
            lines The lines of items that will make up the list.
        }
    }

    SimpleDocLanguage @@doc orderedList {

        Purpose: Defines an orderedList where each line in the list is an item.

        Arguments: {
            lines The lines of items that will make up the list.
        }
    }

    SimpleDocLanguage @@doc package {

        Purpose: To support package operations in SimpleDoc files such as package require.

        Arguments: {
            args The subcommand and its arguments as defined by the Tcl package command.
        }
    }

    SimpleDocLanguage @@doc commandList {

        Purpose: Declares that a command list should be created using the commandReference items in the same section.
    }

    SimpleDocLanguage @@doc commandReference {

        Purpose: Declares that a command reference to a specific command should be created.

        Arguments: {
            class The class where the command is declared.
            method The method that implements the command.
        }
    }
}


