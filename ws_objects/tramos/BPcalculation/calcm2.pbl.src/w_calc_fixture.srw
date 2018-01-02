$PBExportHeader$w_calc_fixture.srw
$PBExportComments$Making a calculation a fixture
forward
global type w_calc_fixture from mt_w_response_calc
end type
type cbx_allocate_fixture from checkbox within w_calc_fixture
end type
type cb_fixture from uo_cb_base within w_calc_fixture
end type
type cb_cancel from uo_cb_base within w_calc_fixture
end type
type st_1 from uo_st_base within w_calc_fixture
end type
type st_2 from uo_st_base within w_calc_fixture
end type
type lb_cargos from listbox within w_calc_fixture
end type
type st_4 from statictext within w_calc_fixture
end type
type sle_vessel from singlelineedit within w_calc_fixture
end type
type st_3 from statictext within w_calc_fixture
end type
type dw_starting_date from datawindow within w_calc_fixture
end type
end forward

global type w_calc_fixture from mt_w_response_calc
integer width = 1243
integer height = 1092
string title = "Fixture"
boolean controlmenu = false
long backcolor = 32304364
string icon = "images\calcmenu.ICO"
boolean ib_setdefaultbackgroundcolor = true
cbx_allocate_fixture cbx_allocate_fixture
cb_fixture cb_fixture
cb_cancel cb_cancel
st_1 st_1
st_2 st_2
lb_cargos lb_cargos
st_4 st_4
sle_vessel sle_vessel
st_3 st_3
dw_starting_date dw_starting_date
end type
global w_calc_fixture w_calc_fixture

type variables
Private u_atobviac_calculation iuo_atobviac_calc
Private Integer ii_cargoindex[], ii_nocargos

s_voyage_return istr_return
end variables

forward prototypes
public function boolean wf_enable_allocate ()
public subroutine documentation ()
end prototypes

public function boolean wf_enable_allocate ();/********************************************************************
   wf_enable_allocate
   <DESC> check whether the related caculation is allocated to voyage or not </DESC>
   <RETURN>	boolean:
            True:
				False:
    </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	this would be open from open event </USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	16/05/2012 CR2413          LGX001        First Version
		15/03/2013 CR3049   			LGX001			Make "Allocate Fixture" in Fixture dialog box checked by default
		
   </HISTORY>
********************************************************************/
long	ll_fixtureid, ll_result

ll_fixtureid  = iuo_atobviac_calc.uf_get_fix_id( )

cbx_allocate_fixture.enabled = true
cbx_allocate_fixture.checked = true

if ll_fixtureid > 0 then
	SELECT  1 into :ll_result 
	from VOYAGES
	where VOYAGES.CAL_CALC_ID = (SELECT CAL_CALC_ID FROM	CAL_CALC WHERE CAL_CALC_FIX_ID = :ll_fixtureid AND CAL_CALC_STATUS = 6);
   if sqlca.sqlcode <> 100 then
		cbx_allocate_fixture.enabled = false
		cbx_allocate_fixture.checked = false
		return false
	end if
end if

return true
end function

public subroutine documentation ();/********************************************************************
   w_calc_fixture
	
	<OBJECT>
		Shown when user wants to fix calculation
	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
		Date    		Ref      	Author		Comments
		16/05/12		CR2413   	LGX001		add allocate fixture checkedbox 
		10/08/12		CR2413   	AGL027		Set allocate fixture checkbox to unchecked
		18/02/13		CR2931   	AGL027		Change object to use u_atobviac_calculation instead of u_calculation.
		15/03/13		CR3049   	LGX001		Make "Allocate Fixture" in Fixture dialog box checked by default
		29/11/13		CR2658UAT	LGX001		1.It should not be changing vessel when Doing fixture
														2.remove cb_vessel button (?)
		06/08/14		CR3708   	AGL027		F1 help application coverage - corrected ancestor
		12/09/14		CR3773   	XSZ004		Change icon absolute path to reference path
*****************************************************************/

end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This is the Open event for the Fixture window. It takes a 
 					U_CALCULATION as the message argument. If/When the user selects
					fixture, this Window will call the UF_FIXTURE on the passed
					calculation object.

 Arguments : U_CALCULATION object as message argument

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long li_count, li_count2
String ls_tmp

istr_return.ab_allocatefixture = false
istr_return.al_return = 0

dw_starting_date.InsertRow(0)

// Get calculation as argument into the lvo_atobviac_calc object
iuo_atobviac_calc = Message.PowerObjectParm

// Stop if the calculation object isn't valid
If Not(IsValid(iuo_atobviac_calc)) Then
	MessageBox("Error", "Error getting calculation data!", StopSign!)
	closewithreturn(this, istr_return)
End if
	
// Set the title with the description from the calculation, set the
// starting data and vessel name into appropriate fields
This.Title = "Fixture ["+iuo_atobviac_calc.uf_get_description(0)+"]"
dw_starting_date.SetItem(1,1,iuo_atobviac_calc.uf_get_starting_date())
sle_vessel.text = iuo_atobviac_calc.uf_get_vessel_name()

// Add all cargos that is not already fixtured to the fixture listbox,
// and put the cargo number into the II_CARGOINDEX, so we have a link between
// cargo's in the listbox and the original cargo number
ii_nocargos = iuo_atobviac_calc.uf_get_no_cargos()
ii_cargoindex[ii_nocargos] = 0

