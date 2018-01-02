$PBExportHeader$w_select_from_list.srw
$PBExportComments$Generic "select from list" window
forward
global type w_select_from_list from mt_w_response
end type
type cb_deselect_all from mt_u_commandbutton within w_select_from_list
end type
type cb_select_all from mt_u_commandbutton within w_select_from_list
end type
type dw_1 from uo_datawindow_multiselect within w_select_from_list
end type
type cb_close from commandbutton within w_select_from_list
end type
type cb_delete from commandbutton within w_select_from_list
end type
type cb_refresh from commandbutton within w_select_from_list
end type
type rb_header1 from radiobutton within w_select_from_list
end type
type rb_header2 from radiobutton within w_select_from_list
end type
type st_return from statictext within w_select_from_list
end type
type st_1 from statictext within w_select_from_list
end type
type sle_find from singlelineedit within w_select_from_list
end type
type cb_modify from commandbutton within w_select_from_list
end type
type cb_new from commandbutton within w_select_from_list
end type
type cb_ok from commandbutton within w_select_from_list
end type
type gb_1 from groupbox within w_select_from_list
end type
type cb_cancel from commandbutton within w_select_from_list
end type
end forward

global type w_select_from_list from mt_w_response
integer x = 361
integer y = 336
integer width = 1851
integer height = 2028
long backcolor = 81324524
event ue_entry_chosen pbm_custom01
event ue_retrieve pbm_custom02
cb_deselect_all cb_deselect_all
cb_select_all cb_select_all
dw_1 dw_1
cb_close cb_close
cb_delete cb_delete
cb_refresh cb_refresh
rb_header1 rb_header1
rb_header2 rb_header2
st_return st_return
st_1 st_1
sle_find sle_find
cb_modify cb_modify
cb_new cb_new
cb_ok cb_ok
gb_1 gb_1
cb_cancel cb_cancel
end type
global w_select_from_list w_select_from_list

type variables
long   il_selectedrow

string  is_filter

integer ii_search_column
boolean ib_search_column_string

boolean ib_search_column_1_string  //TRUE = string
boolean ib_search_column_2_string  // FALSE = number

boolean ib_return_column_string  //TRUE = string
                                                // FALSE = number

s_search_window istr_parametre



end variables

forward prototypes
public function string wf_return_selected ()
public subroutine documentation ()
end prototypes

on ue_entry_chosen;// Entry_Chosen Script for UO_1

string	ls_selected_value

ls_selected_value = wf_return_selected ()

if Len (ls_selected_value) = 0  then  SetNull(ls_selected_value)

st_return.text =  ls_selected_value

CloseWithReturn(this,ls_selected_value)
end on

event ue_retrieve;/************************************************************************************

 Author    : Regin Mortesen, Martin Israelsen
   
 Date       : 1/1-96

 Description : Default search & select windows

 Arguments : istr_parameter 

 Returns   : String

 Variables : None

 Other : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-1-96		1.0 			MI		Initial version
************************************************************************************/

if istr_parametre.dw = "dw_profit_center_list" &
or istr_parametre.dw = "dw_vessel_list" &
or istr_parametre.dw = "d_vessel_group_list" then
	dw_1.Retrieve(uo_global.is_userid )
else
	dw_1.Retrieve()
end if

ii_search_column = istr_parametre.search_column_1
ib_search_column_string = ib_search_column_1_string
sle_find.SetFocus()



end event

public function string wf_return_selected ();// String Function RETURN_SELECTED () in U_SELECTION_LIST

string	ls_return_val
Long       ll_row 

ll_Row = 0 
ls_return_val = ""

Do While dw_1.GetSelected( ll_Row ) 
	If ls_return_val<>"" Then ls_return_val += ","
	IF ib_return_column_string THEN
		ls_return_val += GetItemString (dw_1, ll_row,istr_parametre.return_column)
	ELSE
		IF mid(dw_1.describe("#"+string(istr_parametre.search_column_1)+".ColType"),1,7) = "decimal" THEN
			ls_return_val += String(GetItemDecimal (dw_1, ll_row, istr_parametre.return_column))
		ELSE
			ls_return_val += String(GetItemNumber (dw_1, ll_row, istr_parametre.return_column))
		END IF
	END IF
Loop

return ls_return_val
end function

public subroutine documentation ();/********************************************************************
   w_select_from_list
	
	<OBJECT>
		shared window object	
	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/08/11    CR2324   RJH022         Added documentation()
   05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_from_list
  
 Object     : 
  
 Event	 :  Open

 Scope     : Global

 ************************************************************************************

 Author    : Regin Mortesen, Martin Israelsen
   
 Date       : 1/1-96

 Description : Default search & select windows

 Arguments : istr_parameter 

 Returns   : String

 Variables : None

 Other : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-1-96		1.0 			MI		Initial version
17-4-96		2.19			MI		Fixed problem with keypress (up and down), that could cause
										program errors.  
02-5-96		2.21			MI		Added multiselect functionality.
************************************************************************************/

