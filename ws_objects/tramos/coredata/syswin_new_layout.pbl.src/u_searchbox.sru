$PBExportHeader$u_searchbox.sru
forward
global type u_searchbox from mt_u_visualobject
end type
type st_search from statictext within u_searchbox
end type
type cb_clear from commandbutton within u_searchbox
end type
type sle_search from singlelineedit within u_searchbox
end type
end forward

global type u_searchbox from mt_u_visualobject
integer width = 955
integer height = 160
long backcolor = 553648127
event ue_keypress ( )
event clearclicked ( )
event type long ue_prekeypress ( keycode key,  unsignedlong keyflags )
st_search st_search
cb_clear cb_clear
sle_search sle_search
end type
global u_searchbox u_searchbox

type variables

Datawindow idw_DW
String is_Columns
String is_DWFilter = ""

boolean	ib_standard_ui, ib_standard_ui_topbar
boolean  ib_scrolltocurrentrow = false

end variables

forward prototypes
public subroutine of_initialize (ref datawindow adw_dw, string as_columnlist)
public subroutine of_setlabel (string as_label, boolean abool_bold)
public subroutine of_setoriginalfilter (string as_filter)
public subroutine of_findandselect (string as_text)
public subroutine of_dofilter ()
public subroutine documentation ()
public subroutine of_resetwidth ()
public subroutine of_hide_label ()
private subroutine _set_standard_ui ()
public subroutine of_setlabelcolor (long al_color)
end prototypes

event clearclicked();// Event if fired when the clear button is clicked
end event

event type long ue_prekeypress(keycode key, unsignedlong keyflags);/********************************************************************
   ue_prekeypress
   <DESC>	optional. do something before filtering(coding on event sel_search.ue_keyup)	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: >= 0, continue processing
            <LI> c#return.Failure: < 0, stop processing(but will post event ue_keypress())	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		key
		keyflags
   </ARGS>
   <USAGE>	called from sel_search.ue_keyup	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		31/10/14 CR2420        LHG008   First Version
   </HISTORY>
********************************************************************/

return c#return.Success
end event

public subroutine of_initialize (ref datawindow adw_dw, string as_columnlist);/*
This function must be called to link the search control to the datawindow.

Parameters:

adw_DW - The data window to be linked
as_Columnlist - String containing the columns to be searched. Join columns using '+' sign.

Return Value: None

*/

idw_DW = adw_DW
is_columns = as_ColumnList
end subroutine

public subroutine of_setlabel (string as_label, boolean abool_bold);/*

This function sets the label text and boldness.

Paramters:

as_Label - String for label
abool_Bold - Bold font or not

*/

st_Search.Text = as_Label
If abool_bold then st_Search.Weight =  700 Else st_Search.Weight = 400
end subroutine

public subroutine of_setoriginalfilter (string as_filter);// This function sets the original filter for the DW so that it is not overwritten
// by the search filter.

// If you are using a filter in dw_list, make sure to call this function

is_DWFilter = Trim(as_Filter, True)

If is_DWFilter > "" then is_DWFilter = "(" + is_DWFilter + ")"
end subroutine

public subroutine of_findandselect (string as_text);// This function finds and selects a Item. 
// Is usually called from a calling window that opens a system table window and
// selects a item.

If Not IsValid(idw_DW) then Return

If idw_DW.RowCount()<1 then Return

Integer li_Row

li_Row = idw_DW.Find("lower(" + is_Columns + ") like '%" + lower(as_text) + "%'", 0, idw_DW.RowCount())

If li_Row > 0 then
	idw_dw.SetRow(li_Row)
	idw_dw.ScrollToRow(li_Row)
	idw_dw.event RowFocusChanged(li_Row)
	idw_dw.event clicked(0, 0, li_Row, idw_dw.object)
	idw_dw.SetFocus( )	
End If
end subroutine

public subroutine of_dofilter ();// This function performs the actual filtering based on the text in the textbox

String ls_Filter,ls_oldfilter
long ll_currow, ll_rowid

ll_currow = idw_DW.getselectedrow(0)
if ll_currow > 0 then
	ll_rowid = idw_DW.getrowidfromrow(ll_currow)
end if

ls_Filter = Trim(sle_Search.text, True)

If ls_Filter > "" then ls_Filter ="lower(" + is_Columns + ") like '%"+ lower(ls_Filter)+"%'"

If is_DWFilter > "" then
	If ls_Filter > "" then ls_Filter = is_DWFilter + " and (" + ls_Filter + ")" Else ls_Filter = is_DWFilter	
End If
ls_oldfilter = idw_dw.Describe("DataWindow.Table.Filter")
if ls_oldfilter = '?' or ls_oldfilter = '!' then
	ls_oldfilter = ''
end if
if ls_oldfilter = ls_Filter then return
idw_DW.SetFilter(ls_Filter)
idw_DW.Filter()
idw_DW.SelectRow(0, False)

