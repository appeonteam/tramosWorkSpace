$PBExportHeader$uo_fin_agent.sru
forward
global type uo_fin_agent from userobject
end type
type rb_header2 from radiobutton within uo_fin_agent
end type
type rb_header1 from radiobutton within uo_fin_agent
end type
type dw_1 from uo_datawindow within uo_fin_agent
end type
type sle_find from singlelineedit within uo_fin_agent
end type
type st_1 from statictext within uo_fin_agent
end type
type gb_1 from groupbox within uo_fin_agent
end type
end forward

global type uo_fin_agent from userobject
integer width = 2021
integer height = 736
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_retrieve ( )
rb_header2 rb_header2
rb_header1 rb_header1
dw_1 dw_1
sle_find sle_find
st_1 st_1
gb_1 gb_1
end type
global uo_fin_agent uo_fin_agent

type variables
long   il_selectedrow

string  is_filter

s_list istr_parametre
boolean ib_column_string[0 to 2] // True, False 
integer ii_current_column
end variables

forward prototypes
public subroutine wf_select_column (integer columnno)
public subroutine wf_initialize ()
end prototypes

event ue_retrieve();dw_1.Retrieve()
COMMIT;
//ii_search_column = istr_parametre.search_column_1
//ib_search_column_string = ib_search_column_1_string
sle_find.SetFocus()
end event

public subroutine wf_select_column (integer columnno);ii_current_column = columnno
dw_1.SelectRow(0,False)
dw_1.SetSort(string(istr_parametre.column[ii_current_column])+" A")
dw_1.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

// wf_updatebuttons()
end subroutine

public subroutine wf_initialize ();Long ll_count
string ls_tmp
// istr_parametre = Message.PowerObjectParm

istr_parametre.list_window = "dw_agent_list"
istr_parametre.edit_window = "w_agent"
SetNull(istr_parametre.edit_datawindow)
istr_parametre.column[0] = "agent_nr"
istr_parametre.column[1] = "agent_sn"
istr_parametre.column[2] = "agent_n_1"
istr_parametre.column_name[1] = "short name"
istr_parametre.column_name[2] = "full name"
istr_parametre.window_title = "Agents"

dw_1.DataObject  = istr_parametre.list_window
dw_1.SetTransObject(SQLCA)
// dw_agent_payments.settransobject(SQLCA)
dw_1.setrowfocusindicator(FocusRect!)

// This.Move(5,5)

// Get search column data type

For ll_count = 0 to 2 
	ls_tmp= "string"
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

// this.Title = istr_parametre.window_title

rb_header1.text = istr_parametre.column_name[1]
rb_header2.text = istr_parametre.column_name[2]

//IF  IsNull(istr_parametre.edit_datawindow) And  IsNull (istr_parametre.edit_window) THEN
//	cb_close.Hide()
//END IF

Setnull(istr_parametre.return_value)
wf_select_column(1)
PostEvent("ue_retrieve")
end subroutine

on uo_fin_agent.create
this.rb_header2=create rb_header2
this.rb_header1=create rb_header1
this.dw_1=create dw_1
this.sle_find=create sle_find
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.rb_header2,&
this.rb_header1,&
this.dw_1,&
this.sle_find,&
this.st_1,&
this.gb_1}
end on

on uo_fin_agent.destroy
destroy(this.rb_header2)
destroy(this.rb_header1)
destroy(this.dw_1)
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.gb_1)
end on

type rb_header2 from radiobutton within uo_fin_agent
integer x = 1536
integer y = 592
integer width = 402
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Full Name"
borderstyle borderstyle = stylelowered!
end type

on clicked;wf_select_column(2)
end on

type rb_header1 from radiobutton within uo_fin_agent
integer x = 1536
integer y = 512
integer width = 416
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Short Name"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

on clicked;wf_select_column(1)

end on

type dw_1 from uo_datawindow within uo_fin_agent
integer x = 37
integer y = 144
integer width = 1431
integer height = 564
integer taborder = 20
string dataobject = "d_fin_agent"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;// Clicked Script for dw_1 
long ll_array[]

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
	
	ll_array[1] = dw_1.getitemnumber(row, "agent_nr")
	IF isvalid(w_fin_agent_payments.dw_agent_payments) THEN
		w_fin_agent_payments.dw_agent_payments.retrieve(ll_array)
	END IF
	
//	wf_updatebuttons()
End If


end event

event doubleclicked;call super::doubleclicked;if (row > 0) then
	openwithparm(w_agent, dw_1.getitemnumber(dw_1.getrow(), "agent_nr"))
end if
end event

type sle_find from singlelineedit within uo_fin_agent
event key_pressed pbm_keydown
integer x = 187
integer y = 32
integer width = 951
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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


end event

type st_1 from statictext within uo_fin_agent
integer x = 37
integer y = 48
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Find:"
alignment alignment = right!
end type

type gb_1 from groupbox within uo_fin_agent
integer x = 1499
integer y = 420
integer width = 475
integer height = 288
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Sort/Search"
borderstyle borderstyle = stylelowered!
end type

