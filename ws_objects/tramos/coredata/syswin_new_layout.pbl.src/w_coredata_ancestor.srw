$PBExportHeader$w_coredata_ancestor.srw
$PBExportComments$This is the ancestor window for all core data windows
forward
global type w_coredata_ancestor from mt_w_sheet
end type
type uo_searchbox from u_searchbox within w_coredata_ancestor
end type
type st_1 from statictext within w_coredata_ancestor
end type
type dw_dddw from datawindow within w_coredata_ancestor
end type
type dw_list from datawindow within w_coredata_ancestor
end type
type cb_close from commandbutton within w_coredata_ancestor
end type
type cb_cancel from commandbutton within w_coredata_ancestor
end type
type cb_delete from commandbutton within w_coredata_ancestor
end type
type cb_new from commandbutton within w_coredata_ancestor
end type
type cb_update from commandbutton within w_coredata_ancestor
end type
type st_list from statictext within w_coredata_ancestor
end type
type tab_1 from tab within w_coredata_ancestor
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tab_1 from tab within w_coredata_ancestor
tabpage_1 tabpage_1
end type
end forward

global type w_coredata_ancestor from mt_w_sheet
integer width = 4635
integer height = 2592
uo_searchbox uo_searchbox
st_1 st_1
dw_dddw dw_dddw
dw_list dw_list
cb_close cb_close
cb_cancel cb_cancel
cb_delete cb_delete
cb_new cb_new
cb_update cb_update
st_list st_list
tab_1 tab_1
end type
global w_coredata_ancestor w_coredata_ancestor

forward prototypes
public subroutine wf_sortdw (ref string as_tag)
public subroutine documentation ()
end prototypes

public subroutine wf_sortdw (ref string as_tag);
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_coredata_ancestor
	
   <OBJECT>standard object for windows where list on right side and detail in main area</OBJECT>
   <DESC>part of the MT framework</DESC>
   <USAGE>
	children include:
	w_agentlist/w_area/w_berth/w_brokerlist/w_charterlist/w_claimtypelist/w_countrylist/w_grade/w_officelist
	w_port/w_profitcenterlist/w_tcowner_list/w_vessel/w_vessel_competitor/w_vessel_shiptype/w_yard
   </USAGE>
   <ALSO>object inherited from mt_w_sheet</ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07	?      		Name Here	First Version
  	26/11/10 CR2193 	AGL027		Changed object ancestory to MT framework
	01/09/14	 CR3708	CCY018		Modified open event
********************************************************************/
end subroutine

on w_coredata_ancestor.create
int iCurrent
call super::create
this.uo_searchbox=create uo_searchbox
this.st_1=create st_1
this.dw_dddw=create dw_dddw
this.dw_list=create dw_list
this.cb_close=create cb_close
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_update=create cb_update
this.st_list=create st_list
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_searchbox
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_dddw
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_delete
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.cb_update
this.Control[iCurrent+10]=this.st_list
this.Control[iCurrent+11]=this.tab_1
end on

on w_coredata_ancestor.destroy
call super::destroy
destroy(this.uo_searchbox)
destroy(this.st_1)
destroy(this.dw_dddw)
destroy(this.dw_list)
destroy(this.cb_close)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_update)
destroy(this.st_list)
destroy(this.tab_1)
end on

event open;call super::open;dw_list.setrowfocusindicator( FocusRect!)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_coredata_ancestor
end type

type uo_searchbox from u_searchbox within w_coredata_ancestor
integer x = 37
integer y = 240
integer width = 969
integer taborder = 20
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type st_1 from statictext within w_coredata_ancestor
integer x = 37
integer y = 44
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "group:"
boolean focusrectangle = false
end type

type dw_dddw from datawindow within w_coredata_ancestor
integer x = 37
integer y = 112
integer width = 969
integer height = 80
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_coredata_ancestor
integer x = 37
integer y = 512
integer width = 969
integer height = 1776
integer taborder = 40
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort

// Perform Sorting
If row = 0 then
	If (String(dwo.type) = "text") then
		If (String(dwo.tag)>"") then
			ls_sort = dwo.Tag
			This.SetSort(ls_sort)
			This.Sort()
			If right(ls_sort,1) = "A" then 
				ls_sort = Replace(ls_sort, len(ls_sort),1, "D")
			Else
				ls_sort = Replace(ls_sort, len(ls_sort),1, "A")
			End if
			dwo.Tag = ls_sort		
		End If
	End if
End If
end event

type cb_close from commandbutton within w_coredata_ancestor
integer x = 4178
integer y = 2352
integer width = 402
integer height = 112
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cl&ose"
end type

type cb_cancel from commandbutton within w_coredata_ancestor
integer x = 3735
integer y = 2352
integer width = 402
integer height = 112
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

type cb_delete from commandbutton within w_coredata_ancestor
integer x = 3291
integer y = 2352
integer width = 402
integer height = 112
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

type cb_new from commandbutton within w_coredata_ancestor
integer x = 2405
integer y = 2352
integer width = 402
integer height = 112
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

type cb_update from commandbutton within w_coredata_ancestor
integer x = 2848
integer y = 2352
integer width = 402
integer height = 112
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

type st_list from statictext within w_coredata_ancestor
integer x = 37
integer y = 448
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "st_list:"
boolean focusrectangle = false
end type

type tab_1 from tab within w_coredata_ancestor
string tag = "tab_1"
integer x = 1042
integer y = 48
integer width = 3529
integer height = 2272
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3493
integer height = 2156
long backcolor = 67108864
string text = "General"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 50
integer y = 36
integer width = 3415
integer height = 1612
integer taborder = 40
string title = "none"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

