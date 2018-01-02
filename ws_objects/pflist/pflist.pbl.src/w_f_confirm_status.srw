$PBExportHeader$w_f_confirm_status.srw
$PBExportComments$Replaces old popup with window. This will appear if user updates a fixture.  1. It will ask the user if they want to copy fixture to cargo list (default Yes). 2. it will ask the user to provide a reason why the fixture failed.
forward
global type w_f_confirm_status from mt_w_response
end type
type cb_cancel from mt_u_commandbutton within w_f_confirm_status
end type
type st_1 from mt_u_statictext within w_f_confirm_status
end type
type cb_ok from mt_u_commandbutton within w_f_confirm_status
end type
type dw_failedreason from mt_u_datawindow within w_f_confirm_status
end type
end forward

global type w_f_confirm_status from mt_w_response
integer width = 1115
integer height = 1072
string title = "Failed Fixture"
boolean controlmenu = false
cb_cancel cb_cancel
st_1 st_1
cb_ok cb_ok
dw_failedreason dw_failedreason
end type
global w_f_confirm_status w_f_confirm_status

type variables
constant integer ii_FailedStatus=103, ii_CancelledStatus=101, ii_ReleasedStatus=107, ii_DeletedStatus=114
s_status istr_fixture
constant integer ii_DefaultReason=15
end variables

on w_f_confirm_status.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.cb_ok=create cb_ok
this.dw_failedreason=create dw_failedreason
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_failedreason
end on

on w_f_confirm_status.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.dw_failedreason)
end on

event open;call super::open;long li_heightY=0

istr_fixture = Message.powerobjectparm
dw_FailedReason.settransobject(sqlca)
dw_FailedReason.retrieve(istr_fixture.l_id)



dw_failedreason.setitem(1,"rsnid",ii_DefaultReason)
dw_failedreason.setitem(1,"rsn_comment","")

if dw_failedreason.rowcount()>0 then
	this.title = "Failed Fixture #"+string(istr_fixture.l_id)
	dw_failedreason.visible=true		
	li_heightY+=dw_failedreason.height
else
	this.title = "Failed Competitor Fixture"			
end if
if istr_fixture.i_statusid=ii_failedstatus then	
	st_1.y = li_heightY + 25
	li_heightY+=st_1.height
else
	st_1.visible=false
	cb_cancel.visible=false
	cb_ok.text="Ok"
end if

height = li_heightY + 275
cb_cancel.y = height - 250
cb_ok.y = height - 250

end event

type cb_cancel from mt_u_commandbutton within w_f_confirm_status
integer x = 731
integer y = 592
integer taborder = 30
string text = "No"
end type

event clicked;call super::clicked;dw_failedreason.accepttext()

if dw_failedreason.rowcount()>0 then
	istr_fixture.i_reasoncode= dw_failedreason.getitemnumber(1,"rsnid")
	istr_fixture.s_comment=dw_failedreason.getitemstring(1,"rsn_comment")
end if
istr_fixture.b_copytocargolist=false
closewithreturn(Parent,istr_fixture)
end event

type st_1 from mt_u_statictext within w_f_confirm_status
integer x = 37
integer y = 384
integer width = 1042
integer height = 128
string text = "You have failed this fixture.  Do you want to copy the record into the cargo list?"
end type

type cb_ok from mt_u_commandbutton within w_f_confirm_status
integer x = 18
integer y = 592
integer taborder = 20
string text = "Yes"
boolean default = true
end type

event clicked;call super::clicked;dw_failedreason.accepttext()
//
//if dw_failedreason.rowcount()>0 then
//	istr_fixture.i_reasoncode = dw_failedreason.getitemnumber(1,"rsnid")
//	istr_fixture.s_comment = dw_failedreason.getitemstring(1,"rsn_comment")
//end if
//

if dw_failedreason.rowcount()>0 then
	istr_fixture.i_reasoncode = dw_failedreason.getitemnumber(1,"rsnid")
	istr_fixture.s_comment = dw_failedreason.getitemstring(1,"rsn_comment")
end if
if istr_fixture.i_statusid<>ii_FailedStatus then istr_fixture.b_copytocargolist=false
closewithreturn(Parent,istr_fixture)
end event

type dw_failedreason from mt_u_datawindow within w_f_confirm_status
boolean visible = false
integer x = 37
integer width = 1042
integer height = 368
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_tb_f_reason_failed"
boolean border = false
end type

