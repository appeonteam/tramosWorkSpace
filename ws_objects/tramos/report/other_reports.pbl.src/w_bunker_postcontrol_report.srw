$PBExportHeader$w_bunker_postcontrol_report.srw
forward
global type w_bunker_postcontrol_report from window
end type
type cb_print from commandbutton within w_bunker_postcontrol_report
end type
type st_warning from statictext within w_bunker_postcontrol_report
end type
type st_6 from statictext within w_bunker_postcontrol_report
end type
type sle_year from singlelineedit within w_bunker_postcontrol_report
end type
type cb_retrieve from commandbutton within w_bunker_postcontrol_report
end type
type cb_saveas from commandbutton within w_bunker_postcontrol_report
end type
type cb_close from commandbutton within w_bunker_postcontrol_report
end type
type cb_modify from commandbutton within w_bunker_postcontrol_report
end type
type st_5 from statictext within w_bunker_postcontrol_report
end type
type st_4 from statictext within w_bunker_postcontrol_report
end type
type st_3 from statictext within w_bunker_postcontrol_report
end type
type st_2 from statictext within w_bunker_postcontrol_report
end type
type st_1 from statictext within w_bunker_postcontrol_report
end type
type dw_control from datawindow within w_bunker_postcontrol_report
end type
end forward

global type w_bunker_postcontrol_report from window
integer width = 3529
integer height = 2596
boolean titlebar = true
string title = "Posted Bunker Control Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_print cb_print
st_warning st_warning
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
global w_bunker_postcontrol_report w_bunker_postcontrol_report

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    Author        Comments
  01/01/96 	      	???     		First Version
  04/04/08   1193  JSU042       Can't use button <update voyage> on report "Bunker Postcontrol"
  28/08/14	CR3781	CCY018	The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_bunker_postcontrol_report.create
this.cb_print=create cb_print
this.st_warning=create st_warning
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
this.Control[]={this.cb_print,&
this.st_warning,&
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

on w_bunker_postcontrol_report.destroy
destroy(this.cb_print)
destroy(this.st_warning)
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

timer(0.5)
end event

event timer;st_warning.visible = not st_warning.visible
end event

type cb_print from commandbutton within w_bunker_postcontrol_report
integer x = 1312
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

type st_warning from statictext within w_bunker_postcontrol_report
integer x = 2034
integer y = 296
integer width = 1134
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Remember to check if voyage number has been modified before you make any changes!"
boolean focusrectangle = false
end type

type st_6 from statictext within w_bunker_postcontrol_report
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

type sle_year from singlelineedit within w_bunker_postcontrol_report
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

type cb_retrieve from commandbutton within w_bunker_postcontrol_report
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

event clicked;transaction	mytrans

if len(sle_year.text) <> 4 then
	MessageBox("Error", "The Voyage Year not entered in the right format")
	return
end if

setPointer(HourGlass!)

/* workaround PB bugfix */
mytrans = create transaction
mytrans.DBMS 		= SQLCA.DBMS
mytrans.Database 	= SQLCA.Database
mytrans.LogPAss 	= SQLCA.LogPass
mytrans.ServerName= SQLCA.ServerName
mytrans.LogId		= SQLCA.LogId
mytrans.AutoCommit= true
mytrans.DBParm		= SQLCA.DBParm
connect using mytrans;
dw_control.setTransObject(mytrans)
dw_control.reset()
dw_control.retrieve(mid(sle_year.text,3,2))
disconnect using mytrans;
destroy mytrans;

setPointer(Arrow!)
end event

type cb_saveas from commandbutton within w_bunker_postcontrol_report
integer x = 896
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

event clicked;dw_control.saveas()
end event

type cb_close from commandbutton within w_bunker_postcontrol_report
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

type cb_modify from commandbutton within w_bunker_postcontrol_report
integer x = 425
integer y = 2396
integer width = 398
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Modify Posting"
end type

event clicked;long		ll_row
decimal	ld_hfo, ld_do, ld_go, ld_lshfo
integer	li_vessel
String ls_vessel_ref_nr
string		ls_voyage

ll_row = dw_control.getSelectedRow(0)

if ll_row < 1 then return

ls_vessel_ref_nr = dw_control.getItemString(ll_row, "vessel")

  SELECT VESSELS.VESSEL_NR  
    INTO :li_vessel  
    FROM VESSELS  
   WHERE VESSELS.VESSEL_REF_NR = :ls_vessel_ref_nr   ;

ls_voyage	= dw_control.getItemString(ll_row, "voyage")

ld_hfo = dw_control.getItemDecimal(ll_row, "transhfo")
if isnull(ld_hfo) then ld_hfo = 0
ld_do = dw_control.getItemDecimal(ll_row, "transdo")
if isnull(ld_do) then ld_do = 0
ld_go = dw_control.getItemDecimal(ll_row, "transgo")
if isnull(ld_go) then ld_go = 0
ld_lshfo = dw_control.getItemDecimal(ll_row, "translshfo")
if isnull(ld_lshfo) then ld_lshfo = 0

UPDATE VOYAGES
	SET BUNKER_POSTED_HFO = :ld_hfo,
		BUNKER_POSTED_DO = :ld_do,
		BUNKER_POSTED_GO = :ld_go,
		BUNKER_POSTED_LSHFO = :ld_lshfo,
		VOYAGE_FINISHED = 0
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR = :ls_voyage;
if SQLCA.SQLCODE = 0 then
	commit;
	if isValid(w_port_of_call) then w_port_of_call.cb_refresh.postevent(Clicked!)
else
	rollback;
end if	
end event

type st_5 from statictext within w_bunker_postcontrol_report
integer x = 82
integer y = 376
integer width = 1367
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

type st_4 from statictext within w_bunker_postcontrol_report
integer x = 82
integer y = 308
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
string text = "2) Press the button <Modify Posting>"
boolean focusrectangle = false
end type

type st_3 from statictext within w_bunker_postcontrol_report
integer x = 82
integer y = 240
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

type st_2 from statictext within w_bunker_postcontrol_report
integer x = 9
integer y = 148
integer width = 2999
integer height = 72
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

type st_1 from statictext within w_bunker_postcontrol_report
integer x = 9
integer width = 3465
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This report is showing all voyages where transaction log postings are different from what is registred for voyage (what TRAMOS belive is posted)"
boolean focusrectangle = false
end type

type dw_control from datawindow within w_bunker_postcontrol_report
integer x = 5
integer y = 604
integer width = 3493
integer height = 1752
integer taborder = 30
string title = "none"
string dataobject = "d_sp_tb_bunker_postcontrol"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectRow(0, false)
if currentrow > 0 then
	this.selectRow(currentrow, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
	
end event

