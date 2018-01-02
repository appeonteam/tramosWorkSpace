$PBExportHeader$w_bunker_purchase_list.srw
$PBExportComments$This window lists the bunker purchases. The user can ~r~nadd new purchases with the help of a button.
forward
global type w_bunker_purchase_list from w_vessel_basewindow
end type
type cb_2 from commandbutton within w_bunker_purchase_list
end type
type cb_3 from commandbutton within w_bunker_purchase_list
end type
type cb_1 from commandbutton within w_bunker_purchase_list
end type
type cb_4 from commandbutton within w_bunker_purchase_list
end type
type rb_all_voyages from radiobutton within w_bunker_purchase_list
end type
type rb_only_this_year from radiobutton within w_bunker_purchase_list
end type
type gb_1 from groupbox within w_bunker_purchase_list
end type
type st_rows from statictext within w_bunker_purchase_list
end type
type dw_bunker_purchase_list from uo_datawindow within w_bunker_purchase_list
end type
type st_1 from statictext within w_bunker_purchase_list
end type
type st_2 from statictext within w_bunker_purchase_list
end type
type st_3 from statictext within w_bunker_purchase_list
end type
type sle_year_start from singlelineedit within w_bunker_purchase_list
end type
type sle_year_end from singlelineedit within w_bunker_purchase_list
end type
type cb_saveas from commandbutton within w_bunker_purchase_list
end type
type gb_2 from groupbox within w_bunker_purchase_list
end type
end forward

global type w_bunker_purchase_list from w_vessel_basewindow
integer width = 4498
integer height = 2212
string title = "Bunkers Purchased List"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
string icon = "images\BP.ICO"
cb_2 cb_2
cb_3 cb_3
cb_1 cb_1
cb_4 cb_4
rb_all_voyages rb_all_voyages
rb_only_this_year rb_only_this_year
gb_1 gb_1
st_rows st_rows
dw_bunker_purchase_list dw_bunker_purchase_list
st_1 st_1
st_2 st_2
st_3 st_3
sle_year_start sle_year_start
sle_year_end sle_year_end
cb_saveas cb_saveas
gb_2 gb_2
end type
global w_bunker_purchase_list w_bunker_purchase_list

event ue_retrieve;call super::ue_retrieve;dw_bunker_purchase_list.setredraw(FALSE)
dw_bunker_purchase_list.Retrieve(ii_vessel_nr,right(string(today(),"yyyy"),2))	
dw_bunker_purchase_list.SetFocus()
st_rows.text = string(dw_bunker_purchase_list.rowcount()) + " Row(s)"
dw_bunker_purchase_list.setredraw(TRUE)
end event

event open;call super::open;w_bunker_purchase_list.Move(0, 0)
dw_bunker_purchase_list.SetTransObject(SQLCA)

uo_vesselselect.of_registerwindow( w_bunker_purchase_list )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
end event

on w_bunker_purchase_list.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_1=create cb_1
this.cb_4=create cb_4
this.rb_all_voyages=create rb_all_voyages
this.rb_only_this_year=create rb_only_this_year
this.gb_1=create gb_1
this.st_rows=create st_rows
this.dw_bunker_purchase_list=create dw_bunker_purchase_list
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_year_start=create sle_year_start
this.sle_year_end=create sle_year_end
this.cb_saveas=create cb_saveas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.rb_all_voyages
this.Control[iCurrent+6]=this.rb_only_this_year
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.st_rows
this.Control[iCurrent+9]=this.dw_bunker_purchase_list
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.sle_year_start
this.Control[iCurrent+14]=this.sle_year_end
this.Control[iCurrent+15]=this.cb_saveas
this.Control[iCurrent+16]=this.gb_2
end on

on w_bunker_purchase_list.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.rb_all_voyages)
destroy(this.rb_only_this_year)
destroy(this.gb_1)
destroy(this.st_rows)
destroy(this.dw_bunker_purchase_list)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_year_start)
destroy(this.sle_year_end)
destroy(this.cb_saveas)
destroy(this.gb_2)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_bunker_purchase_list, "bp_vessel_nr", "bp_voyage_nr", True)


