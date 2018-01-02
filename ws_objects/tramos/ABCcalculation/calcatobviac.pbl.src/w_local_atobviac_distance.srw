$PBExportHeader$w_local_atobviac_distance.srw
$PBExportComments$Maintenance of Local Distances in connection with AtoBviaC distance table
forward
global type w_local_atobviac_distance from w_sheet
end type
type cb_mail from commandbutton within w_local_atobviac_distance
end type
type st_1 from statictext within w_local_atobviac_distance
end type
type cb_close from commandbutton within w_local_atobviac_distance
end type
type cb_cancel from commandbutton within w_local_atobviac_distance
end type
type cb_delete from commandbutton within w_local_atobviac_distance
end type
type cb_update from commandbutton within w_local_atobviac_distance
end type
type cb_new from commandbutton within w_local_atobviac_distance
end type
type dw_distance from u_dw within w_local_atobviac_distance
end type
end forward

global type w_local_atobviac_distance from w_sheet
integer x = 214
integer y = 221
integer width = 2734
integer height = 2240
string title = "Local AtoBviaC Distance"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "AppIcon!"
boolean center = true
cb_mail cb_mail
st_1 st_1
cb_close cb_close
cb_cancel cb_cancel
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
dw_distance dw_distance
end type
global w_local_atobviac_distance w_local_atobviac_distance

type variables
Long il_find_row
Long il_found_row

n_cst_dwsrv_dropdownsearch inv_dropDownSearch

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_local_atobviac_distance: 
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
   <USAGE>

	</USAGE>
   <ALSO>
		
	</ALSO>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
		06/04/16    CR4316	AGL027			Call users email address from the database not from constant variable
********************************************************************/
end subroutine

event open;call super::open;This.move(0,0)

//Set-up user access
Choose case uo_global.ii_access_level
	Case 2, 3 // Superuser, Administrator
		dw_distance.of_setUpdateable( true )
		cb_new.enabled = True
		cb_update.enabled = True
		cb_delete.enabled = True
		cb_cancel.enabled = True
		cb_Mail.Enabled = True
Case 1 // User
		dw_distance.of_setUpdateable( false )
		cb_new.enabled = False
		cb_update.enabled = False
		cb_delete.enabled = False
		cb_cancel.enabled = False
		cb_Mail.Enabled = False
End choose

dw_distance.post setFocus()

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_registercolumn("from_portid",true,false)
lnv_style.of_registercolumn("to_portid",true,false)
lnv_style.of_registercolumn("distance",true,false)
lnv_style.of_dwlistformater(dw_distance,false)
end event

on w_local_atobviac_distance.create
int iCurrent
call super::create
this.cb_mail=create cb_mail
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.dw_distance=create dw_distance
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_mail
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_update
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.dw_distance
end on

on w_local_atobviac_distance.destroy
call super::destroy
destroy(this.cb_mail)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.dw_distance)
end on

event pfc_postopen;call super::pfc_postopen;if dw_distance.event pfc_retrieve( ) < 1 then
	dw_distance.event pfc_insertrow( )
end if
end event

type cb_mail from commandbutton within w_local_atobviac_distance
integer x = 1422
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Notify U&ser"
end type

event clicked;
string ls_userid, ls_body, ls_username, ls_useremail, ls_error
integer li_row
mt_n_outgoingmail lnv_mail 
setnull(ls_useremail)

li_row = dw_distance.getrow()

// Get userid
ls_userid = dw_distance.getitemstring(li_row, "userid")
if isnull(ls_userid) then
	messagebox("No User Available", "There is no user available to notify!")
	return
end If

// Check if table is updated
if dw_distance.modifiedcount( ) + dw_distance.deletedcount( ) > 0 then
	messagebox("Table modified", "The table has been modified. Please save the table before notifying the user.")
	return
end if

// Check distance is entered
if dw_distance.getitemnumber(li_Row, "distance") <= 0.0 then
	messagebox("Distance Required", "The distance must be non-zero!")
	return	
end if

if messagebox("Confirm Notification", "Are you sure you want to send a notification to the user " + ls_UserID + "?", Question!, YesNo!) = 2 then return

SELECT FIRST_NAME, EMAIL INTO :ls_username, :ls_useremail FROM USERS WHERE USERID = :ls_userid;

commit;

lnv_mail = create mt_n_outgoingmail

if isnull(ls_useremail) then 
	ls_useremail = ls_userid + C#EMAIL.DOMAIN
end if

ls_body = "Good day " + ls_username + ",~r~n~r~nThe following distance you requested for is now available in Tramos:~r~n~r~n"
ls_body += dw_distance.getitemstring(li_row, "from_name") + "   to   " + dw_distance.getitemstring(li_row, "to_name") + "   =   " + string(dw_distance.getitemnumber(li_row, "distance"), "0.0") + " nautical miles~r~n~r~n"
ls_body += "To update Tramos without re-starting, select 'System Tables' > 'Refresh Cached Tables'.~r~n~r~n"
ls_body += "Best Regards,~r~nTramos System Admin~r~n~r~n[This is a system-generated mail. Do not reply to this mail. If you received this mail in error, please contact " + C#EMAIL.TRAMOSSUPPORT + "]"

If lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_useremail, "Distance Updated", ls_body, ls_error) > 0 then
	If lnv_mail.of_sendmail(ls_error) < 0 then
		messagebox("Mail Error", "Unable to send email. Error reported: " + ls_error)
	Else
		messagebox("Mail Sent", "Mail to user was sent successfully!")		
	End If
End If

destroy lnv_mail

end event

type st_1 from statictext within w_local_atobviac_distance
integer x = 37
integer y = 28
integer width = 2633
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "When the AtoBviaC distance table  don~'t have a direct distance  available for requested ports, the below distances will be used. If distance in below table is zero, the distance request has already been sent to AtoBviaC."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_local_atobviac_distance
integer x = 2345
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;
Close(parent)
end event

type cb_cancel from commandbutton within w_local_atobviac_distance
integer x = 1074
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "C&ancel"
end type

event clicked;dw_distance.event pfc_retrieve( )
dw_distance.post setColumn("from_portid")
dw_distance.post setFocus()
end event

type cb_delete from commandbutton within w_local_atobviac_distance
integer x = 727
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

event clicked;dw_distance.event pfc_deleterow( )
dw_distance.post setFocus()
end event

type cb_update from commandbutton within w_local_atobviac_distance
integer x = 379
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

event clicked;if dw_distance.event pfc_update( true, true) = 1 then
	commit;
else
	rollback;
end if
end event

type cb_new from commandbutton within w_local_atobviac_distance
integer x = 32
integer y = 2024
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&New"
end type

event clicked;dw_distance.scrollToRow(dw_distance.event pfc_Insertrow( ))
dw_distance.post setColumn("from_portid")
dw_distance.post setFocus()
end event

type dw_distance from u_dw within w_local_atobviac_distance
integer x = 37
integer y = 156
integer width = 2651
integer height = 1840
integer taborder = 20
string dataobject = "d_sq_tb_local_atobviac_distance"
end type

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event constructor;call super::constructor;this.setTransObject(SQLCA)
this.of_SetDropDownSearch( true )
this.inv_dropdownsearch.of_Register()

end event

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

