$PBExportHeader$w_redflagports.srw
forward
global type w_redflagports from window
end type
type st_2 from statictext within w_redflagports
end type
type sle_search from singlelineedit within w_redflagports
end type
type cb_rfrep from commandbutton within w_redflagports
end type
type mle_notes from multilineedit within w_redflagports
end type
type dw_hist from datawindow within w_redflagports
end type
type st_1 from statictext within w_redflagports
end type
type cb_close from commandbutton within w_redflagports
end type
type dw_list from datawindow within w_redflagports
end type
type gb_1 from groupbox within w_redflagports
end type
type gb_port from groupbox within w_redflagports
end type
end forward

global type w_redflagports from window
integer width = 3465
integer height = 2356
boolean titlebar = true
string title = "Red Flag Ports"
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
sle_search sle_search
cb_rfrep cb_rfrep
mle_notes mle_notes
dw_hist dw_hist
st_1 st_1
cb_close cb_close
dw_list dw_list
gb_1 gb_1
gb_port gb_port
end type
global w_redflagports w_redflagports

forward prototypes
public subroutine wf_search (string as_text)
end prototypes

public subroutine wf_search (string as_text);
// Searches the port list and selects if anything found

Integer li_Found

as_Text = Upper(Trim(as_Text,True))

If as_Text="" then
    sle_Search.Backcolor=16777215
	 Return
End If

as_Text = "'%" + as_Text + "%'"

li_Found = dw_List.Find("(upper(port_code) like " + as_Text + ") or (upper(Port_n) like " + as_Text +")",0,dw_List.RowCount())

If li_Found>0 then
	dw_list.SetRow(li_Found)
	dw_List.ScrollToRow(li_Found)
	dw_List.SetRedraw(True)
	sle_Search.BackColor = 14745568
Else
	sle_Search.BackColor = 14737663
End If
end subroutine

on w_redflagports.create
this.st_2=create st_2
this.sle_search=create sle_search
this.cb_rfrep=create cb_rfrep
this.mle_notes=create mle_notes
this.dw_hist=create dw_hist
this.st_1=create st_1
this.cb_close=create cb_close
this.dw_list=create dw_list
this.gb_1=create gb_1
this.gb_port=create gb_port
this.Control[]={this.st_2,&
this.sle_search,&
this.cb_rfrep,&
this.mle_notes,&
this.dw_hist,&
this.st_1,&
this.cb_close,&
this.dw_list,&
this.gb_1,&
this.gb_port}
end on

on w_redflagports.destroy
destroy(this.st_2)
destroy(this.sle_search)
destroy(this.cb_rfrep)
destroy(this.mle_notes)
destroy(this.dw_hist)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.dw_list)
destroy(this.gb_1)
destroy(this.gb_port)
end on

event open;
dw_List.SetTransObject(SQLCA)
dw_Hist.SetTransObject(SQLCA)

dw_List.Retrieve()
Commit;
end event

type st_2 from statictext within w_redflagports
integer x = 731
integer y = 16
integer width = 197
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search:"
boolean focusrectangle = false
end type

type sle_search from singlelineedit within w_redflagports
event ue_keyup pbm_keyup
integer x = 933
integer width = 274
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;
// Trigger search when key is released

post wf_Search(this.text)

end event

event losefocus;
this.text=""
this.backcolor=16777215
end event

type cb_rfrep from commandbutton within w_redflagports
integer x = 18
integer y = 2128
integer width = 416
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Full Report"
end type

event clicked;
OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_sq_tb_redflagportreport"

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve()

w_preview.dw_rep.object.datawindow.print.preview='Yes'

w_preview.wf_ShowReport()

Commit;
end event

type mle_notes from multilineedit within w_redflagports
integer x = 1298
integer y = 128
integer width = 2048
integer height = 704
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type dw_hist from datawindow within w_redflagports
integer x = 1298
integer y = 1008
integer width = 2048
integer height = 1040
integer taborder = 30
string title = "none"
string dataobject = "d_sq_ff_redflaghist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_redflagports
integer x = 18
integer y = 16
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Red Flag Port List:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_redflagports
integer x = 2999
integer y = 2128
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type dw_list from datawindow within w_redflagports
integer x = 18
integer y = 80
integer width = 1189
integer height = 2016
integer taborder = 10
string dataobject = "d_sq_tb_redflagports"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
SetPointer(HourGlass!)

If Currentrow > 0 then 
	mle_notes.text=this.GetItemString(currentrow,"Vett_Notes")
	dw_Hist.Retrieve(This.GetItemString(currentrow, "Port_Code"))
	gb_Port.Text = "Port Notes - " + this.GetItemString(currentrow,"Port_N")
	commit;
End If

// PB Bug - Detail background colour does not refresh when using arrow keys to select rows
// Workaround: This must be done to force refresh of row colors when using arrow keys to navigate
This.SetRedraw(True)

end event

event clicked;
string ls_sort

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

type gb_1 from groupbox within w_redflagports
integer x = 1243
integer y = 928
integer width = 2158
integer height = 1168
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port History"
end type

type gb_port from groupbox within w_redflagports
integer x = 1243
integer y = 48
integer width = 2158
integer height = 832
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Red Flag Notes"
end type

