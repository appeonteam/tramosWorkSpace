$PBExportHeader$w_revenue_expenses.srw
$PBExportComments$Multi purpose Revenue report.  Pass the dataobject when opening the window.  1 Parameter for year~r~n~r~n1. Revenue split by Charterer Country and Expenses split by Agent Country~r~n2. Revenue split by Profit Center and then Office
forward
global type w_revenue_expenses from mt_w_sheet
end type
type cb_saveas from commandbutton within w_revenue_expenses
end type
type st_5 from statictext within w_revenue_expenses
end type
type st_4 from statictext within w_revenue_expenses
end type
type st_3 from statictext within w_revenue_expenses
end type
type st_2 from statictext within w_revenue_expenses
end type
type cb_1 from commandbutton within w_revenue_expenses
end type
type st_1 from statictext within w_revenue_expenses
end type
type em_year from editmask within w_revenue_expenses
end type
type cbx_filterzero from checkbox within w_revenue_expenses
end type
type cb_retrieve from commandbutton within w_revenue_expenses
end type
type dw_report from datawindow within w_revenue_expenses
end type
end forward

global type w_revenue_expenses from mt_w_sheet
boolean visible = false
integer width = 3456
integer height = 2644
string title = "Revenue Expenses"
cb_saveas cb_saveas
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
cb_1 cb_1
st_1 st_1
em_year em_year
cbx_filterzero cbx_filterzero
cb_retrieve cb_retrieve
dw_report dw_report
end type
global w_revenue_expenses w_revenue_expenses

type variables
transaction mytrans

end variables

forward prototypes
public subroutine documentation ()
public function integer wf_loaddatawindow (string as_dataobjname)
end prototypes

public subroutine documentation ();/*  This report was created based on Change Request # 1874

Datawindow used = 'd_sp_tb_revenue_expenses_by_country'
which again is based on the stored procedure SP_REVENUE_BY_COUNTRY

window is opened from the finance  menu
*/

/*
Change Request #1981

Using this same window, dependent on what is passed when it is opened,
can now report on revenue/expenses based on profit center and office.

Uses stored procedure SP_REVEXP_BY_OFFICEPC


Report Revenue Expenses by Office and Profit Center
=======================================================	

Base columns (from stored procedure)

{1}Freight
{2}Misc. freight
{3}Demurrage
{4}Misc. Income
{5}TC Hire Revenue
{6}Disbursement Expenses
{7}Bunker Expenses
{8}Commission Expenses
{9}TC Disbursements (not transferred to contract)
{10}TC Receivables
{11}TC Commissions


Report column definition:

Profit Center
Office
Freight = {1}Freight + {2}Misc. freight
Demurrage = {3}Demurrage
Misc = {4}Misc. Income
Tchire = {5}TC Hire revenue
Expenses = {6}Disbursement Expenses + {7}Bunker Expenses + {8}Commission Expenses + {9}TC Disbursements + {11}TC Commissions + ({5}TC Hire Revenue - {10}TC Receivables)
*/
/********************************************************************
   documentation
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/08/14		CR3708           CCY018       corrected ancestor and modified event ue_getwidowname
	28/08/14		CR3781			CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_loaddatawindow (string as_dataobjname);dw_report.dataobject = as_dataobjname
choose case dw_report.dataobject
	case "d_sp_tb_revenue_expenses_by_country"
		// also the default
		this.title = "Revenue/Expenses Split by Country"
	case else
		
		this.title = "Revenue/Expenses by Office and Profit Center"		
		this.st_3.text="Revenue (Freight, Demurrage, TC Hire and Misc. claims) split by Vessels Profit Center and Contract's Office"
		this.st_4.text="Expenses for standard voyages and TC-Out (Port Expenses + Bunker + Contract + Commission + OffSerive)"
end choose
return 1
end function

on w_revenue_expenses.create
int iCurrent
call super::create
this.cb_saveas=create cb_saveas
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.cb_1=create cb_1
this.st_1=create st_1
this.em_year=create em_year
this.cbx_filterzero=create cbx_filterzero
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saveas
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_year
this.Control[iCurrent+9]=this.cbx_filterzero
this.Control[iCurrent+10]=this.cb_retrieve
this.Control[iCurrent+11]=this.dw_report
end on

on w_revenue_expenses.destroy
call super::destroy
destroy(this.cb_saveas)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cbx_filterzero)
destroy(this.cb_retrieve)
destroy(this.dw_report)
end on

event open;call super::open;
/********************************************************************
   open() 
   <DESC>this expects the name of the datawindow to be passed in as a
	parameter</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  pass a string var as reference to the name of the dataobject we
	want to use.  if nothing is passed the report by office and pc is run.</USAGE>



********************************************************************/

