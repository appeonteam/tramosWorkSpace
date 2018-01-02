$PBExportHeader$w_calc_worldscale_edit.srw
$PBExportComments$Window for editing the Worldscale flatrates
forward
global type w_calc_worldscale_edit from mt_w_response_calc
end type
type cb_filter from commandbutton within w_calc_worldscale_edit
end type
type sle_port from singlelineedit within w_calc_worldscale_edit
end type
type st_3 from statictext within w_calc_worldscale_edit
end type
type em_to_year from editmask within w_calc_worldscale_edit
end type
type st_2 from statictext within w_calc_worldscale_edit
end type
type st_1 from statictext within w_calc_worldscale_edit
end type
type em_from_year from editmask within w_calc_worldscale_edit
end type
type cb_cancel from uo_cb_base within w_calc_worldscale_edit
end type
type cb_ok from uo_cb_base within w_calc_worldscale_edit
end type
type dw_calc_worldscale from u_datagrid within w_calc_worldscale_edit
end type
type cb_delete from uo_cb_base within w_calc_worldscale_edit
end type
type gb_1 from groupbox within w_calc_worldscale_edit
end type
end forward

global type w_calc_worldscale_edit from mt_w_response_calc
integer width = 2144
integer height = 1476
string title = "Flat Rates"
boolean controlmenu = false
boolean ib_setdefaultbackgroundcolor = true
cb_filter cb_filter
sle_port sle_port
st_3 st_3
em_to_year em_to_year
st_2 st_2
st_1 st_1
em_from_year em_from_year
cb_cancel cb_cancel
cb_ok cb_ok
dw_calc_worldscale dw_calc_worldscale
cb_delete cb_delete
gb_1 gb_1
end type
global w_calc_worldscale_edit w_calc_worldscale_edit

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_calc_worldscale_edit
	
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
		04/09/2013 	CR3206       LGX001     1. Set em_to_year to current year
														2. Set the max year from 2010 to 2050
														3. Adjust UI
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves the worldscale routes into the DW_CALC_WORLDSCALE 
 					datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_worldscale.Retrieve()
COMMIT;
end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Posts a UE_RETRIEVE event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

PostEvent("ue_retrieve")

em_to_year.text = string(today(), 'YYYY')

/* Administrator and Charterer */
if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 1 then
	cb_delete.enabled = true
	cb_ok.enabled = true
else
	cb_delete.enabled = false
	cb_ok.enabled = false
end if
end event

on w_calc_worldscale_edit.create
int iCurrent
call super::create
this.cb_filter=create cb_filter
this.sle_port=create sle_port
this.st_3=create st_3
this.em_to_year=create em_to_year
this.st_2=create st_2
this.st_1=create st_1
this.em_from_year=create em_from_year
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_calc_worldscale=create dw_calc_worldscale
this.cb_delete=create cb_delete
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_filter
this.Control[iCurrent+2]=this.sle_port
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_to_year
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.em_from_year
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.cb_ok
this.Control[iCurrent+10]=this.dw_calc_worldscale
this.Control[iCurrent+11]=this.cb_delete
this.Control[iCurrent+12]=this.gb_1
end on

on w_calc_worldscale_edit.destroy
call super::destroy
destroy(this.cb_filter)
destroy(this.sle_port)
destroy(this.st_3)
destroy(this.em_to_year)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_from_year)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_calc_worldscale)
destroy(this.cb_delete)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_worldscale_edit
end type

type cb_filter from commandbutton within w_calc_worldscale_edit
integer x = 37
integer y = 1264
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Filter"
end type

event clicked;string ls_filter

if (integer(em_from_year.text) > integer(em_to_year.text)) then
	Messagebox("Mismatch year", "Please specify the year interval correct.")
else
	
	ls_filter = "cal_wsca_year >= " + em_from_year.text + " and cal_wsca_year <= " &
					+ em_to_year.text + " and match(cal_wsca_port_list,'" + sle_port.text + "')"
	
	dw_calc_worldscale.setfilter(ls_filter)
	dw_calc_worldscale.filter()

end if
end event

type sle_port from singlelineedit within w_calc_worldscale_edit
integer x = 338
integer y = 1136
integer width = 549
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_calc_worldscale_edit
integer x = 91
integer y = 1152
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port Code:"
boolean focusrectangle = false
end type

type em_to_year from editmask within w_calc_worldscale_edit
integer x = 622
integer y = 1032
integer width = 270
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "2010"
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1996~~2050"
end type

type st_2 from statictext within w_calc_worldscale_edit
integer x = 530
integer y = 1044
integer width = 59
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "to"
boolean focusrectangle = false
end type

type st_1 from statictext within w_calc_worldscale_edit
integer x = 91
integer y = 1044
integer width = 133
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year:"
boolean focusrectangle = false
end type

type em_from_year from editmask within w_calc_worldscale_edit
integer x = 229
integer y = 1032
integer width = 270
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "1996"
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1996~~2050"
end type

type cb_cancel from uo_cb_base within w_calc_worldscale_edit
integer x = 1755
integer y = 1264
integer width = 343
integer height = 100
integer taborder = 70
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the window, without updating the database

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type cb_ok from uo_cb_base within w_calc_worldscale_edit
integer x = 1408
integer y = 1264
integer width = 343
integer height = 100
integer taborder = 60
string text = "&OK"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls acceptext, and updates the database

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_worldscale.AcceptText()

// If the update succeds, then COMMIT and close the window. Otherwise rollback
If dw_calc_worldscale.Update()=1 Then
	COMMIT USING SQLCA;
	Close(Parent)
Else
	ROLLBACK USING SQLCA;
End if
end event

type dw_calc_worldscale from u_datagrid within w_calc_worldscale_edit
integer x = 37
integer y = 32
integer width = 2066
integer height = 896
integer taborder = 10
string dataobject = "d_calc_worldscale"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Enables the delete button

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


cb_delete.enabled = cb_ok.enabled
end event

type cb_delete from uo_cb_base within w_calc_worldscale_edit
integer x = 1061
integer y = 1264
integer width = 343
integer height = 100
integer taborder = 80
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Deletes the current entry in the DW_CALC_WORLDSCALE window

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
Long ll_row, ll_tmp

// Get the user to acknowledge the deletion
ll_tmp = MessageBox("Warning","You are about to delete. Continue?",StopSign!,YesNo!)
CHOOSE CASE ll_tmp
	CASE 1
		// Get current row
		ll_row = dw_calc_worldscale.GetRow()
		If ll_row > 0 Then
			
			// delete it, and move one row back
			dw_calc_worldscale.DeleteRow(ll_row)
			
			If ll_row > 1 Then ll_row --
			If ll_row <= dw_calc_worldscale.RowCount() Then
				dw_calc_worldscale.SetRow(ll_row)
				dw_calc_worldscale.SetFocus()
			Else
				// disable the delete button if no more rows
				cb_delete.enabled = false
			End if
		End if
	CASE 2
		// Do nothing
END CHOOSE

	
end event

type gb_1 from groupbox within w_calc_worldscale_edit
integer x = 37
integer y = 960
integer width = 882
integer height = 276
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Filter"
end type

