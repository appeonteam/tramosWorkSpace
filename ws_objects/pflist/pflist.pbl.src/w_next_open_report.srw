$PBExportHeader$w_next_open_report.srw
forward
global type w_next_open_report from w_events_pcgroup
end type
type uo_pcgroup from u_pcgroup within w_next_open_report
end type
type cb_close from commandbutton within w_next_open_report
end type
type cb_saveas from commandbutton within w_next_open_report
end type
type cb_print from commandbutton within w_next_open_report
end type
type st_2 from statictext within w_next_open_report
end type
type st_1 from mt_u_statictext within w_next_open_report
end type
type dw_select_report from mt_u_datawindow within w_next_open_report
end type
type tab_1 from tab within w_next_open_report
end type
type tp_report from userobject within tab_1
end type
type dw_report from mt_u_datawindow within tp_report
end type
type tp_report from userobject within tab_1
dw_report dw_report
end type
type tp_config from userobject within tab_1
end type
type cb_delete from mt_u_commandbutton within tp_config
end type
type cb_update from mt_u_commandbutton within tp_config
end type
type cb_insert from mt_u_commandbutton within tp_config
end type
type dw_config from mt_u_datawindow within tp_config
end type
type tp_config from userobject within tab_1
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
dw_config dw_config
end type
type tab_1 from tab within w_next_open_report
tp_report tp_report
tp_config tp_config
end type
end forward

global type w_next_open_report from w_events_pcgroup
integer width = 3232
integer height = 2440
string title = "Next Open Report"
event ue_selectreport_refresh ( )
uo_pcgroup uo_pcgroup
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
st_2 st_2
st_1 st_1
dw_select_report dw_select_report
tab_1 tab_1
end type
global w_next_open_report w_next_open_report

type variables
integer ii_pcgroup

end variables

forward prototypes
public subroutine wf_refresh ()
end prototypes

event ue_selectreport_refresh();string ls_selected
long	ll_row

ll_row = dw_select_report.getselectedRow(0)
if ll_row < 1 then return

ls_selected = dw_select_report.getItemString(ll_row, "next_open_label")

dw_select_report.retrieve(ii_pcgroup)

ll_row = dw_select_report.find( "next_open_label='"+ls_selected+"'", 1, 9999)

if ll_row > 0 then dw_select_report.selectRow(ll_row, true)
end event

public subroutine wf_refresh ();string ls_selected
long	ll_row

ll_row = dw_select_report.getselectedRow(0)

if ll_row > 0 then 
	ls_selected = dw_select_report.getItemString(ll_row, "next_open_label")
	dw_select_report.retrieve(ii_pcgroup)
	ll_row = dw_select_report.find( "next_open_label='"+ls_selected+"'", 1, 9999)
	if ll_row < 1 then
		ll_row = 1
	end if		
else
	dw_select_report.retrieve(ii_pcgroup)
	ll_row = 1
end if

if dw_select_report.rowcount()=0 then return 

dw_select_report.selectRow(ll_row, true)
dw_select_report.POST EVENT Clicked( 0, 0, ll_row, dw_select_report.object )

end subroutine

on w_next_open_report.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.st_2=create st_2
this.st_1=create st_1
this.dw_select_report=create dw_select_report
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_select_report
this.Control[iCurrent+8]=this.tab_1
end on

on w_next_open_report.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_select_report)
destroy(this.tab_1)
end on

event open;// dw_profit_center.settransobject(SQLCA)
dw_select_report.setTransObject(SQLCA)
tab_1.tp_config.dw_config.setTransObject(SQLCA)
tab_1.tp_report.dw_report.setTransObject(SQLCA)

ii_pcgroup = uo_pcgroup.uf_getpcgroup( )
if ii_pcgroup < 0 then
	this.Post Event ue_postopen()
end if

dw_select_report.retrieve(ii_pcgroup)
if dw_select_report.rowcount( )>0 then
	dw_select_report.selectrow( 1, true)
	tab_1.tp_report.dw_report.retrieve(dw_select_report.getItemNumber(1, "next_config_id"), ii_pcgroup, dw_select_report.getItemString(1, "next_open_label"))
	tab_1.tp_report.dw_report.groupcalc( )
end if

