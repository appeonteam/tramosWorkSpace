$PBExportHeader$w_sysreport_master.srw
forward
global type w_sysreport_master from mt_w_sheet
end type
type dw_table from u_datagrid within w_sysreport_master
end type
type cb_saveasexcel from commandbutton within w_sysreport_master
end type
type cb_print from commandbutton within w_sysreport_master
end type
end forward

global type w_sysreport_master from mt_w_sheet
integer width = 3191
integer height = 2080
string title = "System Reports"
boolean minbox = false
boolean maxbox = false
boolean ib_setdefaultbackgroundcolor = true
event ue_print ( )
event ue_saveasexcel ( )
event ue_open ( )
dw_table dw_table
cb_saveasexcel cb_saveasexcel
cb_print cb_print
end type
global w_sysreport_master w_sysreport_master

forward prototypes
public subroutine documentation ()
end prototypes

event ue_print();mt_n_datastore lds_print

lds_print = create mt_n_datastore

lds_print.dataobject = dw_table.dataobject
lds_print.settransobject(sqlca)
dw_table.sharedata(lds_print)

if lds_print.rowcount() > 0 then lds_print.print()

destroy lds_print
end event

event ue_saveasexcel();if dw_table.rowcount() > 0 then dw_table.saveas("", Excel!, true)
end event

public subroutine documentation ();/*****************************************************************************************
   w_sysreport_master
   <OBJECT> system report	</OBJECT>
   <USAGE>	Template window for system report  </USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date     	CR-Ref   Author      Comments
		10/07/12		CRM		WWG004		First Version
   </HISTORY>
******************************************************************************************/
end subroutine

on w_sysreport_master.create
int iCurrent
call super::create
this.dw_table=create dw_table
this.cb_saveasexcel=create cb_saveasexcel
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_table
this.Control[iCurrent+2]=this.cb_saveasexcel
this.Control[iCurrent+3]=this.cb_print
end on

on w_sysreport_master.destroy
call super::destroy
destroy(this.dw_table)
destroy(this.cb_saveasexcel)
destroy(this.cb_print)
end on

event open;call super::open;this.event ue_open()
end event

type dw_table from u_datagrid within w_sysreport_master
integer x = 37
integer y = 32
integer width = 3090
integer height = 1808
integer taborder = 10
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event clicked;call super::clicked;if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
end if
end event

type cb_saveasexcel from commandbutton within w_sysreport_master
integer x = 2743
integer y = 1856
integer width = 379
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As Excel"
end type

event clicked;parent.event ue_saveasexcel()

end event

type cb_print from commandbutton within w_sysreport_master
integer x = 2395
integer y = 1856
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;parent.event ue_print()
end event

