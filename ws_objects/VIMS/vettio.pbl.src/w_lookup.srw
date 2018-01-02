$PBExportHeader$w_lookup.srw
forward
global type w_lookup from window
end type
type sle_text from singlelineedit within w_lookup
end type
type cb_cancel from commandbutton within w_lookup
end type
type cb_okay from commandbutton within w_lookup
end type
type dw_list from datawindow within w_lookup
end type
type cb_search from commandbutton within w_lookup
end type
type gb_1 from groupbox within w_lookup
end type
type gb_result from groupbox within w_lookup
end type
end forward

global type w_lookup from window
integer width = 2418
integer height = 2508
boolean titlebar = true
string title = "Question Lookup"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_text sle_text
cb_cancel cb_cancel
cb_okay cb_okay
dw_list dw_list
cb_search cb_search
gb_1 gb_1
gb_result gb_result
end type
global w_lookup w_lookup

type variables

Integer ii_IMID
end variables

on w_lookup.create
this.sle_text=create sle_text
this.cb_cancel=create cb_cancel
this.cb_okay=create cb_okay
this.dw_list=create dw_list
this.cb_search=create cb_search
this.gb_1=create gb_1
this.gb_result=create gb_result
this.Control[]={this.sle_text,&
this.cb_cancel,&
this.cb_okay,&
this.dw_list,&
this.cb_search,&
this.gb_1,&
this.gb_result}
end on

on w_lookup.destroy
destroy(this.sle_text)
destroy(this.cb_cancel)
destroy(this.cb_okay)
destroy(this.dw_list)
destroy(this.cb_search)
destroy(this.gb_1)
destroy(this.gb_result)
end on

event open;String ls_IM

dw_List.SetTransObject(SQLCA)

// Get Inspection Model from Inspection
Select VETT_INSP.IM_ID, NAME + ' - ' + EDITION Into :ii_IMID, :ls_IM 
From VETT_INSP Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
Where INSP_ID = :g_Obj.InspID;

If SQLCA.SQLCode <> 0 then
	Messagebox("DB Error", "Unable to locate Inspection Model. Search will not work!~n~nError: " + SQLCA.SQLErrText, Exclamation!)
	ii_IMID = 0
Else
	If Right(ls_IM, 3) = " - " then ls_IM = Left(ls_IM, Len(ls_IM) - 3)
	This.Title = "Question Lookup: " + ls_IM
End If

Commit;

sle_Text.SetFocus( )
end event

type sle_text from singlelineedit within w_lookup
integer x = 73
integer y = 80
integer width = 2249
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_lookup
integer x = 1445
integer y = 2304
integer width = 366
integer height = 96
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
CloseWithReturn(Parent, "")
end event

type cb_okay from commandbutton within w_lookup
integer x = 549
integer y = 2304
integer width = 366
integer height = 96
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Select"
end type

event clicked;
CloseWithReturn(Parent, dw_List.GetItemString(dw_List.GetRow(), "fullqnum"))
end event

type dw_list from datawindow within w_lookup
integer x = 73
integer y = 416
integer width = 2249
integer height = 1808
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_viq_lookup"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
cb_Okay.Enabled = (rowcount>0)

If rowcount = 0 then
	gb_Result.Text = "Search Results - No questions found"
ElseIf rowcount = 1 then
	gb_Result.Text = "Search Results - 1 question found"
Else
	gb_Result.Text = "Search Results - " + String(rowcount) + " questions found"
End If

end event

type cb_search from commandbutton within w_lookup
integer x = 1902
integer y = 176
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search"
boolean default = true
end type

event clicked;
dw_List.Reset()

sle_Text.Text = Trim(sle_Text.Text, True)

If sle_Text.Text = "" then
	Messagebox("Search Text", "Please specify text to search for!", Exclamation!)
	Return
End If

This.Enabled = False
This.Text = "Searching..."

Yield()

dw_List.Retrieve(ii_IMID, "%" + Lower(sle_Text.Text) + "%")

This.Enabled = True
This.Text = "Search"
end event

type gb_1 from groupbox within w_lookup
integer x = 18
integer width = 2359
integer height = 304
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Text"
end type

type gb_result from groupbox within w_lookup
integer x = 18
integer y = 336
integer width = 2359
integer height = 1936
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results"
end type