tab_1.tp_config.dw_config.retrieve(ii_pcgroup)
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;//if row > 0 then
//	selectrow(0, false)
//	selectrow(row, true)	
	ii_pcgroup = ai_pcgroupid
	if dw_select_report.retrieve(ii_pcgroup) > 0 then
		dw_select_report.POST EVENT Clicked( 0, 0, 1, dw_select_report.object )
	else
		tab_1.tp_report.dw_report.reset()
	end if
	tab_1.tp_config.dw_config.retrieve(ii_pcgroup)
// end if
	return 0
end event

type uo_pcgroup from u_pcgroup within w_next_open_report
integer x = 27
integer y = 4
integer height = 148
integer taborder = 50
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_close from commandbutton within w_next_open_report
integer x = 2638
integer y = 576
integer width = 343
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_saveas from commandbutton within w_next_open_report
integer x = 2217
integer y = 576
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&SaveAs..."
end type

event clicked;tab_1.tp_report.dw_report.saveas()
end event

type cb_print from commandbutton within w_next_open_report
integer x = 1797
integer y = 576
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;tab_1.tp_report.dw_report.print()
end event

type st_2 from statictext within w_next_open_report
integer x = 1797
integer y = 120
integer width = 1193
integer height = 164
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please be aware of that this report is created on requirements from the Crude Profitcenter. "
boolean focusrectangle = false
end type

type st_1 from mt_u_statictext within w_next_open_report
integer x = 859
integer y = 8
integer width = 992
integer height = 56
integer weight = 700
string text = "Select Tracking Area (Port):"
end type

type dw_select_report from mt_u_datawindow within w_next_open_report
integer x = 855
integer y = 80
integer width = 727
integer height = 588
integer taborder = 50
string dataobject = "d_sq_tb_next_open_port_label"
boolean vscrollbar = true
end type

event clicked;call super::clicked;if row > 0 then
	selectrow(0, false)
	selectrow(row, true)
	tab_1.tp_report.dw_report.retrieve(this.getItemNumber(row, "next_config_id"), ii_pcgroup, this.getItemString(row, "next_open_label"))
	tab_1.tp_report.dw_report.groupcalc( )
end if

end event

type tab_1 from tab within w_next_open_report
integer x = 14
integer y = 732
integer width = 3163
integer height = 1592
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_report tp_report
tp_config tp_config
end type

on tab_1.create
this.tp_report=create tp_report
this.tp_config=create tp_config
this.Control[]={this.tp_report,&
this.tp_config}
end on

on tab_1.destroy
destroy(this.tp_report)
destroy(this.tp_config)
end on

event selectionchanged;if newindex = 1 then 
	cb_print.enabled = true
	cb_saveas.enabled = true
else
	cb_print.enabled = false
	cb_saveas.enabled = false
end if	
end event

type tp_report from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3127
integer height = 1476
long backcolor = 67108864
string text = "Report"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_report dw_report
end type

on tp_report.create
this.dw_report=create dw_report
this.Control[]={this.dw_report}
end on

on tp_report.destroy
destroy(this.dw_report)
end on

type dw_report from mt_u_datawindow within tp_report
integer x = 18
integer y = 28
integer width = 3086
integer height = 1424
integer taborder = 40
string dataobject = "d_next_open_report"
boolean vscrollbar = true
end type

type tp_config from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3127
integer height = 1476
long backcolor = 67108864
string text = "Configure"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
dw_config dw_config
end type

on tp_config.create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.dw_config=create dw_config
this.Control[]={this.cb_delete,&
this.cb_update,&
this.cb_insert,&
this.dw_config}
end on

on tp_config.destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.dw_config)
end on

type cb_delete from mt_u_commandbutton within tp_config
integer x = 923
integer y = 1008
integer taborder = 80
string text = "&Delete"
end type

event clicked;call super::clicked;long 		ll_rows, ll_row
string		ls_validate
long		ll_configID

dw_config.acceptText()
ll_rows = dw_config.rowCount()