if ib_scrolltocurrentrow then
	if ll_rowid > 0 then
		ll_currow = idw_DW.getrowfromrowid(ll_rowid)
		if ll_currow > 0 then
			idw_DW.scrolltorow(ll_currow)
			idw_DW.selectrow(ll_currow, true)
		end if
	end if
end if


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_searchbox
	
   <OBJECT>
		This object implements a search-as-you-type functionality for any datawindow.
		The datawindow is filtered based on the text entered in the text box.
	</OBJECT>
	
   <USAGE>
	
		Use function of_Initialize(datawindow, columns): Call this function to attach control to the
		datawindow and specify the columns used in the search. You can combine colums
		in expressions, e.g: "firstname + lastname"
		
		If you need to apply additional filters, use function of_setoriginalfilter( )
		
	</USAGE>

<HISTORY> 
   Date	       CR-Ref	 Author	    Comments
   00/00/07	?	          Name Here	 First Version
	16/04/2013   CR3198   ZSW001      Add function _set_standard_ui() and of_setlabelcolor()
	15/10/14		 CR3708	  CCY018		  Scroll to pre-selectrow after filter
</HISTORY>    
********************************************************************/

end subroutine

public subroutine of_resetwidth ();// This resizes the controls to the parent

st_search.width = this.width
cb_clear.x = this.width - cb_clear.width
sle_search.width = cb_clear.x - 4

end subroutine

public subroutine of_hide_label ();st_search.visible = false
sle_search.y = 0
cb_clear.y = 0
end subroutine

private subroutine _set_standard_ui ();/********************************************************************
   _set_standard_ui
   <DESC>	Adjusting the appearance according to the guidelines	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the constructor event	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	16/04/2013   CR3198       ZSW001       First Version
   </HISTORY>
********************************************************************/

sle_search.border = false
sle_search.height = 56
sle_search.y = 80

cb_clear.height = 70
cb_clear.y = sle_search.y - (cb_clear.height - sle_search.height) / 2

st_search.backcolor = c#color.Transparent

if ib_standard_ui_topbar then
	this.backcolor = c#color.mt_listheader_bg
	st_search.textcolor = c#color.mt_listheader_text
else
	this.backcolor = c#color.Transparent
end if

end subroutine

public subroutine of_setlabelcolor (long al_color);/********************************************************************
   of_setlabelcolor
   <DESC>	set the label's color	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_color
   </ARGS>
   <USAGE>	Usage in windows with the new color formating	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	16/04/2013   CR3198       ZSW001       First Version
   </HISTORY>
********************************************************************/

st_search.textcolor = al_color

end subroutine

on u_searchbox.create
int iCurrent
call super::create
this.st_search=create st_search
this.cb_clear=create cb_clear
this.sle_search=create sle_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search
this.Control[iCurrent+2]=this.cb_clear
this.Control[iCurrent+3]=this.sle_search
end on

on u_searchbox.destroy
call super::destroy
destroy(this.st_search)
destroy(this.cb_clear)
destroy(this.sle_search)
end on

event constructor;
// This resizes the controls to the parent

of_ResetWidth()

if ib_standard_ui or ib_standard_ui_topbar then _set_standard_ui()

end event

type st_search from statictext within u_searchbox
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Search"
boolean focusrectangle = false
end type

type cb_clear from commandbutton within u_searchbox
integer x = 731
integer y = 60
integer width = 192
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cl&ear"
end type

event clicked;long ll_currow, ll_rowid

ll_currow = idw_DW.getselectedrow(0)
if ll_currow > 0 then
	ll_rowid = idw_DW.getrowidfromrow(ll_currow)
end if

sle_Search.Text = ""

idw_DW.SetFilter(is_DWFilter)
idw_DW.Filter( )

if ib_scrolltocurrentrow then
	if ll_rowid > 0 then
		ll_currow = idw_DW.getrowfromrowid(ll_rowid)
		if ll_currow > 0 then
			idw_DW.SelectRow(0, false)
			idw_DW.scrolltorow(ll_currow)
			idw_DW.selectrow(ll_currow, true)
		end if
	end if
end if


Parent.event clearclicked( )
end event

type sle_search from singlelineedit within u_searchbox
event ue_keyup pbm_keyup
integer y = 72
integer width = 695
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;string ls_filter

parent.postevent("ue_keypress")

if parent.event ue_prekeypress(key, keyflags) < 0 then return

if not isvalid(idw_dw) then return

of_dofilter()

// if user presses 'enter' then select first row and call events to select row
if key = keyenter! and idw_dw.rowcount() > 0 then
	idw_dw.setrow(1)
	idw_dw.event rowfocuschanged(1)
	idw_dw.event clicked(0, 0, 1, idw_dw.object)
	idw_dw.setfocus( )
end if
end event

event getfocus;idw_DW.accepttext( )
end event

