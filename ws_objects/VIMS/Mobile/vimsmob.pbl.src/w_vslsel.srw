$PBExportHeader$w_vslsel.srw
forward
global type w_vslsel from window
end type
type cb_delete from commandbutton within w_vslsel
end type
type cb_new from commandbutton within w_vslsel
end type
type cb_cancel from commandbutton within w_vslsel
end type
type cb_ok from commandbutton within w_vslsel
end type
type st_2 from statictext within w_vslsel
end type
type st_1 from statictext within w_vslsel
end type
type dw_vsl from datawindow within w_vslsel
end type
type ln_1 from line within w_vslsel
end type
end forward

global type w_vslsel from window
integer width = 1655
integer height = 1792
boolean titlebar = true
string title = "Vessel Selection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_delete cb_delete
cb_new cb_new
cb_cancel cb_cancel
cb_ok cb_ok
st_2 st_2
st_1 st_1
dw_vsl dw_vsl
ln_1 ln_1
end type
global w_vslsel w_vslsel

on w_vslsel.create
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_2=create st_2
this.st_1=create st_1
this.dw_vsl=create dw_vsl
this.ln_1=create ln_1
this.Control[]={this.cb_delete,&
this.cb_new,&
this.cb_cancel,&
this.cb_ok,&
this.st_2,&
this.st_1,&
this.dw_vsl,&
this.ln_1}
end on

on w_vslsel.destroy
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_vsl)
destroy(this.ln_1)
end on

event open;Integer li_Row

f_Write2Log("w_VslSel Open")
dw_vsl.SetTransObject(SQLCA)
dw_vsl.Retrieve( )

If g_Obj.ParamLong > 0 then
	li_Row = dw_vsl.Find("IMO_Number = " + String(g_Obj.ParamLong), 1, 9999)
	If li_Row > 0 then 
		dw_Vsl.SetRow(li_Row)
		dw_Vsl.ScrollToRow(li_Row)
	Else
		Messagebox("Vessel Not Found", "The vessel was found in the list of active vessels.", Exclamation!)
	End If
End If
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3900)
end event

type cb_delete from commandbutton within w_vslsel
integer x = 457
integer y = 1408
integer width = 439
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete Vessel"
end type

event clicked;
If Messagebox("Confirm Delete", "A vessel should be deleted only if it has been added incorrectly or if it is a duplicate entry.~n~nAre you sure you wish to delete this vessel?", Question!, YesNo!) = 2 then Return

dw_vsl.DeleteRow(dw_vsl.GetRow())

If dw_vsl.Update( ) = 1 then
	If dw_vsl.Rowcount( ) <= 0 then
		cb_Delete.Enabled = False
		cb_ok.Enabled = False
	End If
Else
	Messagebox("Delete Error", "The vessel could not be deleted.", Exclamation!)
	dw_vsl.Retrieve( )
End If
end event

type cb_new from commandbutton within w_vslsel
integer x = 18
integer y = 1408
integer width = 439
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Vessel..."
end type

event clicked;Integer li_Row

If Messagebox("New Vessel", "Any new vessel added to this list may be overwritten when a new database update is issued.~n~nDo you want to continue?", Question!, YesNo!) = 2 then Return

Open(w_CreateVsl)

If g_Obj.Level = 1 then 
	dw_Vsl.Retrieve( )
	cb_ok.Enabled = True
	li_Row = dw_Vsl.Find("Ref_nr = '" + g_Obj.ParamString + "'", 1, dw_Vsl.RowCount())
	If li_Row < 0 then li_Row = 1
	dw_vsl.SetRow(li_Row)
	dw_vsl.ScrollToRow(li_Row)
End If
end event

type cb_cancel from commandbutton within w_vslsel
integer x = 914
integer y = 1568
integer width = 512
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.Paramlong = 0

f_Write2Log("w_VslSel Cancel")
Close(Parent)
end event

type cb_ok from commandbutton within w_vslsel
integer x = 201
integer y = 1568
integer width = 512
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select Vessel"
boolean default = true
end type

event clicked;Integer li_Row

li_Row = dw_Vsl.GetRow()

g_Obj.ParamLong = dw_vsl.GetItemNumber(li_Row, "IMO_Number")
g_Obj.ParamString = dw_vsl.GetItemString(li_Row, "Ref_Nr") + " - " + dw_vsl.GetItemString(li_Row, "Vessel_Name")

f_Write2Log("w_VslSel Select")
Close(Parent)
end event

type st_2 from statictext within w_vslsel
integer x = 1061
integer y = 32
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "(Click headers to sort)"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_vslsel
integer x = 18
integer y = 32
integer width = 530
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select a Vessel:"
boolean focusrectangle = false
end type

type dw_vsl from datawindow within w_vslsel
integer x = 18
integer y = 96
integer width = 1591
integer height = 1312
integer taborder = 10
string dataobject = "d_sq_tb_vslsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then cb_ok.Enabled = False
end event

event rowfocuschanged;
// Force redraw
This.SetRedraw(False)
This.SetRedraw(True)
end event

event clicked;string ls_sort

If (dwo.type = "text") then
	If (dwo.tag>"") then
		ls_sort = dwo.Tag
		this.setSort(ls_sort)
		this.Sort()
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		dwo.Tag = ls_sort
	End If
End if

end event

type ln_1 from line within w_vslsel
long linecolor = 33554432
integer linethickness = 4
integer beginx = 37
integer beginy = 1536
integer endx = 1609
integer endy = 1536
end type