/* Validation only Crude */
if ii_pcgroup = 1 then
	if ll_rows < 2 then
		MessageBox("Validation error", "You have to have at least 2 areas to track." &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		return
	end if
end if

/* Start new transaction */
commit;

/* Delete row */
ll_row = dw_config.getRow()
if ll_row > 0 then
	ll_configID = dw_config.getItemNumber(ll_row, "next_config_id")
	if not isnull(ll_configID) then
		DELETE FROM PF_NEXT_OPEN_REPORT WHERE NEXT_CONFIG_ID = :ll_configID;
		if sqlca.sqlcode <> 0 then
			Rollback;
			Messagebox("Delete Eror", "Error deleting fromtable NEXT_OPEN_REPORT")
			return
		end if
	end if
	dw_config.deleteRow(ll_row)
end if

/* Validation only Crude */
if ii_pcgroup = 1 then
	if dw_config.getItemString(1, "next_open_label") <> "AG" then
		MessageBox("Validation error", "The first label has to be 'AG'" &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(1)
		rollback;
		return
	end if
	if dw_config.getItemString(2, "next_open_label") <> "WAF" then
		MessageBox("Validation error", "The first label has to be 'WAF'" &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(2)
		rollback;
		return
	end if
end if


/* Update */
if dw_config.update() = 1 then
	commit;
else
	MessageBox("Update Error", "The update of Next Open Config failed")
	dw_config.post setColumn("next_open_label") 
	dw_config.post setFocus()
	dw_config.post ScrollToRow(1)
	rollback;
end if

wf_refresh( )
end event

type cb_update from mt_u_commandbutton within tp_config
integer x = 526
integer y = 1008
integer taborder = 70
string text = "&Update"
end type

event clicked;call super::clicked;long 			ll_rows, ll_row
string			ls_validate
n_next_open_calculation	lnv_nextOpen

dw_config.acceptText()

/* Validation */
ll_rows = dw_config.rowCount()

/* Validation only Crude */
if ii_pcgroup = 1 then
	if ll_rows < 2 then
		MessageBox("Validation error", "You have to have at least 2 areas to track." &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		return
	end if
	if dw_config.getItemString(1, "next_open_label") <> "AG" then
		MessageBox("Validation error", "The first label has to be 'AG'" &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(1)
		return
	end if
	if dw_config.getItemString(2, "next_open_label") <> "WAF" then
		MessageBox("Validation error", "The second label has to be 'WAF'" &
					+c#string.CRLF+c#string.CRLF+"The reason is that the two first items are sent to the web-site")
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(2)
		return
	end if
end if

/* If nothing changed then just return */
if dw_config.modifiedCount() = 0 then return


/* Validation ALL */
for ll_row = 1 to ll_rows
	ls_validate = dw_config.getItemString(ll_row, "next_open_label")
	if isNull(ls_validate) or ls_validate = "" then
		MessageBox("Validation error", "Please enter a label in line# "+string(ll_row))
		dw_config.post setColumn("next_open_label") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(ll_row)
		return
	end if
	ls_validate = dw_config.getItemString(ll_row, "port_code")
	if isNull(ls_validate) or ls_validate = "" then
		MessageBox("Validation error", "Please select a portcode in line# "+string(ll_row))
		dw_config.post setColumn("port_code") 
		dw_config.post setFocus()
		dw_config.post ScrollToRow(ll_row)
		return
	end if
next

lnv_nextOpen = create n_next_open_calculation

commit;   //start new transaction

/* Update */
if dw_config.update( true, false ) = 1 then    // Update without resetting the flags. Has to be used in next loop
	commit;
	for ll_row = 1 to ll_rows
		choose case  dw_config.getItemStatus(ll_row, "port_code", primary!)
			case newModified!, dataModified!
				lnv_nextOpen.of_configchanged( dw_config.getItemNumber(ll_row, "next_config_id"), ii_pcgroup )
		end choose
	next
	dw_config.resetUpdate()      //Reset the flags
else
	MessageBox("Update Error", "The update of Next Open Config failed")
	dw_config.post setColumn("next_open_label") 
	dw_config.post setFocus()
	dw_config.post ScrollToRow(1)
	rollback;
end if

if isValid(lnv_nextOpen) then destroy lnv_nextOpen

wf_refresh()
end event

type cb_insert from mt_u_commandbutton within tp_config
integer x = 128
integer y = 1008
integer taborder = 60
string text = "&Insert"
end type

event clicked;call super::clicked;long 	ll_row
ll_row = dw_config.insertRow(0)
if ll_row > 0 then
	dw_config.setItem(ll_row, "pcgroup_id", ii_pcgroup)
	dw_config.setItem(ll_row, "pc_nr", 999)
	dw_config.scrollToRow(ll_row)
	dw_config.setColumn("next_open_label")
	dw_config.setFocus()
end if
	
end event

type dw_config from mt_u_datawindow within tp_config
integer x = 18
integer y = 44
integer width = 1367
integer height = 928
integer taborder = 40
string dataobject = "d_sq_tb_next_open_port_config"
end type

event clicked;call super::clicked;if row > 0 then
	this.selectRow(0, FALSE)
	this.selectRow(row, TRUE)
end if
end event