For li_count = 1 To ii_nocargos
	If iuo_atobviac_calc.uf_get_status(li_count)<4 Then
		ls_tmp = iuo_atobviac_calc.uf_get_cargo_description(li_count)
		lb_cargos.AddItem(ls_tmp)

		li_count2++
		ii_cargoindex[li_count]=li_count2
	End if
Next

// Exit with an error, if no cargos was added to the listbox
If lb_cargos.TotalItems()=0 Then
	MessageBox("Error", "There's no cargoes which can be fixtured (all have been fixed allready)")
	closewithreturn(this, istr_return)
	Return
End if

if not wf_enable_allocate( ) then
	//cb_vessel.enabled = false
end if

// Select item 1 (first cargo) in the listbox
lb_cargos.SelectItem(1)
end event

on w_calc_fixture.create
int iCurrent
call super::create
this.cbx_allocate_fixture=create cbx_allocate_fixture
this.cb_fixture=create cb_fixture
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.st_2=create st_2
this.lb_cargos=create lb_cargos
this.st_4=create st_4
this.sle_vessel=create sle_vessel
this.st_3=create st_3
this.dw_starting_date=create dw_starting_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_allocate_fixture
this.Control[iCurrent+2]=this.cb_fixture
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.lb_cargos
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_vessel
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.dw_starting_date
end on

on w_calc_fixture.destroy
call super::destroy
destroy(this.cbx_allocate_fixture)
destroy(this.cb_fixture)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.lb_cargos)
destroy(this.st_4)
destroy(this.sle_vessel)
destroy(this.st_3)
destroy(this.dw_starting_date)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_fixture
end type

type cbx_allocate_fixture from checkbox within w_calc_fixture
integer x = 18
integer y = 880
integer width = 494
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = " Allocate Fixture"
end type

type cb_fixture from uo_cb_base within w_calc_fixture
integer x = 521
integer y = 880
integer width = 343
integer height = 100
integer taborder = 60
string text = "&Fixture"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Creates an array boolean values, where each entry corrosponds to the
 					cargo in the calculation. All cargos that have their boolean value
					set to true is to be fixed.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_count
Boolean lb_fixtures[], lb_tmp

lb_fixtures[ii_nocargos] = false

// Test for ballast voyage. Ballastvoyages may not be fixtured because they can't 
// be handeled by the operation module
lb_tmp = iuo_atobviac_calc.uf_get_ballast_voyage()
If lb_tmp then 
	MessageBox("Stop","It is not possible to fixture a Ballast Voyage",Stopsign!, OK!, 1)
	cb_cancel.TriggerEvent(Clicked!)
	Return
End if

// Set the boolean fixture value for each cargo in the calculation, depending on
// if the corrosponding cargo in the listbox is selected
For li_count = 1 To ii_nocargos
	If ii_cargoindex[li_count] > 0 Then
		lb_fixtures[li_count] = lb_cargos.State(ii_cargoindex[li_count]) = 1
	End if
Next

// Ask the calculation object to do the fixture. We'll return if the fixture
// succedes.
If IsValid(iuo_atobviac_calc) Then
	dw_starting_date.Accepttext()
	iuo_atobviac_calc.uf_set_starting_date(dw_starting_date.GetItemDatetime(1,1))
	
	If iuo_atobviac_calc.uf_fixture(lb_fixtures) Then 
		/* set return value */
		istr_return.ab_allocatefixture = cbx_allocate_fixture.checked
		istr_return.al_return = 1
		
		closewithreturn(parent, istr_return)
		Return
	End if
Else
	MessageBox("Error", "Error accessing calcule", StopSign!)
	istr_return.ab_allocatefixture = false
	istr_return.al_return = 0
	closewithreturn(parent, istr_return)
	Return
End if
end event

type cb_cancel from uo_cb_base within w_calc_fixture
integer x = 869
integer y = 880
integer width = 343
integer height = 100
integer taborder = 70
string text = "&Cancel"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes this window

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

istr_return.ab_allocatefixture = false
istr_return.al_return = 0

closewithreturn(parent, istr_return)
Return

end event

type st_1 from uo_st_base within w_calc_fixture
integer x = 14
integer y = 8
integer width = 1207
integer height = 144
long backcolor = 32304364
string text = "Select one or more cargo for TRAMOS transfer. After selecting Fixture, the calculation will become locked."
alignment alignment = left!
end type

type st_2 from uo_st_base within w_calc_fixture
integer x = 32
integer y = 168
integer width = 311
integer height = 64
long backcolor = 32304364
string text = "Starting date"
alignment alignment = left!
end type

type lb_cargos from listbox within w_calc_fixture
integer x = 18
integer y = 476
integer width = 1189
integer height = 368
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32430488
boolean border = false
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles selectionchanged for the fixturewindow, by enabling the
 					fixture button

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_fixture.Default = True
end event

type st_4 from statictext within w_calc_fixture
integer x = 32
integer y = 392
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Cargo(s)"
boolean focusrectangle = false
end type

type sle_vessel from singlelineedit within w_calc_fixture
integer x = 343
integer y = 264
integer width = 425
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_calc_fixture
integer x = 32
integer y = 280
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Vessel"
boolean focusrectangle = false
end type

type dw_starting_date from datawindow within w_calc_fixture
integer x = 343
integer y = 152
integer width = 421
integer height = 88
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

