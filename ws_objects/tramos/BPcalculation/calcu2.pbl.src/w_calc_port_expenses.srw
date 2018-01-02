$PBExportHeader$w_calc_port_expenses.srw
$PBExportComments$This window is showing average port expenses over time
forward
global type w_calc_port_expenses from mt_w_response_calc
end type
type cb_refresh from mt_u_commandbutton within w_calc_port_expenses
end type
type dw_port_expenses from u_datagrid within w_calc_port_expenses
end type
type dw_shiptype from u_datagrid within w_calc_port_expenses
end type
type gb_shiptype from mt_u_groupbox within w_calc_port_expenses
end type
type cbx_selectcall_shiptype from mt_u_checkbox within w_calc_port_expenses
end type
type cbx_allshiptype from mt_u_checkbox within w_calc_port_expenses
end type
type dw_query from u_datagrid within w_calc_port_expenses
end type
type gb_1 from mt_u_groupbox within w_calc_port_expenses
end type
type st_6 from u_topbar_background within w_calc_port_expenses
end type
type cb_close from mt_u_commandbutton within w_calc_port_expenses
end type
end forward

global type w_calc_port_expenses from mt_w_response_calc
integer x = 1001
integer y = 200
integer width = 2962
integer height = 2268
string title = "Port Expenses"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve pbm_custom01
event ue_pre_retrieve ( )
cb_refresh cb_refresh
dw_port_expenses dw_port_expenses
dw_shiptype dw_shiptype
gb_shiptype gb_shiptype
cbx_selectcall_shiptype cbx_selectcall_shiptype
cbx_allshiptype cbx_allshiptype
dw_query dw_query
gb_1 gb_1
st_6 st_6
cb_close cb_close
end type
global w_calc_port_expenses w_calc_port_expenses

type variables
s_calc_port_expenses istr_parm
n_messagebox inv_messagebox

end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_get_selectshiptype (ref long al_selectshiptype[])
end prototypes

event ue_retrieve;string  ls_portcode, ls_purpose
int li_year
long ll_index, ll_findrow, ll_rowcount, ll_shiptype[]
//

dw_query.accepttext()
wf_get_selectshiptype(ll_shiptype[])

ls_portcode = dw_query.getitemstring(1,'port_code')
ls_purpose = dw_query.getitemstring(1,'purpose')
li_year = dw_query.getitemnumber(1,'years')

dw_port_expenses.Retrieve(ll_shiptype[], ls_portcode, ls_purpose, li_year)
if dw_port_expenses.rowcount() > 0 then
	dw_port_expenses.SelectRow(1,true)
end if
	
end event

public subroutine documentation ();/********************************************************************
   w_calc_port_expenses
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
	16/0317		CR4458	KSH092			All users could see all ship types from all profit centers and UI adjustment  
*****************************************************************/
end subroutine

public subroutine wf_get_selectshiptype (ref long al_selectshiptype[]);	/********************************************************************
   wf_get_selectshiptype()
   <DESC>	</DESC>
   <RETURN>	
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> ue_retrieve(), cbx_allshiptype.clicked()		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		24/03/17	CR4458       KSH092   First Version
   </HISTORY>
********************************************************************/

long ll_index, ll_findrow, ll_rowcount

ll_index = 1
ll_rowcount = dw_shiptype.rowcount()

ll_findrow = dw_shiptype.find("isSelected()", 1, ll_rowcount)
do while ll_findrow > 0 
	al_selectshiptype[ll_index] = dw_shiptype.getitemnumber(ll_findrow, "cal_vest_type_id")
	ll_index ++
	ll_findrow = dw_shiptype.find("isSelected()", ll_findrow + 1, ll_rowcount + 1)
loop
end subroutine

event open;string ls_portname

istr_parm = message.PowerObjectParm

dw_query.of_set_dddwspecs(true)
dw_query.inv_dddwsearch.of_register()

