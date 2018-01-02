$PBExportHeader$w_calc_change_status.srw
$PBExportComments$This windows modifies status, and is called from w_calc_calculation
forward
global type w_calc_change_status from mt_w_response_calc
end type
type cbx_changeall from uo_cbx_base within w_calc_change_status
end type
type cb_ok from uo_cb_base within w_calc_change_status
end type
type cb_cancel from uo_cb_base within w_calc_change_status
end type
type rb_offer from uo_rb_base within w_calc_change_status
end type
type rb_working from uo_rb_base within w_calc_change_status
end type
type gb_1 from uo_gb_base within w_calc_change_status
end type
type gb_2 from uo_gb_base within w_calc_change_status
end type
end forward

global type w_calc_change_status from mt_w_response_calc
integer width = 791
integer height = 640
string title = "Status"
long backcolor = 32304364
cbx_changeall cbx_changeall
cb_ok cb_ok
cb_cancel cb_cancel
rb_offer rb_offer
rb_working rb_working
gb_1 gb_1
gb_2 gb_2
end type
global w_calc_change_status w_calc_change_status

type variables
Private u_calculation iuo_calculation
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_change_status
	
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
	28/08/2014	CR3781	CCY018			The window title match with the text of a menu item
*****************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieves information from the calculation given as argument.

 Arguments : U_CALCULATION as messageobject argument

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
Integer li_page, li_status

// Get the calculation from the messageobject and store it in IUO_CALCULATION
iuo_calculation = Message.PowerObjectParm

// Validate the calculation
if Not(IsValid(iuo_calculation)) Then
	MessageBox("Error", "Error accessing u_calculation", StopSign!)
	Close(This)
Else
	// Get the current status from the active page, if we're on a cargopage (page 3),
	// then get the status for the cargo, otherwise get the status for the calculation
	// The "Change all" checkbox is set to true and disabled when working on calculations
	li_page = iuo_calculation.uf_get_current_page()

	CHOOSE CASE li_page
		CASE 1,2
			li_status = iuo_calculation.uf_get_status(0)
			cbx_changeall.checked = true
			cbx_changeall.enabled = false
		CASE 3
			li_status = iuo_calculation.uf_get_status(iuo_calculation.uf_get_cargo())
	END CHOOSE

	// Update to radiobuttons to show the current status
	CHOOSE CASE li_status
		CASE 0,1
			// not supported
		CASE 2
			rb_working.checked = true
		CASE 3
			rb_offer.checked = true
	END CHOOSE
End if


end event

on w_calc_change_status.create
int iCurrent
call super::create
this.cbx_changeall=create cbx_changeall
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.rb_offer=create rb_offer
this.rb_working=create rb_working
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_changeall
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.rb_offer
this.Control[iCurrent+5]=this.rb_working
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_calc_change_status.destroy
call super::destroy
destroy(this.cbx_changeall)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.rb_offer)
destroy(this.rb_working)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_change_status
end type

type cbx_changeall from uo_cbx_base within w_calc_change_status
integer x = 55
integer y = 304
integer width = 640
integer height = 80
long backcolor = 32304364
string text = "Change whole calcule"
end type

type cb_ok from uo_cb_base within w_calc_change_status
integer x = 50
integer y = 432
integer width = 343
integer height = 100
integer taborder = 30
string text = "&Ok"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the OK clicked, by updating the calculation with the new
 					status and closes the change status window

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_status, li_cargo

// Validate the calculation before processing
if Not(IsValid(iuo_calculation)) Then
	MessageBox("Error", "Error accessing u_calculation", StopSign!)
Else
	// Set the value in LI_STATUS, depending on the radiobutton settings
	If rb_working.checked then
		li_status = 2
	Elseif rb_offer.checked then
		li_status = 3
	End if

	// If the change all is checked then change the status for the calculation,
	// otherwise change the status for the current cargo
	If cbx_changeall.checked then li_cargo = 0 Else li_cargo = iuo_calculation.uf_get_cargo()

	iuo_calculation.uf_set_status(li_cargo,li_status)
	
	// Close and exit
	Close(Parent)
End if
end event

type cb_cancel from uo_cb_base within w_calc_change_status
integer x = 411
integer y = 432
integer width = 343
integer height = 100
integer taborder = 20
string text = "&Cancel"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the set status window with setting the status

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type rb_offer from uo_rb_base within w_calc_change_status
integer x = 55
integer y = 144
long backcolor = 32304364
string text = " Off&er"
end type

type rb_working from uo_rb_base within w_calc_change_status
integer x = 55
integer y = 64
integer width = 293
long backcolor = 32304364
string text = " &Working"
end type

type gb_1 from uo_gb_base within w_calc_change_status
integer x = 18
integer width = 731
integer height = 256
integer taborder = 40
long backcolor = 32304364
string text = ""
end type

type gb_2 from uo_gb_base within w_calc_change_status
integer x = 18
integer y = 256
integer width = 731
integer height = 144
integer taborder = 10
long backcolor = 32304364
string text = ""
end type

