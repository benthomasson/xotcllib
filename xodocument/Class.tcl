# Created at Wed Jan 23 01:27:16 PM EST 2008 by bthomass

namespace eval ::xotcl {

    ::xodocument loadClass ::xodocument::ClassDocLanguage

    ::xox::MetaData instproc @@doc { token doc } { 

        if [ catch {

            catch { my unset @return($token) }
            catch { my unset @author($token) } 
            catch { my unset @changes($token) }
            catch { my unset @see($token) } 
            catch { my unset @date($token) } 
            catch { my unset @tag($token) }

            set language [ ::xodocument::ClassDocLanguage newLanguage -docClass [ self ] -method $token ]
            set environment [ $language set environment ]
            $environment eval $doc
            catch { $language destroy }
            catch { $environment destroy }

        } error ] {

            puts "ClassDoc Warning: [ self ] @@doc $token error:$error"
        }
    } 

    Class @@doc @@doc {

        Purpose: { To provide an easy way to write meaningful and extractable documentation
        in your XOTcl code. }

        Arguments: {
            token { Either the name of the class or a name of a method or procedure.
                    This is the key used to retrieve the documentation later.
            }
            doc The block of documentation that will be intepreted by ClassDoc.
        }

        Example: {

            Class A 

            A @@doc A {

                Author: Ben Thomasson
                Purpose: To give a simple example of using @@doc
            }
        }
    }
}

