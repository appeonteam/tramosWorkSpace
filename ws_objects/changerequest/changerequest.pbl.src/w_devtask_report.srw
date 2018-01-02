$PBExportHeader$w_devtask_report.srw
$PBExportComments$Task Report
forward
global type w_devtask_report from mt_w_sheet
end type
type cbx_selectall_businessunit from mt_u_checkbox within w_devtask_report
end type
type em_to from mt_u_editmask within w_devtask_report
end type
type em_from from mt_u_editmask within w_devtask_report
end type
type cb_refresh from mt_u_commandbutton within w_devtask_report
end type
type sle_search from mt_u_singlelineedit within w_devtask_report
end type
type st_5 from mt_u_statictext within w_devtask_report
end type
type gb_2 from mt_u_groupbox within w_devtask_report
end type
type gb_1 from mt_u_groupbox within w_devtask_report
end type
type st_3 from mt_u_statictext within w_devtask_report
end type
type st_1 from mt_u_statictext within w_devtask_report
end type
type cb_import from mt_u_commandbutton within w_devtask_report
end type
type cb_save from mt_u_commandbutton within w_devtask_report
end type
type dw_report from u_datagrid within w_devtask_report
end type
type st_7 from u_topbar_background within w_devtask_report
end type
type dw_devstatus from u_datagrid within w_devtask_report
end type
type dw_devaction from u_datagrid within w_devtask_report
end type
end forward

global type w_devtask_report from mt_w_sheet
integer width = 3593
integer height = 2544
string title = "Task Report"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
cbx_selectall_businessunit cbx_selectall_businessunit
em_to em_to
em_from em_from
cb_refresh cb_refresh
sle_search sle_search
st_5 st_5
gb_2 gb_2
gb_1 gb_1
st_3 st_3
st_1 st_1
cb_import cb_import
cb_save cb_save
dw_report dw_report
st_7 st_7
dw_devstatus dw_devstatus
dw_devaction dw_devaction
end type
global w_devtask_report w_devtask_report

type variables

end variables

forward prototypes
public subroutine wf_retrieve ()
public subroutine wf_filter ()
public function integer wf_update ()
public subroutine documentation ()
end prototypes

