$PBExportHeader$w_fin_controlpanel.srw
forward
global type w_fin_controlpanel from w_vessel_basewindow
end type
type dw_voyage from datawindow within w_fin_controlpanel
end type
type dw_responsible from datawindow within w_fin_controlpanel
end type
type uo_single_voyage from u_fin_single_voyage within w_fin_controlpanel
end type
type cb_refresh from commandbutton within w_fin_controlpanel
end type
type cb_prtscr from commandbutton within w_fin_controlpanel
end type
type dw_datetime from datawindow within w_fin_controlpanel
end type
type cb_find_voyage from commandbutton within w_fin_controlpanel
end type
type uo_tc_voyage from u_fin_tc_voyage within w_fin_controlpanel
end type
type cb_find_cp from commandbutton within w_fin_controlpanel
end type
end forward

global type w_fin_controlpanel from w_vessel_basewindow
integer width = 4567
integer height = 2660
string title = "Control Panel"
string icon = "images\control_panel.ico"
dw_voyage dw_voyage
dw_responsible dw_responsible
uo_single_voyage uo_single_voyage
cb_refresh cb_refresh
cb_prtscr cb_prtscr
dw_datetime dw_datetime
cb_find_voyage cb_find_voyage
uo_tc_voyage uo_tc_voyage
cb_find_cp cb_find_cp
end type
global w_fin_controlpanel w_fin_controlpanel

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_fin_controlpanel.create
int iCurrent
call super::create
this.dw_voyage=create dw_voyage
this.dw_responsible=create dw_responsible
this.uo_single_voyage=create uo_single_voyage
this.cb_refresh=create cb_refresh
this.cb_prtscr=create cb_prtscr
this.dw_datetime=create dw_datetime
this.cb_find_voyage=create cb_find_voyage
this.uo_tc_voyage=create uo_tc_voyage
this.cb_find_cp=create cb_find_cp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_voyage
this.Control[iCurrent+2]=this.dw_responsible
this.Control[iCurrent+3]=this.uo_single_voyage
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.cb_prtscr
this.Control[iCurrent+6]=this.dw_datetime
this.Control[iCurrent+7]=this.cb_find_voyage
this.Control[iCurrent+8]=this.uo_tc_voyage
this.Control[iCurrent+9]=this.cb_find_cp
end on

on w_fin_controlpanel.destroy
call super::destroy
destroy(this.dw_voyage)
destroy(this.dw_responsible)
destroy(this.uo_single_voyage)
destroy(this.cb_refresh)
destroy(this.cb_prtscr)
destroy(this.dw_datetime)
destroy(this.cb_find_voyage)
destroy(this.uo_tc_voyage)
destroy(this.cb_find_cp)
end on

event open;call super::open;this.move(0,0)
this.width=4600
this.height=2700
dw_voyage.setrowfocusindicator(FocusRect!)
dw_voyage.SetTransObject(SQLCA)
dw_responsible.SetTransObject(SQLCA)
dw_datetime.InsertRow(0)

uo_vesselselect.of_registerwindow( w_fin_controlpanel )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

end event

event ue_vesselselection;call super::ue_vesselselection;uo_single_voyage.visible=FALSE
uo_tc_voyage.visible=FALSE

postevent( "ue_retrieve" )
end event

event ue_retrieve;call super::ue_retrieve;long ll_row
dw_voyage.retrieve(ii_vessel_nr)	
dw_responsible.POST retrieve(ii_vessel_nr, "XXXX") // Retrieve only vessel information
ll_row = dw_voyage.RowCount()
IF ll_row > 0 THEN
	dw_voyage.SelectRow(0,FALSE)
	dw_voyage.SelectRow(ll_row,TRUE)
	dw_voyage.setrow(ll_row)
	dw_voyage.ScrollToRow(ll_row)
END IF
end event

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_voyage, "vessel_nr", "voyage_nr", True)
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_fin_controlpanel
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_fin_controlpanel
end type

type dw_voyage from datawindow within w_fin_controlpanel
integer x = 37
integer y = 224
integer width = 489
integer height = 2268
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_fin_voyages"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;long ll_calc_id
integer li_vessel
string ls_voyage

if row > 0 then
	this.selectrow(0, FALSE)
	this.selectrow(row, TRUE)
	ll_calc_id = dw_voyage.getItemNumber(row, "cal_calc_id")
	li_vessel = dw_voyage.getItemNumber(row, "vessel_nr")
	ls_voyage = dw_voyage.getItemString(row, "voyage_nr")
	if ll_calc_id > 1 then
		uo_tc_voyage.visible = FALSE
		uo_single_voyage.visible = TRUE
		dw_responsible.POST retrieve(li_vessel, ls_voyage)
		uo_single_voyage.of_setVesselVoyage(li_vessel, ls_voyage, ll_calc_id)
		uo_single_voyage.of_retrieve()
		//m_tramosmain.mf_setcalclink(uo_single_voyage.tab_finance.tabpage_poc.dw_poc, "poc_vessel_nr", "poc_voyage_nr", True)
	else
		uo_single_voyage.visible = FALSE
		uo_tc_voyage.visible = TRUE
		dw_responsible.POST retrieve(li_vessel, ls_voyage)
		uo_tc_voyage.of_setVesselVoyage(li_vessel, ls_voyage)
		uo_tc_voyage.of_retrieve()
		//m_tramosmain.mf_setcalclink(uo_tc_voyage.tab_finance.tabpage_poc.dw_poc, "poc_vessel_nr", "poc_voyage_nr", True)
	end if
