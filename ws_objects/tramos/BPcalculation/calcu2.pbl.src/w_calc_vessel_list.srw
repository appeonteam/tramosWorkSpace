$PBExportHeader$w_calc_vessel_list.srw
$PBExportComments$Look up vessel window for the calculation
forward
global type w_calc_vessel_list from mt_w_response
end type
type dw_vessel from u_datagrid within w_calc_vessel_list
end type
type uo_search from u_searchbox within w_calc_vessel_list
end type
type st_1 from u_topbar_background within w_calc_vessel_list
end type
type cbx_primary_pc from mt_u_checkbox within w_calc_vessel_list
end type
type cb_select from mt_u_commandbutton within w_calc_vessel_list
end type
type cb_detail from mt_u_commandbutton within w_calc_vessel_list
end type
type cb_cancel from mt_u_commandbutton within w_calc_vessel_list
end type
end forward

global type w_calc_vessel_list from mt_w_response
integer width = 2318
integer height = 1944
string title = "Vessels"
boolean ib_setdefaultbackgroundcolor = true
dw_vessel dw_vessel
uo_search uo_search
st_1 st_1
cbx_primary_pc cbx_primary_pc
cb_select cb_select
cb_detail cb_detail
cb_cancel cb_cancel
end type
global w_calc_vessel_list w_calc_vessel_list

type variables
boolean ib_row_highlight
long    il_selected_vessel
end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_set_checkbox (long al_vessel_nr)
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
		04/12/15		CR3381		XSZ004		Remove ship type and competitor vessel.
	</HISTORY>
********************************************************************/
end subroutine

public subroutine wf_set_checkbox (long al_vessel_nr);/********************************************************************
   wf_primary_pc
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		04/12/15		CR3381		XSZ004		First Version.
   </HISTORY>
********************************************************************/

int li_primay_pc

SELECT PRIMARY_PROFITCENTER into :li_primay_pc
  FROM VESSELS, USERS_PROFITCENTER  
 WHERE VESSELS.PC_NR = USERS_PROFITCENTER.PC_NR and VESSELS.VESSEL_NR = :al_vessel_nr AND
 		 USERS_PROFITCENTER.USERID = :uo_global.is_userid;
 
if li_primay_pc = 1 then
	cbx_primary_pc.checked = true
else
	cbx_primary_pc.checked = false
end if
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
  		04/12/15			CR3381		XSZ004		First Version.	      
   </HISTORY>
********************************************************************/


int  li_flag
long ll_findrow

if cbx_primary_pc.checked then
	li_flag = 0
else
	li_flag = -1
end if

ib_row_highlight = false

dw_vessel.setredraw(false)

dw_vessel.retrieve(uo_global.is_userid, li_flag)

if il_selected_vessel > 0 then
	
	ll_findrow    = dw_vessel.find("vessel_nr = " + string(il_selected_vessel), 0, dw_vessel.rowcount())
	
	if ll_findrow > 0 then
		dw_vessel.setrow(ll_findrow)
		dw_vessel.selectrow(ll_findrow, true)
		dw_vessel.scrolltorow(ll_findrow)
	else
		il_selected_vessel = 0
	end if
end if

wf_control_button()

dw_vessel.setredraw(true)
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
		04/12/15		CR3381		XSZ004		First Version.
   </HISTORY>
********************************************************************/

long ll_row, ll_vessel_nr

ll_row = dw_vessel.getselectedrow(0)

if ll_row < 1 then return

ll_vessel_nr = dw_vessel.GetItemNumber(ll_row, "vessel_nr")

CloseWithReturn(w_calc_vessel_list, ll_vessel_nr)
end subroutine

public subroutine wf_control_button ();/********************************************************************
   wf_control_button
   <DESC> </DESC>
   <RETURN>	(none)  
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    			CR-Ref		Author		Comments
  		04/12/15			CR3381		XSZ004		First Version.	      
   </HISTORY>
********************************************************************/

long ll_selectrow

ll_selectrow = dw_vessel.getselectedrow(0)

if ll_selectrow > 0 then
	cb_select.enabled = true
	cb_detail.enabled = true
else
	cb_select.enabled = false
	cb_detail.enabled = false
end if
end subroutine

on w_calc_vessel_list.create
int iCurrent
call super::create
this.dw_vessel=create dw_vessel
this.uo_search=create uo_search
this.st_1=create st_1
this.cbx_primary_pc=create cbx_primary_pc
this.cb_select=create cb_select
this.cb_detail=create cb_detail
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vessel
this.Control[iCurrent+2]=this.uo_search
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_primary_pc
this.Control[iCurrent+5]=this.cb_select
this.Control[iCurrent+6]=this.cb_detail
this.Control[iCurrent+7]=this.cb_cancel
end on

