$PBExportHeader$w_print_time_registration.srw
forward
global type w_print_time_registration from mt_w_sheet
end type
type dw_time_used_period from mt_u_datawindow within w_print_time_registration
end type
type cb_print from mt_u_commandbutton within w_print_time_registration
end type
type cb_refresh from mt_u_commandbutton within w_print_time_registration
end type
type st_6 from mt_u_statictext within w_print_time_registration
end type
type st_3 from mt_u_statictext within w_print_time_registration
end type
type st_5 from mt_u_statictext within w_print_time_registration
end type
type dw_consultant from u_datagrid within w_print_time_registration
end type
type dw_date_end from u_datagrid within w_print_time_registration
end type
type dw_date_start from u_datagrid within w_print_time_registration
end type
type st_4 from u_topbar_background within w_print_time_registration
end type
end forward

global type w_print_time_registration from mt_w_sheet
integer width = 2606
integer height = 2568
string title = "Time Used"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
dw_time_used_period dw_time_used_period
cb_print cb_print
cb_refresh cb_refresh
st_6 st_6
st_3 st_3
st_5 st_5
dw_consultant dw_consultant
dw_date_end dw_date_end
dw_date_start dw_date_start
st_4 st_4
end type
global w_print_time_registration w_print_time_registration

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_print_time_registration
   <OBJECT>		Print Time Registration Period	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
   	12/07/2013 CR3254       LHG008        Give valid name to some objects
	01/09/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;long ll_newrow

ll_newrow = dw_date_start.insertrow(0)
dw_date_start.setitem(ll_newrow, "date_value", date("01-" + string(month(today())) + "-" + string(year(today()))))

ll_newrow = dw_date_end.insertrow(0)
dw_date_end.SetItem(ll_newrow, "date_value", today())

dw_time_used_period.settransobject(sqlca)

dw_consultant.settransobject(sqlca)
dw_consultant.insertrow(0)
end event

on w_print_time_registration.create
int iCurrent
call super::create
this.dw_time_used_period=create dw_time_used_period
this.cb_print=create cb_print
this.cb_refresh=create cb_refresh
this.st_6=create st_6
this.st_3=create st_3
this.st_5=create st_5
this.dw_consultant=create dw_consultant
this.dw_date_end=create dw_date_end
this.dw_date_start=create dw_date_start
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_time_used_period
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.dw_consultant
this.Control[iCurrent+8]=this.dw_date_end
this.Control[iCurrent+9]=this.dw_date_start
this.Control[iCurrent+10]=this.st_4
end on

on w_print_time_registration.destroy
call super::destroy
destroy(this.dw_time_used_period)
destroy(this.cb_print)
destroy(this.cb_refresh)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.dw_consultant)
destroy(this.dw_date_end)
destroy(this.dw_date_start)
destroy(this.st_4)
end on

event activate;call super::activate;if w_tramos_main.MenuName <> "m_creqmain" then
	w_tramos_main.ChangeMenu(m_creqmain)
	m_creqmain.mf_controlreport()
end if

end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_print_time_registration
end type

type dw_time_used_period from mt_u_datawindow within w_print_time_registration
integer x = 32
integer y = 240
integer width = 2523
integer height = 2216
integer taborder = 60
string dataobject = "d_print_time_used_period"
boolean vscrollbar = true
boolean border = false
end type

type cb_print from mt_u_commandbutton within w_print_time_registration
integer x = 2213
integer y = 32
integer taborder = 50
string text = "&Print"
end type

event clicked;call super::clicked;dw_time_used_period.print()
end event

type cb_refresh from mt_u_commandbutton within w_print_time_registration
integer x = 1865
integer y = 32
integer taborder = 40
string text = "&Refresh"
boolean default = true
end type

event clicked;call super::clicked;dw_date_start.accepttext()
dw_date_end.accepttext()
dw_consultant.accepttext( )

dw_time_used_period.retrieve(datetime(dw_date_start.GetItemDate(1,"date_value")), datetime(relativedate(dw_date_end.GetItemDate(1, "date_value"), 1)), dw_consultant.getItemNumber(1, "consultant_id"))

end event

type st_6 from mt_u_statictext within w_print_time_registration
integer x = 640
integer y = 120
integer width = 110
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "End"
alignment alignment = right!
end type

type st_3 from mt_u_statictext within w_print_time_registration
integer x = 37
integer y = 120
integer width = 238
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Start"
alignment alignment = right!
end type

type st_5 from mt_u_statictext within w_print_time_registration
integer x = 37
integer y = 40
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Consultant"
end type

type dw_consultant from u_datagrid within w_print_time_registration
integer x = 293
integer y = 32
integer width = 805
integer height = 64
integer taborder = 10
string dataobject = "d_select_consultant"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked( )
end event

type dw_date_end from u_datagrid within w_print_time_registration
integer x = 768
integer y = 112
integer width = 329
integer height = 64
integer taborder = 30
string dataobject = "d_input_date"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked( )
end event

event losefocus;call super::losefocus;this.accepttext( )
end event

type dw_date_start from u_datagrid within w_print_time_registration
integer x = 293
integer y = 112
integer width = 329
integer height = 64
integer taborder = 20
string dataobject = "d_input_date"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked( )
end event

event losefocus;call super::losefocus;this.accepttext( )
end event

type st_4 from u_topbar_background within w_print_time_registration
integer width = 2642
end type

