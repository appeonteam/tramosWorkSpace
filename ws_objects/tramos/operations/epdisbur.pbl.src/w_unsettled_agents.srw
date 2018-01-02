$PBExportHeader$w_unsettled_agents.srw
$PBExportComments$For Global Agent Import file
forward
global type w_unsettled_agents from mt_w_main
end type
type cb_refresh from commandbutton within w_unsettled_agents
end type
type dw_unsettled_agents from mt_u_datawindow within w_unsettled_agents
end type
type cb_print from commandbutton within w_unsettled_agents
end type
type cbx_1 from checkbox within w_unsettled_agents
end type
type cb_settle from mt_u_commandbutton within w_unsettled_agents
end type
type cb_save from commandbutton within w_unsettled_agents
end type
end forward

global type w_unsettled_agents from mt_w_main
integer x = 503
integer y = 224
integer width = 4037
integer height = 2568
string title = "Unsettled Agents"
boolean maxbox = false
boolean resizable = false
long backcolor = 79741120
string icon = "images\unsettled _agents.ico"
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve ( )
cb_refresh cb_refresh
dw_unsettled_agents dw_unsettled_agents
cb_print cb_print
cbx_1 cbx_1
cb_settle cb_settle
cb_save cb_save
end type
global w_unsettled_agents w_unsettled_agents

type variables

end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_link_disbursement ()
private subroutine _set_permissions ()
public subroutine wf_settle_expenses ()
end prototypes

event ue_retrieve();constant int li_RETRIEVE_ALL_DATA = 2

dw_unsettled_agents.retrieve()
_set_permissions()
end event

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_unsettled_agents
   <OBJECT> </OBJECT>
   <DESC>  </DESC>
   <USAGE></USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date   		CR-Ref   		Author      Comments
		29/11/16		CR4420			XSZ004		Add settle port expenses function.
	</HISTORY>
*********************************************************************************************************/
end subroutine

