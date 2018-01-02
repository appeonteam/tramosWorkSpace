$PBExportHeader$w_default_values_maintenance.srw
$PBExportComments$Window for display/editing of default values used in transactions.
forward
global type w_default_values_maintenance from mt_w_response
end type
type cb_ax_config from commandbutton within w_default_values_maintenance
end type
type cb_view_log from commandbutton within w_default_values_maintenance
end type
type cb_1 from commandbutton within w_default_values_maintenance
end type
type cb_update from commandbutton within w_default_values_maintenance
end type
type dw_default_values_maintenance from datawindow within w_default_values_maintenance
end type
end forward

global type w_default_values_maintenance from mt_w_response
integer x = 535
integer y = 320
integer width = 4489
integer height = 2592
string title = "Transaction Defaults"
cb_ax_config cb_ax_config
cb_view_log cb_view_log
cb_1 cb_1
cb_update cb_update
dw_default_values_maintenance dw_default_values_maintenance
end type
global w_default_values_maintenance w_default_values_maintenance

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
  w_default_values_maintenance 
	
	<OBJECT>
	</OBJECT>
   <DESC>
		Window for finance admin to change default tranaction values		
	</DESC>
  	<USAGE>

	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	11/08/14 	CR3708  	AGL027			F1 help application coverage - change of ancestor
	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
********************************************************************/
end subroutine

on w_default_values_maintenance.create
int iCurrent
call super::create
this.cb_ax_config=create cb_ax_config
this.cb_view_log=create cb_view_log
this.cb_1=create cb_1
this.cb_update=create cb_update
this.dw_default_values_maintenance=create dw_default_values_maintenance
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ax_config
this.Control[iCurrent+2]=this.cb_view_log
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.dw_default_values_maintenance
end on

on w_default_values_maintenance.destroy
call super::destroy
destroy(this.cb_ax_config)
destroy(this.cb_view_log)
destroy(this.cb_1)
destroy(this.cb_update)
destroy(this.dw_default_values_maintenance)
end on

event open;call super::open;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Populates the data window and check that the user has the right access level
			(administrator)
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/
String ls_userid
Integer li_access

w_default_values_maintenance.Move(5,5)

// Get the data
dw_default_values_maintenance.SetTransObject(SQLCA)
dw_default_values_maintenance.Retrieve()

/* Admin and finance profile Superuser have access */
if (uo_global.ii_access_level = 3) &
or (uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 ) then 
	dw_default_values_maintenance.object.datawindow.readonly = 'No'
	cb_update.enabled = true 
	cb_view_log.enabled = true
else
	dw_default_values_maintenance.object.datawindow.readonly = 'Yes'
	cb_update.enabled = false 
	cb_view_log.enabled = false
end if	

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_default_values_maintenance
end type

type cb_ax_config from commandbutton within w_default_values_maintenance
integer x = 41
integer y = 2400
integer width = 471
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&AX Configurations"
end type

event clicked;open(w_default_values_maintenance_ax)


end event

type cb_view_log from commandbutton within w_default_values_maintenance
integer x = 517
integer y = 2400
integer width = 448
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&View Changes..."
end type

event clicked;open(w_default_values_change_log)
end event

type cb_1 from commandbutton within w_default_values_maintenance
integer x = 4096
integer y = 2400
integer width = 370
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(parent)
end event

type cb_update from commandbutton within w_default_values_maintenance
integer x = 3666
integer y = 2400
integer width = 379
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		07-05-1999
Purpose:	The default values for the CMS/CODA file generation.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
01-06-99		1.1		ta			Validation on accounting year
************************************************************************************/
String ls_year

dw_default_values_maintenance.AcceptText()

if dw_default_values_maintenance.update() = 1 then
	commit;
else
	rollback;
	messageBox("Update Error", "Update of Default values Failed!")
end if
	




end event

type dw_default_values_maintenance from datawindow within w_default_values_maintenance
integer y = 32
integer width = 4462
integer height = 2340
integer taborder = 20
string dataobject = "d_default_values_maintenance"
borderstyle borderstyle = stylelowered!
end type

