$PBExportHeader$w_print_r_outstanding_freights.srw
forward
global type w_print_r_outstanding_freights from mt_w_sheet
end type
type cb_retrieve from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type dw_save from mt_u_datawindow within w_print_r_outstanding_freights
end type
type gb_pc from mt_u_groupbox within w_print_r_outstanding_freights
end type
type dw_pc from u_datagrid within w_print_r_outstanding_freights
end type
type cbx_selectallpc from mt_u_checkbox within w_print_r_outstanding_freights
end type
type st_8 from mt_u_statictext within w_print_r_outstanding_freights
end type
type st_9 from mt_u_statictext within w_print_r_outstanding_freights
end type
type st_7 from mt_u_statictext within w_print_r_outstanding_freights
end type
type st_6 from mt_u_statictext within w_print_r_outstanding_freights
end type
type cbx_include_vessel from mt_u_checkbox within w_print_r_outstanding_freights
end type
type cbx_include_chart from mt_u_checkbox within w_print_r_outstanding_freights
end type
type cbx_include_broker from mt_u_checkbox within w_print_r_outstanding_freights
end type
type cbx_include_office from mt_u_checkbox within w_print_r_outstanding_freights
end type
type sle_offices from mt_u_singlelineedit within w_print_r_outstanding_freights
end type
type sle_brokers from mt_u_singlelineedit within w_print_r_outstanding_freights
end type
type sle_vessels from mt_u_singlelineedit within w_print_r_outstanding_freights
end type
type gb_5 from mt_u_groupbox within w_print_r_outstanding_freights
end type
type cb_sel_vessel from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type cb_sel_chart from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type cb_sel_broker from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type cb_sel_office from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type dw_userdate from u_datagrid within w_print_r_outstanding_freights
end type
type t_topbar from u_topbar_background within w_print_r_outstanding_freights
end type
type dw_print from uo_datawindow within w_print_r_outstanding_freights
end type
type cb_print from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type cb_saveas from mt_u_commandbutton within w_print_r_outstanding_freights
end type
type dw_date from u_datagrid within w_print_r_outstanding_freights
end type
type sle_charterers from multilineedit within w_print_r_outstanding_freights
end type
end forward

global type w_print_r_outstanding_freights from mt_w_sheet
integer width = 4608
integer height = 2568
string title = "Outstanding Freights"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
cb_retrieve cb_retrieve
dw_save dw_save
gb_pc gb_pc
dw_pc dw_pc
cbx_selectallpc cbx_selectallpc
st_8 st_8
st_9 st_9
st_7 st_7
st_6 st_6
cbx_include_vessel cbx_include_vessel
cbx_include_chart cbx_include_chart
cbx_include_broker cbx_include_broker
cbx_include_office cbx_include_office
sle_offices sle_offices
sle_brokers sle_brokers
sle_vessels sle_vessels
gb_5 gb_5
cb_sel_vessel cb_sel_vessel
cb_sel_chart cb_sel_chart
cb_sel_broker cb_sel_broker
cb_sel_office cb_sel_office
dw_userdate dw_userdate
t_topbar t_topbar
dw_print dw_print
cb_print cb_print
cb_saveas cb_saveas
dw_date dw_date
sle_charterers sle_charterers
end type
global w_print_r_outstanding_freights w_print_r_outstanding_freights

type variables
long il_arr_pc[]
boolean ib_accepttext, ib_dw_has_focus
string is_vessel_filter
s_demurrage_stat_selection 	istr_parm
n_messagebox inv_messagebox
u_dddw_search inv_dddw_search_analyst
end variables

forward prototypes
private subroutine _stringtoarray (string as_source, string as_delimiter, ref integer ai_ref_array[])
public subroutine documentation ()
public subroutine enableedit (ref singlelineedit acontrol)
public subroutine wf_filter ()
public subroutine wf_get_userpcnr ()
public subroutine wf_getcurrentpc ()
public subroutine of_open_actions_trans (datawindow dwo)
end prototypes

