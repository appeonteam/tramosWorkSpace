$PBExportHeader$w_safeportmemo.srw
forward
global type w_safeportmemo from w_sheet
end type
type cb_close from commandbutton within w_safeportmemo
end type
type cb_print from commandbutton within w_safeportmemo
end type
type st_3 from statictext within w_safeportmemo
end type
type st_2 from statictext within w_safeportmemo
end type
type st_1 from statictext within w_safeportmemo
end type
type dw_memo from u_dw within w_safeportmemo
end type
type dw_portberth from u_dw within w_safeportmemo
end type
type dw_city from u_dw within w_safeportmemo
end type
type dw_country from u_dw within w_safeportmemo
end type
end forward

global type w_safeportmemo from w_sheet
integer width = 3570
integer height = 2680
string title = "SafePortMemo"
boolean maxbox = false
boolean resizable = false
cb_close cb_close
cb_print cb_print
st_3 st_3
st_2 st_2
st_1 st_1
dw_memo dw_memo
dw_portberth dw_portberth
dw_city dw_city
dw_country dw_country
end type
global w_safeportmemo w_safeportmemo

type variables
datawindowchild	idwc_city
end variables

on w_safeportmemo.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_print=create cb_print
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_memo=create dw_memo
this.dw_portberth=create dw_portberth
this.dw_city=create dw_city
this.dw_country=create dw_country
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_memo
this.Control[iCurrent+7]=this.dw_portberth
this.Control[iCurrent+8]=this.dw_city
this.Control[iCurrent+9]=this.dw_country
end on

on w_safeportmemo.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_memo)
destroy(this.dw_portberth)
destroy(this.dw_city)
destroy(this.dw_country)
end on

type cb_close from commandbutton within w_safeportmemo
integer x = 3122
integer y = 704
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_print from commandbutton within w_safeportmemo
integer x = 3122
integer y = 540
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_memo.print()
end event

type st_3 from statictext within w_safeportmemo
integer x = 27
integer y = 200
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ports / Berths:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_safeportmemo
integer x = 1093
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "City:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_safeportmemo
integer x = 27
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Country:"
boolean focusrectangle = false
end type

type dw_memo from u_dw within w_safeportmemo
integer x = 14
integer y = 868
integer width = 3520
integer height = 1692
integer taborder = 40
string dataobject = "d_one_memo"
end type

event constructor;call super::constructor;of_setTransobject( sqlca )
of_setUpdateable( false )

end event

type dw_portberth from u_dw within w_safeportmemo
integer x = 18
integer y = 268
integer width = 2011
integer height = 476
integer taborder = 30
string dataobject = "d_sq_tb_safeportmemo_portberth"
end type

event constructor;call super::constructor;of_setTransobject( sqlca )
of_setUpdateable( false )

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

this.selectrow(0, false)
this.selectrow(currentrow, true)

dw_memo.retrieve(this.getItemNumber(currentrow, "safeportmemo_id"))
end event

type dw_city from u_dw within w_safeportmemo
integer x = 1088
integer y = 64
integer width = 942
integer height = 100
integer taborder = 20
string dataobject = "d_sq_tb_safeportmemo_city"
boolean vscrollbar = false
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event constructor;call super::constructor;of_setTransobject( sqlca )
of_setUpdateable( false )
of_setdropdownsearch( true)
inv_dropdownsearch.of_register( )

this.getchild("city", idwc_city)
idwc_city.setTransObject(sqlca)
idwc_city.retrieve("")
this.post insertrow(0)

end event

event itemchanged;call super::itemchanged;string		ls_city
if row < 1 then return

this.accepttext()
ls_city = this.getItemString(row, "city")
if isNull(ls_city) then
	MessageBox("Validation Error", "Please select a City")
else
	if dw_portberth.retrieve(ls_city) > 0 then
		dw_portberth.post event rowfocuschanged( 1 )
	else
		dw_memo.retrieve(-1)  //reset memo details
	end if
end if
	
 
end event

type dw_country from u_dw within w_safeportmemo
integer x = 23
integer y = 68
integer width = 942
integer height = 96
integer taborder = 10
string dataobject = "d_sq_tb_safeportmemo_country"
boolean vscrollbar = false
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_itemfocuschanged(row, dwo)
end if
end event

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event pfc_editchanged(row, dwo, data)
end if
end event

event constructor;call super::constructor;of_setTransobject( sqlca )
of_setupdateable( false )
of_setdropdownsearch( true )
inv_dropdownsearch.of_register( )

this.post insertrow(0)

end event

event pfc_retrieve;call super::pfc_retrieve;//return this.retrieve()
return this.insertrow( 0)
end event

event itemchanged;call super::itemchanged;string		ls_country
if row < 1 then return

this.accepttext()
ls_country = this.getItemString(row, "country")

dw_city.setItem(1, "city", "")
dw_portberth.retrieve("")  //reset berth list
dw_memo.retrieve(-1)  //reset memo details

if isNull(ls_country) then
	idwc_city.retrieve("")
else
	idwc_city.retrieve(ls_country)
end if
	
 
end event

