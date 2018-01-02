$PBExportHeader$w_calc_addbuncons.srw
$PBExportComments$Additionals bunker consumption window
forward
global type w_calc_addbuncons from mt_w_response
end type
type cb_default from commandbutton within w_calc_addbuncons
end type
type st_1 from statictext within w_calc_addbuncons
end type
type dw_addbuncons from u_datawindow_sqlca within w_calc_addbuncons
end type
type dw_default from u_datawindow_sqlca within w_calc_addbuncons
end type
type cb_reset from mt_u_commandbutton within w_calc_addbuncons
end type
type ln_1 from line within w_calc_addbuncons
end type
end forward

global type w_calc_addbuncons from mt_w_response
integer width = 2423
integer height = 1128
string title = "Additional Bunker Consumption"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
cb_default cb_default
st_1 st_1
dw_addbuncons dw_addbuncons
dw_default dw_default
cb_reset cb_reset
ln_1 ln_1
end type
global w_calc_addbuncons w_calc_addbuncons

type variables

s_calc_addbuncons istr_calc_addbuncons

end variables

forward prototypes
public function integer wf_validate ()
public subroutine wf_inibunvalue ()
public subroutine wf_refreshlist ()
public subroutine wf_deleteinactive ()
public subroutine wf_selecttext (long al_row, string as_colname)
public subroutine documentation ()
end prototypes

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>Validate data</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13/07/16		CR4216			CCY018        First Version
   </HISTORY>
********************************************************************/

string ls_message, ls_cal_description
long ll_errorrow, ll_row, ll_rowcount, ll_findrow
integer li_errorcolumn, li_return, li_active
dec{3} ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo
mt_n_datastore lds_active
n_dw_validation_service    lnv_validation

if istr_calc_addbuncons.ai_locked = 1 then return c#return.Success

dw_addbuncons.accepttext( )

lds_active = create mt_n_datastore
lds_active.dataobject = 'd_sq_gr_cal_addbuncons_active'
lds_active.settransobject( sqlca)
ll_rowcount = lds_active.retrieve(istr_calc_addbuncons.al_vessel_nr)

for ll_row = 1 to dw_addbuncons.rowcount( )
	ls_cal_description = dw_addbuncons.getitemstring(ll_row, "cal_description")
	ll_findrow = lds_active.find("cal_description = '" + ls_cal_description + "'", 1, ll_rowcount)
	if ll_findrow > 0 then
		dw_addbuncons.setitem(ll_row, "cal_active", 1)
	else	
		dw_addbuncons.setitem(ll_row, "cal_active", 0)
	end if
	
	dw_addbuncons.setitemstatus(ll_row, "cal_active", primary!, NotModified!)
next

wf_deleteinactive()

destroy lnv_validation

return c#return.Success
end function

public subroutine wf_inibunvalue ();/********************************************************************
   wf_setdefault
   <DESC>Reset bunker value from profit center</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/07/16		CR4216		CCY018		 First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowscount, ll_findrow
integer li_default, li_active
decimal ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo
string ls_cal_description
mt_n_datastore lds_active

lds_active = create mt_n_datastore
lds_active.dataobject = 'd_sq_gr_cal_addbuncons_active'
lds_active.settransobject( sqlca)
ll_rowscount = lds_active.retrieve(istr_calc_addbuncons.al_vessel_nr )

dw_addbuncons.setredraw(false)

for ll_row = 1 to dw_addbuncons.rowcount( )
	ls_cal_description = dw_addbuncons.getitemstring(ll_row, "cal_description")
	li_active = 0
	li_default = 0
	
	ll_findrow = lds_active.find("cal_description = '" + ls_cal_description + "'", 1, ll_rowscount)
	if ll_findrow > 0 then 
		ld_hsfo = lds_active.getitemnumber(ll_findrow , "hsfo_value")
		ld_hsgo = lds_active.getitemnumber(ll_findrow , "hsgo_value")
		ld_lsgo = lds_active.getitemnumber(ll_findrow , "lsgo_value")
		ld_lsfo = lds_active.getitemnumber(ll_findrow , "lsfo_value")
		li_default = lds_active.getitemnumber(ll_findrow , "default_value")
	
		li_active = 1
	end if
	
	if li_default <> 1 then
		setnull(ld_hsfo) 
		setnull(ld_hsgo)
		setnull(ld_lsgo)
		setnull(ld_lsfo)
	end if
	
	dw_addbuncons.setitem(ll_row, "hsfo_value", ld_hsfo)
	dw_addbuncons.setitem(ll_row, "hsgo_value", ld_hsgo)
	dw_addbuncons.setitem(ll_row, "lsgo_value", ld_lsgo)
	dw_addbuncons.setitem(ll_row, "lsfo_value", ld_lsfo)
	dw_addbuncons.setitem(ll_row, "cal_active", li_active)
	dw_addbuncons.setitemstatus(ll_row, "cal_active", primary!, NotModified!)
next

dw_addbuncons.setredraw(true)

destroy lds_active
end subroutine

public subroutine wf_refreshlist ();/********************************************************************
   wf_refreshlist
   <DESC>refresh the list of activities</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04/08/16		CR4216		CCY018		 First Version
		08/10/16		CR4515		XSZ004		 The new bunker value should empty when open this window.
   </HISTORY>
********************************************************************/

