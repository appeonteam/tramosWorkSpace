$PBExportHeader$w_select_voyage_charter_owner.srw
$PBExportComments$Select voyage/charterer/owner when creating t/c owner
forward
global type w_select_voyage_charter_owner from mt_w_response
end type
type dw_list_charterer from uo_datawindow within w_select_voyage_charter_owner
end type
type rb_header2 from radiobutton within w_select_voyage_charter_owner
end type
type rb_header1 from radiobutton within w_select_voyage_charter_owner
end type
type sle_find from singlelineedit within w_select_voyage_charter_owner
end type
type st_find from statictext within w_select_voyage_charter_owner
end type
type dw_list_voyage from uo_datawindow within w_select_voyage_charter_owner
end type
type sle_tcowner from singlelineedit within w_select_voyage_charter_owner
end type
type st_tcowner from statictext within w_select_voyage_charter_owner
end type
type st_hiretext from statictext within w_select_voyage_charter_owner
end type
type rb_out from radiobutton within w_select_voyage_charter_owner
end type
type rb_in from radiobutton within w_select_voyage_charter_owner
end type
type cb_cancel from commandbutton within w_select_voyage_charter_owner
end type
type cb_ok from commandbutton within w_select_voyage_charter_owner
end type
type gb_sort from groupbox within w_select_voyage_charter_owner
end type
type gb_hire from groupbox within w_select_voyage_charter_owner
end type
end forward

global type w_select_voyage_charter_owner from mt_w_response
integer x = 626
integer y = 300
integer width = 1710
integer height = 1148
string title = "Select Hire-In/Out, Voyage and Charterer/Owner"
boolean controlmenu = false
long backcolor = 81324524
dw_list_charterer dw_list_charterer
rb_header2 rb_header2
rb_header1 rb_header1
sle_find sle_find
st_find st_find
dw_list_voyage dw_list_voyage
sle_tcowner sle_tcowner
st_tcowner st_tcowner
st_hiretext st_hiretext
rb_out rb_out
rb_in rb_in
cb_cancel cb_cancel
cb_ok cb_ok
gb_sort gb_sort
gb_hire gb_hire
end type
global w_select_voyage_charter_owner w_select_voyage_charter_owner

type variables
s_select_voyage_chartererowner istr_parametre
LONG tcowner_nr=0
long   il_selectedrow

string  is_filter

integer ii_search_column
boolean ib_search_column_string

boolean ib_search_column_1_string  //TRUE = string
boolean ib_search_column_2_string  // FALSE = number

boolean ib_return_column_string  //TRUE = string
                                                // FALSE = number

LONG vessel_nr
end variables

forward prototypes
public subroutine setsort (integer pl_sort)
public subroutine selectcontrols (boolean pb_hireout)
public subroutine documentation ()
end prototypes

public subroutine setsort (integer pl_sort);SetRedraw(False)

ii_search_column = pl_sort
ib_search_column_string = TRUE

if pl_sort = 1 Then 
    dw_list_charterer.SetSort("chart_chart_sn A")
Else
    dw_list_charterer.SetSort("chart_chart_n_1 A")
End if

dw_list_charterer.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

Long ll_row
ll_row = dw_list_charterer.GetSelectedRow(0)
If ll_row <> 0 Then dw_list_charterer.ScrollToRow( ll_Row )

SetRedraw(True)


end subroutine

public subroutine selectcontrols (boolean pb_hireout);gb_sort.visible = pb_hireout
rb_header2.visible = pb_hireout
rb_header1.visible = pb_hireout
dw_list_charterer.visible = pb_hireout
// dw_list_voyage.visible = pb_hireout
sle_find.visible = pb_hireout
st_find.visible = pb_hireout

sle_tcowner.visible = not pb_hireout
st_tcowner.visible = not pb_hireout




end subroutine

