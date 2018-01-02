$PBExportHeader$w_timebar_noticebar.srw
$PBExportComments$Displays Timebar, Noticebar and voyages that have Claims but no cargo.
forward
global type w_timebar_noticebar from mt_w_sheet
end type
type cb_print from commandbutton within w_timebar_noticebar
end type
type cbx_balance from checkbox within w_timebar_noticebar
end type
type cb_saveas from commandbutton within w_timebar_noticebar
end type
type cb_retrieve from commandbutton within w_timebar_noticebar
end type
type dw_profitcenter from u_datagrid within w_timebar_noticebar
end type
type cbx_pc from checkbox within w_timebar_noticebar
end type
type gb_profitcenter from groupbox within w_timebar_noticebar
end type
type r_1 from rectangle within w_timebar_noticebar
end type
type rb_all from mt_u_radiobutton within w_timebar_noticebar
end type
type rb_cargo from mt_u_radiobutton within w_timebar_noticebar
end type
type rb_cargono from mt_u_radiobutton within w_timebar_noticebar
end type
type tab_1 from tab within w_timebar_noticebar
end type
type tabpage_1 from userobject within tab_1
end type
type dw_timebar from uo_datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_timebar dw_timebar
end type
type tabpage_2 from userobject within tab_1
end type
type dw_noticebar from uo_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_noticebar dw_noticebar
end type
type tabpage_3 from userobject within tab_1
end type
type dw_cargo_and_no_claim from uo_datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_cargo_and_no_claim dw_cargo_and_no_claim
end type
type tab_1 from tab within w_timebar_noticebar
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type gb_4 from groupbox within w_timebar_noticebar
end type
type gb_1 from groupbox within w_timebar_noticebar
end type
end forward

global type w_timebar_noticebar from mt_w_sheet
integer x = 672
integer y = 264
integer width = 4608
integer height = 2520
string title = "Timebar/Noticebar"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
string icon = "images\time_notice_bar.ico"
event ue_retrieve pbm_custom01
cb_print cb_print
cbx_balance cbx_balance
cb_saveas cb_saveas
cb_retrieve cb_retrieve
dw_profitcenter dw_profitcenter
cbx_pc cbx_pc
gb_profitcenter gb_profitcenter
r_1 r_1
rb_all rb_all
rb_cargo rb_cargo
rb_cargono rb_cargono
tab_1 tab_1
gb_4 gb_4
gb_1 gb_1
end type
global w_timebar_noticebar w_timebar_noticebar

type variables
constant integer ii_ALL = 0
constant integer ii_BALANCE = 1
constant integer ii_NOCLAIMS = 2
mt_u_datawindow idw_current,idw_timebar,idw_noticebar,idw_cargo_and_no_claim

end variables

forward prototypes
public subroutine documentation ()
public function integer wf_filter (integer ai_no)
public subroutine wf_gotoclaims (readonly datawindow adw_dw, long row, dwobject dwo)
private subroutine _set_permission ()
end prototypes

event ue_retrieve;string 	ls_filter,ls_temp_filter,ls_pclist,ls_nr[]
int	 	li_nr[]

dw_profitcenter.inv_filter_multirow.of_getfiltertoarray(li_nr)
if upperbound(li_nr) = 0 then
	Messagebox("Nothing Selected", "You must select at least one Profit Center!", Exclamation!)
	return
end if

idw_timebar.Reset()
idw_noticebar.Reset()
idw_cargo_and_no_claim.Reset()
setpointer(hourglass!)

idw_timebar.retrieve(li_nr)
idw_noticebar.retrieve(li_nr)
idw_cargo_and_no_claim.Retrieve(li_nr)
setpointer(arrow!)

wf_filter(ii_ALL)



end event

public subroutine documentation ();/********************************************************************
	w_time_bar_noticebar
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancesto
		01/09/14		CR3781		CCY018		The window title match with the text of a menu item
		20/10/16		CR4279		HHX010		Add function wf_filter and wf_gotoclaims 
	</HISTORY>
********************************************************************/
end subroutine

public function integer wf_filter (integer ai_no);/********************************************************************
   wf_filter
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		ai_no
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/10/16 CR4279            HHX010        First Version
   </HISTORY>
********************************************************************/
string ls_filter

if ai_no = ii_ALL or ai_no = ii_BALANCE then
	if cbx_balance.checked = true then
		ls_filter = " balance > 0 "
	else
		ls_filter = ""
	end if
	idw_timebar.setfilter(ls_filter)
	idw_timebar.filter()
	idw_noticebar.setfilter(ls_filter)
	idw_noticebar.filter()
end if

