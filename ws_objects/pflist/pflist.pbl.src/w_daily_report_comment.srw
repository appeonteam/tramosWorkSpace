$PBExportHeader$w_daily_report_comment.srw
forward
global type w_daily_report_comment from w_events_pcgroup
end type
type uo_pcgroup from u_pcgroup within w_daily_report_comment
end type
type cb_clear from mt_u_commandbutton within w_daily_report_comment
end type
type cb_reset from mt_u_commandbutton within w_daily_report_comment
end type
type cb_save from mt_u_commandbutton within w_daily_report_comment
end type
type cb_close from mt_u_commandbutton within w_daily_report_comment
end type
type dw_comment from datawindow within w_daily_report_comment
end type
end forward

global type w_daily_report_comment from w_events_pcgroup
integer width = 2176
integer height = 916
string title = "Daily Report Comments"
uo_pcgroup uo_pcgroup
cb_clear cb_clear
cb_reset cb_reset
cb_save cb_save
cb_close cb_close
dw_comment dw_comment
end type
global w_daily_report_comment w_daily_report_comment

type variables
integer ii_pcgroup
end variables

on w_daily_report_comment.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_clear=create cb_clear
this.cb_reset=create cb_reset
this.cb_save=create cb_save
this.cb_close=create cb_close
this.dw_comment=create dw_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_clear
this.Control[iCurrent+3]=this.cb_reset
this.Control[iCurrent+4]=this.cb_save
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.dw_comment
end on

on w_daily_report_comment.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_clear)
destroy(this.cb_reset)
destroy(this.cb_save)
destroy(this.cb_close)
destroy(this.dw_comment)
end on

event open;
ii_pcgroup=uo_pcgroup.uf_getpcgroup( )

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	dw_comment.settransobject(SQLCA)
	dw_comment.retrieve(ii_pcgroup)
end if
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;
ii_pcgroup=ai_pcgroupid

dw_comment.settransobject(SQLCA)
dw_comment.retrieve(ii_pcgroup)
return 0
end event

type st_hidemenubar from w_events_pcgroup`st_hidemenubar within w_daily_report_comment
end type

type uo_pcgroup from u_pcgroup within w_daily_report_comment
integer x = 23
integer y = 16
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_clear from mt_u_commandbutton within w_daily_report_comment
integer x = 1426
integer y = 688
integer taborder = 30
string facename = "Arial"
string text = "&Clear"
end type

event clicked;dw_comment.clear( )
dw_comment.setfocus( )
end event

type cb_reset from mt_u_commandbutton within w_daily_report_comment
integer x = 1083
integer y = 688
integer taborder = 30
string facename = "Arial"
string text = "&Reset"
end type

event clicked;dw_comment.retrieve(ii_pcgroup)
dw_comment.setfocus( )
end event

type cb_save from mt_u_commandbutton within w_daily_report_comment
integer x = 741
integer y = 688
integer taborder = 30
string facename = "Arial"
string text = "&Save"
end type

event clicked;if  dw_comment.rowcount( ) <> 0 then
	dw_comment.acceptText()
	if dw_comment.update() = 1 then
		commit;
		dw_comment.retrieve(ii_pcgroup)
		dw_comment.setfocus( )
	else
		rollback;
		MessageBox("Update Error", "Error updating comment.")
		return -1
	end if
end if
end event

type cb_close from mt_u_commandbutton within w_daily_report_comment
integer x = 1769
integer y = 688
integer taborder = 30
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_comment from datawindow within w_daily_report_comment
integer x = 18
integer y = 192
integer width = 2098
integer height = 476
integer taborder = 10
string title = "none"
string dataobject = "d_daily_report_comment"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

