$PBExportHeader$w_cms_elec_file_log.srw
$PBExportComments$Window opened from the File history button in transaction log. Shows generated files.
forward
global type w_cms_elec_file_log from mt_w_response
end type
type st_found from statictext within w_cms_elec_file_log
end type
type cb_close from commandbutton within w_cms_elec_file_log
end type
type dw_cms_elec_file_log from u_datawindow_sqlca within w_cms_elec_file_log
end type
end forward

global type w_cms_elec_file_log from mt_w_response
integer x = 832
integer y = 360
integer width = 1166
integer height = 1360
string title = "Electronic file log"
long backcolor = 81324524
st_found st_found
cb_close cb_close
dw_cms_elec_file_log dw_cms_elec_file_log
end type
global w_cms_elec_file_log w_cms_elec_file_log

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_cms_elec_file_log
	
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

on w_cms_elec_file_log.create
int iCurrent
call super::create
this.st_found=create st_found
this.cb_close=create cb_close
this.dw_cms_elec_file_log=create dw_cms_elec_file_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_found
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_cms_elec_file_log
end on

on w_cms_elec_file_log.destroy
call super::destroy
destroy(this.st_found)
destroy(this.cb_close)
destroy(this.dw_cms_elec_file_log)
end on

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cms_elec_file_log
  
 Object  : 
  
 Event	:  Open

 Scope   : local

 ************************************************************************************

 Author  : Teit Aunt 
   
 Date    : 28-10-97

 Description : 

 Arguments   : None

 Returns     : None

 Variables   : None

 Other : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
28-10-97	1.0		TA		Initial version
  
************************************************************************************/
long ll_cms_rris_key, ll_rows, ll_key, ll_tmp
boolean lb_found

/* Get retrieveal value */
lb_found = false
ll_tmp = 1
ll_cms_rris_key = Message.DoubleParm

dw_cms_elec_file_log.Retrieve()

ll_rows = dw_cms_elec_file_log.RowCount()
If (ll_rows > 0) and (ll_cms_rris_key > 0) Then
	DO
		ll_key = dw_cms_elec_file_log.GetItemNumber(ll_tmp,"cms_rris_key")
		If ll_key = ll_cms_rris_key Then
			dw_cms_elec_file_log.SelectRow(ll_tmp,True)
			dw_cms_elec_file_log.ScrollToRow(ll_tmp)
			lb_found = true
			st_found.Text = "Entry found"
		End if
		ll_tmp ++
		If ll_tmp = ll_rows Then 
			lb_found = True
			st_found.Text = "No previouse history"
		End if
	LOOP UNTIL lb_found
End if

If (ll_rows = 0) And (ll_cms_rris_key > 0) Then st_found.Text = "No rows"
	
If (ll_cms_rris_key = 0) Then st_found.Text = "All rows retrieved"

end event

type st_found from statictext within w_cms_elec_file_log
integer x = 41
integer y = 1032
integer width = 1074
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_cms_elec_file_log
integer x = 873
integer y = 1136
integer width = 247
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean default = true
end type

event clicked;Close(Parent)
end event

type dw_cms_elec_file_log from u_datawindow_sqlca within w_cms_elec_file_log
integer x = 46
integer y = 36
integer width = 1074
integer height = 992
boolean enabled = false
string dataobject = "d_cms_elec_file_log"
boolean vscrollbar = true
end type

event clicked;call super::clicked;ib_auto = true
end event

event rowfocuschanged;call super::rowfocuschanged;st_found.Text = ""
end event