if ai_no = ii_ALL or ai_no = ii_NOCLAIMS then
	if rb_all.checked = true then
		ls_filter =''
	elseif rb_cargo.checked = true then
		ls_filter = "cargo = 'Yes'"
	else
		ls_filter = "cargo = 'No'"
	end if
	idw_cargo_and_no_claim.setfilter(ls_filter)
	idw_cargo_and_no_claim.filter()
end if

_set_permission()

return 1
end function

public subroutine wf_gotoclaims (readonly datawindow adw_dw, long row, dwobject dwo);/********************************************************************
   wf_gotoclaims
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		adw_dw,
		row,
		dwo
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/10/16 CR4279            HHX010        First Version
   </HISTORY>
********************************************************************/
string ls_voyage_nr
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr
u_jump_claims luo_jump_claims
u_jump_actions_trans luo_jump_actions_trans

if row = 0 then return 

li_vessel_nr 	= adw_dw.getitemnumber(row, "claims_vessel_nr")
ls_voyage_nr 	= adw_dw.getitemstring(row, "voyage_no")
ll_chart_nr	 	= adw_dw.getitemnumber(row, "claims_chart_nr")
ll_claim_nr	 	= adw_dw.getitemnumber(row, "claim_no")

luo_jump_claims = create u_jump_claims
luo_jump_actions_trans = create u_jump_actions_trans

