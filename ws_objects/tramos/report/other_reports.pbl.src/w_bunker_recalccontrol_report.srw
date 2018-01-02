$PBExportHeader$w_bunker_recalccontrol_report.srw
forward
global type w_bunker_recalccontrol_report from window
end type
type hpb_1 from hprogressbar within w_bunker_recalccontrol_report
end type
type cb_print from commandbutton within w_bunker_recalccontrol_report
end type
type st_6 from statictext within w_bunker_recalccontrol_report
end type
type sle_year from singlelineedit within w_bunker_recalccontrol_report
end type
type cb_retrieve from commandbutton within w_bunker_recalccontrol_report
end type
type cb_saveas from commandbutton within w_bunker_recalccontrol_report
end type
type cb_close from commandbutton within w_bunker_recalccontrol_report
end type
type cb_modify from commandbutton within w_bunker_recalccontrol_report
end type
type st_5 from statictext within w_bunker_recalccontrol_report
end type
type st_4 from statictext within w_bunker_recalccontrol_report
end type
type st_3 from statictext within w_bunker_recalccontrol_report
end type
type st_2 from statictext within w_bunker_recalccontrol_report
end type
type st_1 from statictext within w_bunker_recalccontrol_report
end type
type dw_control from datawindow within w_bunker_recalccontrol_report
end type
end forward

global type w_bunker_recalccontrol_report from window
integer width = 3529
integer height = 2592
boolean titlebar = true
string title = "Recalc Bunker Control Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
hpb_1 hpb_1
cb_print cb_print
st_6 st_6
sle_year sle_year
cb_retrieve cb_retrieve
cb_saveas cb_saveas
cb_close cb_close
cb_modify cb_modify
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_control dw_control
end type
global w_bunker_recalccontrol_report w_bunker_recalccontrol_report

forward prototypes
private function integer wf_recalc ()
public subroutine documentation ()
end prototypes

private function integer wf_recalc ();long													ll_rows, ll_row
n_voyage_bunker_consumption 					lnv_bunker
n_voyage_offservice_bunker_consumption 	lnv_offservice
integer												li_vessel
string												ls_voyage
decimal{2}											ld_price, ld_offprice
decimal{4}											ld_ton, ld_offton

ll_rows = dw_control.rowcount()
if ll_rows < 1 then return -1

lnv_bunker = create n_voyage_bunker_consumption 	
lnv_offservice = create n_voyage_offservice_bunker_consumption 	
hpb_1.maxposition = ll_rows
dw_control.setredraw(false)
for ll_row = 1 to ll_rows
	li_vessel = dw_control.getItemNumber(ll_row, "vessel_nr")
	ls_voyage = dw_control.getItemString(ll_row, "voyage_nr")
	lnv_bunker.of_calculate( "HFO", li_vessel, ls_voyage, ld_price, ld_ton )
	if ld_price <> 0 then 
		lnv_offservice.of_calculate( "HFO", li_vessel, ls_voyage, ld_offprice, ld_offton )
	else
		ld_offprice = 0
	end if
	dw_control.setItem(ll_row, "recalc_hfo", ld_price - ld_offprice )
	lnv_bunker.of_calculate( "DO", li_vessel, ls_voyage, ld_price, ld_ton )
	if ld_price <> 0 then 
		lnv_offservice.of_calculate( "DO", li_vessel, ls_voyage, ld_offprice, ld_offton )
	else
		ld_offprice = 0
	end if
	dw_control.setItem(ll_row, "recalc_do", ld_price - ld_offprice )
	lnv_bunker.of_calculate( "GO", li_vessel, ls_voyage, ld_price, ld_ton )
	if ld_price <> 0 then 
		lnv_offservice.of_calculate( "GO", li_vessel, ls_voyage, ld_offprice, ld_offton )
	else
		ld_offprice = 0
	end if
	dw_control.setItem(ll_row, "recalc_go", ld_price - ld_offprice )
	lnv_bunker.of_calculate( "LSHFO", li_vessel, ls_voyage, ld_price, ld_ton )
	if ld_price <> 0 then 
		lnv_offservice.of_calculate( "LSHFO", li_vessel, ls_voyage, ld_offprice, ld_offton )
	else
		ld_offprice = 0
	end if
	dw_control.setItem(ll_row, "recalc_lshfo", ld_price - ld_offprice )
	
	hpb_1.position = ll_row
	dw_control.scrolltorow( ll_row )
