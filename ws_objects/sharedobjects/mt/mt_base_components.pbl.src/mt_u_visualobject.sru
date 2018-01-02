$PBExportHeader$mt_u_visualobject.sru
forward
global type mt_u_visualobject from userobject
end type
end forward

global type mt_u_visualobject from userobject
integer width = 457
integer height = 216
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type
global mt_u_visualobject mt_u_visualobject

forward prototypes
public subroutine documentation ()
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage)
protected function integer _addmessage (readonly powerobject apo_classdef, readonly string as_methodname, readonly string as_message, readonly string as_devmessage, boolean ab_showmessage)
public function string of_tostring ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
********************************************************************/
end subroutine

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

n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")

lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage )

if ab_showmessage then lnv_errService.of_showmessages( )

return c#return.success


end function

public function string of_tostring ();return ClassName(this)
end function

on mt_u_visualobject.create
end on

on mt_u_visualobject.destroy
end on

