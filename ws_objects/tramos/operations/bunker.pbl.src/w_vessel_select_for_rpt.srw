$PBExportHeader$w_vessel_select_for_rpt.srw
$PBExportComments$Small window for vessel selection option settings such as active and profitcenter
forward
global type w_vessel_select_for_rpt from mt_w_response
end type
type dw_vessel from u_datagrid within w_vessel_select_for_rpt
end type
type uo_search from u_creq_search within w_vessel_select_for_rpt
end type
type st_1 from u_topbar_background within w_vessel_select_for_rpt
end type
type cb_select from mt_u_commandbutton within w_vessel_select_for_rpt
end type
type cbx_selectall from checkbox within w_vessel_select_for_rpt
end type
type cb_cancel from mt_u_commandbutton within w_vessel_select_for_rpt
end type
end forward

global type w_vessel_select_for_rpt from mt_w_response
integer width = 2318
integer height = 1944
string title = "Vessels"
boolean ib_setdefaultbackgroundcolor = true
dw_vessel dw_vessel
uo_search uo_search
st_1 st_1
cb_select cb_select
cbx_selectall cbx_selectall
cb_cancel cb_cancel
end type
global w_vessel_select_for_rpt w_vessel_select_for_rpt

type variables
integer ii_vessel_select[]
s_demurrage_stat_selection istr_parm

end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_retrieve ()
public subroutine wf_select_vessel ()
public subroutine wf_control_button ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_calc_vessel_list	
	<OBJECT></OBJECT>
	<DESC></DESC>
	<USAGE></USAGE>
	<ALSO></ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		12/12/16		CR2879		CCY018		First Version
	</HISTORY>
********************************************************************/
end subroutine

public subroutine wf_retrieve ();/********************************************************************
   wf_retrieve
   <DESC> </DESC>
   <RETURN>	(none)  
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    			CR-Ref		Author		Comments
  		02/12/16			CR2879		CCY018		First Version.	      
   </HISTORY>
********************************************************************/

long ll_row, ll_findrow, ll_rowcount

ll_rowcount = dw_vessel.retrieve(istr_parm.profitcenter)

for ll_row = 1 to upperbound(istr_parm.vessel_nr)
	ll_findrow = dw_vessel.find("vessel_nr = " + string(istr_parm.vessel_nr[ll_row]), 1, ll_rowcount)
	if ll_findrow > 0 then dw_vessel.selectrow(ll_findrow, true)
next 

if ll_rowcount = 0 then cbx_selectall.enabled = false


end subroutine

public subroutine wf_select_vessel ();/********************************************************************
   wf_select_vessel
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		12/12/16		CR2879		CCY018		First Version.
   </HISTORY>
********************************************************************/

long ll_row
integer li_vessel_nr, li_vessel_arr[]
string ls_clean_array[]

istr_parm.vessel_nr = li_vessel_arr
istr_parm.vessel_ref_nr = ls_clean_array

ll_row = dw_vessel.getselectedrow(0)
do while ll_row > 0
	istr_parm.vessel_nr[upperbound(istr_parm.vessel_nr) + 1] = dw_vessel.getitemnumber(ll_row, "vessel_nr")
	istr_parm.vessel_ref_nr[upperbound(istr_parm.vessel_ref_nr) + 1] = dw_vessel.getitemstring(ll_row, "vessel_ref_nr")
	ll_row = dw_vessel.getselectedrow(ll_row)
loop

close(this)
end subroutine

public subroutine wf_control_button ();
end subroutine

on w_vessel_select_for_rpt.create
int iCurrent
call super::create
this.dw_vessel=create dw_vessel
this.uo_search=create uo_search
this.st_1=create st_1
this.cb_select=create cb_select
this.cbx_selectall=create cbx_selectall
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vessel
this.Control[iCurrent+2]=this.uo_search
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_select
this.Control[iCurrent+5]=this.cbx_selectall
this.Control[iCurrent+6]=this.cb_cancel
end on

on w_vessel_select_for_rpt.destroy
call super::destroy
destroy(this.dw_vessel)
destroy(this.uo_search)
destroy(this.st_1)
destroy(this.cb_select)
destroy(this.cbx_selectall)
destroy(this.cb_cancel)
end on

event open;call super::open;n_service_manager  lnv_serviceMgr
n_dw_style_service lnv_style

istr_parm = message.PowerObjectParm

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_vessel, false)
dw_vessel.of_setallcolumnsresizable(true)

dw_vessel.settransobject(sqlca)

wf_retrieve()

uo_search.of_initialize(dw_vessel, "vessel_name + '#' + vessel_ref_nr + '#' + pc_nr + '#' + profit_c_pc_name + '#' + vessels_imo_number")
uo_search.of_setoriginalfilter("compute_select = 1")
uo_search.sle_search.setfocus()
end event

event close;call super::close;message.powerobjectparm = istr_parm
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_vessel_select_for_rpt
end type

type dw_vessel from u_datagrid within w_vessel_select_for_rpt
integer x = 37
integer y = 240
integer width = 2235
integer height = 1480
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_gr_vessel_select_for_rpt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
boolean ib_multiselect = true
end type

event clicked;call super::clicked;return 0
end event

type uo_search from u_creq_search within w_vessel_select_for_rpt
integer x = 37
integer y = 32
integer width = 951
integer taborder = 10
boolean bringtotop = true
boolean ib_standard_ui = true
boolean ib_standard_ui_topbar = true
end type

on uo_search.destroy
call u_creq_search::destroy
end on

event ue_prekeypress;call super::ue_prekeypress;if key = keyenter! or key = keytab! then return c#return.failure
end event

type st_1 from u_topbar_background within w_vessel_select_for_rpt
end type

type cb_select from mt_u_commandbutton within w_vessel_select_for_rpt
integer x = 1582
integer y = 1736
integer taborder = 40
boolean bringtotop = true
string text = "&Select"
end type

event clicked;call super::clicked;wf_select_vessel()
end event

type cbx_selectall from checkbox within w_vessel_select_for_rpt
integer x = 37
integer y = 1752
integer width = 393
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Select All"
end type

event clicked;
if this.checked then
	dw_vessel.selectrow(0, true)
	this.text = "Deselect All"
else
	dw_vessel.selectrow(0, false)
	this.text = "Select All"
end if

end event

type cb_cancel from mt_u_commandbutton within w_vessel_select_for_rpt
integer x = 1929
integer y = 1736
integer taborder = 50
boolean bringtotop = true
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;close(parent)
end event

