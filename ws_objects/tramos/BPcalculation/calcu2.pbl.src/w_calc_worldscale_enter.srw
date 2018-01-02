$PBExportHeader$w_calc_worldscale_enter.srw
$PBExportComments$Window for entering a Worldscale flatrate during calculation
forward
global type w_calc_worldscale_enter from mt_w_response_calc
end type
type cb_ok from uo_cb_base within w_calc_worldscale_enter
end type
type cb_cancel from uo_cb_base within w_calc_worldscale_enter
end type
type st_1 from statictext within w_calc_worldscale_enter
end type
type dw_calc_worldscale from u_datagrid within w_calc_worldscale_enter
end type
type gb_1 from uo_gb_base within w_calc_worldscale_enter
end type
end forward

global type w_calc_worldscale_enter from mt_w_response_calc
integer width = 2135
integer height = 532
string title = "Enter Flatrate"
boolean controlmenu = false
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
dw_calc_worldscale dw_calc_worldscale
gb_1 gb_1
end type
global w_calc_worldscale_enter w_calc_worldscale_enter

type variables
s_calculation_ws istr_ws
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_worldscale_enter
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    		Author   		Comments
		25/09/2013 	CR3206   LGX001         adjust UI 
		07/08/2014 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets up the W_CALC_WORLDSCALE_ENTER for asking the user for the 
 					Worldscale rate for the given year and portlist. Year and portlist
					is passed in a S_CALCULATION_WS structure.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Get the passed S_CALCULATION_WS structure from the message object into ISTR_WS
istr_ws = Message.PowerObjectParm

// Insert a new row in the DW_CALC_WORLDSCALE datawindow, and scroll to it.
// Insert the portlist and rate into the DW_CALC_WORLDSCALE, and set rate
// to zero
dw_calc_worldscale.ScrollToRow(dw_calc_worldscale.InsertRow(0))
dw_calc_worldscale.SetItem(1, "cal_wsca_port_list", istr_ws.s_portlist)
dw_calc_worldscale.SetItem(1, "cal_wsca_year", istr_ws.i_year)
dw_calc_worldscale.SetItem(1, "cal_wsca_rate", 0)

// Set current column to the rate
dw_calc_worldscale.SetColumn("cal_wsca_rate")

// And disable changes to year and portlist fields
dw_calc_worldscale.Modify("cal_wsca_year.protect = 1 cal_wsca_year.background.color = 12632256")
dw_calc_worldscale.Modify("cal_wsca_port_list.protect = 1 cal_wsca_port_list.background.color = 12632256")




end event

on w_calc_worldscale_enter.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.dw_calc_worldscale=create dw_calc_worldscale
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_calc_worldscale
this.Control[iCurrent+5]=this.gb_1
end on

on w_calc_worldscale_enter.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.dw_calc_worldscale)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_worldscale_enter
end type

type cb_ok from uo_cb_base within w_calc_worldscale_enter
integer x = 1408
integer y = 320
integer width = 343
integer height = 100
integer taborder = 40
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : 

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Double ld_rate
Long ll_tmp

// Acceptext, and validate that it's above 0.
dw_calc_worldscale.Accepttext()
ld_rate = dw_calc_worldscale.GetItemNumber(1, "cal_wsca_rate")

If not ld_rate > 0 Then
	MessageBox("Notice", "Error in worldscale rate; has to be above 0", StopSign!)
	Return
End if

dw_calc_worldscale.uf_redraw_off()

// The line below seems to be obsolete
dw_calc_worldscale.SetItem(1, "cal_wsca_port_list", istr_ws.s_portlist)

// Get the MAX id, add 1 and use this value as the NEW ID.
SELECT MAX(CAL_WSCA_ID)
INTO :ll_tmp
FROM CAL_WSCA;
COMMIT;

If IsNull(ll_tmp) Then ll_tmp = 0
ll_tmp ++

// Set the ID, and update the DW_CALC_WORLDSCALE datawindow to the database. If it
// succedes, then COMMIT, and return with the entered rate. Otherwise rollback
dw_calc_worldscale.SetItem(1, "cal_wsca_id", ll_tmp) 
If dw_calc_worldscale.Update()=1 Then
	COMMIT;

	Open(w_updated)
	CloseWithReturn(Parent,ld_rate)
	REturn
Else
	ROLLBACK;
End if



end event

type cb_cancel from uo_cb_base within w_calc_worldscale_enter
integer x = 1755
integer y = 320
integer width = 343
integer height = 100
integer taborder = 30
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the W_CALC_WORLDSCALE_ENTER window, without returning any
 					rates

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type st_1 from statictext within w_calc_worldscale_enter
integer x = 73
integer y = 64
integer width = 946
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Please enter worldscale rate for:"
boolean focusrectangle = false
end type

type dw_calc_worldscale from u_datagrid within w_calc_worldscale_enter
integer x = 73
integer y = 128
integer width = 1993
integer height = 144
integer taborder = 10
string dataobject = "d_calc_worldscale"
boolean border = false
end type

type gb_1 from uo_gb_base within w_calc_worldscale_enter
integer x = 37
integer y = 16
integer width = 2066
integer height = 288
integer taborder = 20
long backcolor = 81324524
string text = ""
end type

