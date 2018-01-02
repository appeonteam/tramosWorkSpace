$PBExportHeader$w_calc_lookup_consumption.srw
$PBExportComments$Consumption lookup for vessel lookup vindow
forward
global type w_calc_lookup_consumption from mt_w_response_calc
end type
type dw_calc_consumption_data from u_datawindow_sqlca within w_calc_lookup_consumption
end type
type dw_calc_consumption_list from u_datawindow_sqlca within w_calc_lookup_consumption
end type
type cb_delete from uo_cb_base within w_calc_lookup_consumption
end type
type cb_new from uo_cb_base within w_calc_lookup_consumption
end type
type cb_save from uo_cb_base within w_calc_lookup_consumption
end type
type gb_1 from uo_gb_base within w_calc_lookup_consumption
end type
type gb_2 from uo_gb_base within w_calc_lookup_consumption
end type
type cb_close from uo_cb_base within w_calc_lookup_consumption
end type
type st_2 from uo_st_base within w_calc_lookup_consumption
end type
end forward

global type w_calc_lookup_consumption from mt_w_response_calc
integer width = 2144
integer height = 1224
string title = "Consumption Lookup"
dw_calc_consumption_data dw_calc_consumption_data
dw_calc_consumption_list dw_calc_consumption_list
cb_delete cb_delete
cb_new cb_new
cb_save cb_save
gb_1 gb_1
gb_2 gb_2
cb_close cb_close
st_2 st_2
end type
global w_calc_lookup_consumption w_calc_lookup_consumption

type variables
Private s_calc_vessel_id istr_calc_vessel_id
end variables

forward prototypes
public function boolean wf_save ()
public subroutine documentation ()
end prototypes

public function boolean wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_consumption
  
 Object     : cb_save
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------------------------------------------------------------------------------------
28-8-96		1.1			TA		Changed to windows function
12-8-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Save changes or new row to database */

long ll_rownum, ll_type, ll_speed, ll_rows
boolean lb_return, lb_continue
lb_continue = True
lb_return = True

ll_rows = dw_calc_consumption_data.RowCount()
dw_calc_consumption_data.Accepttext()

ll_rownum = 0

DO
	ll_rownum = dw_calc_consumption_data.GetNextModified(ll_rownum,Primary!)
	If ll_rownum > 0 Then
		ll_type = dw_calc_consumption_data.GetItemNumber(ll_rownum,"cal_cons_type")
		ll_speed = dw_calc_consumption_data.GetItemNumber(ll_rownum,"cal_cons_speed")
		If (ll_type = 1 Or ll_type = 2) And (ll_speed = 0) Then
			MessageBox("Error", "speed must be above zero for loaded and ballasted")
			lb_continue = False
			lb_return = False
		End If
	End if
LOOP UNTIL ll_rownum = 0

If lb_continue Then
	If dw_calc_consumption_data.Update() = 1 Then
		COMMIT;
		f_notify(4)
		Open(w_updated)
		lb_return = TRUE
		dw_calc_consumption_list.Retrieve(istr_calc_vessel_id.l_vessel_type_id, istr_calc_vessel_id.l_vessel_id, istr_calc_vessel_id.l_clarkson_id)
		COMMIT;
	Else
		ROLLBACK;
		lb_return = FALSE
	End if
End If

Return(lb_return)


end function

public subroutine documentation ();/********************************************************************
   w_calc_lookup_consumption
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

on open;call mt_w_response_calc::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_consumption
  
 Object     : 
  
 Event	 :  open

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
12-8-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Hent parametre ind i istr_calc_vessel_id */

istr_calc_vessel_id = Message.PowerObjectParm 

dw_calc_consumption_list.ib_auto = true
dw_calc_consumption_list.Retrieve(istr_calc_vessel_id.l_vessel_type_id, istr_calc_vessel_id.l_vessel_id, istr_calc_vessel_id.l_clarkson_id)
COMMIT;

/* Sharing the data between two windows */
Long ll_tmp
ll_tmp = dw_calc_consumption_list.ShareData(dw_calc_consumption_data)
If ll_tmp <> 1 Then
	MessageBox("Error", "Error sharing detail window to mother")
End if

/* Disable datawindow so that data can't be changed */
dw_calc_consumption_data.Enabled = false

f_center_window(this)

end on

on closequery;call mt_w_response_calc::closequery;long ll_choise

If dw_calc_consumption_list.ModifiedCount() > 0 Then
	ll_choise = Messagebox("Warning","You have unsaved data. Do you want to save?",StopSign!, YesNoCancel! ,2 )
End If

int li_return
CHOOSE CASE ll_choise
	CASE 1
		If wf_save() Then
			li_return = 1
		End If
	CASE 2
		li_return = 0
	CASE 3
		li_return = 1
END CHOOSE