end event

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_bunker_purchase_list
integer taborder = 10
end type

type cb_2 from commandbutton within w_bunker_purchase_list
integer x = 3986
integer y = 1996
integer width = 475
integer height = 80
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;Close(parent)
end on

type cb_3 from commandbutton within w_bunker_purchase_list
integer x = 3438
integer y = 1996
integer width = 475
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Bunker Purchase"
boolean default = true
end type

on clicked;
OpenSheet(w_bunker_purchase,w_tramos_main,7,Original!)
end on

type cb_1 from commandbutton within w_bunker_purchase_list
integer x = 2341
integer y = 1996
integer width = 475
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;string ls_bcolor
string modstring, ls_filter
dw_bunker_purchase_list.setredraw(FALSE)
ls_bcolor = dw_bunker_purchase_list.Describe("datawindow.color")
dw_bunker_purchase_list.Modify("datawindow.Color=16777215")
//set print filter
if parent.sle_year_end.text = "" and parent.sle_year_start.text = "" then
	messagebox("","Voyage year is not specified, all voyages will be printed out!")
	ls_filter = ""
elseif parent.sle_year_end.text <> "" and parent.sle_year_start.text = "" then
	messagebox("","Please input voyage start year!")
	parent.sle_year_start.post setfocus( )
	return
elseif parent.sle_year_end.text = "" and parent.sle_year_start.text <> "" then
	messagebox("","Please input voyage end year!")
	parent.sle_year_end.post setfocus( )
	return
else
	ls_filter = "voyage_year >= " + parent.sle_year_start.text + " and voyage_year <= " + parent.sle_year_end.text
end if
dw_bunker_purchase_list.setfilter(ls_filter)
dw_bunker_purchase_list.filter( )
dw_bunker_purchase_list.print()
dw_bunker_purchase_list.setfilter("")
dw_bunker_purchase_list.filter( )
dw_bunker_purchase_list.SetFocus()
modstring = "datawindow.Color="+ls_bcolor
dw_bunker_purchase_list.Modify(modstring)
dw_bunker_purchase_list.setredraw(TRUE)
end event

type cb_4 from commandbutton within w_bunker_purchase_list
integer x = 1829
integer y = 20
integer width = 375
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

on clicked;parent.triggerevent("ue_retrieve")
end on

type rb_all_voyages from radiobutton within w_bunker_purchase_list
integer x = 1303
integer y = 64
integer width = 370
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "All"
end type

event clicked;/* Local Variables */
string ls_sql_string

ls_sql_string = '  SELECT POC.PORT_ARR_DT,        ' + &
'         BP_DETAILS.PRICE_HFO,           ' + &
'         BP_DETAILS.PRICE_DO,           ' + &
'         BP_DETAILS.PRICE_GO,           ' + &
'         BP_DETAILS.PORT_CODE,           ' + &
'         BP_DETAILS.PCN,           ' + &
'         BP_DETAILS.VOYAGE_NR,          ' + & 
'         PROCEED.PROC_TEXT,          ' + &
'         BP_DETAILS.VESSEL_NR,          ' + &
'         VESSELS.VESSEL_NAME  ,        ' + &
'         BP_DETAILS.PRICE_LSHFO,        ' + &
'         BP_DETAILS.FIFO_SEQUENCE,  ' + &
'         BP_DETAILS.LIFTED_HFO,           ' + &
'         BP_DETAILS.LIFTED_DO,           ' + &
'         BP_DETAILS.LIFTED_GO,           ' + &
'         BP_DETAILS.LIFTED_LSHFO,      ' + &
'         VESSELS.VESSEL_REF_NR      ' + &
'    FROM BP_DETAILS,           ' + &
'         POC,           ' + &
'         PROCEED,          ' + &
'         VESSELS          ' + &
'   WHERE ( POC.PORT_CODE =* BP_DETAILS.PORT_CODE) and          ' + &
'         ( POC.VESSEL_NR =* BP_DETAILS.VESSEL_NR) and          ' + &
'         ( POC.VOYAGE_NR =* BP_DETAILS.VOYAGE_NR) and          ' + &
'         ( POC.PCN =* BP_DETAILS.PCN) and          ' + &
'         ( BP_DETAILS.PORT_CODE = PROCEED.PORT_CODE ) and          ' + &
'         ( BP_DETAILS.VESSEL_NR = PROCEED.VESSEL_NR ) and          ' + &
'         ( BP_DETAILS.VOYAGE_NR = PROCEED.VOYAGE_NR ) and          ' + &
'         ( BP_DETAILS.PCN = PROCEED.PCN ) and          ' + &
'         ( BP_DETAILS.VESSEL_NR = VESSELS.VESSEL_NR ) and 			' + &  
'         ( ( BP_DETAILS.VESSEL_NR = :vessel_nr ) AND          ' + &
'         ( PROCEED.CANCEL = 0 ) )       '

