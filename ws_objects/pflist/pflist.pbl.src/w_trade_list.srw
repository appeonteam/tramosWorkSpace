$PBExportHeader$w_trade_list.srw
forward
global type w_trade_list from w_events_pcgroup
end type
type cbx_showdeactive from checkbox within w_trade_list
end type
type uo_pcgroup from u_pcgroup within w_trade_list
end type
type dw_flatrate_year from datawindow within w_trade_list
end type
type st_1 from mt_u_statictext within w_trade_list
end type
type cb_delete from mt_u_commandbutton within w_trade_list
end type
type cb_edit from mt_u_commandbutton within w_trade_list
end type
type cb_new from mt_u_commandbutton within w_trade_list
end type
type cb_close from mt_u_commandbutton within w_trade_list
end type
type cb_print from mt_u_commandbutton within w_trade_list
end type
type cb_saveas from mt_u_commandbutton within w_trade_list
end type
type cb_retrieve from mt_u_commandbutton within w_trade_list
end type
type dw_trade_list from datawindow within w_trade_list
end type
end forward

global type w_trade_list from w_events_pcgroup
integer width = 5033
integer height = 1968
string title = "Fixture Trade"
event ue_refreshonerow ( integer al_tradeid )
cbx_showdeactive cbx_showdeactive
uo_pcgroup uo_pcgroup
dw_flatrate_year dw_flatrate_year
st_1 st_1
cb_delete cb_delete
cb_edit cb_edit
cb_new cb_new
cb_close cb_close
cb_print cb_print
cb_saveas cb_saveas
cb_retrieve cb_retrieve
dw_trade_list dw_trade_list
end type
global w_trade_list w_trade_list

type variables
integer 	 ii_year, ii_pcgroup
string		is_sort, is_sort_temp
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_refreshonerow(integer al_tradeid);long ll_found

setpointer(hourglass!)
dw_trade_list.setredraw( false )

dw_trade_list.settransobject( SQLCA)
dw_trade_list.retrieve(ii_pcgroup, ii_year)
	
ll_found = dw_trade_list.find("trade_id ="+string(al_tradeid),1,999999)
if ll_found > 0 then
	dw_trade_list.selectrow(0, false)
	dw_trade_list.selectrow(ll_found,true)
	dw_trade_list.scrolltorow(ll_found)
end if

dw_trade_list.setredraw( true )
setpointer(Arrow!)
dw_trade_list.POST setfocus()

if SQLCA.SQLcode = -1 then
	MessageBox("Error", SQLCA.sqlerrtext )
	return
end if
if dw_trade_list.rowcount( ) > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
	cb_edit.enabled = true
	cb_delete.enabled = true
else 
	cb_saveas.enabled = false
	cb_print.enabled = false
	cb_edit.enabled = false
	cb_delete.enabled = false
end if




end event

public subroutine documentation ();/********************************************************************
   w_trade_list
   <OBJECT>		</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		10/10/2014		CR3839		XSZ004		Fix a historical bug
   </HISTORY>
********************************************************************/
end subroutine

on w_trade_list.create
int iCurrent
call super::create
this.cbx_showdeactive=create cbx_showdeactive
this.uo_pcgroup=create uo_pcgroup
this.dw_flatrate_year=create dw_flatrate_year
this.st_1=create st_1
this.cb_delete=create cb_delete
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_retrieve=create cb_retrieve
this.dw_trade_list=create dw_trade_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_showdeactive
this.Control[iCurrent+2]=this.uo_pcgroup
this.Control[iCurrent+3]=this.dw_flatrate_year
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_edit
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.cb_print
this.Control[iCurrent+10]=this.cb_saveas
this.Control[iCurrent+11]=this.cb_retrieve
this.Control[iCurrent+12]=this.dw_trade_list
end on

on w_trade_list.destroy
call super::destroy
destroy(this.cbx_showdeactive)
destroy(this.uo_pcgroup)
destroy(this.dw_flatrate_year)
destroy(this.st_1)
destroy(this.cb_delete)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_retrieve)
destroy(this.dw_trade_list)
end on

event open;datawindowchild ldwc

