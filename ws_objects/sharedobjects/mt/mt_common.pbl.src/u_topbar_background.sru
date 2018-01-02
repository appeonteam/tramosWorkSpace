$PBExportHeader$u_topbar_background.sru
forward
global type u_topbar_background from mt_u_statictext
end type
end forward

global type u_topbar_background from mt_u_statictext
integer width = 8000
integer height = 208
long backcolor = 5851683
boolean enabled = false
string text = ""
end type
global u_topbar_background u_topbar_background

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   u_topbar_background
   <OBJECT> Set the dark green background for the top bar region of the window. </OBJECT>
   <USAGE> Place it to the top of the window </USAGE>
   <ALSO> </ALSO>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	27-06-2011                ZSW001             First Version
   	23-01-2013   CR2877       WWA048             Modify the standards height of panel
   </HISTORY>
********************************************************************/

end subroutine

on u_topbar_background.create
call super::create
end on

on u_topbar_background.destroy
call super::destroy
end on

