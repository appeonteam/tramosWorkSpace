$PBExportHeader$w_calc_select_wizard.srw
$PBExportComments$Selects wizards open new creation of a calcultion
forward
global type w_calc_select_wizard from mt_w_response_calc
end type
type lb_wizards from listbox within w_calc_select_wizard
end type
type cb_cancel from uo_cb_base within w_calc_select_wizard
end type
type cb_ok from uo_cb_base within w_calc_select_wizard
end type
type cbx_default from checkbox within w_calc_select_wizard
end type
type gb_wizards from groupbox within w_calc_select_wizard
end type
end forward

global type w_calc_select_wizard from mt_w_response_calc
integer width = 1463
integer height = 1276
string title = "Calculation Wizard"
lb_wizards lb_wizards
cb_cancel cb_cancel
cb_ok cb_ok
cbx_default cbx_default
gb_wizards gb_wizards
end type
global w_calc_select_wizard w_calc_select_wizard

type variables
String istr_wizard_name[]
s_opencalc_parm istr_opencalc_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_select_wizard
	
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

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 1996

 Description : Used for selection of wizard, either in the "System options" or when 
 					the user creates a new calculation, and no wizard is selected, 
					depending on the LI_OPTION argument. 
					
					If LI_OPTION = 0 (create calculation), and a default calculation
					is already set up, either using system options or by checking the
					"set as default" checkbox, the W_CALC_SELECT_WIZARD will immediately
					exit with the default calculation.
					 
 Arguments : LI_OPTION as integer. Values:
 
 				 0 = create calculation, 
 				 1 = select standard calculation

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_directory
Integer li_option
String ls_tmp
Integer li_pos, li_count
Integer li_max

// Get the option argument from the message object
li_option = Message.DoubleParm

// Check if we're called from system options, if that's the case then set the
// default checkbox to checked and not enabled.
If li_option = 1 Then
	cbx_default.checked = true
	cbx_default.enabled = false
End if

// Search the Wizard.pbl for available wizards, we use the GS_WIZARD_PATH from
// the UO_GLOBAL object as the path to lock for the WIZARD.PBL file
istr_opencalc_parm.s_wizardfile = uo_global.gs_wizard_path
// Add trailing backslash
If Right(istr_opencalc_parm.s_wizardfile,1)<>'\' Then istr_opencalc_parm.s_wizardfile += '\'
istr_opencalc_parm.s_wizardfile += 'WIZARD.PBL'
// And get the datawindow-directory from the PBL file
ls_directory = LibraryDirectory(istr_opencalc_parm.s_wizardfile, DirDataWindow!)

// Loop through the (length) of the directory string, and 
// Add each entry in the wizard.pbl to our list
DO WHILE Len(ls_directory)>0
	li_pos = Pos(ls_directory, "~n")
	ls_tmp = Left(ls_directory, li_pos - 1)

	li_count ++	
	istr_wizard_name[li_count]=Left(ls_tmp, Pos(ls_tmp,"~t") - 1 )	

	ls_tmp = Mid(ls_tmp, Pos(ls_tmp,"~t", Pos(ls_tmp, "~t") +1 ) +1 )
	ls_tmp = Left(ls_tmp, Len(ls_tmp) - 1)
	lb_wizards.AddItem(ls_tmp)
	ls_directory = Mid(ls_directory, li_pos + 1)
LOOP

// If any wizard is selected as standard, and this is "create calculation" (LI_OPTION=0),
// then select the wizard and click ok (a bit dirty, but it works fine)
If li_option = 0 Then
	li_max = lb_wizards.TotalItems()
	
	For li_count = 1 To li_max 
		If  lb_wizards.text(li_count) = uo_global.gs_calc_wizard Then
			lb_wizards.SelectItem(li_count)
			cb_ok.TriggerEvent(Clicked!)
			Return
		End if
	Next
End if

// Otherwise select first wizard, and set the focus to the first wizard entry
lb_wizards.SelectItem(1)
lb_wizards.SetFocus()
end event

on w_calc_select_wizard.create
int iCurrent
call super::create
this.lb_wizards=create lb_wizards
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cbx_default=create cbx_default
this.gb_wizards=create gb_wizards
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_wizards
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cbx_default
this.Control[iCurrent+5]=this.gb_wizards
end on

on w_calc_select_wizard.destroy
call super::destroy
destroy(this.lb_wizards)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cbx_default)
destroy(this.gb_wizards)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_select_wizard
end type

type lb_wizards from listbox within w_calc_select_wizard
integer x = 55
integer y = 112
integer width = 1317
integer height = 816
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean vscrollbar = true
boolean sorted = false
string item[] = {"Standard Calculation"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Enables the OK button upon selectionchange and sets the OK button
 					as the default button

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_ok.enabled = true
cb_ok.default = true
end event

event doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Routes the double-clicked event to the OK button's clicked event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_ok.TriggerEvent(clicked!)
end event

type cb_cancel from uo_cb_base within w_calc_select_wizard
integer x = 1170
integer y = 1056
integer taborder = 40
string text = "&Cancel"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the window, and returns an empty ISTR_OPENCALC_PARM to the
 					calling window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

CloseWithReturn(Parent,istr_opencalc_parm)
Return
end event

type cb_ok from uo_cb_base within w_calc_select_wizard
integer x = 878
integer y = 1056
integer taborder = 30
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the OK-button clicked, by either setting the Wizard name &
 					title in the ISTR_OPENCALC_PARM, and returning the ISTR_OPENCALC_PARM
					to the calling window.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_tmp

// Get the selected entry from the listbox
li_tmp = lb_wizards.SelectedIndex()

// If entry is > 0 then substract 1, so that the "standard calculation" will have
// index 0, and first Wizard will have index 1.
If li_tmp > 0 Then
	li_tmp --

	If li_tmp = 0 Then
		// The "standard calculation" wizardname is "DEFAULT", put this value
		// and the title in the ISTR_OPEN_CALC_PARM
		istr_opencalc_parm.s_wizard = "default"
		istr_opencalc_parm.s_wizardtitle = lb_wizards.text(1)
	Else
		// The user selected a "real" wizard, store the name and the title to
		// to ISTR_OPEN_CALC_PARM
		istr_opencalc_parm.s_wizard = istr_wizard_name[li_tmp]
		istr_opencalc_parm.s_wizardtitle = lb_wizards.text(li_tmp+1)
	End if

	// If the "set as default" checkbox is enabled - and checked then
	// set this wizard as the default wizard. Explanation: The "set as default"
	// checkbox will only be enabled on calling the W_CALC_SELECT_WIZARD window
	// from the calculation manager. When called from system options, the
	// system options window will update the UO_GLOBAL object by itself
	If (cbx_default.enabled) And (cbx_default.checked) Then
		uo_global.gs_calc_wizard = istr_opencalc_parm.s_wizardtitle
	End if
End if

// Return the ISTR_OPENCALC_PARM to the calling window.
CloseWithReturn(Parent,istr_opencalc_parm)
Return

end event

type cbx_default from checkbox within w_calc_select_wizard
integer x = 55
integer y = 944
integer width = 439
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Set as default"
end type

type gb_wizards from groupbox within w_calc_select_wizard
integer x = 18
integer y = 32
integer width = 1390
integer height = 992
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = " Select Wizard"
end type

