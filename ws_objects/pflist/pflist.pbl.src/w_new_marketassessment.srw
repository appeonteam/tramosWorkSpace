$PBExportHeader$w_new_marketassessment.srw
forward
global type w_new_marketassessment from window
end type
type cb_update from mt_u_commandbutton within w_new_marketassessment
end type
type cb_cancel from mt_u_commandbutton within w_new_marketassessment
end type
type dw_new_marketassessment from datawindow within w_new_marketassessment
end type
end forward

global type w_new_marketassessment from window
integer width = 1211
integer height = 1332
boolean titlebar = true
string title = "New  Market Assessment"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_update cb_update
cb_cancel cb_cancel
dw_new_marketassessment dw_new_marketassessment
end type
global w_new_marketassessment w_new_marketassessment

type variables
s_pf 		istr_marketassessment
end variables

on w_new_marketassessment.create
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_new_marketassessment=create dw_new_marketassessment
this.Control[]={this.cb_update,&
this.cb_cancel,&
this.dw_new_marketassessment}
end on

on w_new_marketassessment.destroy
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_new_marketassessment)
end on

event open;datawindowchild	ldwc
long 					ll_row

istr_marketassessment = message.powerobjectparm
dw_new_marketassessment.setTransObject(SQLCA)


if istr_marketassessment.pc_nr[1] = 4 then
	dw_new_marketassessment.height = 1056
	cb_update.y = 1100
	cb_cancel.y = 1100
	this.height = 1380
else
	dw_new_marketassessment.height = 650
	cb_update.y = 700
	cb_cancel.y = 700
	this.height = 960
end if
this.width = 1200
this.move(0,100)

/* retrieve DDDW - trade*/
dw_new_marketassessment.getchild("tradeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_marketassessment.pc_nr)
/* retrieve DDDW - cargo*/
dw_new_marketassessment.getchild("cargoid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_marketassessment.pc_nr)

dw_new_marketassessment.retrieve(0)
ll_row = dw_new_marketassessment.InsertRow(0)
if ll_row < 1 then return
dw_new_marketassessment.setitem( 1,"pc_nr",istr_marketassessment.pc_nr[1])
dw_new_marketassessment.setitem( 1,"activated",1)



end event

event closequery;dw_new_marketassessment.accepttext()
if dw_new_marketassessment.modifiedcount() > 0 then
	if MessageBox("Confirmation", "Data Changed but not saved. Close anyway?", question!, YesNo!,2) = 2 then
		dw_new_marketassessment.POST setFocus()
		return 1
	end if
end if
end event

type cb_update from mt_u_commandbutton within w_new_marketassessment
integer x = 338
integer y = 1100
integer width = 402
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Save"
end type

event clicked;call super::clicked;if  dw_new_marketassessment.rowcount( ) <> 0 then
	dw_new_marketassessment.acceptText()
	if dw_new_marketassessment.update() = 1 then
		commit;
		if isValid(w_marketassessment) then	
			w_marketassessment.post event ue_refreshonerow( dw_new_marketassessment.getitemnumber(1, "marketassesmentid") )
		end if
		close(parent)
	else
		MessageBox("Update Error", "Error newing marketassessment.")
		return -1
	end if
end if
end event

type cb_cancel from mt_u_commandbutton within w_new_marketassessment
integer x = 741
integer y = 1100
integer width = 402
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type dw_new_marketassessment from datawindow within w_new_marketassessment
integer x = 32
integer y = 28
integer width = 1111
integer height = 1056
integer taborder = 10
string title = "none"
string dataobject = "d_new_marketassessment"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

