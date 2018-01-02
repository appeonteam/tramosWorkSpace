$PBExportHeader$mt_n_nonvisualobject.sru
$PBExportComments$Main NVO ancester for all other NVO's
forward
global type mt_n_nonvisualobject from nonvisualobject
end type
end forward

global type mt_n_nonvisualobject from nonvisualobject
end type
global mt_n_nonvisualobject mt_n_nonvisualobject

forward prototypes
public function string of_tostring ()
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage)
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, boolean ab_showmessage)
public subroutine documentation ()
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, integer ai_severity, boolean ab_showmessage)
end prototypes

public function string of_tostring ();return ClassName(this)
end function

protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage);/********************************************************************
   _addMessage
   <DESC>  This function is implemented on the ancestor level, to ensure that 
	whenever there is an error, what we have to do is just adding a message to
	the Error Service</DESC>
   <RETURN> Integer:
            <LI> c#return.success (1), ok
            <LI> c#return.failed(-1), failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS>	apo_classdef: Class definition of object where error occured
            		as_methodName: The method (function/event) where the error occured
				as_message: String holding the message to the user
				as_devMessage: If needed some additional information for the developer</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
return _addMessage(apo_classdef , as_methodname, as_message, as_devmessage, TRUE )



end function

protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, boolean ab_showmessage);/********************************************************************
   _addMessage
   <DESC>  This function is implemented on the ancestor level, to ensure that 
	whenever there is an error, what we have to do is just adding a message to
	the Error Service</DESC>
   <RETURN> Integer:
            <LI> c#return.success (1), ok
            <LI> c#return.failed(-1), failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS>	apo_classdef: Class definition of object where error occured
            		as_methodName: The method (function/event) where the error occured
				as_message: String holding the message to the user
				as_devMessage: If needed some additional information for the developer</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
return _addmessage( apo_classdef, as_methodname, as_message, as_devmessage, 2, ab_showmessage)

end function

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
  19/02/13	CR3167	AGL027		Added new _addmessage() function to control icon displayed
********************************************************************/

end subroutine

protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, integer ai_severity, boolean ab_showmessage);/********************************************************************
   _addMessage
   <DESC>  This function is implemented on the ancestor level, to ensure that 
	whenever there is an error, what we have to do is just adding a message to
	the Error Service</DESC>
   <RETURN> Integer:
            <LI> c#return.success (1), ok
            <LI> c#return.failed(-1), failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS>	apo_classdef: Class definition of object where error occured
            		as_methodName: The method (function/event) where the error occured
				as_message: String holding the message to the user
				as_devMessage: If needed some additional information for the developer</ARGS>
   <USAGE>  </USAGE>
********************************************************************/

n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")

lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage, ai_severity )

if ab_showmessage then lnv_errService.of_showmessages( )

return c#return.success


end function

on mt_n_nonvisualobject.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_nonvisualobject.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

