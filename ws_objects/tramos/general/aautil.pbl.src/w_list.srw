$PBExportHeader$w_list.srw
$PBExportComments$Default select/edit window
forward
global type w_list from mt_w_response
end type
type cb_modify from uo_securitybutton within w_list
end type
type cb_delete from uo_securitybutton within w_list
end type
type cb_new from uo_securitybutton within w_list
end type
type cb_close from commandbutton within w_list
end type
type cb_refresh from commandbutton within w_list
end type
type rb_header1 from radiobutton within w_list
end type
type rb_header2 from radiobutton within w_list
end type
type st_return from statictext within w_list
end type
type st_1 from statictext within w_list
end type
type cb_ok from commandbutton within w_list
end type
type cb_cancel from commandbutton within w_list
end type
type dw_1 from uo_datawindow within w_list
end type
type gb_1 from groupbox within w_list
end type
type sle_find from singlelineedit within w_list
end type
end forward

global type w_list from mt_w_response
integer x = 677
integer y = 268
integer width = 1737
integer height = 1752
long backcolor = 81324524
event ue_entry_chosen pbm_custom01
event ue_retrieve pbm_custom02
cb_modify cb_modify
cb_delete cb_delete
cb_new cb_new
cb_close cb_close
cb_refresh cb_refresh
rb_header1 rb_header1
rb_header2 rb_header2
st_return st_return
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
dw_1 dw_1
gb_1 gb_1
sle_find sle_find
end type
global w_list w_list

type variables
long   il_selectedrow

string  is_filter

s_list istr_parametre
boolean ib_column_string[0 to 2] // True, False 
integer ii_current_column
end variables

forward prototypes
public subroutine wf_updatebuttons ()
public subroutine wf_open_detail ()
public function string wf_return_selected ()
public subroutine wf_select_column (integer columnno)
public subroutine documentation ()
end prototypes

on ue_entry_chosen;// Entry_Chosen Script for UO_1

string	ls_selected_value

ls_selected_value = wf_return_selected ()

if Len (ls_selected_value) = 0  then  SetNull(ls_selected_value)

st_return.text =  ls_selected_value
// s_list_return = ls_selected_value
// CloseWithReturn(This, ls_selected_value)
Close(This)
end on

event ue_retrieve;/* Which one needs retrieval agrument and which does not */
if dw_1.dataObject = "dw_profit_center_list" & 
or dw_1.dataObject = "dw_vessel_list" &
or dw_1.dataObject = "d_vessel_group_list" then
	dw_1.Retrieve( uo_global.is_userid )
else	
	dw_1.Retrieve()
end if
COMMIT;
//ii_search_column = istr_parametre.search_column_1
//ib_search_column_string = ib_search_column_1_string
sle_find.SetFocus()

/* Access control - remember to alto modify w_detail_list */
Choose case dw_1.dataObject
	/* Admin and Superuser */
	case "dw_claimtype_list", "dw_groups_list", "dw_purpose_list", &
    			"d_vessel_group_list", "d_vessel_type_list" 
		if uo_global.ii_access_level > 1 then
			cb_new.enabled = true
			cb_delete.enabled = true
		else
			cb_new.enabled = false
			cb_delete.enabled = false
		end if
	/* Admin and Finance profile */
	case "dw_currency_list", "dw_voucher_list", "dw_voucher_group_list", "dw_profit_center_list"
		if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
			cb_new.enabled = true
			cb_delete.enabled = true
		else
			cb_new.enabled = false
			cb_delete.enabled = false
		end if
end choose

end event

public subroutine wf_updatebuttons ();cb_delete.enabled = il_selectedrow > 0 and cb_new.enabled
//cb_modify.enabled = cb_delete.enabled
end subroutine

public subroutine wf_open_detail ();w_list_detail mydata
Window mywindow

If (IsNull(istr_parametre.edit_window_title)) Or (istr_parametre.edit_window_title = "")  Then &
	istr_parametre.edit_window_title = Istr_parametre.window_title

