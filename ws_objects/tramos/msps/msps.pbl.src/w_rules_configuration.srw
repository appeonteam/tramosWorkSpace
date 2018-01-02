$PBExportHeader$w_rules_configuration.srw
forward
global type w_rules_configuration from w_vessel_basewindow
end type
type st_background from u_topbar_background within w_rules_configuration
end type
type dw_list from mt_u_datawindow within w_rules_configuration
end type
type cb_refresh from commandbutton within w_rules_configuration
end type
type dw_rules_list from mt_u_datawindow within w_rules_configuration
end type
type pb_expandcollapse from picturebutton within w_rules_configuration
end type
end forward

global type w_rules_configuration from w_vessel_basewindow
integer width = 4087
integer height = 2564
string title = "Rules Configuration"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
st_background st_background
dw_list dw_list
cb_refresh cb_refresh
dw_rules_list dw_rules_list
pb_expandcollapse pb_expandcollapse
end type
global w_rules_configuration w_rules_configuration

type variables
integer	ii_vessel_list[]
boolean	ib_allowedit

long		il_selectedrow, il_selectedlevel

private boolean _ib_expanded = true

end variables

forward prototypes
public subroutine wf_getbandatpointer (mt_u_datawindow adw_target, ref string as_band, ref long al_row)
public subroutine documentation ()
public subroutine wf_refreshrulelist (long al_level, long al_row)
end prototypes