if not isnull(message.stringparm) then 
	wf_loaddatawindow(message.stringparm)
end if	
em_year.text = string(year(today()))


end event

event resize;dw_report.width = This.width - 100
dw_report.height = This.height - 600
end event

event ue_getwindowname;call super::ue_getwindowname;if dw_report.dataobject = "d_sp_tb_revenue_expenses_by_country" then
	as_windowname = this.classname( ) + "_country"
elseif dw_report.dataobject = "d_sp_tb_revenue_expenses_by_office_and_pc" then
	as_windowname = this.classname( ) + "_officepc"
else
	as_windowname = this.classname( ) 
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_revenue_expenses
end type

type cb_saveas from commandbutton within w_revenue_expenses
integer x = 1531
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save As"
end type

event clicked;dw_report.saveas("", &
   XML!, true)
end event

type st_5 from statictext within w_revenue_expenses
integer x = 137
integer y = 336
integer width = 2459
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(includes all voyages related to report year yyxx and TC Payments year to date)"
boolean focusrectangle = false
end type

type st_4 from statictext within w_revenue_expenses
integer x = 137
integer y = 276
integer width = 2459
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Disbursement Expenses split by Agent~'s Country"
boolean focusrectangle = false
end type

type st_3 from statictext within w_revenue_expenses
integer x = 137
integer y = 220
integer width = 2459
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revenue (Freight, Demurrage, TC Hire and Misc. claims) split by Charterer~'s Country"
boolean focusrectangle = false
end type

type st_2 from statictext within w_revenue_expenses
integer x = 55
integer y = 164
integer width = 2459
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Below Report is showing:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_revenue_expenses
integer x = 1125
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_report.print()
end event

type st_1 from statictext within w_revenue_expenses
integer x = 55
integer y = 52
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Year:"
boolean focusrectangle = false
end type

type em_year from editmask within w_revenue_expenses
integer x = 389
integer y = 40
integer width = 256
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "YYYY"
boolean spin = true
double increment = 1
end type

type cbx_filterzero from checkbox within w_revenue_expenses
integer x = 1975
integer y = 44
integer width = 1010
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter out Records with no figures (zero)"
end type

event clicked;string 	ls_filter

if this.checked then
	ls_filter = "freight <> 0 or demurrage <> 0 or misc <> 0 or tchire <> 0"
else
	ls_filter = ""
end if

dw_report.setFilter(ls_filter)
dw_report.filter()
end event

type cb_retrieve from commandbutton within w_revenue_expenses
integer x = 713
integer y = 32
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve..."
boolean default = true
end type

event clicked;/* workaround PB bugfix */
mytrans = create transaction
mytrans.DBMS 			= SQLCA.DBMS
mytrans.Database 	= SQLCA.Database
mytrans.LogPAss 		= SQLCA.LogPass
mytrans.ServerName	= SQLCA.ServerName
mytrans.LogId			= SQLCA.LogId
mytrans.AutoCommit	= true
mytrans.DBParm		= SQLCA.DBParm
connect using mytrans;

dw_report.setTransObject(mytrans)
dw_report.retrieve(integer(em_year.text) )

disconnect using mytrans;
destroy mytrans;



end event

type dw_report from datawindow within w_revenue_expenses
integer x = 32
integer y = 424
integer width = 3346
integer height = 2092
integer taborder = 50
string title = "none"
string dataobject = "d_sp_tb_revenue_expenses_by_country"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

