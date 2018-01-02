$PBExportHeader$w_chart_comment_popup.srw
$PBExportComments$Used in connection with charterer comments
forward
global type w_chart_comment_popup from mt_w_response
end type
type cb_update from commandbutton within w_chart_comment_popup
end type
type cb_close from commandbutton within w_chart_comment_popup
end type
type dw_comment from datawindow within w_chart_comment_popup
end type
end forward

global type w_chart_comment_popup from mt_w_response
integer width = 1883
integer height = 1696
string title = "Charterer Comment"
long backcolor = 32304364
cb_update cb_update
cb_close cb_close
dw_comment dw_comment
end type
global w_chart_comment_popup w_chart_comment_popup

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_chart_comment_popup
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_chart_comment_popup.create
int iCurrent
call super::create
this.cb_update=create cb_update
this.cb_close=create cb_close
this.dw_comment=create dw_comment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_update
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_comment
end on

on w_chart_comment_popup.destroy
call super::destroy
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.dw_comment)
end on

event open;s_chart_comment_parm		lstr_parm 

lstr_parm = Message.PowerObjectParm

if lstr_parm.chart_nr then
	dw_comment.dataobject = "d_chart_comment_chartnr"
else
	dw_comment.dataobject = "d_chart_comment_calcid"
end if
dw_comment.settransobject(sqlca)
dw_comment.post retrieve(lstr_parm.recID )

//Timer(5)



end event

event timer;Timer(0)
Close(This)
end event

event closequery;dw_comment.accepttext( )
if dw_comment.modifiedcount( ) > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to close window without saving?",Question!,YesNo!,2)=2 then
		// prevent
		return 1
	else
		//allow
		RETURN 0
	end if
else
	//allow
	return 0
end if
end event

type cb_update from commandbutton within w_chart_comment_popup
integer x = 1152
integer y = 1488
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;dw_comment.accepttext( )
if dw_comment.update() = 1 then
	commit;
	close(parent)
else
	MessageBox("Update failed", "Update of Charterer Comments failed!")
	rollback;
end if
end event

type cb_close from commandbutton within w_chart_comment_popup
integer x = 1509
integer y = 1488
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_comment from datawindow within w_chart_comment_popup
integer width = 1856
integer height = 1464
integer taborder = 10
string title = "none"
string dataobject = "d_chart_comment_chartnr"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