public subroutine wf_getbandatpointer (mt_u_datawindow adw_target, ref string as_band, ref long al_row);/********************************************************************
   wf_getbandatpointer
   <DESC>	Get band name and row number by clicking </DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_target
		as_band
		al_row
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2014   CR3240       ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_object
long		ll_pos

as_band = ""
al_row = 0

ls_object = adw_target.getbandatpointer()

ll_pos = pos(ls_object, c#string.Tab)
if ll_pos > 0 then
	as_band = left(ls_object, ll_pos - 1)
	al_row = long(mid(ls_object, ll_pos + len(c#string.Tab)))
end if

end subroutine

public subroutine documentation ();/********************************************************************
   w_rules_configuration
   <OBJECT>		Display rules for ship type, vessel and voyage	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	07/01/2014   CR3240       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

public subroutine wf_refreshrulelist (long al_level, long al_row);/********************************************************************
   wf_refreshrulelist
   <DESC>	Refresh the rules list	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_level
		al_row
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2014   CR3240       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_type_id, ll_vessel_nr
string	ls_voyage_nr

if al_level <= 0 or al_row <= 0 then
	dw_rules_list.reset()
elseif al_row <= dw_list.rowcount() then
	dw_list.setrow(al_row)
	
	setnull(ll_type_id)
	setnull(ll_vessel_nr)
	setnull(ls_voyage_nr)
	
	choose case al_level
		case 1
			ll_type_id = dw_list.getitemnumber(al_row, "cal_vest_type_id")
		case 2
			ll_vessel_nr = dw_list.getitemnumber(al_row, "vessel_nr")
		case 3
			ll_vessel_nr = dw_list.getitemnumber(al_row, "vessel_nr")
			ls_voyage_nr = dw_list.getitemstring(al_row, "voyage_nr")
	end choose
	if not isnull(ll_type_id) or not isnull(ll_vessel_nr) or not isnull(ls_voyage_nr) then
		dw_rules_list.retrieve(ll_type_id, ll_vessel_nr, ls_voyage_nr)
	end if
end if

end subroutine

on w_rules_configuration.create
int iCurrent
call super::create
this.st_background=create st_background
this.dw_list=create dw_list
this.cb_refresh=create cb_refresh
this.dw_rules_list=create dw_rules_list
this.pb_expandcollapse=create pb_expandcollapse
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_background
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.dw_rules_list
this.Control[iCurrent+5]=this.pb_expandcollapse
end on

on w_rules_configuration.destroy
call super::destroy
destroy(this.st_background)
destroy(this.dw_list)
destroy(this.cb_refresh)
destroy(this.dw_rules_list)
destroy(this.pb_expandcollapse)
end on

event ue_retrieve;call super::ue_retrieve;long		ll_type_id, ll_vessel_nr, ll_row, ll_level
string	ls_voyage_nr, ls_find

dw_list.setredraw(false)

if 0 < il_selectedrow and il_selectedrow <= dw_list.rowcount() then
	ll_type_id = dw_list.getitemnumber(il_selectedrow, "cal_vest_type_id")
	ll_vessel_nr = dw_list.getitemnumber(il_selectedrow, "vessel_nr")
	ls_voyage_nr = dw_list.getitemstring(il_selectedrow, "voyage_nr")
	
	ll_level = il_selectedlevel
	ls_find = "cal_vest_type_id = " + string(ll_type_id) + " and vessel_nr = " + string(ll_vessel_nr) + " and voyage_nr = '" + ls_voyage_nr + "'"
end if

dw_list.retrieve(ii_vessel_list)

if dw_list.rowcount() > 0 then
	if ls_find <> "" then ll_row = dw_list.find(ls_find, 1, dw_list.rowcount())
	
	if ll_row <= 0 then
		ll_row = 1
		ll_level = long(dw_list.describe("datawindow.tree.defaultexpandtolevel"))
	end if
	
	dw_list.scrolltorow(ll_row)
	dw_list.setrow(ll_row)
	dw_list.selecttreenode(ll_row, ll_level, true)
else
	dw_rules_list.reset()
end if

dw_list.setredraw(true)

end event

event open;call super::open;dw_list.settransobject(sqlca)
dw_rules_list.settransobject(sqlca)

ii_vessel_nr = uo_global.getvessel_nr()

uo_vesselselect.of_registerwindow(w_rules_configuration)
uo_vesselselect.of_setcurrentvessel(ii_vessel_nr)
uo_vesselselect.dw_vessel.setfocus()

uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

if uo_global.ii_access_level = c#usergroup.#SUPERUSER and uo_global.ii_user_profile = 2 then		//Advanced User, Operator
	ib_allowedit = true
else
	dw_rules_list.modify("t_edit.text = '' compute_configuration.tooltip.enabled = '0'")
end if

this.post event ue_vesselselection(ii_vessel_nr)

end event

event ue_vesselselection;call super::ue_vesselselection;integer	li_empty[]

mt_n_stringfunctions	lnv_parse

if ai_vessel = 0 then setnull(ai_vessel)

ii_vessel_list = li_empty
if isnull(ai_vessel) then
	lnv_parse.of_parsetoarray(uo_vesselselect.of_get_vessels_nr(), ",", ii_vessel_list)
else
	ii_vessel_list[1] = ai_vessel
end if

this.postevent("ue_retrieve")

end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_rules_configuration
integer x = 23
integer taborder = 10
end type

event uo_vesselselect::ue_itemchanged;call super::ue_itemchanged;integer	li_vessel_nr

if isnull(vessel_nr) then
	setnull(li_vessel_nr)
	parent.post event ue_vesselselection(li_vessel_nr)
end if

end event

type st_background from u_topbar_background within w_rules_configuration
integer height = 232
end type

type dw_list from mt_u_datawindow within w_rules_configuration
integer x = 37
integer y = 264
integer width = 850
integer height = 2072
integer taborder = 30
boolean bringtotop = true
string title = ""
string dataobject = "d_sq_tv_rules_belong"
boolean vscrollbar = true
boolean border = false
end type

event doubleclicked;call super::doubleclicked;string	ls_object
long		ll_row, ll_pos, ll_level

wf_getbandatpointer(this, ls_object, ll_row)
if ll_row > 0 then
	ll_pos = pos(ls_object, "tree.level.")
	if ll_pos > 0 then
		ll_level = long(mid(ls_object, ll_pos + len("tree.level.")))
		if this.isexpanded(ll_row, ll_level) then
			this.collapse(ll_row, ll_level)
		else
			this.expand(ll_row, ll_level)
		end if
	end if
end if

end event

event treenodeselected;call super::treenodeselected;il_selectedlevel = grouplevel
il_selectedrow = row

wf_refreshrulelist(grouplevel, row)

end event

type cb_refresh from commandbutton within w_rules_configuration
integer x = 3698
integer y = 32
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;long	ll_count

ll_count = uo_vesselselect.dw_vessel.rowcount()
if ll_count > 0 then
	ii_vessel_nr = uo_vesselselect.dw_vessel.getitemnumber(1, "vessel_nr")
	parent.post event ue_vesselselection(ii_vessel_nr)
end if

end event

type dw_rules_list from mt_u_datawindow within w_rules_configuration
integer x = 919
integer y = 264
integer width = 3122
integer height = 2072
integer taborder = 40
boolean bringtotop = true
string title = ""
string dataobject = "d_sq_tb_rules_list"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event doubleclicked;call super::doubleclicked;string	ls_type_id, ls_vessel_nr, ls_voyage_nr
long		ll_type_row, ll_vessel_row, ll_voyage_row, ll_type_id, ll_vessel_nr
long		ll_type_configs, ll_vessel_configs, ll_voyage_configs

s_rul_config	lstr_rul_config

if row <= 0 then return

choose case dwo.name
	case "t_edit", "compute_configuration", "severity_id"
		if not ib_allowedit then return
		
		setnull(lstr_rul_config.type_id)
		setnull(lstr_rul_config.vessel_nr)
		setnull(lstr_rul_config.voyage_nr)
		
		lstr_rul_config.rul_id = dw_rules_list.getitemnumber(row, "rul_id")
		lstr_rul_config.config_id = dw_rules_list.getitemnumber(row, "config_id")
		
		lstr_rul_config.rul_unit = dw_rules_list.getitemstring(row, "rul_unit")
		lstr_rul_config.rul_sourcelabel = dw_rules_list.getitemstring(row, "rul_sourcelabel")
		lstr_rul_config.rul_targetfield1 = dw_rules_list.getitemstring(row, "rul_targetfield1")
		lstr_rul_config.rul_targetlabel1 = dw_rules_list.getitemstring(row, "rul_targetlabel1")
		lstr_rul_config.rul_targetfield2 = dw_rules_list.getitemstring(row, "rul_targetfield2")
		lstr_rul_config.rul_targetlabel2 = dw_rules_list.getitemstring(row, "rul_targetlabel2")
		
		ls_type_id = dw_rules_list.describe("evaluate('al_type_id', 0)")
		if ls_type_id <> "" then lstr_rul_config.type_id = long(ls_type_id)
		
		ls_vessel_nr = dw_rules_list.describe("evaluate('al_vessel_nr', 0)")
		if ls_vessel_nr <> "" then lstr_rul_config.vessel_nr = long(ls_vessel_nr)
		
		ls_voyage_nr = dw_rules_list.describe("evaluate('as_voyage_nr', 0)")
		if ls_voyage_nr <> "" then lstr_rul_config.voyage_nr = ls_voyage_nr
		
		openwithparm(w_rules_edition, lstr_rul_config)
		
		dw_rules_list.retrieve(lstr_rul_config.type_id, lstr_rul_config.vessel_nr, lstr_rul_config.voyage_nr)
		if row > 0 then
			dw_rules_list.scrolltorow(row)
			dw_rules_list.setrow(row)
		end if
		
		ll_voyage_row = dw_list.getrow()
		if ll_voyage_row > 0 then
			ll_type_id = dw_list.getitemnumber(ll_voyage_row, "cal_vest_type_id")
			ll_vessel_nr = dw_list.getitemnumber(ll_voyage_row, "vessel_nr")
			ls_voyage_nr = dw_list.getitemstring(ll_voyage_row, "voyage_nr")
			
			SELECT COUNT(*) INTO :ll_type_configs   FROM RUL_CONFIG WHERE CAL_VEST_TYPE_ID = :ll_type_id;
         SELECT COUNT(*) INTO :ll_vessel_configs FROM RUL_CONFIG WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR IS NULL;
         SELECT COUNT(*) INTO :ll_voyage_configs FROM RUL_CONFIG WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
			
			ll_type_row = long(dw_list.describe("evaluate('first(getrow() for group 1)', " + string(ll_voyage_row) + ")"))
			ll_vessel_row = long(dw_list.describe("evaluate('first(getrow() for group 2)', " + string(ll_voyage_row) + ")"))
			
			dw_list.setitem(ll_type_row, "vest_type_config", ll_type_configs)
			dw_list.setitem(ll_vessel_row, "vessel_config", ll_vessel_configs)
			dw_list.setitem(ll_voyage_row, "voyage_config", ll_voyage_configs)
		end if
	case else
		//do nothing
end choose

end event

type pb_expandcollapse from picturebutton within w_rules_configuration
event doubleclicked pbm_bndoubleclicked
integer x = 37
integer y = 2360
integer width = 110
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "TreeView!"
alignment htextalign = left!
string powertiptext = "Expand/Collapse All"
end type

event doubleclicked;this.event clicked()

end event

event clicked;_ib_expanded = not _ib_expanded

if _ib_expanded then
	dw_list.expandall()
else
	dw_list.collapseall()
end if

end event