istr_parametre = Message.PowerObjectParm
dw_1.DataObject  = istr_parametre.dw
dw_1.SetTransObject(SQLCA)

If istr_parametre.multiselect then
	dw_1.ib_simpleselect = true
  
else
	dw_1.ib_multiallowed = false
	dw_1.ib_auto = true
	//CR2324 Added by RJH022 on 2011-08-02. Change desc: change UI
	this.height = dw_1.y + dw_1.height + cb_select_all.height + 36
end if

PostEvent("ue_retrieve")

// Get search column 1 data type
IF dw_1.describe("#"+string(istr_parametre.search_column_1)+".ColType") = "number" OR &
   dw_1.describe("#"+string(istr_parametre.search_column_1)+".ColType") = "long" OR &
	mid(dw_1.describe("#"+string(istr_parametre.search_column_1)+".ColType"),1,7) = "decimal" THEN
	ib_search_column_1_string = FALSE
ELSE
	ib_search_column_1_string = TRUE
END IF

// Get search column 2 data type
IF dw_1.describe("#"+string(istr_parametre.search_column_2)+".ColType") = "number" OR &
   dw_1.describe("#"+string(istr_parametre.search_column_2)+".ColType") = "long" OR &
	mid(dw_1.describe("#"+string(istr_parametre.search_column_2)+".ColType"),1,7) = "decimal"THEN
	ib_search_column_2_string = FALSE
ELSE
	ib_search_column_2_string = TRUE
END IF

// Get return value data type
IF dw_1.describe("#"+string(istr_parametre.return_column)+".ColType") = "number" OR &
	dw_1.describe("#"+string(istr_parametre.return_column)+".ColType") = "long" OR &
	mid(dw_1.describe("#"+string(istr_parametre.return_column)+".ColType"),1,7) = "decimal" THEN
	ib_return_column_string = FALSE
ELSE
	ib_return_column_string = TRUE
END IF

//Set Window Title sort Text and Hide
this.Title = istr_parametre.window_title
rb_header1.text = istr_parametre.search_column_1_text
rb_header2.text = istr_parametre.search_column_2_text
IF rb_header1.text = rb_header2.text then rb_header2.visible = false
IF IsNull(istr_parametre.win) THEN
	cb_new.Hide()
	cb_modify.Hide()
	cb_delete.Hide()
	cb_refresh.Hide()
	cb_close.Hide()
	cb_ok.Default = TRUE
ELSE
	cb_ok.Hide()
	cb_cancel.Hide()
	cb_new.Default = TRUE
END IF

// MI 06-11-95, fixed so that the selectlist will start sorted:

dw_1.SetSort("#"+string(istr_parametre.search_column_1)+" A")
dw_1.Sort()


sle_find.text = ""
is_filter = ""
il_selectedrow = 0

end event

on w_select_from_list.create
int iCurrent
call super::create
this.cb_deselect_all=create cb_deselect_all
this.cb_select_all=create cb_select_all
this.dw_1=create dw_1
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_refresh=create cb_refresh
this.rb_header1=create rb_header1
this.rb_header2=create rb_header2
this.st_return=create st_return
this.st_1=create st_1
this.sle_find=create sle_find
this.cb_modify=create cb_modify
this.cb_new=create cb_new
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_deselect_all
this.Control[iCurrent+2]=this.cb_select_all
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_refresh
this.Control[iCurrent+7]=this.rb_header1
this.Control[iCurrent+8]=this.rb_header2
this.Control[iCurrent+9]=this.st_return
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_find
this.Control[iCurrent+12]=this.cb_modify
this.Control[iCurrent+13]=this.cb_new
this.Control[iCurrent+14]=this.cb_ok
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.cb_cancel
end on

on w_select_from_list.destroy
call super::destroy
destroy(this.cb_deselect_all)
destroy(this.cb_select_all)
destroy(this.dw_1)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_refresh)
destroy(this.rb_header1)
destroy(this.rb_header2)
destroy(this.st_return)
destroy(this.st_1)
destroy(this.sle_find)
destroy(this.cb_modify)
destroy(this.cb_new)
destroy(this.cb_ok)
destroy(this.gb_1)
destroy(this.cb_cancel)
end on

event resize;////
//this.setredraw(false)
//If istr_parametre.multiselect then
//	this.height = dw_1.y + dw_1.height + cb_select_all.height + 72
//else
//	 
//	this.height = dw_1.y + dw_1.height + cb_select_all.height + 36
//end if
//this.setredraw(true)
end event