private subroutine _stringtoarray (string as_source, string as_delimiter, ref integer ai_ref_array[]); 
/********************************************************************
   _stringtoarray
   <DESC>	convert a string to an array	 	</DESC>
   <RETURN>	(None):</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_source  original string
      as_delimiter  delimiter string
      ai_ref_array[]    reference integer array

   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref            Author             Comments
   	2011-08-01 CR2324            RJH022             First Version
   </HISTORY>
********************************************************************/
long ll_count
string ls_tmp
ll_count = 0
DO
	ls_tmp = f_Get_Token(as_source,as_delimiter)
	
	ll_count ++
	ai_ref_array[ll_count] = Integer(ls_tmp) 

	If ai_ref_array[ll_count] <> Integer(ls_tmp ) Then
		MessageBox("Error", "Cannot evaluate  number "+ String (ll_count) )
		Return
	End if
	
LOOP UNTIL as_source = ""
end subroutine

public subroutine documentation ();/********************************************************************
   w_print_r_outstanding_freights
   <OBJECT>		print outstanding freights window	</OBJECT>
   <USAGE>		query and print outstanding freights			</USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date        CR-Ref           Author             Comments
   	2011-08-01  CR2324           RJH022             Added _stringtoarray()
   	2011-11-21	CR2625           CONASW             Changed office selection DW (to get active offices only)
   	29/08/14    CR3781           CCY018             The window title match with the text of a menu item
   	10/12/14    CR3796           LHG008             1.Add Claim Comment from Actions/Transactions to reports.
   	                                                2.Use the latest exchange rate for Amount calculation.
	05/12/16	    CR2679		   CCY018			Refactor UI.
   </HISTORY>
********************************************************************/


end subroutine

public subroutine enableedit (ref singlelineedit acontrol);
end subroutine

public subroutine wf_filter ();string ls_filter, ls_text

/* Vessel Number */
ls_text = is_vessel_filter
if len(ls_text) > 0 then
	if cbx_include_vessel.checked then
		if len(ls_filter) = 0 then
			ls_filter += " claims_vessel_nr in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_vessel_nr in ( " + ls_text + " )"
		end if
	else
		if len(ls_filter) = 0 then
			ls_filter += " claims_vessel_nr not in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_vessel_nr not in ( " + ls_text + " )"
		end if
	end if
end if

/* Charterer Number */
ls_text = trim(sle_charterers.text)
if len(ls_text) > 0 then
	if cbx_include_chart.checked then
		if len(ls_filter) = 0 then
			ls_filter += " claims_chart_nr in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_chart_nr in ( " + ls_text + " )"
		end if
	else
		if len(ls_filter) = 0 then
			ls_filter += " claims_chart_nr not in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_chart_nr not in ( " + ls_text + " )"
		end if
	end if		
end if

/* Broker Number */
ls_text = trim(sle_brokers.text)
if len(ls_text) > 0 then
	if cbx_include_broker.checked then
		if len(ls_filter) = 0 then
			ls_filter += " claims_broker_nr in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_broker_nr in ( " + ls_text + " )"
		end if
	else
		if len(ls_filter) = 0 then
			ls_filter += " claims_broker_nr not in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += " claims_broker_nr not in ( " + ls_text + " )"
		end if
	end if		
end if

/* Office Number */
ls_text = trim(sle_offices.text)
if len(ls_text) > 0 then
	if cbx_include_office.checked then
		if len(ls_filter) = 0 then
			ls_filter += "  claims_office_nr in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += "  claims_office_nr in ( " + ls_text + " )"
		end if
	else
		if len(ls_filter) = 0 then
			ls_filter += "  claims_office_nr not in ( " + ls_text + " )"
		else 
			ls_filter += " and "
			ls_filter += "  claims_office_nr not in ( " + ls_text + " )"
		end if
	end if		
end if

if len(ls_filter) = 0 then
	ls_filter += "out_amount_usd > 1"
else
	ls_filter += " and "
	ls_filter += "(out_amount_usd > 1)"
end if

dw_print.setfilter(ls_filter)
dw_print.filter()

end subroutine

public subroutine wf_get_userpcnr ();/********************************************************************
   wf_get_userpcnr
   <DESC></DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2679            CCY018        First Version
   </HISTORY>
********************************************************************/

mt_n_datastore lds_pc

lds_pc = create mt_n_datastore 
lds_pc.dataobject = 'd_profit_center'
lds_pc.settransobject(sqlca)
lds_pc.retrieve(uo_global.is_userid)

il_arr_pc = lds_pc.object.pc_nr.primary 

destroy lds_pc
end subroutine

