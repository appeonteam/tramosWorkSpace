$PBExportHeader$w_modify_access.srw
forward
global type w_modify_access from mt_w_sheet
end type
type ddlb_profile from dropdownlistbox within w_modify_access
end type
type dw_groups from datawindow within w_modify_access
end type
type st_1 from statictext within w_modify_access
end type
end forward

global type w_modify_access from mt_w_sheet
integer width = 1655
string title = "Modify Access"
ddlb_profile ddlb_profile
dw_groups dw_groups
st_1 st_1
end type
global w_modify_access w_modify_access

on w_modify_access.create
int iCurrent
call super::create
this.ddlb_profile=create ddlb_profile
this.dw_groups=create dw_groups
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_profile
this.Control[iCurrent+2]=this.dw_groups
this.Control[iCurrent+3]=this.st_1
end on

on w_modify_access.destroy
call super::destroy
destroy(this.ddlb_profile)
destroy(this.dw_groups)
destroy(this.st_1)
end on

event open;call super::open;dw_groups.settransobject(sqlca)
dw_groups.retrieve()

st_1.text = "Profile = " + string(uo_global.ii_user_profile) + "  Access = " + string(uo_global.ii_access_level)

ddlb_profile.selectitem(uo_global.ii_user_profile)

int findrow

findrow = dw_groups.find("group_id = " + string(uo_global.ii_access_level), 0, dw_groups.rowcount())

if findrow > 0 then	
	dw_groups.selectrow(findrow, true)
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_modify_access
end type

type ddlb_profile from dropdownlistbox within w_modify_access
integer x = 146
integer y = 352
integer width = 549
integer height = 416
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
string text = "none"
boolean sorted = false
string item[] = {"Charterer","Operator","Finance","Developer","Support"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;uo_global.ii_user_profile = this.selectitem(index)

st_1.text = "Profile = " + string(uo_global.ii_user_profile) + "  Access = " + string(uo_global.ii_access_level)

end event

type dw_groups from datawindow within w_modify_access
integer x = 823
integer y = 352
integer width = 622
integer height = 568
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_groups"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row < 1 then return 

this.selectrow(0, false)
this.selectrow(row, true)

uo_global.ii_access_level = this.getitemnumber(row, "group_id")

st_1.text = "Profile = " + string(uo_global.ii_user_profile) + "  Access = " + string(uo_global.ii_access_level)
end event

type st_1 from statictext within w_modify_access
integer x = 146
integer y = 192
integer width = 1371
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

