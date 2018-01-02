$PBExportHeader$w_revenue_by_chart_country.srw
$PBExportComments$This report shows Revenue split by Charterer and Charterer Country
forward
global type w_revenue_by_chart_country from window
end type
type cb_saveas from commandbutton within w_revenue_by_chart_country
end type
type st_5 from statictext within w_revenue_by_chart_country
end type
type st_3 from statictext within w_revenue_by_chart_country
end type
type st_2 from statictext within w_revenue_by_chart_country
end type
type cb_1 from commandbutton within w_revenue_by_chart_country
end type
type st_1 from statictext within w_revenue_by_chart_country
end type
type em_year from editmask within w_revenue_by_chart_country
end type
type cb_retrieve from commandbutton within w_revenue_by_chart_country
end type
type dw_report from datawindow within w_revenue_by_chart_country
end type
end forward

global type w_revenue_by_chart_country from window
boolean visible = false
integer width = 3456
integer height = 2644
boolean titlebar = true
string title = "Revenue Split by Charterer and Country"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
cb_saveas cb_saveas
st_5 st_5
st_3 st_3
st_2 st_2
cb_1 cb_1
st_1 st_1
em_year em_year
cb_retrieve cb_retrieve
dw_report dw_report
end type
global w_revenue_by_chart_country w_revenue_by_chart_country

type variables
transaction mytrans

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_revenue_by_chart_country: Report showing actual revenue by Charterer and 
	Charterer Home Country
   <OBJECT> This report was created based on Change Request # 2259

	Datawindow used = 'd_sp_tb_revenue_by_chart_country'
	which again is based on the stored procedure SP_REVENUE_BY_CHART_COUNTRY
	
	window is opened from the finance  menus
	
	Base columns (from stored procedure)
	
	{1}	Freight
	{2}	Demurrage
	{3}	Misc. Income
	{4}	TC Hire Revenue

 </OBJECT>
   <DESC>  </DESC>
   <USAGE>  </USAGE>
   <ALSO> </ALSO>
  Date   		Ref    				Author        		Comments
  19/01-11 	CR#2259      	RMO003     		First Version
  28/08/14	CR3781			CCY018			The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_revenue_by_chart_country.create
this.cb_saveas=create cb_saveas
this.st_5=create st_5
this.st_3=create st_3
this.st_2=create st_2
this.cb_1=create cb_1
this.st_1=create st_1
this.em_year=create em_year
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
this.Control[]={this.cb_saveas,&
this.st_5,&
this.st_3,&
this.st_2,&
this.cb_1,&
this.st_1,&
this.em_year,&
this.cb_retrieve,&
this.dw_report}
end on

on w_revenue_by_chart_country.destroy
destroy(this.cb_saveas)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cb_retrieve)
destroy(this.dw_report)
end on

event open;em_year.text = string(year(today()))


end event

event resize;dw_report.width = This.width - 100
dw_report.height = This.height - 600
end event

type cb_saveas from commandbutton within w_revenue_by_chart_country
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

type st_5 from statictext within w_revenue_by_chart_country
integer x = 137
integer y = 316
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

type st_3 from statictext within w_revenue_by_chart_country
integer x = 137
integer y = 236
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
string text = "Revenue (Freight, Demurrage, TC Hire and Misc. claims) split by Charterer~'s Name and Country"
boolean focusrectangle = false
end type

type st_2 from statictext within w_revenue_by_chart_country
integer x = 55
integer y = 180
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

type cb_1 from commandbutton within w_revenue_by_chart_country
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

type st_1 from statictext within w_revenue_by_chart_country
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

type em_year from editmask within w_revenue_by_chart_country
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

type cb_retrieve from commandbutton within w_revenue_by_chart_country
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
//connect using mytrans;

dw_report.setTrans(mytrans) 
dw_report.retrieve(integer(em_year.text) )

//disconnect using mytrans;
destroy mytrans;



end event

type dw_report from datawindow within w_revenue_by_chart_country
integer x = 32
integer y = 424
integer width = 3346
integer height = 2092
integer taborder = 50
string title = "none"
string dataobject = "d_sp_tb_revenue_by_chart_country"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