Message.ReturnValue = li_return

end on

on w_calc_lookup_consumption.create
int iCurrent
call super::create
this.dw_calc_consumption_data=create dw_calc_consumption_data
this.dw_calc_consumption_list=create dw_calc_consumption_list
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_save=create cb_save
this.gb_1=create gb_1
this.gb_2=create gb_2
this.cb_close=create cb_close
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calc_consumption_data
this.Control[iCurrent+2]=this.dw_calc_consumption_list
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.st_2
end on

on w_calc_lookup_consumption.destroy
call super::destroy
destroy(this.dw_calc_consumption_data)
destroy(this.dw_calc_consumption_list)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_save)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.cb_close)
destroy(this.st_2)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_lookup_consumption
end type

type dw_calc_consumption_data from u_datawindow_sqlca within w_calc_lookup_consumption
event ue_keydown pbm_dwnkey
integer x = 1061
integer y = 176
integer width = 987
integer height = 448
string dataobject = "d_calc_consumption_data"
boolean border = false
end type

on ue_keydown;call u_datawindow_sqlca::ue_keydown;///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : 
//  
// Object     : 
//  
// Event	 :  
//
// Scope     : 
//
// ************************************************************************************
//
// Author    :Teit Aunt 
//   
// Date       : 20-8-96
//
// Description : Keeps the two datawindows in sync when you tab!
//
// Arguments : 
//
// Returns   :   
//
// Variables : 
//
// Other : 
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//---------------------------------------------------------
//20-8-965		1.0 			TA		Initial version
//  
//************************************************************************************/
//string ls_cname
//long ll_rowcount,  ll_rownum
//Integer li_actioncode
//
//ls_cname = dw_calc_consumption_data.GetColumnName()
//ll_rownum = dw_calc_consumption_data.GetRow()
//ll_rowcount = dw_calc_consumption_data.RowCount()
//
////if keydown(keyenter!) or keydown(keyuparrow!) or keydown(keydownarrow!) then
////	li_actioncode = 1
////elseif keydown(keytab!) and keydown(keyshift!) and ls_cname = "cal_cons_type" then
////	li_actioncode = 1	
////elseif keydown(keytab!) and not keydown(keyshift!) and ls_cname = "cal_cons_mgo" then
////	li_actioncode = 1
////end if
//
//If li_actioncode = 0 Then
//	CHOOSE CASE ls_cname
//		CASE "cal_cons_type"
//			If (ll_rownum > 1) And (Keydown(keytab!) And Keydown(keyshift!)) Then
//				Beep(1)
//				dw_calc_consumption_list.uf_select_row(ll_rownum - 1)
//				li_actioncode = 1
//			End If
//		CASE "cal_cons_mgo"
//			If (ll_rownum < ll_rowcount) And (Keydown(keytab!) and not keydown(keyshift!)) Then
//				Beep(1)
//				dw_calc_consumption_list.uf_select_row(ll_rownum + 1)
//				li_actioncode = 1
//			End If
//	END CHOOSE
//End if
//
//If li_actioncode <> 0 Then SetActionCode(li_actioncode)
//
//
end on

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_consumption
  
 Object     : 
  
 Event	 :  

 Scope     : 

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
20-8-96		1.1			TA		Fix tabbing/ selected row between dw - windows
12-8-96		1.0 			TA		Initial version
************************************************************************************/
/* If at port or at EU port is chosen, speed is set to 0 and editable = no */
cb_save.enabled = true

dw_calc_consumption_list.AcceptText()
dw_calc_consumption_data.AcceptText()

long ll_rownum
ll_rownum = dw_calc_consumption_data.GetRow()

string  ls_speedtype
If dw_calc_consumption_data.GetColumnName() = "cal_cons_type" Then
	ls_speedtype = dw_calc_consumption_data.GetText()
End If

If  (ls_speedtype = "4") Or (ls_speedtype = "5") Or (ls_speedtype = "3") Then
	dw_calc_consumption_data.SetItem(ll_rownum,"cal_cons_speed", 0)
End If


end event

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : 
  
 Event	 :  

 Scope     : 

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 20-8-96

 Description : Keeps the two datawindows in sync when you tab!

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------------------------------------------------------------------------------------
20-8-965		1.0 			TA		Initial version
************************************************************************************/
/* Syncronize the selected rows of the two datawindows */

long ll_rownum1, ll_rownum2

ll_rownum1 =  dw_calc_consumption_data.GetRow()
ll_rownum2 = dw_calc_consumption_list.GetRow()

If ll_rownum1 <> ll_rownum2 Then
	dw_calc_consumption_list.SelectRow(0,False)
	dw_calc_consumption_list.SelectRow(ll_rownum1,true)
	dw_calc_consumption_list.SetRow(ll_rownum1)
End If