ii_year = 1

ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
ii_year = 1

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	dw_flatrate_year.settransobject(SQLCA)
	dw_flatrate_year.getchild("flatrateyear",ldwc)
	ldwc.SetTransObject(SQLCA)
	if ldwc.retrieve(ii_pcgroup) > 0 then
		ii_year = ldwc.getitemnumber(1,"flatrateyear")
		dw_flatrate_year.insertrow(0)
		dw_flatrate_year.setitem(1,"flatrateyear",ii_year)
		//cb_retrieve.enabled = true
		cb_retrieve.event clicked()
	else
		//cb_retrieve.enabled = false
		dw_flatrate_year.reset()
		dw_trade_list.reset( )
		return
	end if
	cb_retrieve.event clicked( )
end if
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;datawindowchild ldwc

ii_pcgroup = ai_pcgroupid

dw_flatrate_year.settransobject(SQLCA)
dw_flatrate_year.getchild("flatrateyear", ldwc)
ldwc.SetTransObject(SQLCA)

if ldwc.retrieve(ii_pcgroup) > 0 then
	ii_year = ldwc.getitemnumber(1, "flatrateyear")
	dw_flatrate_year.insertrow(0)
	dw_flatrate_year.setitem(1, "flatrateyear", ii_year)
else 
	dw_flatrate_year.reset()
end if

cb_retrieve.event clicked()

if dw_trade_list.rowcount() < 1 then
	ii_year = 0
	cb_delete.enabled = false
end if

return 0
end event