long ll_row, ll_rowscount, ll_findrow, ll_newrow
integer li_default, li_order
decimal ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo
string ls_cal_description
mt_n_datastore lds_active

lds_active = create mt_n_datastore
lds_active.dataobject = 'd_sq_gr_cal_addbuncons_active'
lds_active.settransobject( sqlca)
ll_rowscount = lds_active.retrieve(istr_calc_addbuncons.al_vessel_nr )

dw_addbuncons.setredraw(false)

for ll_row = 1 to dw_addbuncons.rowcount()
	dw_addbuncons.setitem(ll_row, "cal_active", 0)
	dw_addbuncons.setitemstatus(ll_row, "cal_active", primary!, NotModified!)
next

for ll_row = 1 to ll_rowscount
	ls_cal_description = lds_active.getitemstring(ll_row, "cal_description")
	li_order = lds_active.getitemnumber(ll_row , "cal_order")
	
	ll_findrow = dw_addbuncons.find("cal_description = '" + ls_cal_description + "'", 1, dw_addbuncons.rowcount())
	if ll_findrow > 0 then
		ll_newrow = ll_findrow
	else
		if istr_calc_addbuncons.ai_locked = 1 then continue
		
		ll_newrow = dw_addbuncons.insertrow(0)
		dw_addbuncons.setitem(ll_newrow, "cal_description", ls_cal_description)
		dw_addbuncons.setitem(ll_newrow, "cal_carg_id", istr_calc_addbuncons.al_carg_id )
	end if
		
	dw_addbuncons.setitem(ll_newrow, "cal_order", li_order)
	dw_addbuncons.setitem(ll_newrow, "cal_active", 1 )
	dw_addbuncons.setitemstatus(ll_newrow, "cal_order", primary!, NotModified!)
	dw_addbuncons.setitemstatus(ll_newrow, "cal_active", primary!, NotModified!)
next

if istr_calc_addbuncons.ai_locked = 0 then
	wf_deleteinactive()
end if

dw_addbuncons.setredraw(true)

destroy lds_active
end subroutine

public subroutine wf_deleteinactive ();/********************************************************************
   wf_deleteinactive
   <DESC>Delete the inactive activity</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04/08/16		CR4216 		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
integer li_active
dec{3} ld_hsfo, ld_hsgo, ld_lsgo, ld_lsfo

ll_rowcount = dw_addbuncons.rowcount()

for ll_row = ll_rowcount to 1 step -1
	li_active = dw_addbuncons.getitemnumber(ll_row, "cal_active")
	ld_hsfo = dw_addbuncons.getitemnumber(ll_row, "hsfo_value")
	ld_hsgo = dw_addbuncons.getitemnumber(ll_row, "hsgo_value")
	ld_lsgo = dw_addbuncons.getitemnumber(ll_row, "lsgo_value")
	ld_lsfo = dw_addbuncons.getitemnumber(ll_row, "lsfo_value")
	
	if isnull(li_active) then li_active =0
	if isnull(ld_hsfo) then ld_hsfo = 0
	if isnull(ld_hsgo) then ld_hsgo = 0
	if isnull(ld_lsgo) then ld_lsgo = 0
	if isnull(ld_lsfo) then ld_lsfo = 0
	
	if li_active = 0 and ld_hsfo = 0 and ld_hsgo = 0 and ld_lsgo = 0 and ld_lsfo = 0 then 
		dw_addbuncons.deleterow(ll_row)
	end if
next

end subroutine

public subroutine wf_selecttext (long al_row, string as_colname);
/********************************************************************
   wf_selecttext
   <DESC>auto select text</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		as_colname
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04/08/16		CR4216		CCY018		First Version
   </HISTORY>
********************************************************************/

if istr_calc_addbuncons.ai_locked = 1 then return
if isnull(al_row) or al_row < 1 then return

if as_colname = "hsfo_value" or as_colname = "hsgo_value" or as_colname = "lsgo_value" or as_colname = "lsfo_value" then
	dw_addbuncons.selecttext(1, len(dw_addbuncons.gettext()) + 1)
end if
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05/08/16		CR4216            CCY018        First Version
		30/09/16		CR4515				XSZ004		  Bunker value should be empty when bunker value is null.
   </HISTORY>
********************************************************************/
end subroutine

on w_calc_addbuncons.create
int iCurrent
call super::create
this.cb_default=create cb_default
this.st_1=create st_1
this.dw_addbuncons=create dw_addbuncons
this.dw_default=create dw_default
this.cb_reset=create cb_reset
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_default
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_addbuncons
this.Control[iCurrent+4]=this.dw_default
this.Control[iCurrent+5]=this.cb_reset
this.Control[iCurrent+6]=this.ln_1
end on