type cb_deselect_all from mt_u_commandbutton within w_select_from_list
integer x = 1458
integer y = 1812
integer taborder = 70
string text = "&Deselect All"
end type

event clicked;call super::clicked;dw_1.selectrow(0, false)
end event

type cb_select_all from mt_u_commandbutton within w_select_from_list
integer x = 1083
integer y = 1812
integer taborder = 70
string text = "&Select All"
end type

event clicked;call super::clicked;dw_1.selectrow(0, true)
end event

type dw_1 from uo_datawindow_multiselect within w_select_from_list
integer x = 18
integer y = 512
integer width = 1792
integer height = 1264
integer taborder = 60
string dataobject = "dw_vessel_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;// DoubleClicked Script for dw_1

//cb_ok.TriggerEvent(Clicked!)
//Added by RJH022 on 2011-08-03. Change desc: fix an existing bug (when clicking the header, the window will be closed)
if row = 0 then return
if istr_parametre.dw = "dw_active_agent_list" then
	OpenWithParm(w_agent_disbursement, dw_1.getitemnumber(dw_1.getselectedrow( 0),"agent_nr"),w_tramos_main)
else
	parent.TriggerEvent("ue_entry_chosen")
end if

end event

event clicked;call super::clicked;//CR2324 Begin modified by RJH022 on 2011-08-03
string ls_sort

If row = 0 then
	If (string(dwo.type) = "text") then
		If (string(dwo.tag)>"") then
			ls_sort = dwo.tag
			This.setsort(ls_sort)
			This.sort()
			If upper(right(ls_sort,1)) = "A" then 
				ls_sort = replace(ls_sort, len(ls_sort),1, "D")
			Else
				ls_sort = replace(ls_sort, len(ls_sort),1, "A")
			End if
			dwo.tag = ls_sort		
		End If
	End if
End If
//End modified by RJH022 on 2011-08-03

end event

type cb_close from commandbutton within w_select_from_list
integer x = 1243
integer y = 416
integer width = 466
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;close(parent)
end on

type cb_delete from commandbutton within w_select_from_list
integer x = 1243
integer y = 224
integer width = 466
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

on clicked;//Long ll_row
//ll_row = dw_agent_list.GetRow()
//IF MessageBox("Delete","You are about to DELETE an Agent!~r~n" + &
//							  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return
//dw_agent_list.DeleteRow(ll_row)
//IF dw_agent_list.Update() = 1 THEN
//	commit;
//	w_agent_list.PostEvent("ue_retrieve")
//ELSE
//	rollback;
//END IF
end on

type cb_refresh from commandbutton within w_select_from_list
integer x = 1243
integer y = 320
integer width = 466
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

on clicked;//w_agent_list.PostEvent("ue_retrieve")
end on

type rb_header1 from radiobutton within w_select_from_list
integer x = 73
integer y = 96
integer width = 507
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Header 1"
boolean checked = true
end type

event clicked;ii_search_column = istr_parametre.search_column_1
ib_search_column_string = ib_search_column_1_string

dw_1.SetSort("#"+string(istr_parametre.search_column_1)+" A")
dw_1.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
st_1.Text = "Search for " + This.Text + ":"
sle_find.SetFocus()
end event

type rb_header2 from radiobutton within w_select_from_list
integer x = 585
integer y = 96
integer width = 471
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Header2"
end type

event clicked;ii_search_column = istr_parametre.search_column_2
ib_search_column_string = ib_search_column_2_string

dw_1.SetSort("#"+string(istr_parametre.search_column_2)+" A")
dw_1.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
st_1.Text = "Search for " + This.Text + ":"
sle_find.SetFocus()
end event

type st_return from statictext within w_select_from_list
integer x = 713
integer y = 416
integer width = 457
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_select_from_list
integer x = 73
integer y = 224
integer width = 677
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Find:"
end type

type sle_find from singlelineedit within w_select_from_list
event key_pressed pbm_keydown
integer x = 73
integer y = 288
integer width = 987
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "arrow!"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event key_pressed;// Key_Pressed Script for sle_find

// key pressed in datawindow
// capture up and down arrows to move the selection up and down

int  li_movement 
long ll_row

string ls_character
long	 ll_found_row
int	 li_num_chars

If KeyDown (keyUparrow!) then
	li_movement = -1
End If

If KeyDown (keyDownarrow!) then
	li_movement = 1
End If

