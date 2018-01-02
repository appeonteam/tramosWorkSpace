$PBExportHeader$w_infomaker_reports.srw
$PBExportComments$Window for using dynamic reports
forward
global type w_infomaker_reports from mt_w_sheet
end type
type dw_reports_list from mt_u_datawindow within w_infomaker_reports
end type
type cb_saveas from mt_u_commandbutton within w_infomaker_reports
end type
type uo_search from u_searchbox within w_infomaker_reports
end type
type st_background from u_topbar_background within w_infomaker_reports
end type
type cb_print from mt_u_commandbutton within w_infomaker_reports
end type
type dw_report_detail from mt_u_datawindow within w_infomaker_reports
end type
type dw_report from mt_u_datawindow within w_infomaker_reports
end type
type cb_retrieve from mt_u_commandbutton within w_infomaker_reports
end type
type cb_cancel from mt_u_commandbutton within w_infomaker_reports
end type
type cb_update from mt_u_commandbutton within w_infomaker_reports
end type
end forward

global type w_infomaker_reports from mt_w_sheet
integer width = 4608
integer height = 2568
string title = "Public InfoMaker Reports"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
dw_reports_list dw_reports_list
cb_saveas cb_saveas
uo_search uo_search
st_background st_background
cb_print cb_print
dw_report_detail dw_report_detail
dw_report dw_report
cb_retrieve cb_retrieve
cb_cancel cb_cancel
cb_update cb_update
end type
global w_infomaker_reports w_infomaker_reports

type variables
integer ii_report_type
boolean ib_retrieve
long    il_report_id
mt_n_transaction  itr_trans
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_data_modified ()
private subroutine _set_permissions ()
public function integer wf_data_validation ()
public function boolean wf_init_transaction ()
public subroutine wf_set_autocommit ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27/08/14		CR3078		CCY018		Corrected ancestor and modified event ue_getwidowname
		01/09/14		CR3781		CCY018		The window title match with the text of a menu item
		21/09/15		CR4161		XSZ004		Public Informaker Reports window and print window merged into one.
		02/12/15		CR4215		XSZ004		Add validation for report name and report description.
		16/03/17		CR4619		XSZ004		Add new transaction for report data retrieve.
   </HISTORY>
********************************************************************/

end subroutine

public function integer wf_data_modified ();/********************************************************************
   wf_data_modified
   <DESC>		</DESC>
   <RETURN>	integer:
            <LI> c#return.success, ok
            <LI> c#return.failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
   	22/09/15		CR4161		XSZ004		First Version
   </HISTORY>
********************************************************************/

int    li_modifiedcount, li_return
string ls_message

dw_report_detail.accepttext()

li_modifiedcount = dw_report_detail.modifiedcount()

if li_modifiedcount > 0 then
	ls_message = "Data has been changed, but not saved.~n~n Would you like to save data?"
	li_return  = messagebox("Updates Pending", ls_message, question!, yesno!, 1)
	
	if li_return = c#return.success then
		li_return = cb_update.event clicked()
	else
		cb_cancel.event clicked()
	end if
end if

return li_return
end function

private subroutine _set_permissions ();/********************************************************************
   _set_permissions
   <DESC>Access control for update report.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		29/09/15			CR4145		XSZ004		First Version	      
   </HISTORY>
********************************************************************/

