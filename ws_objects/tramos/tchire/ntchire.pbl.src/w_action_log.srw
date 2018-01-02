$PBExportHeader$w_action_log.srw
$PBExportComments$Window for Action Log (accessed from Main TC Hire window)
forward
global type w_action_log from mt_w_response
end type
type cb_insert from commandbutton within w_action_log
end type
type cb_close from commandbutton within w_action_log
end type
type cb_cancel from commandbutton within w_action_log
end type
type dw_action_log from datawindow within w_action_log
end type
end forward

global type w_action_log from mt_w_response
integer width = 3264
integer height = 1756
string title = "Action Log"
string icon = "images\action_log.ico"
event ue_dwgotfocus ( datawindow adw_control )
cb_insert cb_insert
cb_close cb_close
cb_cancel cb_cancel
dw_action_log dw_action_log
end type
global w_action_log w_action_log

type variables
long il_contract_id
datawindow	idw_current
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_dwgotfocus(datawindow adw_control);//////////////////////////////////////////////////////////////////////////////
//
//	Event:  ue_dwgotfocus
//
//	Arguments:
//	adw_control   Datawindow Control which just got focus
//
//	Returns:  none
//
//	Description:
//	Keeps track of last active DataWindow
//
//////////////////////////////////////////////////////////////////////////////

If adw_control.TypeOf() = DataWindow! Then
	idw_current = adw_control
End If
end event

public subroutine documentation ();/********************************************************************
	w_action_log
	
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
	</HISTORY>
********************************************************************/
end subroutine

on w_action_log.create
int iCurrent
call super::create
this.cb_insert=create cb_insert
this.cb_close=create cb_close
this.cb_cancel=create cb_cancel
this.dw_action_log=create dw_action_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_insert
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_action_log
end on

on w_action_log.destroy
call super::destroy
destroy(this.cb_insert)
destroy(this.cb_close)
destroy(this.cb_cancel)
destroy(this.dw_action_log)
end on

event open;call super::open;move(0,0)
il_contract_id = message.doubleparm

dw_action_log.settransobject(SQLCA)
dw_action_log.setrowfocusindicator( focusRect!)
dw_action_log.POST retrieve(il_contract_id)

end event

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_action_log
end type

type cb_insert from commandbutton within w_action_log
integer x = 27
integer y = 1560
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&New"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_action_log.insertrow(0)

/* Set default values - i.e. set the contract ID, user ID and date*/
dw_action_log.setitem(ll_row, "contract_id",il_contract_id) 
dw_action_log.setItem(ll_row, "userid", uo_global.is_userid)
dw_action_log.setitem(ll_row, "action_date", Today())
/*-----*/
dw_action_log.setfocus()
dw_action_log.scrollToRow(ll_row)

end event

type cb_close from commandbutton within w_action_log
integer x = 2432
integer y = 1560
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;long ll_counter
string ls_comment

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_action_log.modifiedcount() > 0 then //Data has been modified - update and close
	dw_action_log.accepttext()
	//First check that the Comment field has been filled out
	for ll_counter = 1 to dw_action_log.rowcount()
		ls_comment = dw_action_log.getitemString(ll_counter,"comment")
			if IsNull(ls_comment) then
				MessageBox("Validation Error", "Please fill out the mandatory field Comment")
				dw_action_log.setfocus()
				return
			end if
	next
	//Validation check is finish - GO UPDATE!
	if dw_action_log.update() = 1 then
		commit;
		close(parent)
	else //update went wrong for some reason
		MessageBox("Database Update Error", "Data has not been updated. ~r~rPlease "+&
					  "try again, or contact the system administrator.~r~r" + SQLCA.SQLErrText)
		rollback;
		return
	end if //update = 1
else //Data has not been modified, so the window will be closed straight away
	close(parent)
end if
end event

type cb_cancel from commandbutton within w_action_log
integer x = 2871
integer y = 1560
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type dw_action_log from datawindow within w_action_log
integer x = 27
integer y = 32
integer width = 3186
integer height = 1484
integer taborder = 10
string title = "Action Log"
string dataobject = "d_action_log"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