choose case dwo.name
	case 'timebar_date', 'noticebar_date'
		luo_jump_actions_trans.of_open_actions_trans(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
	case 'claim_no','type'
		luo_jump_claims.of_open_claims(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
end choose

destroy luo_jump_claims
destroy luo_jump_actions_trans
end subroutine

private subroutine _set_permission ();cb_saveas.enabled = (idw_current.rowcount() > 0)
cb_print.enabled = (idw_current.rowcount() > 0)
end subroutine

event open;call super::open;n_service_manager 	ln_serviceMgr
n_dw_style_service   ln_style

idw_timebar = tab_1.tabpage_1.dw_timebar
idw_noticebar = tab_1.tabpage_2.dw_noticebar
idw_cargo_and_no_claim = tab_1.tabpage_3.dw_cargo_and_no_claim

ln_serviceMgr.of_loadservice( ln_style, "n_dw_style_service")
ln_style.of_dwlistformater(idw_timebar, false)
ln_style.of_dwlistformater(idw_noticebar, false)
ln_style.of_dwlistformater(idw_cargo_and_no_claim, false)

idw_cargo_and_no_claim.SetTransObject(SQLCA)
idw_timebar.SetTransObject(SQLCA)
idw_noticebar.SetTransObject(SQLCA)

idw_current = idw_timebar	 


end event

on w_timebar_noticebar.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cbx_balance=create cbx_balance
this.cb_saveas=create cb_saveas
this.cb_retrieve=create cb_retrieve
this.dw_profitcenter=create dw_profitcenter
this.cbx_pc=create cbx_pc
this.gb_profitcenter=create gb_profitcenter
this.r_1=create r_1
this.rb_all=create rb_all
this.rb_cargo=create rb_cargo
this.rb_cargono=create rb_cargono
this.tab_1=create tab_1
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cbx_balance
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.dw_profitcenter
this.Control[iCurrent+6]=this.cbx_pc
this.Control[iCurrent+7]=this.gb_profitcenter
this.Control[iCurrent+8]=this.r_1
this.Control[iCurrent+9]=this.rb_all
this.Control[iCurrent+10]=this.rb_cargo
this.Control[iCurrent+11]=this.rb_cargono
this.Control[iCurrent+12]=this.tab_1
this.Control[iCurrent+13]=this.gb_4
this.Control[iCurrent+14]=this.gb_1
end on

on w_timebar_noticebar.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cbx_balance)
destroy(this.cb_saveas)
destroy(this.cb_retrieve)
destroy(this.dw_profitcenter)
destroy(this.cbx_pc)
destroy(this.gb_profitcenter)
destroy(this.r_1)
destroy(this.rb_all)
destroy(this.rb_cargo)
destroy(this.rb_cargono)
destroy(this.tab_1)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
End if
m_tramosmain.mf_setcalclink(False)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_timebar_noticebar
end type

type cb_print from commandbutton within w_timebar_noticebar
integer x = 4215
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;n_dataprint lnv_dataprint

lnv_dataprint.of_print(idw_current)
end event

type cbx_balance from checkbox within w_timebar_noticebar
integer x = 965
integer y = 84
integer width = 1083
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Exclude claims where balance is lower than 0"
end type

event clicked;wf_filter(ii_BALANCE)
end event

type cb_saveas from commandbutton within w_timebar_noticebar
integer x = 3867
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;n_dataexport lnv_dataexport

lnv_dataexport.of_export(idw_current)


end event

type cb_retrieve from commandbutton within w_timebar_noticebar
integer x = 3520
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;parent.triggerevent("ue_retrieve")







end event

type dw_profitcenter from u_datagrid within w_timebar_noticebar
integer x = 73
integer y = 80
integer width = 786
integer height = 448
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve(uo_global.is_userid)

lstr_module.self_dw = dw_profitcenter
lstr_module.self_column_name = 'pc_nr'       // The column name is getitem column name.
lstr_module.report_column_name = 'pc_nr'

this.inv_filter_multirow.of_register( lstr_module )

setrowfocusindicator( FocusRect!)
end event

type cbx_pc from checkbox within w_timebar_noticebar
integer x = 530
integer y = 16
integer width = 329
integer height = 48
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;if this.checked then
	dw_profitcenter.selectrow(0, this.checked)
	this.text = "Deselect all"
else
	dw_profitcenter.selectrow(0, this.checked)
	this.text = "Select all"
end if

dw_profitcenter.inv_filter_multirow.of_dofilter( )

this.textcolor = rgb(255, 255, 255)
end event

type gb_profitcenter from groupbox within w_timebar_noticebar
integer x = 37
integer y = 16
integer width = 859
integer height = 544
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profit Center(s)"
end type

type r_1 from rectangle within w_timebar_noticebar
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4599
integer height = 592
end type

type rb_all from mt_u_radiobutton within w_timebar_noticebar
integer x = 2185
integer y = 80
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 22628899
string text = "All"
end type

event clicked;call super::clicked;wf_filter(ii_NOCLAIMS)
end event

type rb_cargo from mt_u_radiobutton within w_timebar_noticebar
integer x = 2185
integer y = 152
integer width = 402
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 22628899
string text = "With Cargo"
boolean checked = true
end type

event clicked;call super::clicked;wf_filter(ii_NOCLAIMS)
end event

type rb_cargono from mt_u_radiobutton within w_timebar_noticebar
integer x = 2185
integer y = 224
integer width = 407
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 22628899
string text = "Without Cargo"
end type

event clicked;call super::clicked;wf_filter(ii_NOCLAIMS)
end event

type tab_1 from tab within w_timebar_noticebar
event create ( )
event destroy ( )
integer x = 37
integer y = 612
integer width = 4526
integer height = 1696
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;choose  case newindex
	case 1
		idw_current = idw_timebar
	case 2
		idw_current = idw_noticebar
	case 3
		idw_current = idw_cargo_and_no_claim
end choose 

_set_permission()
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4489
integer height = 1580
long backcolor = 81324524
string text = "Timebar"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_timebar dw_timebar
end type

on tabpage_1.create
this.dw_timebar=create dw_timebar
this.Control[]={this.dw_timebar}
end on

on tabpage_1.destroy
destroy(this.dw_timebar)
end on

type dw_timebar from uo_datawindow within tabpage_1
integer x = 18
integer y = 20
integer width = 4448
integer height = 1544
integer taborder = 80
string title = ""
string dataobject = "dw_timebar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
boolean ib_auto = true
end type

event doubleclicked;call super::doubleclicked;
wf_gotoclaims(this, row, dwo)

end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4489
integer height = 1580
long backcolor = 81324524
string text = "Noticebar"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_noticebar dw_noticebar
end type

on tabpage_2.create
this.dw_noticebar=create dw_noticebar
this.Control[]={this.dw_noticebar}
end on

on tabpage_2.destroy
destroy(this.dw_noticebar)
end on

type dw_noticebar from uo_datawindow within tabpage_2
integer x = 18
integer y = 20
integer width = 4448
integer height = 1544
integer taborder = 90
string title = ""
string dataobject = "dw_noticebar"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
boolean ib_auto = true
end type

event doubleclicked;call super::doubleclicked;
wf_gotoclaims(this, row, dwo)
end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4489
integer height = 1580
long backcolor = 81324524
string text = "Allocated Voyages but No Claims"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_cargo_and_no_claim dw_cargo_and_no_claim
end type

on tabpage_3.create
this.dw_cargo_and_no_claim=create dw_cargo_and_no_claim
this.Control[]={this.dw_cargo_and_no_claim}
end on

on tabpage_3.destroy
destroy(this.dw_cargo_and_no_claim)
end on

type dw_cargo_and_no_claim from uo_datawindow within tabpage_3
integer x = 18
integer y = 20
integer width = 4448
integer height = 1544
integer taborder = 100
string title = ""
string dataobject = "dw_cargo_and_no_claim"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
boolean ib_auto = true
end type

type gb_4 from groupbox within w_timebar_noticebar
integer x = 2121
integer y = 16
integer width = 859
integer height = 312
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Allocated Voyages but No Claims"
end type

type gb_1 from groupbox within w_timebar_noticebar
integer x = 928
integer y = 16
integer width = 1161
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Timebar/Noticebar"
end type

