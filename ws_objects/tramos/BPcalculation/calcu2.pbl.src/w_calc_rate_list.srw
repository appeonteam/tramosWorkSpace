$PBExportHeader$w_calc_rate_list.srw
$PBExportComments$Window for updating the rate list
forward
global type w_calc_rate_list from mt_w_response_calc
end type
type dw_ratetype_list from u_datawindow_sqlca within w_calc_rate_list
end type
type cb_new from uo_cb_base within w_calc_rate_list
end type
type cb_delete from uo_cb_base within w_calc_rate_list
end type
type cb_close from uo_cb_base within w_calc_rate_list
end type
type cb_save from uo_cb_base within w_calc_rate_list
end type
type st_norows from statictext within w_calc_rate_list
end type
type gb_1 from uo_gb_base within w_calc_rate_list
end type
end forward

global type w_calc_rate_list from mt_w_response_calc
integer width = 1381
integer height = 1060
string title = "Load/Discharge Types"
dw_ratetype_list dw_ratetype_list
cb_new cb_new
cb_delete cb_delete
cb_close cb_close
cb_save cb_save
st_norows st_norows
gb_1 gb_1
end type
global w_calc_rate_list w_calc_rate_list

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_calc_rate_list
	
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
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves data into the DW_RATETYPE_LIST

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_ratetype_list.Retrieve()
COMMIT;
end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Update the button's enabled status depending on the user's access
 					level and posts a retrieve event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

/* Administrator and Charterer */
if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 1 then
	cb_delete.enabled = true
	cb_new.enabled = true
	cb_save.enabled = true
else
	cb_delete.enabled = false
	cb_new.enabled = false
	cb_save.enabled = false
end if	

// and post the retrieve event
PostEvent("ue_retrieve")

end event

on w_calc_rate_list.create
int iCurrent
call super::create
this.dw_ratetype_list=create dw_ratetype_list
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.cb_save=create cb_save
this.st_norows=create st_norows
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ratetype_list
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.st_norows
this.Control[iCurrent+7]=this.gb_1
end on

on w_calc_rate_list.destroy
call super::destroy
destroy(this.dw_ratetype_list)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.st_norows)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_rate_list
end type

type dw_ratetype_list from u_datawindow_sqlca within w_calc_rate_list
integer x = 55
integer y = 64
integer width = 1243
integer height = 640
integer taborder = 20
string dataobject = "d_calc_ratetype_list"
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the number of rows in the textfield below the datawindow

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_rows 

ll_rows = This.RowCount()
If IsNull(ll_rows) Then ll_rows = 0
st_norows.text = String(ll_rows) +" row(s)"
end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Enables the save button if the user got sufficient rights

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

//If uo_global.ii_access_level > 1 Then cb_save.enabled = true
if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 1 then  cb_save.enabled = true
end event

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Enables the delete button if the user got sufficient rights

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

//If uo_global.ii_access_level > 1 Then cb_delete.enabled = true
if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 1 then  cb_delete.enabled = true

end event

type cb_new from uo_cb_base within w_calc_rate_list
integer x = 55
integer y = 816
integer taborder = 30
string text = "&New"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Inserts a new row into the DW_RATETYPE_WINDOW

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row

// Insert the row and scroll to it
ll_row = dw_ratetype_list.InsertRow(0)
dw_ratetype_list.ScrollToRow(ll_row)
// Set default values into the MDTH and set the focus to description
dw_ratetype_list.SetItem(ll_row, "cal_raty_mtdh", 1)
dw_ratetype_list.SetFocus()
dw_ratetype_list.SetColumn("cal_raty_description")

// enable the save and delete buttons
cb_save.enabled = true
cb_delete.enabled = true

end event

type cb_delete from uo_cb_base within w_calc_rate_list
integer x = 329
integer y = 816
integer taborder = 40
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Deletes the current row from the DW_RATETYPE_LIST

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row, ll_tmp

// Get the user to acknowledge the deletion
ll_tmp = MessageBox("Warning","You are about to delete! Continue?",StopSign!,YesNo!)


CHOOSE CASE ll_tmp
	CASE 1
		// Get the row that's to be deleted, and check it's above zero
		ll_row = dw_ratetype_list.GetRow()
		If ll_row > 0 Then
			// Ok, delete the row and set the SAVE button enabled
			dw_ratetype_list.DeleteRow(ll_row)
			cb_save.enabled = true

			// Jump to prior row 
			If ll_row > 1 Then ll_row --
			If ll_row <= dw_ratetype_list.RowCount() Then
				dw_ratetype_list.SetRow(ll_row)
				dw_ratetype_list.SetFocus()
			Else
				// Disable the delete button if no more rows
				cb_delete.enabled = false
			End if
		End if
	CASE 2
		// Do nothing!
END CHOOSE

end event

type cb_close from uo_cb_base within w_calc_rate_list
integer x = 1061
integer y = 816
integer taborder = 60
string text = "&Close"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the ratetype window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type cb_save from uo_cb_base within w_calc_rate_list
integer x = 786
integer y = 816
integer taborder = 50
boolean enabled = false
string text = "&Save"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Saves the changes to the DW_RATETYPE_LIST to the database

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Save the changes to the database. If OK the COMMIT and re-retrieve data,
// otherwise rollback
If dw_ratetype_list.Update(True,True)=1 Then
	COMMIT;

	cb_save.enabled = false
	Open(w_updated)
	Parent.TriggerEvent("ue_retrieve")
Else
	ROLLBACK USING SQLCA;
End if

// Set the focus back to the datawindow
dw_ratetype_list.SetFocus()
end event

type st_norows from statictext within w_calc_rate_list
integer x = 933
integer y = 704
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from uo_gb_base within w_calc_rate_list
integer x = 18
integer width = 1317
integer height = 784
integer taborder = 10
long backcolor = 81324524
string text = ""
end type