public subroutine wf_getcurrentpc ();/********************************************************************
   wf_getcurrentpc
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2679            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_x, ll_empty[]

istr_parm.profitcenter = ll_empty
if dw_pc.getselectedrow(0) = 0 then
	istr_parm.profitcenter = il_arr_pc
else
	for ll_x = 1 to dw_pc.rowCount()
		if dw_pc.isselected(ll_x) then
			istr_parm.profitcenter[upperbound(istr_parm.profitcenter) + 1] = dw_pc.getitemnumber(ll_x, "pc_nr")
		end if
	next
end if
end subroutine

public subroutine of_open_actions_trans (datawindow dwo);/********************************************************************
   of_open_actions_trans
   <DESC>	Description	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		dwo
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2679            CCY018        First Version
   </HISTORY>
********************************************************************/

u_jump_actions_trans luo_jump_actions_trans
string ls_voyage_nr, ls_claim_type
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr

if dwo.getrow() < 1 then return

li_vessel_nr 	= dwo.getitemnumber(dwo.getrow(), "claims_vessel_nr")
ls_voyage_nr 	= dwo.getitemstring(dwo.getrow(), "claims_voyage_nr")
ll_chart_nr	 	= dwo.getitemnumber(dwo.getrow(), "claims_chart_nr")
ll_claim_nr	 	= dwo.getitemnumber(dwo.getrow(), "claims_claim_nr")

if ls_voyage_nr = "TC" then return

luo_jump_actions_trans = create u_jump_actions_trans
luo_jump_actions_trans.of_open_actions_trans(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)


destroy luo_jump_actions_trans
end subroutine

on w_print_r_outstanding_freights.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.dw_save=create dw_save
this.gb_pc=create gb_pc
this.dw_pc=create dw_pc
this.cbx_selectallpc=create cbx_selectallpc
this.st_8=create st_8
this.st_9=create st_9
this.st_7=create st_7
this.st_6=create st_6
this.cbx_include_vessel=create cbx_include_vessel
this.cbx_include_chart=create cbx_include_chart
this.cbx_include_broker=create cbx_include_broker
this.cbx_include_office=create cbx_include_office
this.sle_offices=create sle_offices
this.sle_brokers=create sle_brokers
this.sle_vessels=create sle_vessels
this.gb_5=create gb_5
this.cb_sel_vessel=create cb_sel_vessel
this.cb_sel_chart=create cb_sel_chart
this.cb_sel_broker=create cb_sel_broker
this.cb_sel_office=create cb_sel_office
this.dw_userdate=create dw_userdate
this.t_topbar=create t_topbar
this.dw_print=create dw_print
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.dw_date=create dw_date
this.sle_charterers=create sle_charterers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.dw_save
this.Control[iCurrent+3]=this.gb_pc
this.Control[iCurrent+4]=this.dw_pc
this.Control[iCurrent+5]=this.cbx_selectallpc
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.cbx_include_vessel
this.Control[iCurrent+11]=this.cbx_include_chart
this.Control[iCurrent+12]=this.cbx_include_broker
this.Control[iCurrent+13]=this.cbx_include_office
this.Control[iCurrent+14]=this.sle_offices
this.Control[iCurrent+15]=this.sle_brokers
this.Control[iCurrent+16]=this.sle_vessels
this.Control[iCurrent+17]=this.gb_5
this.Control[iCurrent+18]=this.cb_sel_vessel
this.Control[iCurrent+19]=this.cb_sel_chart
this.Control[iCurrent+20]=this.cb_sel_broker
this.Control[iCurrent+21]=this.cb_sel_office
this.Control[iCurrent+22]=this.dw_userdate
this.Control[iCurrent+23]=this.t_topbar
this.Control[iCurrent+24]=this.dw_print
this.Control[iCurrent+25]=this.cb_print
this.Control[iCurrent+26]=this.cb_saveas
this.Control[iCurrent+27]=this.dw_date
this.Control[iCurrent+28]=this.sle_charterers
end on

on w_print_r_outstanding_freights.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.dw_save)
destroy(this.gb_pc)
destroy(this.dw_pc)
destroy(this.cbx_selectallpc)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.cbx_include_vessel)
destroy(this.cbx_include_chart)
destroy(this.cbx_include_broker)
destroy(this.cbx_include_office)
destroy(this.sle_offices)
destroy(this.sle_brokers)
destroy(this.sle_vessels)
destroy(this.gb_5)
destroy(this.cb_sel_vessel)
destroy(this.cb_sel_chart)
destroy(this.cb_sel_broker)
destroy(this.cb_sel_office)
destroy(this.dw_userdate)
destroy(this.t_topbar)
destroy(this.dw_print)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.dw_date)
destroy(this.sle_charterers)
end on

