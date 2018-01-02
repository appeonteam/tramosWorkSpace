$PBExportHeader$u_cb_option.sru
forward
global type u_cb_option from commandbutton
end type
end forward

global type u_cb_option from commandbutton
integer width = 343
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Option>>"
event ue_command ( string as_text )
event ue_lbuttonup pbm_lbuttonup
end type
global u_cb_option u_cb_option

type prototypes

end prototypes

type variables
window	iw_parent

m_option_contextmenu		im_contextmenu

end variables

forward prototypes
public subroutine of_getparentwindow ()
public function long of_addmenuitem (string as_text)
public function integer of_modifymenuitem (long al_num, boolean ab_enabled)
public function integer of_modifymenuitem (long al_num, string as_text)
public subroutine documentation ()
public function long of_addmenuitem (long al_parent, string as_text)
public function long of_addmenuitem (long al_parent, string as_text, string as_tag)
public function long of_addmenuitem (string as_text, string as_tag)
end prototypes

event ue_lbuttonup;if isvalid(iw_parent) then
	//Displays context menu at the cursor location
	im_contextmenu.popmenu(iw_parent.pointerx(), iw_parent.pointery())
end if

end event

public subroutine of_getparentwindow ();/********************************************************************
   of_getparentwindow
   <DESC>	Calculates the parent window of a window object	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the constructor event	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

powerobject		lpo_parent
window			lw_parent

lpo_parent = this

do 
	lpo_parent = lpo_parent.getparent()
loop while lpo_parent.typeof() <> Window!

iw_parent = lpo_parent

lw_parent = iw_parent.parentwindow()
if isvalid(lw_parent) then iw_parent = lw_parent

end subroutine

public function long of_addmenuitem (string as_text);/********************************************************************
   of_addmenuitem
   <DESC>	Add context menu item	</DESC>
   <RETURN>	long:
            <LI> Menu item serial number
            <LI> c#return.Failure	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_text
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_additem(as_text)

end function

public function integer of_modifymenuitem (long al_num, boolean ab_enabled);/********************************************************************
   of_modifymenuitem
   <DESC>	Modify the enabled property of the menu item	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_num
		ab_enabled
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_modifyitem(al_num, ab_enabled)

end function

public function integer of_modifymenuitem (long al_num, string as_text);/********************************************************************
   of_modifymenuitem
   <DESC>	Modify the text property of the menu item	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_num
		as_text
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_modifyitem(al_num, as_text)

end function

public subroutine documentation ();/********************************************************************
   u_cb_option
   <OBJECT>		Opening a context menu when clicked	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	31/07/2012   CR2413       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

public function long of_addmenuitem (long al_parent, string as_text);/********************************************************************
   of_addmenuitem
   <DESC>	Add context menu item	</DESC>
   <RETURN>	long:
            <LI> Menu item serial number
            <LI> c#return.Failure	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_text
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_additem(al_parent, as_text)

end function

public function long of_addmenuitem (long al_parent, string as_text, string as_tag);/********************************************************************
   of_addmenuitem
   <DESC>	Add context menu item	</DESC>
   <RETURN>	long:
            <LI> Menu item serial number
            <LI> c#return.Failure	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_text
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
		05/09/2016   CR4226       SSX014
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_additem(al_parent, as_text, as_tag)

end function

public function long of_addmenuitem (string as_text, string as_tag);/********************************************************************
   of_addmenuitem
   <DESC>	Add context menu item	</DESC>
   <RETURN>	long:
            <LI> Menu item serial number
            <LI> c#return.Failure	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_text
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
		05/09/2016   CR4226       SSX014
   </HISTORY>
********************************************************************/

return im_contextmenu.mf_additem(as_text, tag)

end function

on u_cb_option.create
end on

on u_cb_option.destroy
end on

event constructor;//Create and associate context menu
im_contextmenu = create m_option_contextmenu
im_contextmenu.mf_setparent(this)

of_getparentwindow()

end event

event destructor;//Destroy context menu
if isvalid(im_contextmenu) then destroy im_contextmenu

end event