public subroutine wf_retrieve ();/********************************************************************
   wf_getfilter
   <DESC>	Set condition and retrieve	data	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by cb_refresh	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-25-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

string ls_search
double ld_requestfrom, ld_requestto

//Request from
em_from.getdata(ld_requestfrom)

//Request to
em_to.getdata(ld_requestto)

//Object libray, Object name, Comment, Technical Desc.
ls_search = lower(sle_search.text)
if ls_search > '' then
	ls_search = '%' + ls_search + '%'
else
	ls_search = '%'
end if

dw_report.retrieve(ld_requestfrom, ld_requestto, ls_search)
dw_report.event rowfocuschanged(1)
end subroutine

public subroutine wf_filter ();/********************************************************************
   wf_filter
   <DESC>	Filter data	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-25-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

string ls_filter, ls_action

//Dev status
ls_filter = dw_devstatus.inv_filter_multirow.of_getfilter()

//Dev action
ls_action = dw_devaction.inv_filter_multirow.of_getfilter()

if trim(ls_action) > '' then
	if trim(ls_filter) > '' then
		ls_filter += ' and ' + ls_action
	else
		ls_filter = '1 = 2'
	end if
else
	ls_filter = '1 = 2'
end if

dw_report.setredraw(false)
dw_report.setfilter(ls_filter)
dw_report.filter()
dw_report.setredraw(true)
end subroutine

public function integer wf_update ();/********************************************************************
   wf_update
   <DESC>	Update after import data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-25-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

string ls_updadte_setting

if dw_report.update() = 1 then
	COMMIT;
	return c#return.Success
else
	ROLLBACK;
	MessageBox("Error", "Data update failed.")
	return c#return.Failure
end if

end function

public subroutine documentation ();/********************************************************************
   w_devtask_report
   <OBJECT>		Task report	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		w_modify_changerequest	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author		Comments
   	25/01/2013 CR2614       LHG008		First Version
   	12/07/2013 CR3254       LHG008		Change d_dddw_devstatus data source
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;long ll_newrow
n_dw_style_service   lnv_style
n_service_manager lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_report, false)

dw_report.settransobject(sqlca)
end event

on w_devtask_report.create
int iCurrent
call super::create
this.cbx_selectall_businessunit=create cbx_selectall_businessunit
this.em_to=create em_to
this.em_from=create em_from
this.cb_refresh=create cb_refresh
this.sle_search=create sle_search
this.st_5=create st_5
this.gb_2=create gb_2
this.gb_1=create gb_1
this.st_3=create st_3
this.st_1=create st_1
this.cb_import=create cb_import
this.cb_save=create cb_save
this.dw_report=create dw_report
this.st_7=create st_7
this.dw_devstatus=create dw_devstatus
this.dw_devaction=create dw_devaction
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_selectall_businessunit
this.Control[iCurrent+2]=this.em_to
this.Control[iCurrent+3]=this.em_from
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.sle_search
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.cb_import
this.Control[iCurrent+12]=this.cb_save
this.Control[iCurrent+13]=this.dw_report
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.dw_devstatus
this.Control[iCurrent+16]=this.dw_devaction
end on

on w_devtask_report.destroy
call super::destroy
destroy(this.cbx_selectall_businessunit)
destroy(this.em_to)
destroy(this.em_from)
destroy(this.cb_refresh)
destroy(this.sle_search)
destroy(this.st_5)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cb_import)
destroy(this.cb_save)
destroy(this.dw_report)
destroy(this.st_7)
destroy(this.dw_devstatus)
destroy(this.dw_devaction)
end on

event activate;call super::activate;if w_tramos_main.MenuName <> "m_creqmain" then
	w_tramos_main.ChangeMenu(m_creqmain)
	m_creqmain.mf_controlreport()
end if

end event

type cbx_selectall_businessunit from mt_u_checkbox within w_devtask_report
integer x = 256
integer y = 16
integer width = 329
integer height = 56
integer taborder = 10
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	Change select all checkbox text and filter change request report	</DESC>
   <RETURN>	long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> </USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		12/07/2013	CR3254	LHG008	First Version
   </HISTORY>
********************************************************************/

if this.checked then	
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

this.textcolor = c#color.White

//Change the filter selection status
dw_devstatus.selectrow(0, this.checked)

//Generate filter constation
dw_devstatus.inv_filter_multirow.of_dofilter()

wf_filter()
end event

event constructor;call super::constructor;this.backcolor = st_7.backcolor
end event

type em_to from mt_u_editmask within w_devtask_report
integer x = 1792
integer y = 32
integer width = 293
integer height = 56
integer taborder = 40
string text = ""
boolean border = false
string mask = "######"
string minmax = "0~~"
end type

type em_from from mt_u_editmask within w_devtask_report
integer x = 1390
integer y = 32
integer width = 293
integer height = 56
integer taborder = 30
string text = ""
boolean border = false
string mask = "######"
string minmax = "0~~"
end type

type cb_refresh from mt_u_commandbutton within w_devtask_report
integer x = 2510
integer y = 32
integer taborder = 60
string text = "&Refresh"
boolean default = true
end type

event clicked;call super::clicked;wf_retrieve()

end event

type sle_search from mt_u_singlelineedit within w_devtask_report
integer x = 1390
integer y = 104
integer width = 695
integer height = 56
integer taborder = 50
string text = ""
boolean border = false
end type

type st_5 from mt_u_statictext within w_devtask_report
integer x = 1207
integer y = 112
integer width = 160
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Search"
alignment alignment = right!
end type

type gb_2 from mt_u_groupbox within w_devtask_report
integer x = 640
integer y = 16
integer width = 475
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Action"
end type

type gb_1 from mt_u_groupbox within w_devtask_report
integer x = 37
integer y = 16
integer width = 585
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Status"
end type