event open;call super::open;n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

dw_print.settransobject(sqlca)
dw_userdate.insertrow(0)
dw_date.insertrow(0)
dw_pc.settransobject(sqlca)
dw_pc.retrieve(uo_global.is_userid)
wf_get_userpcnr()

inv_dddw_search_analyst = CREATE u_dddw_search
inv_dddw_search_analyst.of_register(dw_userdate, "username", "created_by", true, true)

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_autoadjustdddwwidth(dw_userdate, "username")

dw_pc.setrowfocusindicator(FocusRect!)
end event

event close;call super::close;destroy inv_dddw_search_analyst
end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredobject(cbx_selectallpc)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_print_r_outstanding_freights
integer x = 457
integer y = 588
end type

type cb_retrieve from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 3525
integer y = 2356
integer taborder = 130
boolean bringtotop = true
string text = "&Retrieve"
boolean default = true
end type

event clicked;
int    li_flag
long ll_row, ll_arr_pc[]
date ld_start_date
string ls_claim_analyst

for ll_row = 1 to dw_pc.rowcount()
	if (dw_pc.isselected(ll_row)) then
		ll_arr_pc[upperbound(ll_arr_pc) + 1] = dw_pc.getitemnumber(ll_row, "pc_nr")
	end if
next

if dw_userdate.event ue_accepttext() <> 1 then 
	dw_userdate.setfocus()
	return
end if

if dw_date.accepttext() <> 1 then
	dw_date.setfocus()
	return
end if

ld_start_date = dw_date.getitemdate(1, "start_date")
ls_claim_analyst = dw_userdate.getitemstring(1, "username")
if isnull(ls_claim_analyst) then ls_claim_analyst = ""
if isnull(ld_start_date) then 
	dw_date.setfocus()
	dw_date.setcolumn("start_date")
	inv_messagebox.of_messagebox(inv_messagebox.is_type_validation_error, "You must enter a Start Date.", parent)
	return
end if

dw_print.reset()
cb_saveas.enabled = false
cb_print.enabled = false

if upperbound(ll_arr_pc) = 0 then
	if ls_claim_analyst <> "" or len(sle_vessels.text) > 0 or len(sle_charterers.text) > 0 or len(sle_brokers.text) > 0 or len(sle_offices.text) > 0 then
		ll_arr_pc = il_arr_pc
	end if
end if

if upperbound(ll_arr_pc) > 0 and ls_claim_analyst <> "" then
	li_flag = 2
elseif upperbound(ll_arr_pc) > 0 and ls_claim_analyst = "" then
	li_flag = 1
else
	return
end if

if upperbound(ll_arr_pc) = 0 then return
dw_print.setredraw(false)
dw_print.retrieve(ld_start_date , ll_arr_pc, ls_claim_analyst, li_flag)
wf_filter()
dw_print.setsort("disch_date A")
dw_print.sort()
dw_print.setredraw(true)

if dw_print.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
end if
 
end event

type dw_save from mt_u_datawindow within w_print_r_outstanding_freights
boolean visible = false
integer x = 731
integer y = 2508
integer width = 329
integer height = 160
boolean bringtotop = true
string dataobject = "r_outstanding_freight"
boolean border = false
end type

type gb_pc from mt_u_groupbox within w_print_r_outstanding_freights
integer x = 37
integer y = 16
integer width = 933
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type dw_pc from u_datagrid within w_print_r_outstanding_freights
integer x = 73
integer y = 80
integer width = 859
integer height = 448
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_multiselect = true
end type

type cbx_selectallpc from mt_u_checkbox within w_print_r_outstanding_freights
integer x = 603
integer y = 16
integer width = 334
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;if this.checked then
	dw_pc.selectrow(0, true)
	this.text = "Deselect all"
	this.textcolor = c#color.WHITE
else
	dw_pc.selectrow(0, false)
	this.text = "Select all"
	this.textcolor = c#color.WHITE
end if

end event

type st_8 from mt_u_statictext within w_print_r_outstanding_freights
integer x = 2240
integer y = 240
integer width = 256
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Brokers"
alignment alignment = right!
end type

type st_9 from mt_u_statictext within w_print_r_outstanding_freights
integer x = 2240
integer y = 320
integer width = 256
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Offices"
alignment alignment = right!
end type