If Not IsNull(istr_parametre.edit_datawindow) Then
	OpenSheetWithParm( mydata, istr_parametre, w_tramos_main, 7, Original!)
Elseif Not IsNull(istr_parametre.edit_window) Then
	If ib_column_string[0] Then
		OpenSheetWithParm(mywindow, istr_parametre.edit_key_text, istr_parametre.edit_window,  w_tramos_main, 7, original!)
	else
		OpenSheetWithParm(mywindow,  istr_parametre.edit_key_number, istr_parametre.edit_window, w_tramos_main, 7, original!)
	end if
end if


end subroutine

public function string wf_return_selected ();// String Function RETURN_SELECTED () in U_SELECTION_LIST

string	ls_return_val
//
//IF il_selectedrow > 0 THEN
//	IF ib_return_column_string THEN
//		ls_return_val = GetItemString (dw_1, il_selectedrow,istr_parametre.return_column)
//	ELSE
//		ls_return_val = String(GetItemNumber (dw_1, il_selectedrow, istr_parametre.return_column))
//	END IF
//ELSE
//	ls_return_val = ""
//END IF
//
return ls_return_val
end function

public subroutine wf_select_column (integer columnno);ii_current_column = columnno
dw_1.SelectRow(0,False)
dw_1.SetSort(string(istr_parametre.column[ii_current_column])+" A")
dw_1.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

wf_updatebuttons()
end subroutine

public subroutine documentation ();/********************************************************************
   w_list
	
	<OBJECT>

	</OBJECT>
   	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
	25/08/14		CR3708	CCY018			F1 help application coverage - modified event ue_getwidowname
	10/10/14		CR3781	CCY018			The window title match with the text of a menu item
********************************************************************/
end subroutine

event open;Long ll_count
string ls_tmp
istr_parametre = Message.PowerObjectParm
dw_1.DataObject  = istr_parametre.list_window
dw_1.SetTransObject(SQLCA)
This.Move(5,5)

// Get search column data type

For ll_count = 0 to 2 
   ls_tmp= dw_1.describe(string(istr_parametre.column[ll_count])+".ColType") 
// If detail window doesn't work test what type is returned and insert into case
//	messagebox("type",ls_tmp)
	CHOOSE CASE ls_tmp
		CASE "number"
			ib_column_string[ll_count] = false
		CASE "long"
			ib_column_string[ll_count] = false
		CASE "integer"
			ib_column_string[ll_count] = false
		CASE ELSE
			ib_column_string[ll_count] = true
	END CHOOSE
Next

//Set Window Title sort Text and Hide
this.Title = istr_parametre.window_title

rb_header1.text = istr_parametre.column_name[1]
rb_header2.text = istr_parametre.column_name[2]
st_1.Text = "Search for " + rb_header1.Text + ":"
If rb_header2.text = "" then rb_header2.Visible = False

IF  IsNull(istr_parametre.edit_datawindow) And  IsNull (istr_parametre.edit_window) THEN
	cb_new.Hide()
	cb_modify.Hide()
	cb_delete.Hide()
	cb_refresh.Hide()
	cb_close.Hide()
ELSE
	cb_ok.Hide()
	cb_cancel.Hide()
END IF

Setnull(istr_parametre.return_value)
wf_select_column(1)
PostEvent("ue_retrieve")




end event

on w_list.create
int iCurrent
call super::create
this.cb_modify=create cb_modify
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_refresh=create cb_refresh
this.rb_header1=create rb_header1
this.rb_header2=create rb_header2
this.st_return=create st_return
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_1=create dw_1
this.gb_1=create gb_1
this.sle_find=create sle_find
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_modify
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.cb_refresh
this.Control[iCurrent+6]=this.rb_header1
this.Control[iCurrent+7]=this.rb_header2
this.Control[iCurrent+8]=this.st_return
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_ok
this.Control[iCurrent+11]=this.cb_cancel
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.sle_find
end on

on w_list.destroy
call super::destroy
destroy(this.cb_modify)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_refresh)
destroy(this.rb_header1)
destroy(this.rb_header2)
destroy(this.st_return)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.sle_find)
end on