dw_bunker_purchase_list.Modify("DataWindow.Table.Select='"+ls_sql_string+"'")
parent.triggerevent("ue_retrieve")

end event

type rb_only_this_year from radiobutton within w_bunker_purchase_list
integer x = 1298
integer y = 128
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Only This Year"
boolean checked = true
end type

event clicked;/* Local Variables */
string ls_sql_string

ls_sql_string = '  SELECT POC.PORT_ARR_DT,        ' + &
'         BP_DETAILS.PRICE_HFO,           ' + &
'         BP_DETAILS.PRICE_DO,           ' + &
'         BP_DETAILS.PRICE_GO,           ' + &
'         BP_DETAILS.PORT_CODE,           ' + &
'         BP_DETAILS.PCN,           ' + &
'         BP_DETAILS.VOYAGE_NR,          ' + & 
'         PROCEED.PROC_TEXT,          ' + &
'         BP_DETAILS.VESSEL_NR,          ' + &
'         VESSELS.VESSEL_NAME  ,        ' + &
'         BP_DETAILS.PRICE_LSHFO,        ' + &
'         BP_DETAILS.FIFO_SEQUENCE,    ' + &
'         BP_DETAILS.LIFTED_HFO,           ' + &
'         BP_DETAILS.LIFTED_DO,           ' + &
'         BP_DETAILS.LIFTED_GO,           ' + &
'         BP_DETAILS.LIFTED_LSHFO,      ' + &
'         VESSELS.VESSEL_REF_NR      ' + &
'    FROM BP_DETAILS,           ' + &
'         POC,           ' + &
'         PROCEED,          ' + &
'         VESSELS          ' + &
'   WHERE ( POC.PORT_CODE =* BP_DETAILS.PORT_CODE) and          ' + &
'         ( POC.VESSEL_NR =* BP_DETAILS.VESSEL_NR) and          ' + &
'         ( POC.VOYAGE_NR =* BP_DETAILS.VOYAGE_NR) and          ' + &
'         ( POC.PCN =* BP_DETAILS.PCN) and          ' + &
'         ( BP_DETAILS.PORT_CODE = PROCEED.PORT_CODE ) and          ' + &
'         ( BP_DETAILS.VESSEL_NR = PROCEED.VESSEL_NR ) and          ' + &
'         ( BP_DETAILS.VOYAGE_NR = PROCEED.VOYAGE_NR ) and          ' + &
'         ( BP_DETAILS.PCN = PROCEED.PCN ) and          ' + &
'         ( BP_DETAILS.VESSEL_NR = VESSELS.VESSEL_NR ) and 			' + &  
'         ( ( BP_DETAILS.VESSEL_NR = :vessel_nr ) AND          ' + &
'         ( PROCEED.CANCEL = 0 ) and           ' + &
'         substring(BP_DETAILS.VOYAGE_NR,1,2) = :year )           ' 

