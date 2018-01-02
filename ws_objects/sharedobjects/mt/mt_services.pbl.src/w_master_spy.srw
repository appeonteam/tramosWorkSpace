$PBExportHeader$w_master_spy.srw
forward
global type w_master_spy from mt_w_main
end type
type cbx_sql from checkbox within w_master_spy
end type
type cb_clear from commandbutton within w_master_spy
end type
type cbx_insert from checkbox within w_master_spy
end type
type cbx_update from checkbox within w_master_spy
end type
type cbx_delete from checkbox within w_master_spy
end type
type cbx_select from checkbox within w_master_spy
end type
type dw_sql from mt_u_datawindow within w_master_spy
end type
type gb_filters from groupbox within w_master_spy
end type
end forward

global type w_master_spy from mt_w_main
integer width = 2139
integer height = 1824
boolean ib_setdefaultbackgroundcolor = true
cbx_sql cbx_sql
cb_clear cb_clear
cbx_insert cbx_insert
cbx_update cbx_update
cbx_delete cbx_delete
cbx_select cbx_select
dw_sql dw_sql
gb_filters gb_filters
end type
global w_master_spy w_master_spy

type variables
mt_n_datastore ids_monitor
end variables

forward prototypes
public function string wf_filterdw ()
public subroutine documentation ()
end prototypes

public function string wf_filterdw ();string ls_filter

ls_filter=""


if this.cbx_select.checked=true then
	ls_filter+=" or (trim(upper(sqlsyntax)) like 'SELECT%')"
end if

if this.cbx_update.checked=true then
	ls_filter+=" or (trim(upper(sqlsyntax)) like 'UPDATE%')"	
end if


if this.cbx_insert.checked=true then
	ls_filter+=" or (trim(upper(sqlsyntax)) like 'INSERT%')"
end if

if this.cbx_delete.checked=true then
	ls_filter+=" or (trim(upper(sqlsyntax)) like 'DELETE%')"	
end if

return mid(ls_filter,5)

end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14 CR3781           CCY018        	F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on w_master_spy.create
int iCurrent
call super::create
this.cbx_sql=create cbx_sql
this.cb_clear=create cb_clear
this.cbx_insert=create cbx_insert
this.cbx_update=create cbx_update
this.cbx_delete=create cbx_delete
this.cbx_select=create cbx_select
this.dw_sql=create dw_sql
this.gb_filters=create gb_filters
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_sql
this.Control[iCurrent+2]=this.cb_clear
this.Control[iCurrent+3]=this.cbx_insert
this.Control[iCurrent+4]=this.cbx_update
this.Control[iCurrent+5]=this.cbx_delete
this.Control[iCurrent+6]=this.cbx_select
this.Control[iCurrent+7]=this.dw_sql
this.Control[iCurrent+8]=this.gb_filters
end on

on w_master_spy.destroy
call super::destroy
destroy(this.cbx_sql)
destroy(this.cb_clear)
destroy(this.cbx_insert)
destroy(this.cbx_update)
destroy(this.cbx_delete)
destroy(this.cbx_select)
destroy(this.dw_sql)
destroy(this.gb_filters)
end on

event resize;call super::resize;dw_sql.width = This.width - 100
dw_sql.height = This.height - 550
cb_clear.y = newheight - (cb_clear.height + 20)

end event

event open;call super::open;ids_monitor = message.powerObjectparm

if not isvalid(ids_monitor) then 
	return
end if

dw_sql.dataObject = ids_monitor.dataObject
ids_monitor.shareData(dw_sql)

n_service_manager  lnv_myMgr
n_dw_style_service   lnv_style

lnv_myMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_sql )
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_master_spy
end type

type cbx_sql from checkbox within w_master_spy
integer x = 1280
integer y = 96
integer width = 663
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show full SQL statement"
end type

event clicked;if this.checked then
	dw_sql.Object.sqlsyntax.Height.AutoSize='Yes'
else
	dw_sql.Object.sqlsyntax.Height.AutoSize='No'
end if
end event

type cb_clear from commandbutton within w_master_spy
integer x = 37
integer y = 1600
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;dw_sql.reset()
end event

type cbx_insert from checkbox within w_master_spy
integer x = 923
integer y = 116
integer width = 251
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Insert"
end type

event clicked;dw_sql.setfilter(wf_filterdw())
dw_sql.filter()
end event

type cbx_update from checkbox within w_master_spy
integer x = 640
integer y = 116
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update"
end type

event clicked;dw_sql.setfilter(wf_filterdw())
dw_sql.filter()
end event

type cbx_delete from checkbox within w_master_spy
integer x = 366
integer y = 116
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Delete"
end type

event clicked;string ls_filter

ls_filter=wf_filterdw()

dw_sql.setfilter(ls_filter)
dw_sql.filter()
end event

type cbx_select from checkbox within w_master_spy
integer x = 110
integer y = 116
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select"
end type

event clicked;string ls_filter

ls_filter=wf_filterdw()

dw_sql.setfilter(ls_filter)
dw_sql.filter()


end event

type dw_sql from mt_u_datawindow within w_master_spy
integer x = 27
integer y = 252
integer width = 1943
integer height = 1336
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;if dwo.name="sqlsyntax" then
	::Clipboard(getitemstring(row,"sqlsyntax"))
	messagebox("Info","Content added to clipboard")
end if
end event

type gb_filters from groupbox within w_master_spy
integer x = 41
integer y = 32
integer width = 1179
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filters"
end type