type st_7 from mt_u_statictext within w_print_r_outstanding_freights
integer x = 2240
integer y = 160
integer width = 256
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Charterers"
alignment alignment = right!
end type

type st_6 from mt_u_statictext within w_print_r_outstanding_freights
integer x = 2240
integer y = 80
integer width = 256
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Vessels"
alignment alignment = right!
end type

type cbx_include_vessel from mt_u_checkbox within w_print_r_outstanding_freights
integer x = 2514
integer y = 80
integer width = 256
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

this.textcolor = c#color.white
end event

type cbx_include_chart from mt_u_checkbox within w_print_r_outstanding_freights
integer x = 2514
integer y = 160
integer width = 256
integer height = 56
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

this.textcolor = c#color.white
end event

type cbx_include_broker from mt_u_checkbox within w_print_r_outstanding_freights
integer x = 2514
integer y = 240
integer width = 256
integer height = 56
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

this.textcolor = c#color.white
end event

type cbx_include_office from mt_u_checkbox within w_print_r_outstanding_freights
integer x = 2514
integer y = 320
integer width = 256
integer height = 56
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then
	this.text = "Include"
else
	this.text = "Exclude"
end if

this.textcolor = c#color.white
end event

type sle_offices from mt_u_singlelineedit within w_print_r_outstanding_freights
integer x = 2770
integer y = 320
integer width = 1664
integer height = 56
boolean bringtotop = true
long backcolor = 16777215
string text = ""
boolean border = false
boolean displayonly = true
end type

type sle_brokers from mt_u_singlelineedit within w_print_r_outstanding_freights
integer x = 2770
integer y = 240
integer width = 1664
integer height = 56
boolean bringtotop = true
long backcolor = 16777215
string text = ""
boolean border = false
boolean displayonly = true
end type

type sle_vessels from mt_u_singlelineedit within w_print_r_outstanding_freights
integer x = 2770
integer y = 80
integer width = 1664
integer height = 56
boolean bringtotop = true
long backcolor = 16777215
string text = ""
boolean border = false
boolean displayonly = true
end type

type gb_5 from mt_u_groupbox within w_print_r_outstanding_freights
integer x = 2213
integer y = 16
integer width = 2350
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = ""
end type

type cb_sel_vessel from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 4453
integer y = 76
integer width = 73
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;call super::clicked;long ll_upperbound
long ll_x
s_demurrage_stat_selection 	lstr_parm

if not isvalid(istr_parm) then istr_parm = lstr_parm

wf_getcurrentpc()

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "vessel"
istr_parm.come_from = "w_print_r_outstanding_freights"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm
if not isvalid(istr_parm) then return

ll_upperbound = UpperBound(istr_parm.vessel_nr)
sle_vessels.text = ""
is_vessel_filter = ""
for ll_x = 1 to ll_upperbound
	if ll_x = 1 then
		sle_vessels.text = istr_parm.vessel_ref_nr[ll_x]
		is_vessel_filter = string(istr_parm.vessel_nr[ll_x])
	else
		sle_vessels.text += ", " + istr_parm.vessel_ref_nr[ll_x]
		is_vessel_filter += ", " + string(istr_parm.vessel_nr[ll_x])
	end if
next

end event

type cb_sel_chart from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 4453
integer y = 156
integer width = 73
integer height = 64
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;call super::clicked;long ll_UpperBound
long ll_x

wf_getcurrentpc()

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "chart"
istr_parm.come_from = "w_print_r_outstanding_freights"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm
if not isvalid(istr_parm) then return

ll_UpperBound = UpperBound(istr_parm.chart_nr)
sle_charterers.text = ""
sle_charterers.setredraw(false)
for ll_x = 1 to ll_UpperBound
	if ll_x = 1 then
		sle_charterers.text = string(istr_parm.chart_nr[ll_x])
	else
		sle_charterers.text += ", " + string(istr_parm.chart_nr[ll_x])
	end if
next
sle_charterers.setredraw(true)

end event

type cb_sel_broker from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 4453
integer y = 236
integer width = 73
integer height = 64
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;call super::clicked;long ll_upperbound
long ll_x, ll_empty[]

wf_getcurrentpc()

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "broker"
istr_parm.come_from = "w_print_r_outstanding_freights"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm
if not isvalid(istr_parm) then return