on w_calc_vessel_list.destroy
call super::destroy
destroy(this.dw_vessel)
destroy(this.uo_search)
destroy(this.st_1)
destroy(this.cbx_primary_pc)
destroy(this.cb_select)
destroy(this.cb_detail)
destroy(this.cb_cancel)
end on

event open;call super::open;n_service_manager  lnv_serviceMgr
n_dw_style_service lnv_style

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_vessel, false)

il_selected_vessel = Message.doubleparm

dw_vessel.settransobject(sqlca)

if il_selected_vessel > 0 then
	wf_set_checkbox(il_selected_vessel)
end if

wf_retrieve()

uo_search.of_initialize(dw_vessel, "vessel_name + vessel_ref_nr + pc_nr + profit_c_pc_name")
uo_search.sle_search.setfocus()
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_calc_vessel_list
end type

type dw_vessel from u_datagrid within w_calc_vessel_list
integer x = 37
integer y = 240
integer width = 2235
integer height = 1480
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sq_gr_vessellist"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
boolean ib_setselectrow = true
end type

event rowfocuschanged;call super::rowfocuschanged;if ib_row_highlight then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	
	if currentrow > 0 then
		il_selected_vessel = this.getitemnumber(currentrow, "vessel_nr")
	end if
else
	ib_row_highlight = true
end if

wf_control_button()
end event

event doubleclicked;call super::doubleclicked;if row < 1 then return

wf_select_vessel()
end event

event clicked;call super::clicked;ib_row_highlight = true

if row = 1 and this.getselectedrow(0) <> 1 then
	this.event rowfocuschanged(1)
end if

end event

event rowfocuschanging;call super::rowfocuschanging;graphicobject focus_control

focus_control = getfocus()

if isvalid(focus_control) then
	if string(focus_control.classname()) = "cb_clear" then
		ib_row_highlight = false
	end if
end if	
end event

type uo_search from u_searchbox within w_calc_vessel_list
integer x = 37
integer y = 32
integer width = 951
integer taborder = 20
boolean bringtotop = true
boolean ib_standard_ui = true
boolean ib_standard_ui_topbar = true
boolean ib_scrolltocurrentrow = true
end type

on uo_search.destroy
call u_searchbox::destroy
end on

event clearclicked;call super::clearclicked;long ll_selectedrow

ll_selectedrow = dw_vessel.getselectedrow(0)

if ll_selectedrow > 0 then
	dw_vessel.scrolltorow(ll_selectedrow)
end if
end event

event ue_keypress;call super::ue_keypress;wf_control_button()
end event

type st_1 from u_topbar_background within w_calc_vessel_list
end type

type cbx_primary_pc from mt_u_checkbox within w_calc_vessel_list
integer x = 1499
integer y = 32
integer width = 809
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show only primary Profit Center"
boolean checked = true
end type

event clicked;call super::clicked;long ll_selectrow

ll_selectrow = dw_vessel.getselectedrow(0) 

if ll_selectrow > 0 then
	il_selected_vessel = dw_vessel.getitemnumber(ll_selectrow, "vessel_nr")
else
	il_selected_vessel = 0
end if

wf_retrieve()
end event

type cb_select from mt_u_commandbutton within w_calc_vessel_list
integer x = 1234
integer y = 1736
integer taborder = 50
boolean bringtotop = true
string text = "&Select"
end type

event clicked;call super::clicked;wf_select_vessel()
end event

type cb_detail from mt_u_commandbutton within w_calc_vessel_list
integer x = 1582
integer y = 1736
integer taborder = 60
boolean bringtotop = true
string text = "De&tail"
end type

event clicked;call super::clicked;long ll_vessel_id, ll_row

ll_row = dw_vessel.getselectedrow(0)

if ll_row < 1 then return 

if isvalid(w_vessel) then
	Messagebox("Warning","Please close the Vessel window you have open already and try again")
else
	ll_vessel_id = dw_vessel.getItemNumber(ll_row, "vessel_nr")
	OpenWithParm(w_vessel, string(ll_vessel_id))
end if
end event

type cb_cancel from mt_u_commandbutton within w_calc_vessel_list
integer x = 1929
integer y = 1736
integer taborder = 70
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;call super::clicked;close(parent)
end event