on w_calc_addbuncons.destroy
call super::destroy
destroy(this.cb_default)
destroy(this.st_1)
destroy(this.dw_addbuncons)
destroy(this.dw_default)
destroy(this.cb_reset)
destroy(this.ln_1)
end on

event open;call super::open;
long ll_row, ll_rowscount
string ls_filter
n_service_manager lnv_serviceMgr
n_dw_style_service  lnv_style

istr_calc_addbuncons = message.powerobjectparm

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")

if istr_calc_addbuncons.ai_locked = 1 then
	dw_addbuncons.setrowfocusindicator(FocusRect!)
	dw_addbuncons.object.datawindow.readonly = "yes"
else
	lnv_style.of_dwlistformater(dw_addbuncons, false)
	cb_reset.enabled = true
end if

//lnv_style.of_dwlistformater(dw_default, false)
dw_default.setrowfocusindicator(FocusRect!)
dw_default.retrieve(istr_calc_addbuncons.al_vessel_nr)
dw_default.selectrow( 0, false)

istr_calc_addbuncons.adw_addbuncons.sharedata(dw_addbuncons)
ls_filter = "cal_carg_id = "+ string(istr_calc_addbuncons.al_carg_id) 
dw_addbuncons.setfilter(ls_filter)
dw_addbuncons.filter()
	
wf_refreshlist()

dw_addbuncons.sort( )
dw_addbuncons.selectrow(0, false)
wf_selecttext(dw_addbuncons.getrow(), dw_addbuncons.getcolumnname() )

end event

event closequery;call super::closequery;if wf_validate() = c#return.Success then
	return 0
else
	return 1
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_calc_addbuncons
end type

type cb_default from commandbutton within w_calc_addbuncons
integer x = 2281
integer y = 824
integer width = 96
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "▼"
end type

event clicked;
dw_default.visible = not dw_default.visible

if dw_default.visible then
	this.text = '▲'
	cb_reset.y = dw_default.y + dw_default.height + 16
else
	this.text = '▼'
	cb_reset.y = this.y + this.height + 16	
end if

parent.height = cb_reset.y + cb_reset.height + 32 + (parent.height - parent.workspaceheight( ) ) //titlebar height = parent.height - parent.workspaceheight

end event

type st_1 from statictext within w_calc_addbuncons
integer x = 37
integer y = 832
integer width = 430
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
string text = "Standard Estimates"
boolean focusrectangle = false
end type

type dw_addbuncons from u_datawindow_sqlca within w_calc_addbuncons
integer x = 37
integer y = 32
integer width = 2341
integer height = 776
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_gr_cal_addbuncons"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;
integer li_active

if row < 1 then return

setrow(row)
if istr_calc_addbuncons.ai_locked = 1 then 
	if row <> getselectedrow(0) then 
		event rowfocuschanged(row)
	end if
end if


end event

event rowfocuschanged;call super::rowfocuschanged;integer li_active
dwitemstatus ldwis_status

if isnull(currentrow) then currentrow = 0

if istr_calc_addbuncons.ai_locked = 1 and currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	
	return
end if

end event

event itemfocuschanged;call super::itemfocuschanged;
wf_selecttext(row, dwo.name)



end event

event ue_dwkeypress;call super::ue_dwkeypress;long ll_row
dec{3} ld_null
string ls_colname

if istr_calc_addbuncons.ai_locked = 1 then return

ll_row = this.getrow()
if ll_row <= 0 then return

setnull(ld_null)

if keyflags = 2 and (keydown(Key0!) or keydown(KeyNumpad0!)) then
	
	ls_colname =  this.getcolumnname()
		
	if ls_colname = "hsfo_value" or ls_colname = "hsgo_value" or ls_colname = "lsgo_value" or ls_colname = "lsfo_value" then
		this.setitem(ll_row, ls_colname, ld_null)
	end if	
end if

end event

type dw_default from u_datawindow_sqlca within w_calc_addbuncons
boolean visible = false
integer x = 37
integer y = 920
integer width = 2341
integer height = 708
boolean bringtotop = true
string dataobject = "d_sq_gr_cal_addbuncons_default"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

event clicked;call super::clicked;if row > 0 then
	setrow(row)
	if row <> getselectedrow(0) then 
		event rowfocuschanged(row)
	end if
end if
end event

type cb_reset from mt_u_commandbutton within w_calc_addbuncons
integer x = 2034
integer y = 920
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "&Set Default"
end type

event clicked;call super::clicked;
wf_inibunvalue()

end event

type ln_1 from line within w_calc_addbuncons
long linecolor = 134217728
integer linethickness = 8
integer beginx = 485
integer beginy = 868
integer endx = 2254
integer endy = 868
end type

