$PBExportHeader$u_search_type.sru
$PBExportComments$Used with w_coredata_ancestor
forward
global type u_search_type from userobject
end type
type cbx_find from checkbox within u_search_type
end type
type sle_edit from singlelineedit within u_search_type
end type
type p_1 from picture within u_search_type
end type
type st_searchlabel from statictext within u_search_type
end type
end forward

global type u_search_type from userobject
integer width = 928
integer height = 148
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_losefocus pbm_enkillfocus
event ue_getfocus pbm_ensetfocus
cbx_find cbx_find
sle_edit sle_edit
p_1 p_1
st_searchlabel st_searchlabel
end type
global u_search_type u_search_type

type variables
datawindow idw_work
boolean ib_string
string is_columnname
long il_rowcount
end variables

forward prototypes
public subroutine of_setcolumn (string as_columnname, boolean ab_string)
public subroutine of_initialize (ref datawindow adw)
public subroutine of_settext (string as_text)
end prototypes

public subroutine of_setcolumn (string as_columnname, boolean ab_string);is_columnname = as_columnname
ib_string = ab_string

idw_work.setSort(is_columnname)
idw_work.sort()
end subroutine

public subroutine of_initialize (ref datawindow adw);idw_work = adw
il_rowcount = idw_work.Rowcount()
end subroutine

public subroutine of_settext (string as_text);sle_edit.text = as_text
return
end subroutine

on u_search_type.create
this.cbx_find=create cbx_find
this.sle_edit=create sle_edit
this.p_1=create p_1
this.st_searchlabel=create st_searchlabel
this.Control[]={this.cbx_find,&
this.sle_edit,&
this.p_1,&
this.st_searchlabel}
end on

on u_search_type.destroy
destroy(this.cbx_find)
destroy(this.sle_edit)
destroy(this.p_1)
destroy(this.st_searchlabel)
end on

type cbx_find from checkbox within u_search_type
integer x = 695
integer y = 64
integer width = 201
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Find"
end type

event clicked;string ls_filter

if this.checked and ib_string then
	ls_filter ="lower("+ is_columnname+") like '%"+ lower(sle_edit.text)+"%'"
	idw_work.setFilter(ls_filter)
	idw_work.filter()
	sle_edit.post setfocus()
else
	if not ib_string then
		this.checked = false
	end if
	ls_filter = ""
	idw_work.setFilter(ls_filter)
	idw_work.filter()
	sle_edit.post setfocus()
end if	
end event

type sle_edit from singlelineedit within u_search_type
event ue_keydown pbm_keyup
integer y = 56
integer width = 677
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;string ls_find
long ll_row, ll_len

ls_find = lower(sle_edit.text)
ll_len = len(ls_find)

if ib_string then
	ll_row = idw_work.find("left(lower("+is_columnname+"),"+string(ll_len)+")='"+ls_find+"'",1,il_rowcount)
else
	ll_row = idw_work.find("left(lower(string("+is_columnname+")),"+string(ll_len)+")='"+ls_find+"'",1,il_rowcount)
//	ll_row = idw_work.find(is_columnname+"<="+ls_find,1,il_rowcount)
end if

IF key = keyEnter! and ll_row > 0 THEN
   idw_work.setRowFocusIndicator(Off!)
	idw_work.SelectRow(0,false)
	idw_work.SelectRow(ll_row,true)
	idw_work.EVENT POST Clicked(0,0,ll_row, idw_work.Object)
	return 1
END IF

idw_work.SetRowFocusIndicator(p_1, 0 , 50 )
//idw_work.SetRowFocusIndicator(Hand!)

if ll_row > 0 then
	idw_work.scrollToRow(ll_row)
end if

return 1
end event

event losefocus;idw_work.setrowfocusindicator( Off!)
//sle_edit.text = ""
idw_work.setRow(idw_work.GetSelectedRow(0))
parent.event ue_losefocus()
end event

event getfocus;parent.event ue_getfocus()
end event

type p_1 from picture within u_search_type
boolean visible = false
integer x = 590
integer y = 32
integer width = 1006
integer height = 4
boolean originalsize = true
string picturename = "images\redline.bmp"
boolean focusrectangle = false
end type

type st_searchlabel from statictext within u_search_type
integer width = 713
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search By:"
boolean focusrectangle = false
end type

