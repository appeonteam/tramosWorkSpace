$PBExportHeader$w_cms_unlock.srw
$PBExportComments$Used to unlock file transfer functionallity.
forward
global type w_cms_unlock from mt_w_response
end type
type cb_unlock from commandbutton within w_cms_unlock
end type
type cb_close from commandbutton within w_cms_unlock
end type
type dw_cms_unlock from u_datawindow_sqlca within w_cms_unlock
end type
end forward

global type w_cms_unlock from mt_w_response
integer x = 832
integer y = 360
integer width = 1906
integer height = 812
string title = "Unlock"
long backcolor = 81324524
cb_unlock cb_unlock
cb_close cb_close
dw_cms_unlock dw_cms_unlock
end type
global w_cms_unlock w_cms_unlock

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_cms_unlock
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

on w_cms_unlock.create
int iCurrent
call super::create
this.cb_unlock=create cb_unlock
this.cb_close=create cb_close
this.dw_cms_unlock=create dw_cms_unlock
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_unlock
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_cms_unlock
end on

on w_cms_unlock.destroy
call super::destroy
destroy(this.cb_unlock)
destroy(this.cb_close)
destroy(this.dw_cms_unlock)
end on

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cms_unlock
  
 Object  : 
  
 Event	:  Open

 Scope   : local

 ************************************************************************************

 Author  : Teit Aunt 
   
 Date    : 22-10-97

 Description : 

 Arguments   : None

 Returns     : None

 Variables   : None

 Other : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
22-10-97	1.0		TA		Initial version
  
************************************************************************************/
long ll_rows, ll_access, ll_lock

/* Retrieve data for dw_cms_unlock */
dw_cms_unlock.Retrieve()

/* Determin if unlock button should be enabled */
ll_rows = dw_cms_unlock.RowCount()

/* Admin and finance can unlock */
If ll_rows = 1 And (uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3) Then
	ll_lock = dw_cms_unlock.GetItemNumber(1,"progress_lock")
	If (ll_lock = 1) Then cb_unlock.Enabled = True
End if

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_cms_unlock
end type

type cb_unlock from commandbutton within w_cms_unlock
integer x = 1221
integer y = 564
integer width = 270
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Unlock"
end type

event clicked;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_cms_unlock
 Object  : cb_unlock
 Event	:  clicked
 Scope   : global
 ************************************************************************************
 Author  : Teit Aunt 
 Date    : 22-10-97
 Description : Enable a user to generate a file for transfer in the CMS after this function
 					has been executed.
 Arguments   : None
 Returns     : None
 Variables   : None
 Other : None
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
22-10-97	1.0		TA		Initial version
************************************************************************************/
Integer li_messg
string ls_null
long ll_rows

/* Change the status of a "file being generated" from yes to no */
li_messg = MessageBox("Warning","You must only Unlock if you are 100% sure that &
there is no generation of a Transaction file to CMS/RRIS in progress ! Check if &
in doubt !!! Are you sure you want to unlock ?",Exclamation!,YesNo!,1)

If li_messg = 1 Then
	ll_rows = dw_cms_unlock.RowCount()
	If ll_rows = 0 Then dw_cms_unlock.InsertRow(0)

	SetNull(ls_null)
	dw_cms_unlock.SetItem(1,"progress_user",ls_null)
	dw_cms_unlock.SetItem(1,"progress_lock",0)
	
	if dw_cms_unlock.Update() = 1 then 
		commit;
	else
		rollback;
		MessageBox("Update Error", "Update of unlock failed!")
	end if
	dw_cms_unlock.Retrieve()
End if
end event

type cb_close from commandbutton within w_cms_unlock
integer x = 1550
integer y = 564
integer width = 270
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean default = true
end type

event clicked;Close(parent)
end event

type dw_cms_unlock from u_datawindow_sqlca within w_cms_unlock
integer x = 87
integer y = 52
integer width = 1733
integer height = 464
integer taborder = 10
string dataobject = "d_cms_unlock"
borderstyle borderstyle = stylebox!
end type