type st_hidemenubar from w_events_pcgroup`st_hidemenubar within w_trade_list
end type

type cbx_showdeactive from checkbox within w_trade_list
integer x = 1893
integer y = 104
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show deactivated trades"
end type

event clicked;	cb_retrieve.event clicked()
end event

type uo_pcgroup from u_pcgroup within w_trade_list
integer x = 23
integer y = 44
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type dw_flatrate_year from datawindow within w_trade_list
integer x = 791
integer y = 116
integer width = 215
integer height = 80
integer taborder = 50
string title = "none"
string dataobject = "d_flatrate_year"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ii_year = Integer(data)
cb_retrieve.event clicked()
end event

type st_1 from mt_u_statictext within w_trade_list
integer x = 786
integer y = 48
integer width = 512
integer height = 56
integer weight = 700
string facename = "Arial"
string text = "Select flatrate year:"
end type

type cb_delete from mt_u_commandbutton within w_trade_list
integer x = 4297
integer y = 1740
integer taborder = 50
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row, ll_trade_id, li_count

ll_row = dw_trade_list.getRow()
if ll_row < 1 then return

ll_trade_id = dw_trade_list.getitemnumber(ll_row, "trade_id")

SELECT COUNT(*)
INTO :li_count
FROM PF_FIXTURE
WHERE TRADEID = :ll_trade_id
;

if li_count > 0 then
	messagebox("Validation","You can't delete the trade because there is a fixture using this trade, please delete the fixture first.")
	return
end if

if MessageBox("Confirmation", "Are you sure you you want to delete the trade?", question!, YesNo!,2) = 1 then 
	Commit;
	DELETE 
	FROM PF_FIXTURE_FLATRATE
	WHERE TRADEID = :ll_trade_id
	;
	if SQLCA.sqlcode = 0 then
		if dw_trade_list.deleterow(ll_row) = 1 then
			if dw_trade_list.update( ) = 1 then
				commit;
			else
				rollback;
			end if
			dw_trade_list.retrieve(ii_pcgroup,ii_year)
			return 1
		else
			rollback;
			MessageBox("Delete Error", "Error deleting trade.")
			return -1
		end if
	else 
		rollback;
		MessageBox("Delete Error", "Error deleting flatrate.")
	end if
end if

end event

type cb_edit from mt_u_commandbutton within w_trade_list
integer x = 3950
integer y = 1740
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Edit"
end type

event clicked;long		ll_row
s_trade 		lstr_trade
// int 		li_pc_nr

ll_row = dw_trade_list.getRow()
if ll_row < 1 then return
lstr_trade.id = dw_trade_list.getitemnumber(ll_row,"trade_id") 
// li_pc_nr = dw_trade_list.getitemnumber(ll_row,"pc_nr") 
lstr_trade.pcgroup = ii_pcgroup
lstr_trade.year  = ii_year
opensheetwithparm(w_modify_trade, lstr_trade,parent.parentWindow(),0,Original!)


end event

type cb_new from mt_u_commandbutton within w_trade_list
integer x = 3602
integer y = 1740
integer taborder = 30
string facename = "Arial"
string text = "&New"
end type

event clicked;long		ll_null, ll_row
int			li_pc_nr, li_null
s_trade 		lstr_trade

setNull(ll_null)
setNull(li_null)
/* Profitcenter */
//if upperBound(ii_profitcenter) = 0 then
//	MessageBox("Validation Error", "Please select a Profitcenter.")
//	dw_profit_center.post setFocus()
//	return
//elseif upperBound(ii_profitcenter) > 1 then
//	MessageBox("Validation Error", "Please select only one Profitcenter when you create new trade.")
//	dw_profit_center.post setFocus()
//	return	
if ii_pcgroup<0 then
	MessageBox("Validation Error", "No profit center group selected")
//	dw_profit_center.post setFocus()
	return
else 
	lstr_trade.id = ll_null
	lstr_trade.pcgroup = ii_pcgroup
	lstr_trade.year = li_null
	openSheetWithParm(w_modify_trade, lstr_trade, "w_modify_trade", parent.parentwindow()) 
	return 1
end if


end event

type cb_close from mt_u_commandbutton within w_trade_list
integer x = 4645
integer y = 1740
integer taborder = 50
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_print from mt_u_commandbutton within w_trade_list
integer x = 366
integer y = 1740
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Print"
end type

event clicked;dw_trade_list.print()

end event

type cb_saveas from mt_u_commandbutton within w_trade_list
integer x = 18
integer y = 1740
integer taborder = 30
string facename = "Arial"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;dw_trade_list.saveas()

end event

type cb_retrieve from mt_u_commandbutton within w_trade_list
integer x = 1312
integer y = 96
integer taborder = 20
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;
if dw_flatrate_year.rowcount() > 0 then
	if isnull(dw_flatrate_year.getitemnumber(1,"flatrateyear")) then
		MessageBox("Validation Error", "Please select a Flatrate year")
		dw_flatrate_year.post setFocus()
		return
	end if
else
	ii_year = 0
end if

dw_trade_list.setTransObject(SQLCA)
dw_trade_list.retrieve(ii_pcgroup,ii_year)
if SQLCA.SQLcode = -1 then
	Messagebox("Error Trade list", Sqlca.sqlerrtext)
	return
end if

//filter
dw_trade_list.setredraw(false)
if cbx_showdeactive.checked = False then
    dw_trade_list.setfilter( "pf_fixture_trade_trade_active=1")
	dw_trade_list.filter()
else
	dw_trade_list.setfilter("")
	dw_trade_list.filter()
end if
dw_trade_list.setredraw(true)

if  dw_trade_list.rowcount( ) > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
	cb_edit.enabled = true
	cb_delete.enabled = true
else 
	cb_saveas.enabled = false
	cb_print.enabled = false
	cb_edit.enabled = false
	cb_delete.enabled = false
end if


end event

type dw_trade_list from datawindow within w_trade_list
integer x = 18
integer y = 236
integer width = 4960
integer height = 1488
integer taborder = 10
string title = "Fixture Trade"
string dataobject = "d_trade_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if dwo.type = "text" then
	is_sort = dwo.Tag
	this.setSort(is_sort)
	this.Sort()
	if right(is_sort,1) = "A" then 
		is_sort = replace(is_sort, len(is_sort),1, "D")
	else
		is_sort = replace(is_sort, len(is_sort),1, "A")
	end if
	is_sort_temp = dwo.Tag
	dwo.Tag = is_sort 
	this.groupCalc()
end if

if row > 0 then
	post event rowfocuschanged( row )
end if
end event

event doubleclicked;if row < 1 then return

cb_edit.triggerevent(clicked!)
end event

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

