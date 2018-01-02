$PBExportHeader$w_import_expenses_unlock.srw
$PBExportComments$Used to unlock import expenses functionallity.
forward
global type w_import_expenses_unlock from mt_w_response
end type
type cb_unlock from commandbutton within w_import_expenses_unlock
end type
type cb_close from commandbutton within w_import_expenses_unlock
end type
type dw_cms_unlock from u_datawindow_sqlca within w_import_expenses_unlock
end type
end forward

global type w_import_expenses_unlock from mt_w_response
integer x = 832
integer y = 360
integer width = 1906
integer height = 812
string title = "Unlock Import"
long backcolor = 81324524
cb_unlock cb_unlock
cb_close cb_close
dw_cms_unlock dw_cms_unlock
end type
global w_import_expenses_unlock w_import_expenses_unlock

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3708            CCY018        F1 help application coverage 
	28/08/14	CR3781			CCY018		  The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_import_expenses_unlock.create
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

on w_import_expenses_unlock.destroy
call super::destroy
destroy(this.cb_unlock)
destroy(this.cb_close)
destroy(this.dw_cms_unlock)
end on

event open;call super::open;long ll_rows 

/* Retrieve data for dw_cms_unlock */
dw_cms_unlock.Retrieve()

/* Determin if unlock button should be enabled */
ll_rows = dw_cms_unlock.RowCount()

If ll_rows <> 1  Then
	cb_unlock.Enabled = false
End if

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_import_expenses_unlock
end type

type cb_unlock from commandbutton within w_import_expenses_unlock
integer x = 1221
integer y = 564
integer width = 270
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Unlock"
end type

event clicked;Integer li_messg
string ls_null

/* Change the status of a "file being generated" from yes to no */
li_messg = MessageBox("Warning","You must only Unlock if you are 100% sure that &
there is no import of expenses in progress ! Check if &
in doubt !!! Are you sure you want to unlock ?",Exclamation!,YesNo!,1)

If li_messg = 1 Then
	SetNull(ls_null)
	dw_cms_unlock.SetItem(1,"import_user",ls_null)
	if dw_cms_unlock.Update() = 1 then
		commit;
	else
		rollback;
	end if
	dw_cms_unlock.Retrieve()
End if
end event

type cb_close from commandbutton within w_import_expenses_unlock
integer x = 1550
integer y = 564
integer width = 270
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean default = true
end type

event clicked;Close(parent)
end event

type dw_cms_unlock from u_datawindow_sqlca within w_import_expenses_unlock
integer x = 87
integer y = 52
integer width = 1733
integer height = 464
integer taborder = 10
string dataobject = "d_import_expenses_unlock"
end type