dw_query.insertrow(0)
dw_query.setitem(1,'years',istr_parm.years)

dw_query.setitem(1,'purpose',istr_parm.purpose)
if not isnull(istr_parm.portcode) and istr_parm.portcode <> '' then
	dw_query.setitem(1,'port_code',istr_parm.portcode)
	SELECT PORT_N
	INTO :ls_portname
	FROM PORTS
	where PORT_CODE = :istr_parm.portcode;
	dw_query.setitem(1,'port_n',ls_portname)
else
	dw_query.setitem(1,'port_n','')
end if


cbx_allshiptype.checked = false


dw_shiptype.SetTransObject(sqlca)
dw_shiptype.retrieve(uo_global.gos_userid, 0)

if dw_shiptype.rowcount() > 0 then
	dw_shiptype.selectrow ( 0, true ) 
end if

cbx_selectcall_shiptype.text = "Deselect all"
cbx_selectcall_shiptype.checked = true

dw_port_expenses.SetTransObject(SQLCA)
this.PostEvent("ue_retrieve")

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_port_expenses ,false)

dw_port_expenses.of_setallcolumnsresizable(true)




end event

on w_calc_port_expenses.create
int iCurrent
call super::create
this.cb_refresh=create cb_refresh
this.dw_port_expenses=create dw_port_expenses
this.dw_shiptype=create dw_shiptype
this.gb_shiptype=create gb_shiptype
this.cbx_selectcall_shiptype=create cbx_selectcall_shiptype
this.cbx_allshiptype=create cbx_allshiptype
this.dw_query=create dw_query
this.gb_1=create gb_1
this.st_6=create st_6
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh
this.Control[iCurrent+2]=this.dw_port_expenses
this.Control[iCurrent+3]=this.dw_shiptype
this.Control[iCurrent+4]=this.gb_shiptype
this.Control[iCurrent+5]=this.cbx_selectcall_shiptype
this.Control[iCurrent+6]=this.cbx_allshiptype
this.Control[iCurrent+7]=this.dw_query
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.cb_close
end on

on w_calc_port_expenses.destroy
call super::destroy
destroy(this.cb_refresh)
destroy(this.dw_port_expenses)
destroy(this.dw_shiptype)
destroy(this.gb_shiptype)
destroy(this.cbx_selectcall_shiptype)
destroy(this.cbx_allshiptype)
destroy(this.dw_query)
destroy(this.gb_1)
destroy(this.st_6)
destroy(this.cb_close)
end on

event key;call super::key;IF key = KeyEscape! THEN
	cb_close.event clicked()
	
end if
end event

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_port_expenses
integer x = 1211
integer y = 528
end type

type cb_refresh from mt_u_commandbutton within w_calc_port_expenses
integer x = 2574
integer y = 2068
integer taborder = 60
string text = "&Retrieve"
end type

event clicked;string  	ls_portcode, ls_purpose, ls_portname
int 		li_year
long  	ll_shiptype[]
//

dw_query.accepttext()

wf_get_selectshiptype(ll_shiptype[])

ls_portcode = dw_query.getitemstring(1,'port_code')
ls_portname = dw_query.getitemstring(1,'port_n')
ls_purpose = dw_query.getitemstring(1,'purpose')
li_year = dw_query.getitemnumber(1,'years')

if upperbound(ll_shiptype[]) < 1 then 
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must select at least one ship type.", this)
	dw_shiptype.setfocus()
	
	return
end if


if (isnull(ls_portcode) or trim(ls_portcode) = '') or (isnull(ls_portname) or trim(ls_portname) = '') then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must select a port code or port name.", this)
	dw_query.setfocus()
	dw_query.setcolumn('port_code')
	return
end if

if isnull(ls_purpose) or trim(ls_purpose) = '' then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must select a purpose.", this)
	dw_query.setfocus()
	dw_query.setcolumn('purpose')
	return
end if