next	
dw_control.setredraw(true)
dw_control.setfilter("bunker_posted_hfo<>recalc_hfo or bunker_posted_do<>recalc_do or bunker_posted_go<>recalc_go or bunker_posted_lshfo<>recalc_lshfo")
dw_control.filter()
destroy lnv_bunker
destroy lnv_offservice

return 1
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
		23/07/15		CR3226		XSZ004		Change label for Bunkers type.	
	</HISTORY>
********************************************************************/
end subroutine

on w_bunker_recalccontrol_report.create
this.hpb_1=create hpb_1
this.cb_print=create cb_print
this.st_6=create st_6
this.sle_year=create sle_year
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.cb_close=create cb_close
this.cb_modify=create cb_modify
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_control=create dw_control
this.Control[]={this.hpb_1,&
this.cb_print,&
this.st_6,&
this.sle_year,&
this.cb_retrieve,&
this.cb_saveas,&
this.cb_close,&
this.cb_modify,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.dw_control}
end on

on w_bunker_recalccontrol_report.destroy
destroy(this.hpb_1)
destroy(this.cb_print)
destroy(this.st_6)
destroy(this.sle_year)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.cb_close)
destroy(this.cb_modify)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_control)
end on

event open;sle_year.text = string(year(today()))

dw_control.setTransObject(sqlca)

end event

type hpb_1 from hprogressbar within w_bunker_recalccontrol_report
integer x = 14
integer y = 408
integer width = 3493
integer height = 68
unsignedinteger maxposition = 100
boolean smoothscroll = true
end type

type cb_print from commandbutton within w_bunker_recalccontrol_report
integer x = 1385
integer y = 2396
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_control.print()
end event

type st_6 from statictext within w_bunker_recalccontrol_report
integer x = 14
integer y = 504
integer width = 366
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Year:"
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_bunker_recalccontrol_report
integer x = 430
integer y = 492
integer width = 178
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16776960
string text = "2007"
borderstyle borderstyle = stylelowered!
end type

type cb_retrieve from commandbutton within w_bunker_recalccontrol_report
integer x = 9
integer y = 2396
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;if len(sle_year.text) <> 4 then
	MessageBox("Error", "The Voyage Year not entered in the right format")
	return
end if

setPointer(HourGlass!)
dw_control.reset()
dw_control.post retrieve(mid(sle_year.text,3,2))
setPointer(Arrow!)
post wf_recalc( )
end event

type cb_saveas from commandbutton within w_bunker_recalccontrol_report
integer x = 969
integer y = 2396
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;string ls_bunkerhfo_dbname, ls_bunkerdo_dbname, ls_bunkergo_dbname, ls_bunkerlshfo_dbname
string ls_recalchfo_dbname, ls_recalcdo_dbname, ls_recalcgo_dbname, ls_recalclshfo_dbname

ls_bunkerhfo_dbname   = dw_control.describe("bunker_posted_hfo.dbname")
ls_bunkerdo_dbname    = dw_control.describe("bunker_posted_do.dbname")
ls_bunkergo_dbname    = dw_control.describe("bunker_posted_go.dbname")
ls_bunkerlshfo_dbname = dw_control.describe("bunker_posted_lshfo.dbname")
ls_recalchfo_dbname   = dw_control.describe("recalc_hfo.dbname")
ls_recalcdo_dbname    = dw_control.describe("recalc_do.dbname")
ls_recalcgo_dbname    = dw_control.describe("recalc_go.dbname")
ls_recalclshfo_dbname = dw_control.describe("recalc_lshfo.dbname")