public subroutine documentation ();/********************************************************************
	w_select_voyage_charter_owner
	
	<OBJECT>
	</OBJECT>
	<DESC>
	This is not used, updated for completeness
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event open;vessel_nr = Message.DoubleParm

dw_list_voyage.SetTransObject(SQLCA)
dw_list_charterer.SetTransObject(SQLCA)

dw_list_voyage.Retrieve(vessel_nr)
dw_list_charterer.Retrieve()

STRING tcowner_sn, tcowner_n_1
SELECT TCOWNER_SN, TCOWNER_N_1, VESSELS.TCOWNER_NR
INTO :tcowner_sn, :tcowner_n_1, :tcowner_nr
FROM TCOWNERS, VESSELS 
WHERE VESSELS.VESSEL_NR = :vessel_nr
AND	VESSELS.TCOWNER_NR = TCOWNERS.TCOWNER_NR;

IF tcowner_nr = 0 THEN
	sle_tcowner.Text = "N/A"
        rb_in.enabled = false
ELSE
	sle_tcowner.Text = tcowner_sn + " / " +tcowner_n_1
        rb_in.checked = true
        rb_in.triggerEvent(Clicked!)
END IF


end event

on w_select_voyage_charter_owner.create
int iCurrent
call super::create
this.dw_list_charterer=create dw_list_charterer
this.rb_header2=create rb_header2
this.rb_header1=create rb_header1
this.sle_find=create sle_find
this.st_find=create st_find
this.dw_list_voyage=create dw_list_voyage
this.sle_tcowner=create sle_tcowner
this.st_tcowner=create st_tcowner
this.st_hiretext=create st_hiretext
this.rb_out=create rb_out
this.rb_in=create rb_in
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.gb_sort=create gb_sort
this.gb_hire=create gb_hire
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list_charterer
this.Control[iCurrent+2]=this.rb_header2
this.Control[iCurrent+3]=this.rb_header1
this.Control[iCurrent+4]=this.sle_find
this.Control[iCurrent+5]=this.st_find
this.Control[iCurrent+6]=this.dw_list_voyage
this.Control[iCurrent+7]=this.sle_tcowner
this.Control[iCurrent+8]=this.st_tcowner
this.Control[iCurrent+9]=this.st_hiretext
this.Control[iCurrent+10]=this.rb_out
this.Control[iCurrent+11]=this.rb_in
this.Control[iCurrent+12]=this.cb_cancel
this.Control[iCurrent+13]=this.cb_ok
this.Control[iCurrent+14]=this.gb_sort
this.Control[iCurrent+15]=this.gb_hire
end on

on w_select_voyage_charter_owner.destroy
call super::destroy
destroy(this.dw_list_charterer)
destroy(this.rb_header2)
destroy(this.rb_header1)
destroy(this.sle_find)
destroy(this.st_find)
destroy(this.dw_list_voyage)
destroy(this.sle_tcowner)
destroy(this.st_tcowner)
destroy(this.st_hiretext)
destroy(this.rb_out)
destroy(this.rb_in)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.gb_sort)
destroy(this.gb_hire)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_voyage_charter_owner
end type

type dw_list_charterer from uo_datawindow within w_select_voyage_charter_owner
integer x = 411
integer y = 248
integer width = 1207
integer height = 592
integer taborder = 30
string dataobject = "dw_list_charterer"
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
END IF

end event

type rb_header2 from radiobutton within w_select_voyage_charter_owner
integer x = 859
integer y = 896
integer width = 334
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Fullname"
end type

on clicked;SetSort(2)

end on

type rb_header1 from radiobutton within w_select_voyage_charter_owner
integer x = 439
integer y = 896
integer width = 384
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "S&hortname"
boolean checked = true
end type

on clicked;SetSort(1)

end on

type sle_find from singlelineedit within w_select_voyage_charter_owner
event key_pressed pbm_keydown
integer x = 713
integer y = 160
integer width = 896
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "arrow!"
long backcolor = 16777215
boolean autohscroll = false
end type

on key_pressed;// Key_Pressed Script for sle_find

// key pressed in datawindow
// capture up and down arrows to move the selection up and down

int li_movement 
long ll_row

If KeyDown (keyUparrow!) then
	li_movement = -1
End If


If KeyDown (keyDownarrow!) then
	li_movement = 1
End If

If li_movement <> 0 Then
	dw_list_charterer.SetRedraw(False)
	ll_row = dw_list_charterer.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_list_charterer.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_list_charterer.selectrow(0,False)
	dw_list_charterer.SelectRow(ll_row , True)
	dw_list_charterer.ScrollToRow (ll_row)
	sle_find.text = dw_list_charterer.GetItemString(ll_row , 1)
	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_list_charterer.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true
	Return
End If


string	ls_character
long	ll_found_row
int		li_num_chars

ls_character = Char(message.wordparm)

////filter out non alpha characters
//If (Lower(ls_character) < "a" or Lower(ls_character) > "z") and  ls_character <> Char(8) Then 
//	message.processed = true
//	Return
//End If

// Backspace 
If message.wordparm = 8   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
end if

// Do case-insensitive search
IF Len(is_filter) > 0 THEN
	IF ib_search_column_string THEN
		ll_found_row = dw_list_charterer.Find("Lower(#"+string(ii_search_column)+")>=~"" + Lower(is_filter) + "~"",1, 99999)
	ELSE
		ll_found_row = dw_list_charterer.Find("#"+string(ii_search_column)+">="+is_filter,1, 99999)
	END IF
	IF ll_found_row > 0 THEN 
		dw_list_charterer.SetRedraw(FALSE)
		dw_list_charterer.SelectRow(0, FALSE)
		dw_list_charterer.ScrollToRow(ll_found_row)
		dw_list_charterer.SelectRow(ll_found_row, TRUE)
		dw_list_charterer.SetRedraw(TRUE)
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
	dw_list_charterer.SelectRow(0, FALSE)
End If

// Remember number of highlighted row
il_selectedrow = ll_found_row			

	
end on

on constructor;ib_search_column_1_string = TRUE
ib_search_column_2_string = TRUE
sle_find.text = ""
is_filter = ""
il_selectedrow = 0
ii_search_column=1
ii_search_column = 1
ib_search_column_string = TRUE

end on

type st_find from statictext within w_select_voyage_charter_owner
integer x = 402
integer y = 176
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Charterer:"
end type

type dw_list_voyage from uo_datawindow within w_select_voyage_charter_owner
boolean visible = false
integer x = 37
integer y = 160
integer width = 329
integer height = 832
integer taborder = 20
boolean enabled = false
string dataobject = "dw_list_voyage"
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
END IF

end event

type sle_tcowner from singlelineedit within w_select_voyage_charter_owner
boolean visible = false
integer x = 347
integer y = 160
integer width = 896
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "test"
boolean autohscroll = false
boolean displayonly = true
end type

type st_tcowner from statictext within w_select_voyage_charter_owner
integer x = 37
integer y = 176
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "T/C Owner:"
boolean focusrectangle = false
end type

type st_hiretext from statictext within w_select_voyage_charter_owner
integer x = 73
integer y = 48
integer width = 133
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Hire:"
boolean focusrectangle = false
end type

type rb_out from radiobutton within w_select_voyage_charter_owner
integer x = 439
integer y = 48
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Out"
boolean checked = true
end type

event clicked;SelectControls(True)



end event

type rb_in from radiobutton within w_select_voyage_charter_owner
integer x = 256
integer y = 48
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&In"
end type

event clicked;Selectcontrols(False)
sle_find.text = ""
dw_list_charterer.SelectRow(dw_list_charterer.GetRow(),FALSE)

end event

type cb_cancel from commandbutton within w_select_voyage_charter_owner
integer x = 1353
integer y = 32
integer width = 247
integer height = 84
integer taborder = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

on clicked;istr_parametre.voyage_nr = "cancel"
CloseWithReturn(parent,istr_parametre)
end on

type cb_ok from commandbutton within w_select_voyage_charter_owner
integer x = 1042
integer y = 32
integer width = 247
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;long ll_rowno_charterer=0 

IF dw_list_charterer.visible THEN
	ll_rowno_charterer = dw_list_charterer.GetSelectedRow(0)
ELSE
	ll_rowno_charterer = -1
END IF
	
IF ll_rowno_charterer > 0 OR tcowner_nr <> 0 THEN
 	IF (ll_rowno_charterer = 0)  THEN
		Messagebox("Charterer required!", "Charterer is required for T/C Hire out.", StopSign!, OK!)
		Return
	END IF

	IF dw_list_charterer.visible THEN
		SetNull(istr_parametre.owner_nr)
		istr_parametre.charter_nr = dw_list_charterer.GetItemNumber(ll_rowno_charterer,"cargo_chart_nr")
	ELSEIF sle_tcowner.Enabled THEN
		istr_parametre.owner_nr = tcowner_nr
		SetNull(istr_parametre.charter_nr)
	END IF
	CloseWithReturn(parent,istr_parametre)
END IF

end event

type gb_sort from groupbox within w_select_voyage_charter_owner
integer x = 402
integer y = 832
integer width = 1207
integer height = 160
integer taborder = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Sort/Search"
end type

type gb_hire from groupbox within w_select_voyage_charter_owner
integer x = 37
integer width = 640
integer height = 128
integer taborder = 10
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