if isnull(li_year) or li_year = 0 then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must type a number of years.", this)
	dw_query.setfocus()
	dw_query.setcolumn('years')
	return
end if


parent.PostEvent("ue_retrieve")
end event

type dw_port_expenses from u_datagrid within w_calc_port_expenses
integer x = 37
integer y = 628
integer width = 2880
integer height = 1424
integer taborder = 50
string dataobject = "d_calc_avg_port_expenses"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
boolean ib_setselectrow = true
string is_sortprefix = "_t"
end type

event clicked;call super::clicked;if row > 0 then
	// Highlight the current row
	this.setrow(row)
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
end if
end event

type dw_shiptype from u_datagrid within w_calc_port_expenses
integer x = 69
integer y = 80
integer width = 955
integer height = 448
integer taborder = 20
string dataobject = "d_sq_tb_shiptype_pr"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_multiselect = true
end type

type gb_shiptype from mt_u_groupbox within w_calc_port_expenses
integer x = 37
integer y = 16
integer width = 1024
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Ship Type(s)"
end type

type cbx_selectcall_shiptype from mt_u_checkbox within w_calc_port_expenses
integer x = 690
integer y = 20
integer width = 329
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;
if this.checked then	
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

this.textcolor = c#color.White


dw_shiptype.selectrow(0, this.checked)

end event

type cbx_allshiptype from mt_u_checkbox within w_calc_port_expenses
integer x = 1426
integer y = 80
integer width = 1019
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Show ship types from all profit centers"
end type

event clicked;
long ll_index, ll_findrow, ll_rowcount, ll_selectshiptype[], ll_i


wf_get_selectshiptype(ll_selectshiptype[])


if this.checked then
	dw_shiptype.retrieve('%', 1)
else
	dw_shiptype.retrieve(uo_global.gos_userid, 0)
end if

dw_shiptype.selectrow(0,true)

cbx_selectcall_shiptype.checked = true 
cbx_selectcall_shiptype.text = "Deselect all"
cbx_selectcall_shiptype.textcolor = c#color.White
end event

type dw_query from u_datagrid within w_calc_port_expenses
integer x = 1106
integer y = 168
integer width = 1243
integer height = 256
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_ex_tb_calcportexpensesquery"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_usectrl0 = true
boolean ib_editmaskselect = true
end type

event itemchanged;string ls_portname, ls_portcode

choose case dwo.name
	case "port_code"
	if this.of_itemchanged() = c#return.success then
		SELECT PORT_N
		INTO :ls_portname
		FROM PORTS
		where PORT_CODE = :data;
		dw_query.setitem(1,'port_n',ls_portname)
	else
		return 2
	end if
case "purpose"
	if this.of_itemchanged() <> c#return.success then return 2
case 'port_n'
	if this.of_itemchanged() = c#return.success then
		SELECT PORT_CODE
		INTO :ls_portcode
		FROM PORTS
		where PORT_N = :data;
		dw_query.setitem(1,'port_code',ls_portcode)
	else
		return 2
	end if

end choose
end event

event getfocus;call super::getfocus;if keydown(KeyTab!) and  keydown(KeyShift!) then
	this.setcolumn("years")
end if

end event

event editchanged;call super::editchanged;if dwo.name = 'years' then
	if long(data) < 0 then
		this.setitem( 1, "years", abs(long(data)))
	end if
end if
end event

type gb_1 from mt_u_groupbox within w_calc_port_expenses
integer x = 1097
integer y = 16
integer width = 1376
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Criteria"
end type

type st_6 from u_topbar_background within w_calc_port_expenses
integer width = 2953
integer height = 592
end type

type cb_close from mt_u_commandbutton within w_calc_port_expenses
boolean visible = false
integer x = 2592
integer y = 492
boolean bringtotop = true
string text = "Close"
end type

event clicked;call super::clicked;closewithreturn(parent,'')
end event