type st_3 from mt_u_statictext within w_devtask_report
integer x = 1682
integer y = 32
integer width = 91
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "To"
alignment alignment = right!
end type

type st_1 from mt_u_statictext within w_devtask_report
integer x = 1125
integer y = 32
integer width = 251
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Request #"
alignment alignment = right!
end type

type cb_import from mt_u_commandbutton within w_devtask_report
integer x = 2857
integer y = 32
integer taborder = 70
string text = "&Import"
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	Work around for importing file with dialog	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-24-2013	2614		LHG008	First Version
   </HISTORY>
********************************************************************/
string ls_docname, ls_named, ls_updadte_setting
integer li_value, li_import_result, li_return

li_value = getfileopenname("Select File to Import", ls_docname, ls_named, "CSV",&
								+ "CSV Files (*.CSV),*.CSV," &
								+ "Text Files (*.TXT),*.TXT," &
								+ "All Files (*.*), *.*")
	
IF li_value = 1 THEN 
	li_import_result = dw_report.importfile(ls_docname)
ELSE
	Return c#return.Failure
END IF

Choose Case li_import_result
	Case 0
		messagebox("Error", "The importfile has to many rows.")
	case -1
		messagebox("Error", "The importfile has no transactions.")
	Case -2
		messagebox("Error", "The importfile specified is empty.")
	case -3
		messagebox("Error", "The argument for the importfile is invalid.")
	case -4
		messagebox("Error", "The input is invalid.")
	case -5
		messagebox("Error", "The importfile could not be opened.")
	case -6
		messagebox("Error", "The importfile could not be closed.")
	case -7
		messagebox("Error", "There has been errors reading the text.")
	case -8
		messagebox("Error", "The importfile is not a textfile.")
	case -9
		messagebox("Error", "The import has been canceled.")
End Choose

IF li_import_result < 1 THEN
	li_return = c#return.Failure
Else
	//Update after import successful
	li_return = wf_update()
END IF

cb_refresh.event clicked()

Return li_return

end event

type cb_save from mt_u_commandbutton within w_devtask_report
integer x = 3205
integer y = 32
integer taborder = 80
string text = "&Save As..."
end type

event clicked;call super::clicked;dw_report.saveas("", Excel8!, true)
end event

type dw_report from u_datagrid within w_devtask_report
integer x = 37
integer y = 624
integer width = 3511
integer height = 1808
integer taborder = 90
string dataobject = "d_sq_gr_devtaskreport"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false) 
	this.selectrow(currentrow, true)
	this.setrow(currentrow)
end if
end event

type st_7 from u_topbar_background within w_devtask_report
integer width = 3584
integer height = 592
end type

type dw_devstatus from u_datagrid within w_devtask_report
integer x = 73
integer y = 80
integer width = 512
integer height = 452
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_dddw_devstatus"
boolean vscrollbar = true
boolean border = false
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve()
this.insertrow(1)
this.setitem(1, "description", "<Empty...>")

lstr_module.self_dw = dw_devstatus
lstr_module.self_column_name = 'id'       // The column name is getitem column name.
lstr_module.report_column_name = 'dev_status'
lstr_module.include_null = true

this.inv_filter_multirow.of_register(lstr_module)

this.selectrow(0, true)
this.inv_filter_multirow.of_dofilter()
end event

event clicked;call super::clicked;this.inv_filter_multirow.of_dofilter()
wf_filter()
end event

type dw_devaction from u_datagrid within w_devtask_report
integer x = 677
integer y = 80
integer width = 402
integer height = 452
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_dddw_devaction"
boolean vscrollbar = true
boolean border = false
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.insertrow(1)
this.setitem(1, "action_desc", "<Empty...>")

lstr_module.self_dw = dw_devaction
lstr_module.self_column_name = 'action_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'actiontype'
lstr_module.include_null = true

this.inv_filter_multirow.of_register(lstr_module )

this.selectrow(0, true)
this.inv_filter_multirow.of_dofilter()

end event

event clicked;call super::clicked;this.inv_filter_multirow.of_dofilter()
wf_filter()
end event

