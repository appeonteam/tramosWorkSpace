$PBExportHeader$mt_w_master.srw
forward
global type mt_w_master from window
end type
end forward

global type mt_w_master from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_addignoredcolorandobject ( n_gui_style_service anv_guistyle )
event ue_getwindowname ( ref string as_windowname )
end type
global mt_w_master mt_w_master

type variables
boolean	ib_setdefaultbackgroundcolor
string	is_webhelppage="Home.aspx"

end variables

forward prototypes
public subroutine documentation ()
protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage, boolean ab_showmessage)
protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage)
protected function integer _setbackgroundcolor ()
protected function integer _setfontandcolor (boolean ab_facename, boolean ab_textsize, boolean ab_fgcolor, boolean ab_bkcolor, string as_facename, long al_textsize, long al_fgcolor, long al_bkcolor)
end prototypes

event ue_addignoredcolorandobject(n_gui_style_service anv_guistyle);/********************************************************************
   ue_addignoredcolorandobject
   <DESC>	Add ignored color and object </DESC>
   <RETURN>	(none):
   <ACCESS> public </ACCESS>
   <ARGS>
		anv_guistyle : n_gui_style_service
   </ARGS>
   <USAGE> Will be called in _setbackgroundcolor and _setfontandcolor </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	29/08/2011   N/A          ZSW001       First Version
   </HISTORY>
********************************************************************/

end event

public subroutine documentation ();/********************************************************************
   ObjectName: mt_w_master
	
	<OBJECT>
	Ancestor object for all windows inside the mt framework
	</OBJECT>
   	<DESC>
		Contains standard settings along with functions utilizing helper services
		such as error and window style
	</DESC>
   	<USAGE>
		Do not directly inherit from this object.  use one of the child/descendents instead
		which are designed to fit requirements. 
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		00/00/07 	??? 		RMO      		First Version
		29/07/11  	CR#2403	AGL				Added APPEON window/control style service functionality in new function 
														_setfontandcolor()
		02/08/11  	CR#2403	ZSW001			Added APPEON window/control style service functionality in new function 
														_setbackgroundcolor()
		29/08/11  	N/A	   ZSW001			Add event ue_addignoredcolorandobject() 
		25/08/14		CR3708	CCY018			Add event ue_getwindowname(ref string as_windowname )
********************************************************************/

end subroutine

protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage, boolean ab_showmessage);/********************************************************************
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

protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage);/********************************************************************
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

return _addMessage(apo_classdef , as_methodname, as_message, as_devmessage, true )

end function

protected function integer _setbackgroundcolor ();/********************************************************************
   _setbackgroundcolor
   <DESC> set the default background color </DESC>
   <RETURN>	integer: c#return.Success
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window to paint the UI as desired </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	28/07/2011              ZSW001       First Version
   </HISTORY>
********************************************************************/

n_service_manager			lnv_manager
n_gui_style_service		lnv_guistyle

lnv_manager.of_loadservice(lnv_guistyle, "n_gui_style_service")
this.event ue_addignoredcolorandobject(lnv_guistyle)
lnv_guistyle.of_setdefaultbackgroundcolor(this)

return c#return.success

end function

protected function integer _setfontandcolor (boolean ab_facename, boolean ab_textsize, boolean ab_fgcolor, boolean ab_bkcolor, string as_facename, long al_textsize, long al_fgcolor, long al_bkcolor);/********************************************************************
   _setfontandcolor
   <DESC> set the font type(facename)/size/color as well as the background color </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_facename : TRUE/FALSE, whether to set the font type or not
		ab_textsize : TRUE/FALSE, whether to set the font size or not
		ab_fgcolor  : TRUE/FALSE, whether to set the font color or not
		ab_bkcolor  : TRUE/FALSE, whether to set the background color or not
		as_facename : String, the font type name
		al_textsize : Long, the font size
		al_fgcolor  : Long, the font color
		al_bkcolor  : Long, the background color
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window to paint the UI as desired </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	28/07/2011              ZSW001       First Version
   </HISTORY>
********************************************************************/

n_service_manager 		lnv_manager
n_gui_style_service		lnv_guistyle

lnv_manager.of_loadservice(lnv_guistyle, "n_gui_style_service")
this.event ue_addignoredcolorandobject(lnv_guistyle)
lnv_guistyle.of_setfontandcolor(this, ab_facename, ab_textsize, ab_fgcolor, ab_bkcolor, as_facename, al_textsize, al_fgcolor, al_bkcolor)

return c#return.success

end function

on mt_w_master.create
end on

on mt_w_master.destroy
end on

event open;if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

end event