end if
end event

type dw_responsible from datawindow within w_fin_controlpanel
integer x = 1307
integer y = 8
integer width = 1847
integer height = 196
boolean bringtotop = true
string title = "none"
string dataobject = "d_fin_responsible"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_row
opensheet(w_vessel, w_tramos_main, 0, original!)
do while w_vessel.dw_list.rowCount() < 1
	/* do nothing, just wait until data present */
loop

w_vessel.uo_SearchBox.of_FindAndSelect(This.getItemString(1, "vessels_vessel_ref_nr"))







end event

type uo_single_voyage from u_fin_single_voyage within w_fin_controlpanel
event destroy ( )
boolean visible = false
integer x = 567
integer y = 224
integer taborder = 70
boolean bringtotop = true
end type

on uo_single_voyage.destroy
call u_fin_single_voyage::destroy
end on

type cb_refresh from commandbutton within w_fin_controlpanel
integer x = 3173
integer y = 8
integer width = 343
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refresh"
end type

event clicked;string ls_voyage = "XXXX"

if dw_voyage.rowCount() > 0 then
	ls_voyage = dw_voyage.getItemString(dw_voyage.getRow(), "voyage_nr")
end if
dw_responsible.POST retrieve(ii_vessel_nr, ls_voyage)

if uo_single_voyage.visible then
	uo_single_voyage.of_retrieve()
elseif uo_tc_voyage.visible then
	uo_tc_voyage.of_retrieve()
end if
end event

type cb_prtscr from commandbutton within w_fin_controlpanel
integer x = 3173
integer y = 108
integer width = 343
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print Screen"
end type

event clicked;long job

job = PrintOpen()
PrintScreen(job, 500, 500, 7500, 5000)
printClose(job)
end event

type dw_datetime from datawindow within w_fin_controlpanel
integer x = 3918
integer y = 68
integer width = 384
integer height = 80
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_find_voyage from commandbutton within w_fin_controlpanel
integer x = 3547
integer y = 8
integer width = 357
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Find Voyage"
end type

event clicked;datastore lds
datetime ldt
string ls_voyage_nr
long ll_rows, ll_found

lds = CREATE datastore
lds.dataObject = "d_fin_find_voyage"
lds.setTransObject(SQLCA)
ll_rows = lds.retrieve(ii_vessel_nr)

dw_datetime.acceptText()
ldt = dw_datetime.getItemDatetime(1, "datetime_value")
ll_found = lds.Find("datetime('" + string(ldt) + "') >= startdate and " +&
							"datetime('" + string(ldt) + "') <= port_dept_dt", 1, ll_rows)
if ll_found < 1 then
	MessageBox("Information", "No voyage match the entered data!")
	DESTROY lds
	return
end if

ls_voyage_nr = lds.getItemString(ll_found, "voyage_nr")
DESTROY lds

ll_found = dw_voyage.Find("voyage_nr='" + ls_voyage_nr+"'",1, 99999)
if ll_found < 1 then
	MessageBox("Information", "No voyage match the entered data!")
	return
end if

dw_voyage.ScrollToRow(ll_found)
dw_voyage.EVENT Clicked(0, 0, ll_found, dw_voyage.object)
end event

type uo_tc_voyage from u_fin_tc_voyage within w_fin_controlpanel
boolean visible = false
integer x = 567
integer y = 224
integer taborder = 80
end type

on uo_tc_voyage.destroy
call u_fin_tc_voyage::destroy
end on

type cb_find_cp from commandbutton within w_fin_controlpanel
integer x = 3547
integer y = 108
integer width = 357
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Find C/P"
end type

event clicked;datastore lds
datetime ldt
string ls_voyage_nr
long ll_rows, ll_row, ll_found

lds = CREATE datastore
lds.dataObject = "d_sq_tb_fin_find_cp"
lds.setTransObject(SQLCA)

dw_datetime.acceptText()
ldt = datetime(date(dw_datetime.getItemDatetime(1, "datetime_value")), time(0,0,0))

ll_rows = lds.retrieve(ii_vessel_nr, ldt)

if ll_rows < 1 then
	MessageBox("Information", "No voyage/CP match the entered date!")
	destroy lds 
	return
end if

if ll_rows = 1 then 
	ll_row = 1
else
	openwithparm(w_fin_show_found_cp, lds)
	ll_row = message.doubleparm
end if

if ll_row = -1 then
	MessageBox("Information", "No Voyage selected!")
	destroy lds 
	return
end if
	
ls_voyage_nr = lds.getItemString(ll_row, "voyage_nr")
destroy lds 

ll_found = dw_voyage.Find("voyage_nr='" + ls_voyage_nr+"'",1, 99999)
if ll_found < 1 then
	MessageBox("Information", "No voyage match the entered data!")
	return
end if

dw_voyage.ScrollToRow(ll_found)
dw_voyage.EVENT Clicked(0, 0, ll_found, dw_voyage.object)

end event