If li_movement <> 0 Then
	dw_1.setRedraw(False)
	ll_row = dw_1.getselectedrow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_1.rowcount( ) Then 
		beep(1)
		Return
	End If
	dw_1.selectrow(0,False)
	dw_1.selectrow(ll_row , True)
	dw_1.scrolltorow (ll_row)
	
	IF ib_search_column_string THEN
		sle_find.text = dw_1.getitemstring(ll_row, ii_search_column);
	Else
		sle_find.text = String(dw_1.getitemnumber(ll_Row, ii_search_column) )
	END IF

/* sle_find.text = dw_1.GetItemString(ll_row , 1) */
	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_1.setredraw(true)
     sle_find.selecttext(len(sle_find.text) + 1,0)
	message.processed = true
	Return
End if


ls_character = Char(message.wordparm)

/* Numeric keys used in search */
IF KeyDown(KeyNumpad0!) Or KeyDown(Key0!)THEN
	ls_character = "0"
ELSEIF KeyDown(KeyNumpad1!) Or KeyDown(Key1!) THEN
	ls_character = "1"
ELSEIF KeyDown(KeyNumpad2!) Or KeyDown(Key2!) THEN
	ls_character = "2"
ELSEIF KeyDown(KeyNumpad3!) Or KeyDown(Key3!) THEN
	ls_character = "3"
ELSEIF KeyDown(KeyNumpad4!) Or KeyDown(Key4!) THEN
	ls_character = "4"
ELSEIF KeyDown(KeyNumpad5!) Or KeyDown(Key5!) THEN
	ls_character = "5"
ELSEIF KeyDown(KeyNumpad6!) Or KeyDown(Key6!) THEN
	ls_character = "6"
ELSEIF KeyDown(KeyNumpad7!) Or KeyDown(Key7!) THEN
	ls_character = "7"
ELSEIF KeyDown(KeyNumpad8!) Or KeyDown(Key8!) THEN
	ls_character = "8"
ELSEIF KeyDown(KeyNumpad9!) Or KeyDown(Key9!) THEN
	ls_character = "9"
END IF


If message.wordparm < 32   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = left(is_filter, li_num_chars - 1)  
else
	beep(1)
	is_filter = is_filter + ls_character
end if
 
 
// Do case-insensitive search
if Len(is_filter) > 0 then
	if ib_search_column_string then
		ll_found_row = dw_1.Find("Lower(#"+string(ii_search_column)+")>=~"" + Lower(is_filter) + "~"",1, 99999)
	else
		
		ll_found_row = dw_1.Find("#"+string(ii_search_column)+">="+is_filter, 1, 99999)
	
   end if
	if ll_found_row > 0 then 
		dw_1.setredraw(false)
		dw_1.selectrow(0, false)
		dw_1.scrolltorow(ll_found_row)
		dw_1.selectrow(ll_found_row, true)
		dw_1.setredraw(true)
		// is_filterer function did not find any matching row
	else
         Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = is_filter  	
		// Throw away last character
		dw_1.SelectRow(0, FALSE)
		message.processed = true
	end if
		// is_filterer length is 0, so unhighlight former selected row
else	
	dw_1.SelectRow(0, false)
end if

// Remember number of highlighted row
il_selectedrow = ll_found_row			

end event

type cb_modify from commandbutton within w_select_from_list
integer x = 1243
integer y = 128
integer width = 466
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Modify"
end type

on clicked;window mywin
parent.TriggerEvent("ue_entry_choosen")
IF st_return.text <> "Nothing" THEN
	OpenSheetWithParm( mywin, integer(st_return.text), istr_parametre.win, w_tramos_main, 7, Original!)
END IF

end on

type cb_new from commandbutton within w_select_from_list
integer x = 1243
integer y = 32
integer width = 466
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New "
boolean default = true
end type

on clicked;window mywin
OpenSheetWithParm( mywin, 0, istr_parametre.win, w_tramos_main, 7, Original!)
end on

type cb_ok from commandbutton within w_select_from_list
integer x = 1243
integer y = 32
integer width = 466
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;// Clicked script for cb_ok

parent.TriggerEvent("ue_entry_chosen")
end event

type gb_1 from groupbox within w_select_from_list
integer x = 18
integer y = 16
integer width = 1097
integer height = 384
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 81324524
string text = "Search and Sort"
end type

type cb_cancel from commandbutton within w_select_from_list
integer x = 1243
integer y = 128
integer width = 466
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;// Clicked script for cb_cancel
// Reset box to none selected, no text
String ls_null

SetNull(ls_null)

dw_1.SetRedraw(FALSE)
dw_1.SelectRow(il_selectedrow, FALSE)
dw_1.ScrollToRow(1)
dw_1.SetRedraw(TRUE)
sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

//parent.TriggerEvent("ue_entry_chosen")
CloseWithReturn(parent,ls_null)
end event