event ue_getwindowname;call super::ue_getwindowname;if istr_parametre.window_title = "Currencies" then
	as_windowname = this.classname( ) + "_currency"
elseif istr_parametre.window_title = "Vouchers" then
	as_windowname = this.classname( ) + "_voucher"
elseif istr_parametre.window_title = "Voucher Groups" then
	as_windowname = this.classname( ) + "_vouchergroup"
else
	as_windowname = this.classname( )
end if
	
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_list
end type

type cb_modify from uo_securitybutton within w_list
integer x = 1243
integer y = 128
integer width = 402
integer height = 80
integer taborder = 60
string text = "&Modify"
end type

event clicked;call super::clicked;Long ll_row

ll_row = dw_1.GetSelectedRow(0)
If ll_Row > 0 Then
	
	If ib_column_string[0] then 
		If "decimal(0)" <> dw_1.describe(string(istr_parametre.column[0])+".ColType") Then
			istr_parametre.edit_key_text = string(dw_1.GetItemString(ll_row, Istr_parametre.column[0] ))
		Else
			istr_parametre.edit_key_number = dw_1.GetItemDecimal(ll_row, Istr_parametre.column[0] )
		End if
	Else
		istr_parametre.edit_key_number = dw_1.GetItemNumber(ll_row, Istr_parametre.column[0] )
   end if
	wf_open_detail()
End if

end event

type cb_delete from uo_securitybutton within w_list
integer x = 1243
integer y = 224
integer width = 402
integer height = 80
integer taborder = 40
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;Long ll_row, ll_pcnr
ll_row = dw_1.GetSelectedRow(0)