dw_bunker_purchase_list.Modify("DataWindow.Table.Select='"+ls_sql_string+"'")
parent.triggerevent("ue_retrieve")




end event

type gb_1 from groupbox within w_bunker_purchase_list
integer x = 1271
integer width = 494
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Show Voyages"
borderstyle borderstyle = styleraised!
end type

type st_rows from statictext within w_bunker_purchase_list
integer x = 4215
integer y = 1900
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Row(s)"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_bunker_purchase_list from uo_datawindow within w_bunker_purchase_list
integer y = 228
integer width = 4466
integer height = 1656
integer taborder = 40
string dataobject = "dw_bunker_purchase_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;IF row > 0 THEN
	this.SelectRow(0,FALSE)
	this.SelectRow(row,TRUE)
	uo_global.SetVoyage_Nr(this.GetItemString(row,"bp_voyage_nr"))
	uo_global.SetPort_Code(this.GetItemstring(row,"bp_port_code"))
	uo_global.Setpcn(this.GetItemNumber(row,"bp_pcn"))
	uo_global.Setparm(1)
	OpenSheet(w_bunker_purchase,w_tramos_main,7,Original!)
	if isvalid(w_bunker_purchase) then w_bunker_purchase.uo_vesselselect.of_setcurrentvessel( ii_vessel_nr )
END IF
end event

on getfocus;call uo_datawindow::getfocus;this.SelectRow(0,FALSE)
this.SelectRow(this.Rowcount(),TRUE)
this.ScrollToRow(this.RowCount())
end on

event clicked;call super::clicked;IF row > 0 THEN
	this.SelectRow(0,FALSE)
	this.SelectRow(row,TRUE)
END IF
end event

type st_1 from statictext within w_bunker_purchase_list
integer x = 1760
integer y = 1928
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage years"
boolean focusrectangle = false
end type

type st_2 from statictext within w_bunker_purchase_list
integer x = 1765
integer y = 2008
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "start:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_bunker_purchase_list
integer x = 2071
integer y = 2008
integer width = 105
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "end:"
boolean focusrectangle = false
end type

type sle_year_start from singlelineedit within w_bunker_purchase_list
integer x = 1893
integer y = 2004
integer width = 142
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
borderstyle borderstyle = stylelowered!
end type

type sle_year_end from singlelineedit within w_bunker_purchase_list
integer x = 2181
integer y = 2004
integer width = 137
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
borderstyle borderstyle = stylelowered!
end type

type cb_saveas from commandbutton within w_bunker_purchase_list
integer x = 2853
integer y = 1996
integer width = 475
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&SaveAs..."
end type

event clicked;string ls_filter
//set filter
if parent.sle_year_end.text = "" and parent.sle_year_start.text = "" then
	messagebox("","Voyage year is not specified, all voyages will be saved!")
	ls_filter = ""
elseif parent.sle_year_end.text <> "" and parent.sle_year_start.text = "" then
	messagebox("","Please input voyage start year!")
	parent.sle_year_start.post setfocus( )
	return
elseif parent.sle_year_end.text = "" and parent.sle_year_start.text <> "" then
	messagebox("","Please input voyage end year!")
	parent.sle_year_end.post setfocus( )
	return
else
	ls_filter = "voyage_year >= " + parent.sle_year_start.text + " and voyage_year <= " + parent.sle_year_end.text
end if
dw_bunker_purchase_list.setfilter(ls_filter)
dw_bunker_purchase_list.filter( )
dw_bunker_purchase_list.saveas()
dw_bunker_purchase_list.setfilter("")
dw_bunker_purchase_list.filter( )
dw_bunker_purchase_list.SetFocus()

end event

type gb_2 from groupbox within w_bunker_purchase_list
integer x = 1719
integer y = 1884
integer width = 1655
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