ll_upperbound = UpperBound(istr_parm.broker_nr)
sle_brokers.text = ""
for ll_x = 1 to ll_upperbound
	if ll_x = 1 then
		sle_brokers.text = string(istr_parm.broker_nr[ll_x])
	else
		sle_brokers.text += ", " + string(istr_parm.broker_nr[ll_x])
	end if
next

end event

type cb_sel_office from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 4453
integer y = 316
integer width = 73
integer height = 64
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
string text = "?"
end type

event clicked;call super::clicked;long ll_upperbound
long ll_x, ll_empty[]

wf_getcurrentpc()

if upperbound(istr_parm.profitcenter)=0 then return 

istr_parm.called_from = "office"
istr_parm.come_from = "w_print_r_outstanding_freights"
openwithparm(w_demurrage_stat_select, istr_parm)
istr_parm = message.PowerObjectParm
if not isvalid(istr_parm) then return

ll_upperbound = upperbound(istr_parm.office_nr)
sle_offices.text = ""
for ll_x = 1 to ll_upperbound
	if ll_x = 1 then
		sle_offices.text = string(istr_parm.office_nr[ll_x])
	else
		sle_offices.text += ", " + string(istr_parm.office_nr[ll_x])
	end if
next

end event

type dw_userdate from u_datagrid within w_print_r_outstanding_freights
event type integer ue_accepttext ( )
event ue_setcolumn ( )
integer x = 997
integer y = 44
integer width = 1179
integer height = 64
integer taborder = 30
string dataobject = "d_ex_tb_outstanding_frt_userdate"
boolean border = false
end type

event type integer ue_accepttext();integer li_rtn

ib_accepttext = true
li_rtn = this.accepttext()
ib_accepttext = false

return li_rtn
end event

event ue_setcolumn();if not ib_dw_has_focus then
	this.setcolumn(this.getcolumn())
end if
end event

event itemerror;call super::itemerror;string ls_message

this.selecttext(1, 50)

if dwo.name = "username" then
//	if ib_accepttext then
//		ls_message = "You cannot enter " + data + " because it does not exist in the list."
//		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, ls_message, parent)
//	end if
	
	return 1
else
	return 0
end if
end event

event editchanged;call super::editchanged;choose case dwo.name
	case "username"
		inv_dddw_search_analyst.uf_editchanged()
end choose
end event

event itemchanged;call super::itemchanged;if isnull(row) or row <= 0 then return

if inv_dddw_search_analyst.uf_itemchanged() = 1 then return 2
end event

event itemfocuschanged;call super::itemfocuschanged;this.selecttext(1, 50)
end event

event getfocus;call super::getfocus;this.selecttext(1, 50)
ib_dw_has_focus = true
end event

event losefocus;call super::losefocus;ib_dw_has_focus = false

this.event post ue_setcolumn()
end event

type t_topbar from u_topbar_background within w_print_r_outstanding_freights
integer height = 592
end type

type dw_print from uo_datawindow within w_print_r_outstanding_freights
integer x = 37
integer y = 624
integer width = 4526
integer height = 1716
integer taborder = 120
string dataobject = "r_outstanding_freight"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event doubleclicked;call super::doubleclicked;
if isnull(row) or row <= 0 then return

of_open_actions_trans(this)


end event

type cb_print from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 4219
integer y = 2356
integer taborder = 150
boolean enabled = false
string text = "&Print"
end type

event clicked;call super::clicked;dw_print.print ()
end event

type cb_saveas from mt_u_commandbutton within w_print_r_outstanding_freights
integer x = 3872
integer y = 2356
integer taborder = 140
boolean enabled = false
string text = "&Save As..."
end type

event clicked;if dw_print.rowcount() > 0 then
	dw_save.dataobject = dw_print.dataobject
	dw_save.object.data.primary = dw_print.object.data.primary
	
	dw_save.modify("destroy column claims_vessel_nr")
	dw_save.saveas("", XLSX!, true)
	dw_save.reset()
end if
end event

type dw_date from u_datagrid within w_print_r_outstanding_freights
integer x = 997
integer y = 132
integer height = 64
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ex_tb_outstanding_frt_date"
boolean border = false
end type

event itemerror;call super::itemerror;this.selecttext(1, 10)
end event

type sle_charterers from multilineedit within w_print_r_outstanding_freights
integer x = 2770
integer y = 160
integer width = 1664
integer height = 56
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