public subroutine wf_link_disbursement ();/********************************************************************
   wf_link_disbursement
   <DESC>  </DESC>
   <RETURN>       
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		29/11/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

long   ll_vessel, ll_pcn, ll_row
string ls_voyage, ls_portcode, ls_agent_sn

u_jump_disbursement luo_jump_disbursement

ll_row = dw_unsettled_agents.getSelectedRow(0)

if ll_row < 1 then return

luo_jump_disbursement = CREATE u_jump_disbursement

ll_vessel = 	dw_unsettled_agents.getItemNumber(ll_row, "disbursements_vessel_nr")
ls_voyage = 	dw_unsettled_agents.getItemString(ll_row, "voyage_nr")
ls_portcode = 	dw_unsettled_agents.getItemString(ll_row, "port_code")
ll_pcn = 		dw_unsettled_agents.getItemNumber(ll_row, "pcn")
ls_agent_sn = 	dw_unsettled_agents.getItemString(ll_row, "agent_sn")

luo_jump_disbursement.of_open_disbursement(ll_vessel, ls_voyage, ls_portcode, ll_pcn, ls_agent_sn)

DESTROY luo_jump_disbursement	
end subroutine

private subroutine _set_permissions ();/********************************************************************
   _set_permissions
   <DESC> </DESC>
   <RETURN>       
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		29/11/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_findrow, li_rowcount

li_rowcount = dw_unsettled_agents.rowcount()
li_findrow = dw_unsettled_agents.find("selected = 'Yes'", 1, li_rowcount)

cb_print.enabled = (li_rowcount > 0)
cb_save.enabled = (li_rowcount > 0)
cb_settle.enabled = (li_findrow > 0)

end subroutine

public subroutine wf_settle_expenses ();
end subroutine

on w_unsettled_agents.create
int iCurrent
call super::create
this.cb_refresh=create cb_refresh
this.dw_unsettled_agents=create dw_unsettled_agents
this.cb_print=create cb_print
this.cbx_1=create cbx_1
this.cb_settle=create cb_settle
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh
this.Control[iCurrent+2]=this.dw_unsettled_agents
this.Control[iCurrent+3]=this.cb_print
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cb_settle
this.Control[iCurrent+6]=this.cb_save
end on

on w_unsettled_agents.destroy
call super::destroy
destroy(this.cb_refresh)
destroy(this.dw_unsettled_agents)
destroy(this.cb_print)
destroy(this.cbx_1)
destroy(this.cb_settle)
destroy(this.cb_save)
end on

event open;call super::open;this.move(0, 0)

n_service_manager 	ln_serviceMgr
n_dw_style_service   ln_style

ln_serviceMgr.of_loadservice( ln_style, "n_dw_style_service")
ln_style.of_dwlistformater(dw_unsettled_agents, false)

dw_unsettled_agents.settransobject(sqlca)

post event ue_retrieve()
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_unsettled_agents
string facename = "Tahoma"
end type

type cb_refresh from commandbutton within w_unsettled_agents
integer x = 2953
integer y = 2360
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;event ue_retrieve()

if dw_unsettled_agents.rowcount() > 0 then
	dw_unsettled_agents.event rowfocuschanged(1)
end if
end event

type dw_unsettled_agents from mt_u_datawindow within w_unsettled_agents
integer x = 37
integer y = 32
integer width = 3954
integer height = 2312
integer taborder = 10
string dataobject = "d_unsettled_agents"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_sortbygroup = false
boolean ib_setselectrow = true
end type

event doubleclicked;if row > 0 then
	wf_link_disbursement()
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 and currentrow <> this.getselectedrow(0) then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

event itemchanged;call super::itemchanged;if dwo.name = "selected" then
	post _set_permissions()
end if
end event

event clicked;call super::clicked;this.setrow(row)
this.event rowfocuschanged(row)
end event

type cb_print from commandbutton within w_unsettled_agents
integer x = 3648
integer y = 2360
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;n_dataprint lnv_print

lnv_print.of_print(dw_unsettled_agents)

end event

type cbx_1 from checkbox within w_unsettled_agents
integer x = 37
integer y = 2360
integer width = 343
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
string text = "Select All"
end type

event clicked;int li_count, li_cnt
string ls_value

li_count = dw_unsettled_agents.rowcount()

if this.checked then
	this.text = "Deselect All"
	ls_value = "Yes"
else
	this.text = "Select All"
	ls_value = "No"
end if

for li_cnt = 1 to li_count
	dw_unsettled_agents.setitem(li_cnt, "selected", ls_value)
next

_set_permissions()
end event

type cb_settle from mt_u_commandbutton within w_unsettled_agents
integer x = 2606
integer y = 2360
integer taborder = 30
boolean bringtotop = true
string text = "S&ettle"
end type

event clicked;call super::clicked;int li_vesselnr, li_pcn, li_agentnr, li_not_use, li_findrow, li_selectrow, li_rowid
string ls_voyagenr, ls_portcode, ls_findstr

mt_n_datastore lds_unsettle_disb
n_settle_expenses lnv_settle_exp

li_rowid = dw_unsettled_agents.getrowidfromrow(dw_unsettled_agents.getselectedrow(0))

dw_unsettled_agents.setredraw(false)

lds_unsettle_disb = create mt_n_datastore
lds_unsettle_disb.dataobject = "d_unsettled_agents"

dw_unsettled_agents.sharedata(lds_unsettle_disb)

lnv_settle_exp = create n_settle_expenses

lnv_settle_exp.of_settle_expenses(lds_unsettle_disb, li_not_use, false)

li_findrow = lds_unsettle_disb.find("reason <> '' and selected = 'Yes'", 1, lds_unsettle_disb.rowcount())

if li_findrow > 0 then
	messagebox("Disbursements not settled", "Tramos has not been able to settle all the selected disbursement expenses.", Information!)
end if

dw_unsettled_agents.sharedataoff()

if li_findrow > 0 then
	li_selectrow = li_findrow
elseif li_rowid > 0 then
	li_selectrow = dw_unsettled_agents.getrowfromrowid(li_rowid)
end if

if li_selectrow > 0 then
	dw_unsettled_agents.scrolltorow(li_selectrow)
else
	dw_unsettled_agents.scrolltorow(1)
end if

dw_unsettled_agents.setredraw(true)

_set_permissions()

if isValid(w_disbursements) then
	w_disbursements.dw_disb_proc_list.event Clicked(0, 0, w_disbursements.dw_disb_proc_list.getRow(), w_disbursements.dw_disb_proc_list.object)
end if

destroy lds_unsettle_disb
destroy lnv_settle_exp
end event

type cb_save from commandbutton within w_unsettled_agents
integer x = 3301
integer y = 2360
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;n_dataexport lnv_exp

lnv_exp.of_export(dw_unsettled_agents)

end event

