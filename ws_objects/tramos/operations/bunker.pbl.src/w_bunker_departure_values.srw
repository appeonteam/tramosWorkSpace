$PBExportHeader$w_bunker_departure_values.srw
$PBExportComments$Display of dept. BP value opened from POC.
forward
global type w_bunker_departure_values from mt_w_sheet
end type
type dw_report from mt_u_datawindow within w_bunker_departure_values
end type
type cb_print from mt_u_commandbutton within w_bunker_departure_values
end type
end forward

global type w_bunker_departure_values from mt_w_sheet
integer width = 3877
integer height = 2432
string title = "Bunker Departure Values"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
dw_report dw_report
cb_print cb_print
end type
global w_bunker_departure_values w_bunker_departure_values

type variables
n_port_departure_bunker_value			inv_bunker
s_port_departure_values_parameter 	istr_parm

end variables

forward prototypes
public function integer of_retrieve ()
end prototypes

public function integer of_retrieve ();decimal{4}			ld_value, ld_hfo_ton, ld_do_ton, ld_go_ton, ld_lshfo_ton
long					ll_bunkerID[], ll_empty[]
long					ll_rows, ll_row
datastore			lds_data
datawindowchild	ldwc_hfo, ldwc_do, ldwc_go, ldwc_lshfo

lds_data = create datastore

select isnull(DEPT_HFO,0), isnull(DEPT_DO,0), isnull(DEPT_GO,0), isnull(DEPT_LSHFO,0) 
	INTO :ld_hfo_ton, :ld_do_ton, :ld_go_ton, :ld_lshfo_ton 
	FROM POC 
	WHERE VESSEL_NR = :istr_parm.vessel 
	AND VOYAGE_NR= :istr_parm.voyage 
	AND PORT_CODE= :istr_parm.portcode 
	AND PCN= :istr_parm.pcn ;
commit;

dw_report.insertRow(0)

/* HFO */
if ld_hfo_ton <> 0 then
	inv_bunker.of_calculate( "HFO", istr_parm.vessel, istr_parm.voyage, istr_parm.portcode, istr_parm.pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	dw_report.getChild( "dw_hfo", ldwc_hfo )
	ldwc_hfo.setTransObject(sqlca)
	ldwc_hfo.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_hfo.rowCount()
	for ll_row = 1 to ll_rows
		if ld_hfo_ton >= ldwc_hfo.getItemDecimal(ll_row, "lifted") then
			ld_hfo_ton -=ldwc_hfo.getItemDecimal(ll_row, "lifted")
			ldwc_hfo.setItem(ll_row, "rest_ton",ldwc_hfo.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_hfo.setItem(ll_row, "rest_ton", ld_hfo_ton)
		end if
	next
end if

/* DO */
ll_bunkerID = ll_empty
if ld_do_ton <> 0 then
	inv_bunker.of_calculate( "DO", istr_parm.vessel, istr_parm.voyage, istr_parm.portcode, istr_parm.pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	dw_report.getChild( "dw_do", ldwc_do )
	ldwc_do.setTransObject(sqlca)
	ldwc_do.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_do.rowCount()
	for ll_row = 1 to ll_rows
		if ld_do_ton >= ldwc_do.getItemDecimal(ll_row, "lifted") then
			ld_do_ton -=ldwc_do.getItemDecimal(ll_row, "lifted")
			ldwc_do.setItem(ll_row, "rest_ton",ldwc_do.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_do.setItem(ll_row, "rest_ton", ld_do_ton)
		end if
	next
end if

/* GO */
ll_bunkerID = ll_empty
if ld_go_ton <> 0 then
	inv_bunker.of_calculate( "GO", istr_parm.vessel, istr_parm.voyage, istr_parm.portcode, istr_parm.pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	dw_report.getChild( "dw_go", ldwc_go )
	ldwc_go.setTransObject(sqlca)
	ldwc_go.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_go.rowCount()
	for ll_row = 1 to ll_rows
		if ld_go_ton >= ldwc_go.getItemDecimal(ll_row, "lifted") then
			ld_go_ton -=ldwc_go.getItemDecimal(ll_row, "lifted")
			ldwc_go.setItem(ll_row, "rest_ton",ldwc_go.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_go.setItem(ll_row, "rest_ton", ld_go_ton)
		end if
	next
end if

/* LSHFO */
ll_bunkerID = ll_empty
if ld_lshfo_ton <> 0 then
	inv_bunker.of_calculate( "LSHFO", istr_parm.vessel, istr_parm.voyage, istr_parm.portcode, istr_parm.pcn, ld_value)
	inv_bunker.of_getdetailbunkerid( lds_data )
	ll_rows = lds_data.rowCount()
	for ll_row = 1 to ll_rows
		ll_bunkerID[ll_row] = lds_data.getItemNumber(ll_row, "bpn")
	next
	dw_report.getChild( "dw_lshfo", ldwc_lshfo )
	ldwc_lshfo.setTransObject(sqlca)
	ldwc_lshfo.retrieve(ll_bunkerID)
	
	ll_rows = ldwc_lshfo.rowCount()
	for ll_row = 1 to ll_rows
		if ld_lshfo_ton >= ldwc_lshfo.getItemDecimal(ll_row, "lifted") then
			ld_lshfo_ton -=ldwc_lshfo.getItemDecimal(ll_row, "lifted")
			ldwc_lshfo.setItem(ll_row, "rest_ton",ldwc_lshfo.getItemDecimal(ll_row, "lifted"))
		else
			ldwc_lshfo.setItem(ll_row, "rest_ton", ld_lshfo_ton)
		end if
	next
end if

destroy lds_data 
return 1
end function

on w_bunker_departure_values.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.cb_print
end on

on w_bunker_departure_values.destroy
call super::destroy
destroy(this.dw_report)
destroy(this.cb_print)
end on

event open;call super::open;string ls_ref_nr
istr_parm = message.powerobjectparm

SELECT VESSEL_REF_NR
INTO :ls_ref_nr
FROM VESSELS
WHERE VESSEL_NR = :istr_parm.vessel;

this.title = "Bunker Departure Values - V"+ls_ref_nr+" T"+istr_parm.voyage
this.width = 3890//3900
this.height = 2459//2500
//
inv_bunker = create n_port_departure_bunker_value	


of_retrieve( )
end event

event close;destroy inv_bunker
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_bunker_departure_values
end type

type dw_report from mt_u_datawindow within w_bunker_departure_values
integer x = 18
integer y = 24
integer width = 3826
integer height = 2192
integer taborder = 60
string dataobject = "d_sq_cm_bunker_dept_value"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_print from mt_u_commandbutton within w_bunker_departure_values
integer x = 3502
integer y = 2232
integer taborder = 50
string text = "&Print"
end type

event clicked;call super::clicked;dw_report.print( )
end event

