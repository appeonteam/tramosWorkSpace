$PBExportHeader$w_report_by_date_fromto.srw
forward
global type w_report_by_date_fromto from mt_w_sheet
end type
type uo_pcgroup from u_pcgroup within w_report_by_date_fromto
end type
type cb_print from mt_u_commandbutton within w_report_by_date_fromto
end type
type st_to from mt_u_statictext within w_report_by_date_fromto
end type
type st_from from mt_u_statictext within w_report_by_date_fromto
end type
type dp_to from mt_u_datepicker within w_report_by_date_fromto
end type
type dp_from from mt_u_datepicker within w_report_by_date_fromto
end type
type cb_retreive from mt_u_commandbutton within w_report_by_date_fromto
end type
type dw_report from mt_u_datawindow within w_report_by_date_fromto
end type
type cb_saveas from mt_u_commandbutton within w_report_by_date_fromto
end type
end forward

global type w_report_by_date_fromto from mt_w_sheet
integer width = 3136
integer height = 1040
boolean center = false
event type integer ue_pcgroupchanged ( integer ai_pcgroupid )
uo_pcgroup uo_pcgroup
cb_print cb_print
st_to st_to
st_from st_from
dp_to dp_to
dp_from dp_from
cb_retreive cb_retreive
dw_report dw_report
cb_saveas cb_saveas
end type
global w_report_by_date_fromto w_report_by_date_fromto

type variables
integer ii_pcgroup
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_initwindow (integer ai_height, integer ai_width, string as_dw, string as_title, boolean ab_saveas, boolean ab_pcgroup)
end prototypes

event type integer ue_pcgroupchanged(integer ai_pcgroupid);ii_pcgroup=ai_pcgroupid
return 0
end event

public subroutine documentation ();/*

w_report_by_date_fromto

Found that there seems to be/could be a lot of reports requiring the date range criteria.


Features include:

	* Standard report window containing dates from/to.

	* Optional usage of profit center group.

Designed and used in:
	Failed fixture reasons report in the fixture list.
	
Used elsewhere in:
	n/a


Sample usage:
	
	w_report_by_date_fromto w_example
	OpenSheet(w_mywin, w_tramos_main, 7, Original!)
	w_example.wf_initwindow( 2200, 3800, "d_sq_tb_rpt_reason_failed", "Reason Failed Report", true, true )

	parameters:
		1. height of new window 
		2. width of new window
		3. datastore
		4. Window title
		5. Include save as button? 
		6. Include profit center group?
		
*/
end subroutine

public function integer wf_initwindow (integer ai_height, integer ai_width, string as_dw, string as_title, boolean ab_saveas, boolean ab_pcgroup);/********************************************************************
   wf_initwindow( /*integer ai_height*/, /*integer ai_width*/, /*string as_dw*/, /*string as_title*/, /*boolean ab_saveas*/, /*boolean ab_pcgroup */)
	
   <DESC>   General reporting window with date range</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ai_height: height of this window
            ai_width: width
				as_dw: name of the datawindow
            as_title: window title
				ab_saveas: do we use the saveas button?
            ab_pcgroup: do we use the fixturelist dependent pcgroup uo?
				</ARGS>
   <USAGE>  See documentation() function</USAGE>
********************************************************************/
This.Title = as_title
dw_report.DataObject = as_dw
dw_report.SetTransObject(SQLCA)
This.width = ai_width
This.height = ai_height
cb_saveas.visible = ab_saveas
uo_pcgroup.visible = ab_pcgroup


this.move(0,0)
return 1
end function

on w_report_by_date_fromto.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_print=create cb_print
this.st_to=create st_to
this.st_from=create st_from
this.dp_to=create dp_to
this.dp_from=create dp_from
this.cb_retreive=create cb_retreive
this.dw_report=create dw_report
this.cb_saveas=create cb_saveas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.st_to
this.Control[iCurrent+4]=this.st_from
this.Control[iCurrent+5]=this.dp_to
this.Control[iCurrent+6]=this.dp_from
this.Control[iCurrent+7]=this.cb_retreive
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.cb_saveas
end on

on w_report_by_date_fromto.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_print)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.cb_retreive)
destroy(this.dw_report)
destroy(this.cb_saveas)
end on

event resize;call super::resize;dw_report.width = This.width - 100
dw_report.height = This.height - 500

cb_retreive.y = This.height - 250
cb_saveas.y = This.height - 250
cb_print.y = This.height - 250
//this.center=true

end event

event open;call super::open;ii_pcgroup = uo_pcgroup.uf_getpcgroup( )
end event

type uo_pcgroup from u_pcgroup within w_report_by_date_fromto
integer x = 18
integer y = 32
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_print from mt_u_commandbutton within w_report_by_date_fromto
integer x = 750
integer y = 816
integer taborder = 30
string text = "&Print"
end type

event clicked;call super::clicked;integer li_resp


li_resp=messagebox("Printing","Are you sure you want to print document?", Question!, OKCancel!, 2) 
if li_resp = 1 then dw_report.print()



end event

type st_to from mt_u_statictext within w_report_by_date_fromto
integer x = 896
integer y = 144
integer width = 274
string text = "To"
end type

type st_from from mt_u_statictext within w_report_by_date_fromto
integer x = 896
integer y = 32
integer width = 274
string text = "From"
end type

type dp_to from mt_u_datepicker within w_report_by_date_fromto
integer x = 1189
integer y = 128
integer width = 402
integer height = 96
integer taborder = 10
datetime value = DateTime(Date("2010-03-08"), Time("15:17:14.000000"))
integer calendarfontweight = 400
end type

type dp_from from mt_u_datepicker within w_report_by_date_fromto
integer x = 1189
integer y = 16
integer width = 402
integer height = 96
integer taborder = 10
datetime value = DateTime(Date("2010-03-08"), Time("15:17:14.000000"))
integer calendarfontweight = 400
end type

type cb_retreive from mt_u_commandbutton within w_report_by_date_fromto
integer x = 18
integer y = 816
integer taborder = 20
string text = "Retreive"
end type

event clicked;call super::clicked;date ld_start_date, ld_end_date

// validate user criteria for dates
ld_start_date = date(dp_from.value)
ld_end_date = date(dp_to.value) 

if (ld_end_date < ld_start_date) then
	messagebox ("Date Error", "Your end date comes before your start date. Please enter a new end date", Information!, Ok!)
	return
end if

if uo_pcgroup.visible=true then
	dw_report.retrieve(datetime(ld_start_date), datetime(ld_end_date),ii_pcgroup)
else
	dw_report.retrieve(datetime(ld_start_date), datetime(ld_end_date))
end if
end event

type dw_report from mt_u_datawindow within w_report_by_date_fromto
integer x = 18
integer y = 256
integer width = 1573
integer height = 544
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_saveas from mt_u_commandbutton within w_report_by_date_fromto
integer x = 384
integer y = 816
integer taborder = 10
string text = "&Save As..."
end type

event clicked;call super::clicked;dw_report.SaveAs("",XML!,true)



end event

