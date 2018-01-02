$PBExportHeader$w_rules_edition.srw
forward
global type w_rules_edition from mt_w_response
end type
type dw_severities_color from mt_u_datawindow within w_rules_edition
end type
type cb_cancel from commandbutton within w_rules_edition
end type
type cb_delete from commandbutton within w_rules_edition
end type
type cb_update from commandbutton within w_rules_edition
end type
type cb_new from commandbutton within w_rules_edition
end type
type dw_rules from u_datagrid within w_rules_edition
end type
end forward

global type w_rules_edition from mt_w_response
integer width = 4183
integer height = 1800
string title = "Rules Edition"
boolean ib_setdefaultbackgroundcolor = true
dw_severities_color dw_severities_color
cb_cancel cb_cancel
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
dw_rules dw_rules
end type
global w_rules_edition w_rules_edition

type variables
s_rul_config	istr_rul_config

end variables

forward prototypes
public subroutine wf_retrieve (long al_type_id, long al_vessel_nr, string as_voyage_nr, long al_rul_id)
public subroutine wf_add ()
public subroutine documentation ()
public function long wf_update ()
end prototypes

public subroutine wf_retrieve (long al_type_id, long al_vessel_nr, string as_voyage_nr, long al_rul_id);/********************************************************************
   wf_retrieve
   <DESC>	Retrieve rules	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_type_id
		al_vessel_nr
		as_voyage_nr
		al_rul_id
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2014   CR3240       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_loop, ll_count, ll_type_id, ll_null
string	ls_null

dw_severities_color.retrieve()

ll_count = dw_rules.retrieve(al_type_id, al_vessel_nr, as_voyage_nr, al_rul_id)
if ll_count <= 0 and isnull(al_type_id) then
	setnull(ll_null)
	setnull(ls_null)
	
	if not isnull(as_voyage_nr) then
		ll_count = dw_rules.retrieve(ll_null, al_vessel_nr, ls_null, al_rul_id)
	end if

	if ll_count <= 0 then
		SELECT CAL_VEST_TYPE_ID INTO :ll_type_id FROM VESSELS WHERE VESSEL_NR = :al_vessel_nr;
		ll_count = dw_rules.retrieve(ll_type_id, ll_null, ls_null, al_rul_id)
	end if
	
	for ll_loop = 1 to ll_count
		dw_rules.setitem(ll_loop, "cal_vest_type_id", al_type_id)
		dw_rules.setitem(ll_loop, "vessel_nr", al_vessel_nr)
		dw_rules.setitem(ll_loop, "voyage_nr", as_voyage_nr)
		dw_rules.setitemstatus(ll_loop, 0, primary!, newmodified!)
	next
end if

if ll_count <= 0 then wf_add()

dw_rules.setfocus()

end subroutine

public subroutine wf_add ();/********************************************************************
   wf_add
   <DESC>	Add a new rule	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the click event of "New" button </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2014   CR3240       ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_row

ll_row = dw_rules.insertrow(0)
dw_rules.scrolltorow(ll_row)
dw_rules.setrow(ll_row)

dw_rules.setitem(ll_row, "cal_vest_type_id", istr_rul_config.type_id)
dw_rules.setitem(ll_row, "vessel_nr", istr_rul_config.vessel_nr)
dw_rules.setitem(ll_row, "voyage_nr", istr_rul_config.voyage_nr)
dw_rules.setitem(ll_row, "rul_id", istr_rul_config.rul_id)
dw_rules.setitem(ll_row, "rul_sourcelabel", istr_rul_config.rul_sourcelabel)
dw_rules.setitem(ll_row, "rul_unit", istr_rul_config.rul_unit)

if isnull(istr_rul_config.rul_targetfield2) then
	dw_rules.setitem(ll_row, "expected1", istr_rul_config.rul_targetfield1)
	dw_rules.setitem(ll_row, "expected2", istr_rul_config.rul_targetfield1)
end if

dw_rules.setitemstatus(ll_row, 0, primary!, notmodified!)		//set to 'new!' status
dw_rules.setfocus()

end subroutine

public subroutine documentation ();/********************************************************************
   w_rules_edition
   <OBJECT>		Add, modify and delete rules	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	07/01/2014   CR3240       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

public function long wf_update ();/********************************************************************
   wf_update
   <DESC>	Save the rules	data </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2014   CR3240       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_found, ll_count, ll_null
string	ls_error, ls_null
datetime	ldt_current

n_service_manager				lnv_servicemgr
n_dw_validation_service		lnv_rules

if dw_rules.accepttext() <> 1 then return c#return.Failure

setnull(ll_null)
setnull(ls_null)

ldt_current = f_getdbserverdatetime()

ll_found = dw_rules.getnextmodified(0, primary!)
do while ll_found > 0
	if isnull(dw_rules.getitemstring(ll_found, "relation")) then
		if not isnull(dw_rules.getitemstring(ll_found, "comp_symbol2")) then
			dw_rules.setitem(ll_found, "comp_symbol2", ls_null)
		end if
		
		if not isnull(istr_rul_config.rul_targetlabel2) and not isnull(istr_rul_config.rul_targetfield2) then
			if not isnull(dw_rules.getitemstring(ll_found, "expected2")) then
				dw_rules.setitem(ll_found, "expected2", ls_null)
			end if
		end if
		
		if not isnull(dw_rules.getitemnumber(ll_found, "operator_symbol2")) then
			dw_rules.setitem(ll_found, "operator_symbol2", ll_null)
		end if
		
		if dw_rules.getitemdecimal(ll_found, "constants2") <> 0.0 then
			dw_rules.setitem(ll_found, "constants2", 0.0)
		end if
	end if
	
	if dw_rules.getitemstatus(ll_found, 0, primary!) = newmodified! then
		dw_rules.setitem(ll_found, "create_date", ldt_current)
		dw_rules.setitem(ll_found, "created_by", uo_global.is_userid)
	end if
	
	dw_rules.setitem(ll_found, "last_edit_date", ldt_current)
	dw_rules.setitem(ll_found, "last_edit_by", uo_global.is_userid)
	
	ll_found = dw_rules.getnextmodified(ll_found, primary!)
loop

lnv_servicemgr.of_loadservice(lnv_rules, "n_dw_validation_service")

lnv_rules.of_registerrulenumber("severity_id", true, "Severity")
lnv_rules.of_registerrulestring("comp_symbol1", true, "Compare")
lnv_rules.of_registerrulestring("expected1", true, "Expected Value")
lnv_rules.of_registerrulenumber("operator_symbol1", true, "Operator")
lnv_rules.of_registerrulestring("comp_symbol2", true, "Compare")
lnv_rules.of_registerrulestring("expected2", true, "Expected Value")
lnv_rules.of_registerrulenumber("operator_symbol2", true, "Operator")
lnv_rules.ib_ignoreinvisiblecolumn = true

if lnv_rules.of_validate(dw_rules, true) = c#return.Failure then
	return c#return.Failure
end if

if dw_rules.update() = 1 then
	COMMIT;
	
	dw_rules.setredraw(false)
	
	do
		ll_found = dw_rules.find("isrownew()", 1, dw_rules.rowcount())
		if ll_found > 0 then dw_rules.rowsdiscard(ll_found, ll_found, primary!)
	loop while ll_found > 0
	
	dw_rules.setredraw(true)
	
	return c#return.Success
else
	ls_error = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_error, stopsign!)
	return c#return.Failure
end if

end function

on w_rules_edition.create
int iCurrent
call super::create
this.dw_severities_color=create dw_severities_color
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.dw_rules=create dw_rules
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_severities_color
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.dw_rules
end on

on w_rules_edition.destroy
call super::destroy
destroy(this.dw_severities_color)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.dw_rules)
end on

event open;call super::open;long		ll_row
string	ls_values

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

istr_rul_config = message.powerobjectparm

dw_severities_color.settransobject(sqlca)
dw_rules.settransobject(sqlca)

wf_retrieve(istr_rul_config.type_id, istr_rul_config.vessel_nr, istr_rul_config.voyage_nr, istr_rul_config.rul_id)

if not isnull(istr_rul_config.config_id) then
	ll_row = dw_rules.find("config_id = " + string(istr_rul_config.config_id), 1, dw_rules.rowcount())
	if ll_row > 0 then
		dw_rules.scrolltorow(ll_row)
		dw_rules.setrow(ll_row)
	end if
end if

ls_values = istr_rul_config.rul_targetlabel1 + c#string.Tab + istr_rul_config.rul_targetfield1 + "/"
if not isnull(istr_rul_config.rul_targetlabel2) and not isnull(istr_rul_config.rul_targetfield2) then
	ls_values += istr_rul_config.rul_targetlabel2 + c#string.Tab + istr_rul_config.rul_targetfield2 + "/"
end if

dw_rules.modify("expected1.values = '" + ls_values + "' expected2.values = '" + ls_values + "'")

//Set the datawindow style
lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_registercolumn("severity_id", true, false)
lnv_style.of_registercolumn("comp_symbol1", true, false)
lnv_style.of_registercolumn("expected1", true, false)
lnv_style.of_registercolumn("operator_symbol1", true, false)
lnv_style.of_registercolumn("constants1", true, false)
lnv_style.of_registercolumn("comp_symbol2", true, false)
lnv_style.of_registercolumn("expected2", true, false)
lnv_style.of_registercolumn("operator_symbol2", true, false)
lnv_style.of_registercolumn("constants2", true, false)
lnv_style.of_dwlistformater(dw_rules)

dw_rules.modify("datawindow.footer.color = '" + string(c#color.MT_FORMDETAIL_BG) + "'")

end event

event closequery;call super::closequery;long	ll_return

if dw_rules.accepttext() <> 1 then return 1

if dw_rules.modifiedcount() + dw_rules.deletedcount() > 0 then
	ll_return = messagebox("Data Not Saved", "Data has been changed, but not saved.~r~nWould you like to save data?", question!, yesno!)
	if ll_return = 1 then
		if wf_update() = c#return.Failure then
			return 1
		end if
	end if
end if

end event

type dw_severities_color from mt_u_datawindow within w_rules_edition
integer x = 37
integer y = 1192
integer width = 2967
integer height = 368
boolean enabled = false
string title = ""
string dataobject = "d_sq_gr_severities_color"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

type cb_cancel from commandbutton within w_rules_edition
integer x = 3785
integer y = 1596
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;wf_retrieve(istr_rul_config.type_id, istr_rul_config.vessel_nr, istr_rul_config.voyage_nr, istr_rul_config.rul_id)

end event

type cb_delete from commandbutton within w_rules_edition
integer x = 3438
integer y = 1596
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;long	ll_row

dw_rules.deleterow(0)
ll_row = dw_rules.getrow()
if ll_row > 0 then
	dw_rules.scrolltorow(ll_row)
	dw_rules.setrow(ll_row)
	dw_rules.event rowfocuschanged(ll_row)
end if

end event

type cb_update from commandbutton within w_rules_edition
integer x = 3090
integer y = 1596
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;wf_update()

end event

type cb_new from commandbutton within w_rules_edition
integer x = 2743
integer y = 1596
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;wf_add()

end event

type dw_rules from u_datagrid within w_rules_edition
integer x = 37
integer y = 32
integer width = 4091
integer height = 1540
integer taborder = 10
string dataobject = "d_sq_tb_rules_edition"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
end type

event editchanged;call super::editchanged;long	ll_pos

ll_pos = pos(data, "-")
if ll_pos > 0 then
	data = left(data, ll_pos - 1) + mid(data, ll_pos + len("-"))
	this.settext(data)
end if

end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
if currentrow > 0 then
	this.selectrow(currentrow, true)
end if

end event

event clicked;call super::clicked;if row > 0 then
	this.scrolltorow(row)
	this.setrow(row)
end if

end event

event retrieveend;call super::retrieveend;if rowcount > 0 then this.event rowfocuschanged(1)

end event