dw_report_detail.modify("report_name.Edit.DisplayOnly = yes")
dw_report_detail.modify("report_desc.Edit.DisplayOnly = yes")
dw_report_detail.modify("report_name.background.color = " + string(c#color.MT_FORM_BG))
dw_report_detail.modify("report_desc.background.color = " + string(c#color.MT_FORM_BG))

if uo_global.ii_access_level >= C#usergroup.#SUPERUSER then
	cb_update.enabled = true
	cb_cancel.enabled = true
	dw_report_detail.modify("report_name.Edit.DisplayOnly = no")
	dw_report_detail.modify("report_desc.Edit.DisplayOnly = no")
	dw_report_detail.modify("report_name.background.color = " + string(c#color.MT_MAERSK))
	dw_report_detail.modify("report_desc.background.color = " + string(c#color.MT_MAERSK))
end if
end subroutine

public function integer wf_data_validation ();/********************************************************************
   wf_data_validation
   <DESC>		</DESC>
   <RETURN>	integer:
            <LI> c#return.success, ok
            <LI> c#return.failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/12/15		CR4215		XSZ004		First Version.
   </HISTORY>
********************************************************************/

string ls_report_name, ls_report_name_original, ls_report_desc, ls_error, ls_column_name
int    li_count, li_return

dw_report_detail.accepttext()

if dw_report_detail.modifiedcount() > 0 and not isnull(dw_report_detail.getitemnumber(1, "report_id"))then
	
	li_return      = c#return.success
	ls_report_name = upper(trim(dw_report_detail.getitemstring(1, "report_name")))
	
	if isnull(ls_report_name) then ls_report_name = ""
	
	if ls_report_name = "" then
		ls_error       = "Report name can not be empty."
		ls_column_name = "report_name"
		li_return      = c#return.failure
	end if
	
	ls_report_name_original = upper(trim(dw_report_detail.getitemstring(1, "report_name", primary!, true)))
	
	if isnull(ls_report_name_original) then ls_report_name_original = ""
	
	if ls_report_name <> ls_report_name_original and li_return = c#return.success then
		
		SELECT count(*) into :li_count FROM PUBLIC_REPORT WHERE upper(REPORT_NAME) = :ls_report_name;
			
		if li_count > 0 then
			ls_error       = "This report name already exists."
			ls_column_name = "report_name"			
			li_return      = c#return.failure
		end if
	end if
	
	ls_report_desc = trim(dw_report_detail.getitemstring(1, "report_desc"))
	
	if isnull(ls_report_desc) then ls_report_desc = ""
	
	if ls_report_desc = "" and li_return = c#return.success then
		ls_error       = "Report description can not be empty."
		ls_column_name = "report_desc"		
		li_return      = c#return.failure
	end if

else
	li_return = c#return.noaction
end if

if li_return = c#return.failure then
	messagebox("Validation Error", ls_error)
	dw_report_detail.setcolumn(ls_column_name)
	dw_report_detail.setfocus()
end if

return li_return
end function

public function boolean wf_init_transaction ();/********************************************************************
   wf_init_transaction
   <DESC>	Init the transaction for public report</DESC>
   <RETURN>	boolean </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date     CR-Ref		Author		Comments
		07-03-17	CR4619		XSZ004		First Version
   </HISTORY>
********************************************************************/

boolean lb_ret

lb_ret = true

itr_trans = create mt_n_transaction

itr_trans.autocommit = sqlca.autocommit
itr_trans.dbms       = sqlca.DBMS
itr_trans.Database   = sqlca.Database
itr_trans.Servername = sqlca.ServerName
itr_trans.UserID     = sqlca.userid
itr_trans.DBPass     = sqlca.dbpass
itr_trans.Logid      = sqlca.logid
itr_trans.LogPass    = sqlca.LogPass
itr_trans.Dbparm     = sqlca.DBParm 

connect using itr_trans;
	
if itr_trans.sqlcode <> 0 then	
	messagebox("Database Error","Could not attach to Database." + "~n~nMessage: " + itr_trans.sqlerrtext, stopsign!)
	lb_ret = false
end if

return lb_ret
end function

public subroutine wf_set_autocommit ();/********************************************************************
   wf_set_autocommit
   <DESC> Set autocommit for transaction</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_check_autocommit
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date     CR-Ref		Author		Comments
		07-03-17	CR4619		XSZ004		First Version
   </HISTORY>
********************************************************************/

boolean lb_autocommit

if dw_report_detail.rowcount() > 0 then
	lb_autocommit = (dw_report_detail.getitemnumber(1, "auto_commit") = 1)
end if	

itr_trans.autocommit = lb_autocommit
end subroutine

event open;call super::open;n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_reports_list, false)

ib_retrieve = false

if not wf_init_transaction() then 
	close(this)
	return 
end if
dw_reports_list.settransobject(sqlca)
dw_reports_list.retrieve()

dw_report_detail.settransobject(sqlca)
dw_report_detail.insertrow(0)

uo_search.of_initialize(dw_reports_list, "report_name")

_set_permissions()
end event

on w_infomaker_reports.create
int iCurrent
call super::create
this.dw_reports_list=create dw_reports_list
this.cb_saveas=create cb_saveas
this.uo_search=create uo_search
this.st_background=create st_background
this.cb_print=create cb_print
this.dw_report_detail=create dw_report_detail
this.dw_report=create dw_report
this.cb_retrieve=create cb_retrieve
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reports_list
this.Control[iCurrent+2]=this.cb_saveas
this.Control[iCurrent+3]=this.uo_search
this.Control[iCurrent+4]=this.st_background
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.dw_report_detail
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.cb_retrieve
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.cb_update
end on

on w_infomaker_reports.destroy
call super::destroy
destroy(this.dw_reports_list)
destroy(this.cb_saveas)
destroy(this.uo_search)
destroy(this.st_background)
destroy(this.cb_print)
destroy(this.dw_report_detail)
destroy(this.dw_report)
destroy(this.cb_retrieve)
destroy(this.cb_cancel)
destroy(this.cb_update)
end on

event ue_getwindowname;call super::ue_getwindowname;if ii_report_type = 1 then
	as_windowname = this.classname( ) + "_private"
else
	as_windowname = this.classname( ) + "_public"
end if
end event

event closequery;call super::closequery;if wf_data_modified() = c#return.failure then
	return 1
end if
end event

event close;call super::close;disconnect using itr_trans;
destroy itr_trans
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_infomaker_reports
end type

type dw_reports_list from mt_u_datawindow within w_infomaker_reports
integer x = 37
integer y = 240
integer width = 1033
integer height = 1416
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_gr_reports_list"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
end type

event clicked;call super::clicked;if row < 1 then return

ib_retrieve = true

if row = 1 and getselectedrow(0) <> 1 then
	this.event rowfocuschanged(row)
end if



end event

event rowfocuschanged;call super::rowfocuschanged;string ls_error
blob   lblb_syntax
long   ll_report_id

if ib_retrieve then
	
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	
	ll_report_id = this.getitemnumber(currentrow, "report_id")
	
	if ll_report_id <> il_report_id then
		
		il_report_id = ll_report_id
	
		SELECTBLOB REPORT_SYNTAX INTO :lblb_syntax 
				FROM PUBLIC_REPORT
			  WHERE REPORT_ID = :il_report_id;
		
		dw_report.create(string(lblb_syntax), ls_error)
		
		if ls_error = "" then
			dw_report.settransobject(itr_trans)
		else
			messagebox("Error", ls_error)
		end if
		
		dw_report_detail.retrieve(il_report_id)
		
	end if
	
else
	ib_retrieve = true
end if



end event

event rowfocuschanging;call super::rowfocuschanging;graphicobject focus_control
string ls_classname

focus_control = getfocus()

if isvalid(focus_control) then
	
	ls_classname = focus_control.classname()
	
	if ls_classname = "cb_clear" then
		ib_retrieve = false
	end if
end if	

if ls_classname <> "cb_clear" then 
	if wf_data_modified() = c#return.failure  then
		return 1
	end if
end if	
	
end event

type cb_saveas from mt_u_commandbutton within w_infomaker_reports
integer x = 3863
integer y = 2364
integer taborder = 80
boolean bringtotop = true
string text = "&Save As..."
end type

event clicked;call super::clicked;string     ls_saveas_type
saveastype lsat_type

if il_report_id < 1 then return

ls_saveas_type = dw_report_detail.getitemstring(1, "save_as_type")

choose case lower(trim(ls_saveas_type))
	case "excel!"
		lsat_type = Excel!
	case "text!"
		lsat_type = Text!
	case "csv!"
		lsat_type = CSV!
	case "sylk!"
		lsat_type = SYLK!
	case "wks!"
		lsat_type = WKS!
	case "wk1!"
		lsat_type = WK1!
	case "dif!"
		lsat_type = DIF!
	case "dbase2!"
		lsat_type = dBASE2!
	case "dbase3!"
		lsat_type = dBASE3!
	case "sqlinsert!"
		lsat_type = SQLInsert!
	case "clipboard!"
		lsat_type = Clipboard!
	case "psreport!"
		lsat_type = PSReport!
	case "wmf!"
		lsat_type = WMF!
	case "htmltable!"
		lsat_type = HTMLTable!
	case "excel5!"
		lsat_type = Excel5!
	case "xml!"
		lsat_type = XML!
	case "xslfo!"
		lsat_type = XSLFO!
	case "pdf!"
		lsat_type = PDF!
	case "excel8!"
		lsat_type = Excel8!
	case "emf!"
		lsat_type = EMF!
	case "xlsx!"
		lsat_type = XLSX!
	case "xlsb!"
		lsat_type = XLSB!
	case else
		lsat_type = Excel!
end choose

dw_report.saveas("", lsat_type, true)

end event

type uo_search from u_searchbox within w_infomaker_reports
integer x = 37
integer y = 32
integer taborder = 10
boolean bringtotop = true
boolean ib_standard_ui_topbar = true
boolean ib_scrolltocurrentrow = true
end type

on uo_search.destroy
call u_searchbox::destroy
end on

event ue_prekeypress;call super::ue_prekeypress;ib_retrieve = false

return 1
end event

type st_background from u_topbar_background within w_infomaker_reports
end type

type cb_print from mt_u_commandbutton within w_infomaker_reports
integer x = 4210
integer y = 2364
integer taborder = 90
boolean bringtotop = true
string text = "&Print"
end type

event clicked;call super::clicked;dw_report.print( )
end event

type dw_report_detail from mt_u_datawindow within w_infomaker_reports
integer x = 32
integer y = 1684
integer width = 1051
integer height = 696
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sq_gr_reports_detail"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_report from mt_u_datawindow within w_infomaker_reports
integer x = 1106
integer y = 240
integer width = 3447
integer height = 2108
integer taborder = 30
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_retrieve from mt_u_commandbutton within w_infomaker_reports
integer x = 3515
integer y = 2364
integer taborder = 70
boolean bringtotop = true
string text = "&Retrieve"
end type

event clicked;call super::clicked;datetime ldt_used_date

wf_set_autocommit()

dw_report.retrieve()

ldt_used_date = datetime(today(), now())

UPDATE PUBLIC_REPORT SET LAST_USED_DATE = :ldt_used_date, LAST_USED_BY = :uo_global.is_userid
WHERE  REPORT_ID = :il_report_id;

COMMIT using sqlca;
end event

type cb_cancel from mt_u_commandbutton within w_infomaker_reports
integer x = 3168
integer y = 2364
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_report_detail.reset()

if il_report_id > 0 then
	dw_report_detail.retrieve(il_report_id)
else
	dw_report_detail.insertrow(0)
end if



end event

type cb_update from mt_u_commandbutton within w_infomaker_reports
integer x = 2821
integer y = 2364
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;int    li_return, li_selectrow
string ls_error, ls_filter, ls_error_title

li_return = wf_data_validation()

if li_return = c#return.success then
	
	dw_report_detail.setitem(1, "last_edit_date", today())
	dw_report_detail.setitem(1, "last_edit_by", uo_global.is_userid)
	
	if dw_report_detail.update() = 1 then
		
		commit;
		
		ls_filter    = dw_reports_list.describe("datawindow.table.filter")
		li_selectrow = dw_reports_list.getselectedrow(0)
		
		ib_retrieve = false
		dw_reports_list.setredraw(false)
		dw_reports_list.retrieve()
		
		if ls_filter <> "?" then
			ib_retrieve = false
			dw_reports_list.setfilter(ls_filter)
			dw_reports_list.filter()
		end if
	
		if li_selectrow > 0 then
			li_selectrow = dw_reports_list.find("report_id = " + string(il_report_id), 1, dw_reports_list.rowcount())
			ib_retrieve = false
			dw_reports_list.scrolltorow(li_selectrow)
			dw_reports_list.selectrow(li_selectrow, true)
			ib_retrieve = true
		end if
		
		dw_reports_list.setredraw(true)
	else
		li_return      = c#return.failure
		ls_error       = "Update aborted." + sqlca.sqlerrtext
		rollback;
		messagebox("Error", ls_error)
	end if
end if
	
return li_return
end event