If ll_Row <> 0 Then
	IF MessageBox("Delete","You are about to DELETE !~r~n" + &
					  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return
	if dw_1.dataObject = "dw_profit_center_list" then
		// if profitcenter delete table where users are given access to profitcenter
		ll_pcnr = dw_1.getItemNumber(ll_row, "pc_nr")
		delete from USERS_PROFITCENTER
		where PC_NR = :ll_pcnr;
	end if
	dw_1.DeleteRow(ll_row)
	IF dw_1.Update() = 1 THEN
		commit;
		dw_1.PostEvent("ue_retrieve")
	ELSE
		rollback;
	END IF
end if
end event

type cb_new from uo_securitybutton within w_list
integer x = 1038
integer y = 108
integer width = 402
integer height = 80
integer taborder = 30
string text = "&New"
end type

on clicked;call uo_securitybutton::clicked;istr_parametre.edit_key_text = ""
istr_parametre.edit_key_number = 0

wf_open_detail()


end on

type cb_close from commandbutton within w_list
integer x = 1243
integer y = 416
integer width = 402
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

type cb_refresh from commandbutton within w_list
integer x = 1243
integer y = 320
integer width = 402
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

event clicked;if dw_1.dataObject = "dw_profit_center_list" or dw_1.dataObject = "dw_vessel_list" then
	dw_1.Retrieve( uo_global.is_userid )
else
	dw_1.Retrieve()
end if
end event

type rb_header1 from radiobutton within w_list
integer x = 73
integer y = 128
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

event clicked;wf_select_column(1)
st_1.Text = "Search for " + this.Text + ":"
end event

type rb_header2 from radiobutton within w_list
integer x = 585
integer y = 128
integer width = 530
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

event clicked;wf_select_column(2)
st_1.Text = "Search for " + this.Text + ":"
end event

type st_return from statictext within w_list
boolean visible = false
integer x = 567
integer y = 272
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

type st_1 from statictext within w_list
integer x = 73
integer y = 288
integer width = 786
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Find:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_list
integer x = 1243
integer y = 32
integer width = 402
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

on clicked;// Clicked script for cb_ok

parent.TriggerEvent("ue_entry_chosen")

end on

type cb_cancel from commandbutton within w_list
integer x = 1243
integer y = 416
integer width = 402
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

on clicked;// Clicked script for cb_cancel
// Reset box to none selected, no text

dw_1.SetRedraw(FALSE)
dw_1.SelectRow(il_selectedrow, FALSE)
dw_1.ScrollToRow(1)
dw_1.SetRedraw(TRUE)
sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

parent.TriggerEvent("ue_entry_chosen")
end on

type dw_1 from uo_datawindow within w_list
integer x = 18
integer y = 528
integer width = 1682
integer height = 1120
integer taborder = 20
string dataobject = "dw_vessel_list"
boolean vscrollbar = true
end type

event clicked;call super::clicked;// Clicked Script for dw_1 

dw_1.SelectRow(il_selectedrow, FALSE)	// Un-highlight old row

il_selectedrow = row

//seletion of row set text to this row and set filter to this
if il_selectedrow <> 0 Then

	dw_1.SelectRow(0,False)
	dw_1.SelectRow(il_selectedrow, TRUE)		// Highlight new row
	IF ib_column_string[ii_current_column] THEN
//		messagebox("debug1",string(ii_current_column))
		sle_find.text = dw_1.GetItemString(il_selectedrow, istr_parametre.column[ii_current_column])
	ELSE
//		messagebox("debug2",string(ii_current_column))
		sle_find.text = string(dw_1.GetItemNumber(il_selectedrow, istr_parametre.column[ii_current_column]))
	END IF

	is_filter = sle_find.text

	wf_updatebuttons()
End If


end event

on doubleclicked;call uo_datawindow::doubleclicked;// DoubleClicked Script for dw_1

// cb_ok.TriggerEvent(Clicked!)

If cb_modify.enabled then cb_modify.TriggerEvent(Clicked!)
end on

type gb_1 from groupbox within w_list
integer x = 18
integer y = 16
integer width = 1134
integer height = 480
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

type sle_find from singlelineedit within w_list
event key_pressed pbm_keydown
integer x = 73
integer y = 352
integer width = 951
integer height = 80
integer taborder = 10
boolean bringtotop = true
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

int li_movement, li_num_chars
long ll_row, ll_found_row
string	ls_character

If KeyDown (keyUparrow!) then
	li_movement = -1
End If


If KeyDown (keyDownarrow!) then
	li_movement = 1
End If

If li_movement <> 0 Then
	dw_1.SetRedraw(False)
	ll_row = dw_1.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_1.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_1.selectrow(0,False)
	dw_1.SelectRow(ll_row , True)
	dw_1.ScrollToRow (ll_row)

	IF ib_column_string[ii_current_column] THEN
		sle_find.text = dw_1.GetItemString(ll_row, istr_parametre.column[ii_current_column]);
	Else
		sle_find.text = String(dw_1.GetItemNumber(ll_Row, ii_current_column) )
	END IF


	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_1.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true

	cb_modify.enabled = true
	cb_delete.enabled = true

End If

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

// Backspace or add character to string
If message.wordparm = 8  then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
end If

// Do case-insensitive search

IF Len(is_filter) > 0 THEN
	IF ib_column_string[ii_current_column] THEN
		ll_found_row = dw_1.Find(Lower(istr_parametre.column[ii_current_column]) + ">='" + Lower(is_filter) + "'",1, 99999)
	ELSE
		ll_found_row = dw_1.Find(string(istr_parametre.column[ii_current_column])+">="+is_filter,1, 99999)
	END IF
	IF ll_found_row > 0 THEN 
		dw_1.SetRedraw(FALSE)
		dw_1.SelectRow(0, FALSE)
		dw_1.ScrollToRow(ll_found_row)
		dw_1.SelectRow(ll_found_row, TRUE)
		dw_1.SetRedraw(TRUE)
// is_filterer function did not find any matching row
	Else
            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
// Throw away last character
		message.processed = true
	End If
// is_filterer length is 0, so unhighlight former selected row
Else	
	dw_1.SelectRow(0, FALSE)
	ll_found_row = 0
End If

// Remember number of highlighted row
il_selectedrow = ll_found_row			

wf_updatebuttons()

end event

