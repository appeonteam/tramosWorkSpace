$PBExportHeader$w_select_cp.srw
forward
global type w_select_cp from mt_w_response
end type
type st_3 from statictext within w_select_cp
end type
type st_2 from statictext within w_select_cp
end type
type st_1 from statictext within w_select_cp
end type
type cb_cancel from commandbutton within w_select_cp
end type
type cb_choose from commandbutton within w_select_cp
end type
type dw_cp_info from datawindow within w_select_cp
end type
end forward

global type w_select_cp from mt_w_response
integer width = 2843
integer height = 1052
string title = "Select CP"
boolean controlmenu = false
boolean contexthelp = true
st_3 st_3
st_2 st_2
st_1 st_1
cb_cancel cb_cancel
cb_choose cb_choose
dw_cp_info dw_cp_info
end type
global w_select_cp w_select_cp

type variables
Private Long il_cp
Private s_cp_id_add_comm istr_cp_comm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_select_cp
	
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

on w_select_cp.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_choose=create cb_choose
this.dw_cp_info=create dw_cp_info
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_choose
this.Control[iCurrent+6]=this.dw_cp_info
end on

on w_select_cp.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_choose)
destroy(this.dw_cp_info)
end on

event open;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/
s_cp_id lstr_cp_id

lstr_cp_id = Message.PowerObjectParm

dw_cp_info.SetTransObject(SQLCA)
dw_cp_info.Retrieve(lstr_cp_id.cp_id[])
end event

event close;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/
CloseWithReturn(w_select_cp, istr_cp_comm)
end event

event activate;m_tramosmain.mf_setcalclink(False)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_cp
end type

type st_3 from statictext within w_select_cp
integer x = 23
integer y = 112
integer width = 2208
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please select the C/P which must be used in the automatic calculation of commission."
boolean focusrectangle = false
end type

type st_2 from statictext within w_select_cp
integer x = 23
integer y = 188
integer width = 1495
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "To choose C/P select any broker under the according C/P:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_select_cp
integer x = 23
integer y = 28
integer width = 1609
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "There is more than one C/P with the relevant charterer name."
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_select_cp
integer x = 2459
integer y = 836
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/
istr_cp_comm.cp_id = 0
istr_cp_comm.add_comm = 0

CloseWithReturn(Parent, istr_cp_comm)
//Close(Parent)
end event

type cb_choose from commandbutton within w_select_cp
integer x = 2089
integer y = 836
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&hoose"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/

istr_cp_comm.cp_id = dw_cp_info.GetItemNumber(dw_cp_info.GetRow(), "cal_cerp_cal_cerp_id")
istr_cp_comm.add_comm = dw_cp_info.GetItemNumber(dw_cp_info.GetRow(), "cal_cerp_cal_cerp_add_comm")

CloseWithReturn(Parent, istr_cp_comm)

//Close(Parent)
end event

type dw_cp_info from datawindow within w_select_cp
integer x = 18
integer y = 272
integer width = 2779
integer height = 528
integer taborder = 10
string dataobject = "d_cp_info"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/
If Row > 0 Then 
	This.SelectRow(0, False)
	This.SelectRow(Row, True)
	This.ScrollToRow(Row)
	This.SetRow(Row)	
End if

Parent.cb_choose.TriggerEvent(Clicked!)
end event

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
18-06-2001  1.0	DOM	Initial version. 
************************************************************************************/

If Row > 0 Then 
	This.SelectRow(0, False)
	This.SelectRow(Row, True)
	This.ScrollToRow(Row)
	This.SetRow(Row)	
End if
end event

