$PBExportHeader$w_calc_dist.srw
$PBExportComments$Distance-liste maintaince window
forward
global type w_calc_dist from mt_w_sheet_calc
end type
type dw_calc_dist from u_datawindow_sqlca within w_calc_dist
end type
type cb_new from uo_cb_base within w_calc_dist
end type
type cb_delete from uo_cb_base within w_calc_dist
end type
type cb_close from uo_cb_base within w_calc_dist
end type
type dw_shared_ports from u_datawindow_sqlca within w_calc_dist
end type
type cb_save from uo_cb_base within w_calc_dist
end type
type st_no_rows from uo_st_base within w_calc_dist
end type
type gb_1 from uo_gb_base within w_calc_dist
end type
end forward

global type w_calc_dist from mt_w_sheet_calc
integer width = 1550
integer height = 1048
string title = "Distance Table"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
dw_calc_dist dw_calc_dist
cb_new cb_new
cb_delete cb_delete
cb_close cb_close
dw_shared_ports dw_shared_ports
cb_save cb_save
st_no_rows st_no_rows
gb_1 gb_1
end type
global w_calc_dist w_calc_dist

type variables

end variables

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves data for the DW_CALC_DIST datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Retrieve the data
dw_calc_dist.Retrieve()
COMMIT;

// And disable all edit-buttons if access-level is inappropriate
If uo_global.ii_access_level< 2 Then
	cb_delete.enabled = false
	cb_new.enabled = false
	cb_save.enabled = false
End if


end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This window enables the user to insert or delete TRAMOS distances

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DataWindowChild dwc_tmp
Boolean lb_result

// Center the window on the screen
f_Center_window(This)

// Share the from & to distance datawindow childs to the DW_CALC_PORT_DDDW. NOTE:
// these childs cannot be shared to the DW_CALC_PORT_DDDW in the W_SHARE, because
// these datawindows uses the TRAMOS 3-letter portcode
dw_calc_dist.GetChild("cal_dist_from", dwc_tmp)
lb_result = uf_sharechild("dw_calc_port_dddw", dwc_tmp) <> 1
if lb_result Then MessageBox("Error", "Error sharing dist from port code")

dw_calc_dist.GetChild("cal_dist_to", dwc_tmp)
lb_result = uf_sharechild("dw_calc_port_dddw", dwc_tmp) <> 1

// Post the retrieve event
PostEvent("ue_retrieve")
end event

on w_calc_dist.create
int iCurrent
call super::create
this.dw_calc_dist=create dw_calc_dist
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.dw_shared_ports=create dw_shared_ports
this.cb_save=create cb_save
this.st_no_rows=create st_no_rows
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calc_dist
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.dw_shared_ports
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.st_no_rows
this.Control[iCurrent+8]=this.gb_1
end on

on w_calc_dist.destroy
call super::destroy
destroy(this.dw_calc_dist)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.dw_shared_ports)
destroy(this.cb_save)
destroy(this.st_no_rows)
destroy(this.gb_1)
end on

type dw_calc_dist from u_datawindow_sqlca within w_calc_dist
integer x = 55
integer y = 64
integer width = 1134
integer height = 784
integer taborder = 70
string dataobject = "d_calc_dist"
boolean vscrollbar = true
end type

on retrieveend;call u_datawindow_sqlca::retrieveend;Long ll_rows 

ll_rows = This.RowCount()
If IsNull(ll_rows) Then ll_rows = 0
st_no_rows.text = String(ll_rows) +" row(s)"
end on

on itemchanged;call u_datawindow_sqlca::itemchanged;If uo_global.ii_access_level >= 2 Then cb_save.enabled = true
end on

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles clicked events, by enabling the DELETE button (if the user
 					has appropriate access level)

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If uo_global.ii_access_level >= 2 Then cb_delete.enabled = true
end event

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;If uo_global.ii_access_level >= 2 Then cb_delete.enabled = true
end on

type cb_new from uo_cb_base within w_calc_dist
integer x = 1207
integer y = 64
integer height = 108
integer taborder = 60
string text = "&New"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Inserts a new row in the DW_CALC_DIST datawindow, and enables the 
 					save and delete buttons

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row

ll_row = dw_calc_dist.InsertRow(0)
dw_calc_dist.ScrollToRow(ll_row)
dw_calc_dist.SetFocus()

cb_save.enabled = true
cb_delete.enabled = true


end event

type cb_delete from uo_cb_base within w_calc_dist
integer x = 1207
integer y = 192
integer height = 108
integer taborder = 50
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Deletes current row from the DW_CALC_DIST datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row

ll_row = dw_calc_dist.GetRow()
If ll_row > 0 Then
	
	// Delete the row, and enable the save button
	dw_calc_dist.DeleteRow(ll_row)
	cb_save.enabled = true
	
	// Set focus to prior row (or next if no prior)
	If ll_row > 1 Then ll_row --
	If ll_row <= dw_calc_dist.RowCount() Then
		dw_calc_dist.SetRow(ll_row)
		dw_calc_dist.SetFocus()
	Else
		// Disable the deletebutton
		cb_delete.enabled = false
	End if
End if


end event

type cb_close from uo_cb_base within w_calc_dist
integer x = 1207
integer y = 736
integer height = 108
integer taborder = 40
string text = "&Close"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type dw_shared_ports from u_datawindow_sqlca within w_calc_dist
boolean visible = false
integer x = 1225
integer y = 384
integer width = 183
integer height = 128
integer taborder = 30
string dataobject = "d_calc_port_dddw"
end type

type cb_save from uo_cb_base within w_calc_dist
integer x = 1207
integer y = 608
integer height = 108
integer taborder = 10
boolean enabled = false
string text = "&Save"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Saves the changes in to DW_CALC_DIST datawindow to the database

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_dist.accepttext()

If dw_calc_dist.Update()=1 Then
	Open(w_updated)
	COMMIT;
Else
	ROLLBACK;
End if
end event

type st_no_rows from uo_st_base within w_calc_dist
integer x = 512
integer y = 592
integer height = 72
end type

type gb_1 from uo_gb_base within w_calc_dist
integer x = 18
integer width = 1481
integer height = 928
integer taborder = 20
long backcolor = 81324524
string text = ""
end type