dw_calc_consumption_list.SelectRow(0,False)
dw_calc_consumption_list.SelectRow(ll_rownum1,true)
end on

type dw_calc_consumption_list from u_datawindow_sqlca within w_calc_lookup_consumption
integer x = 73
integer y = 80
integer width = 896
integer height = 848
integer taborder = 10
string dataobject = "d_calc_consumption_list"
boolean vscrollbar = true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;// Scroll to selected row in detail window
dw_calc_consumption_data.ScrollToRow(dw_calc_consumption_list.GetRow())
cb_delete.enabled = true
end on

type cb_delete from uo_cb_base within w_calc_lookup_consumption
boolean visible = false
integer x = 1243
integer y = 1008
integer width = 256
integer height = 96
integer taborder = 40
boolean enabled = false
string text = "&Delete"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_consumption
  
 Object     : cb_delete
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
12-8-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Deleting a row */

long ll_row, ll_num, ll_tmp

ll_tmp = MessageBox("Warning","Do you want to delete?",Stopsign!, YesNo!)

CHOOSE CASE ll_tmp
	CASE 1
		ll_row = dw_calc_consumption_list.GetSelectedRow(0)
		If ll_row > 0 Then
			dw_calc_consumption_list.DeleteRow(ll_row)
			If dw_calc_consumption_list.Update() = 1 Then
				Commit;
				dw_calc_consumption_list.Retrieve(istr_calc_vessel_id.l_vessel_type_id, istr_calc_vessel_id.l_vessel_id, istr_calc_vessel_id.l_clarkson_id)
			Else
				RollBack;
			End If
			ll_num = dw_calc_consumption_list.Rowcount()
		
			/* Sets the first row as the current row */
			If ll_num > 0 Then
				dw_calc_consumption_list.SetRow(1)
				dw_calc_consumption_list.Selectrow(1, true)
			Else
				cb_delete.enabled = false
			End if
		Else
			MessageBox("Information","No Rows to delete !")
		End If
	CASE 2
		// Do nothing !
END CHOOSE

end on

type cb_new from uo_cb_base within w_calc_lookup_consumption
boolean visible = false
integer x = 951
integer y = 1008
integer width = 256
integer height = 96
integer taborder = 30
string text = "&New"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w:calc_consumption
  
 Object     : cb_new
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
12-8-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Inserting values in new row */
Long ll_row

ll_row = dw_calc_consumption_data.InsertRow(0)
dw_calc_consumption_list.uf_select_row(ll_row)
dw_calc_consumption_data.ScrollToRow(ll_row)
dw_calc_consumption_data.SetFocus()

dw_calc_consumption_data.SetItem(ll_row, "cal_cons_type" , 2)

dw_calc_consumption_data.SetItem(ll_row, "cal_vest_type_id", istr_calc_vessel_id.l_vessel_type_id)
dw_calc_consumption_data.SetItem(ll_row, "vessel_nr", istr_calc_vessel_id.l_vessel_id)
dw_calc_consumption_data.SetItem(ll_row, "cal_clrk_id", istr_calc_vessel_id.l_clarkson_id)

/* Initialize all fields */
dw_calc_consumption_data.SetItem(ll_row ,"cal_cons_speed",0)
dw_calc_consumption_data.SetItem(ll_row ,"cal_cons_do",0)
dw_calc_consumption_data.SetItem(ll_row ,"cal_cons_fo",0)
dw_calc_consumption_data.SetItem(ll_row ,"cal_cons_mgo",0)

end on

type cb_save from uo_cb_base within w_calc_lookup_consumption
boolean visible = false
integer x = 1536
integer y = 1008
integer width = 256
integer height = 96
integer taborder = 50
boolean enabled = false
string text = "&Save"
end type

on clicked;call uo_cb_base::clicked;wf_save()
cb_close.SetFocus()
end on

type gb_1 from uo_gb_base within w_calc_lookup_consumption
integer x = 37
integer y = 16
integer width = 987
integer height = 960
integer taborder = 0
integer weight = 700
long textcolor = 33554432
long backcolor = 81324524
string text = "List"
end type

type gb_2 from uo_gb_base within w_calc_lookup_consumption
integer x = 1024
integer y = 16
integer width = 1042
integer height = 960
integer taborder = 0
integer weight = 700
long textcolor = 33554432
long backcolor = 81324524
string text = "Detail"
end type

type cb_close from uo_cb_base within w_calc_lookup_consumption
integer x = 1829
integer y = 1008
integer width = 256
integer height = 96
integer taborder = 20
string text = "C&lose"
boolean default = true
end type

on clicked;call uo_cb_base::clicked;Close(Parent)

end on

type st_2 from uo_st_base within w_calc_lookup_consumption
integer x = 1097
integer y = 288
integer width = 686
string text = "Enter consumption per hour."
alignment alignment = left!
end type