dw_control.modify("bunker_posted_hfo.dbname = 'BUNKER_POSTED_HSFO'")
dw_control.modify("bunker_posted_do.dbname = 'BUNKER_POSTED_LSGO'")
dw_control.modify("bunker_posted_go.dbname = 'BUNKER_POSTED_HSGO'")
dw_control.modify("bunker_posted_lshfo.dbname = 'BUNKER_POSTED_LSFO'")
dw_control.modify("recalc_hfo.dbname = 'RECALC_HSFO'")
dw_control.modify("recalc_do.dbname = 'RECALC_LSGO'")
dw_control.modify("recalc_go.dbname = 'RECALC_HSGO'")
dw_control.modify("recalc_lshfo.dbname = 'RECALC_LSFO'")

dw_control.saveas()

dw_control.modify("bunker_posted_hfo.dbname = '" + ls_bunkerhfo_dbname + "'")
dw_control.modify("bunker_posted_do.dbname = '" + ls_bunkerdo_dbname + "'")
dw_control.modify("bunker_posted_go.dbname = '" + ls_bunkergo_dbname + "'")
dw_control.modify("bunker_posted_lshfo.dbname = '" + ls_bunkerlshfo_dbname + "'")
dw_control.modify("recalc_hfo.dbname = '" + ls_recalchfo_dbname + "'")
dw_control.modify("recalc_do.dbname = '" + ls_recalcdo_dbname + "'")
dw_control.modify("recalc_go.dbname = '" + ls_recalcgo_dbname + "'")
dw_control.modify("recalc_lshfo.dbname = '" + ls_recalclshfo_dbname + "'")
end event

type cb_close from commandbutton within w_bunker_recalccontrol_report
integer x = 3145
integer y = 2396
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_modify from commandbutton within w_bunker_recalccontrol_report
integer x = 425
integer y = 2396
integer width = 471
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Un-Finish Voyage"
end type

event clicked;long		ll_row
decimal	ld_hfo, ld_do, ld_go, ld_lshfo
integer	li_vessel
string		ls_voyage

ll_row = dw_control.getSelectedRow(0)

if ll_row < 1 then return

li_vessel	= dw_control.getItemNumber(ll_row, "vessel_nr")
ls_voyage	= dw_control.getItemString(ll_row, "voyage_nr")

UPDATE VOYAGES
	SET VOYAGE_FINISHED = 0
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR = :ls_voyage;
if SQLCA.SQLCODE = 0 then
	commit;
	if isValid(w_port_of_call) then w_port_of_call.cb_refresh.postevent(Clicked!)
else
	rollback;
end if	
end event

type st_5 from statictext within w_bunker_recalccontrol_report
integer x = 82
integer y = 332
integer width = 1184
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "3) Go to Port of Call and Re-finish the voyage"
boolean focusrectangle = false
end type

type st_4 from statictext within w_bunker_recalccontrol_report
integer x = 82
integer y = 264
integer width = 1120
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2) Press the button <Un-Finish Voyage>"
boolean focusrectangle = false
end type

type st_3 from statictext within w_bunker_recalccontrol_report
integer x = 82
integer y = 196
integer width = 1120
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "1) Select a voyage in the report below"
boolean focusrectangle = false
end type

type st_2 from statictext within w_bunker_recalccontrol_report
integer x = 9
integer y = 136
integer width = 2999
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "In order to fix this difference, and have TRAMOS to post the difference to CODA, do the following:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_bunker_recalccontrol_report
integer x = 14
integer width = 3447
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This report is showing all voyages where re-calculated cinker consumption is different from what is registred for voyage (what TRAMOS belive is posted)"
boolean focusrectangle = false
end type

type dw_control from datawindow within w_bunker_recalccontrol_report
integer x = 5
integer y = 604
integer width = 3493
integer height = 1752
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_bunker_recalccontrol"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;this.selectRow(0, false)
if row > 0 then
	this.selectRow(row, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
	
end event

