$PBExportHeader$w_system_base.srw
forward
global type w_system_base from mt_w_main
end type
type cb_cancel from mt_u_commandbutton within w_system_base
end type
type cb_refresh from mt_u_commandbutton within w_system_base
end type
type cb_delete from mt_u_commandbutton within w_system_base
end type
type cb_update from mt_u_commandbutton within w_system_base
end type
type cb_new from mt_u_commandbutton within w_system_base
end type
type dw_1 from u_datagrid within w_system_base
end type
end forward

global type w_system_base from mt_w_main
integer width = 1920
integer height = 1024
string title = "Maintain"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
event ue_preopen ( )
event type integer ue_presave ( )
event type integer ue_predelete ( )
event type integer ue_preupdate ( )
event type integer ue_update ( )
event type integer ue_postupdate ( )
event type integer ue_delete ( )
event type integer ue_postdelete ( )
event type integer ue_preadd ( )
event type integer ue_postadd ( )
event type integer ue_add ( )
cb_cancel cb_cancel
cb_refresh cb_refresh
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
dw_1 dw_1
end type
global w_system_base w_system_base

type variables
n_service_manager inv_servicemgr
n_dw_validation_service    inv_validation
boolean ib_showmessage = true
boolean ib_update_after_del = false
boolean ib_confirmdeletion = true
string is_update_table
string is_key[]
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_format_datawindow (datawindow adw)
public function integer wf_format_datawindow (datawindow adw_master, string as_mandatorycol[])
private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol)
public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation)
private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol, boolean ab_duplicatecheck)
public function integer wf_format_datawindow (datawindow adw_master, s_system_base_parm astr_parm[])
private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol, boolean ab_duplicatecheck, boolean ab_casesensitive)
public function integer wf_get_update_properties ()
public function string wf_getitem (long al_row, string as_colname)
public function integer wf_delete_row (long al_row)
end prototypes

event ue_preopen();return
end event

event type integer ue_presave();return C#Return.Success
end event

event type integer ue_predelete();/********************************************************************
   ue_predelete
   <DESC>	Notification of a pending delete operation.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok = Continue with delete
            <LI> c#return.Failure,  failed = Prevent the actual delete </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

return C#Return.Success
end event

event type integer ue_preupdate();/********************************************************************
   ue_preupdate
   <DESC>	Perform any user-defined processing prior to update	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref		Author             Comments
   	02/07/14 CR3427		CCY018        	First Version
   </HISTORY>
********************************************************************/

return C#Return.Success
end event

event type integer ue_update();/********************************************************************
   ue_update
   <DESC>	Update the changed object.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version.
		07/25/14 CR3348      SSX014   Show error message(s) from the database server
		         CR3700
	10/07/16		CR4362		HHX010	The messagebox should use the StopSign Icon
   </HISTORY>
********************************************************************/

n_error_service 		lnv_error
n_service_manager 	lnv_SrvMgr

if dw_1.update() = 1 then
	commit;
	return C#Return.Success
else
	rollback;
	
	// Show error message(s) from the database server if any
	lnv_SrvMgr.of_loadservice( lnv_error, "n_error_service")
	if lnv_error.of_ShowMessages() = c#return.Failure then
		messagebox("Update Error", "Update failure.", StopSign!)
	end if
	return C#Return.Failure
end if

end event

event type integer ue_delete();/********************************************************************
   ue_delete
   <DESC>	Deletes the current row	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
		08/19/14 CR3348      SSX014   Add an option to remove the deletion confirmation
	10/07/16		CR4362		HHX010	The messagebox should use the StopSign Icon	
   </HISTORY>
	
********************************************************************/

long ll_row
long ll_rc
DWItemStatus le_rowstatus

ll_row = dw_1.getrow()
if ll_row > 0 then
	le_rowstatus = dw_1.getitemstatus( ll_row, 0, primary!)
	if le_rowstatus = New! or le_rowstatus = NewModified! then
		dw_1.deleterow(ll_row)
	else
		if ib_confirmdeletion or ib_update_after_del then
			ll_rc = messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!, 2)
		else
			ll_rc = 1
		end if
		
		if ll_rc = 1 then
			if ib_update_after_del then
				if wf_delete_row( ll_row) = c#return.Success then
					dw_1.rowsdiscard( ll_row, ll_row, primary!)
				else
					messagebox("Error", "Delete failed.", StopSign!)
					return c#return.Failure
				end if
			else
				dw_1.deleterow(ll_row)
			end if
		else
			return c#return.Failure
		end if
	end if
end if

if ll_row > dw_1.rowcount( ) then ll_row = dw_1.rowcount( )
if ll_row > 0 then
	dw_1.scrolltorow(ll_row)
	if dw_1.ib_newstandard = false then dw_1.selectrow(ll_row,true)
end if

return C#Return.Success
end event

event type integer ue_postdelete();/********************************************************************
   ue_postdelete
   <DESC>	Perform Post Delete process.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

return C#Return.Success
end event

event type integer ue_preadd();/********************************************************************
   ue_preadd
   <DESC>	Determines if it is OK to insert a new row.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

return C#Return.Success
end event

event type integer ue_postadd();/********************************************************************
   ue_postadd
   <DESC>	Perform Post Add process </DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

return C#Return.Success
end event

event type integer ue_add();/********************************************************************
   ue_add
   <DESC>	Inserts a new row into the DataWindow before the current row</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

long ll_row

ll_row = dw_1.insertrow(0)
if ll_row <= 0 then return c#return.Failure

dw_1.scrolltorow(ll_row)
dw_1.setrow(ll_row)
dw_1.post setfocus()

return C#Return.Success
end event

public subroutine documentation ();/********************************************************************
   w_system_base
   <OBJECT>parent window</OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date        CR-Ref            Author             Comments
   	2011-08-09  CR2438            RJH022             change inheritance relation
		2013-01-16	CR2614				LHG008				 datawindow formart and mandatory column register
		2014-05-30	CR3427				LHG008				 add event ue_preopen(), ue_predelete(), ue_presave() and function wf_validate()
		10/06/14		CR3427				CCY018				 Extended function.
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_format_datawindow (datawindow adw);string ls_mandatory_column[]

return wf_format_datawindow(adw, ls_mandatory_column)
end function

public function integer wf_format_datawindow (datawindow adw_master, string as_mandatorycol[]);/********************************************************************
   wf_format_datawindow
   <DESC>	Mandatory column format and register	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_master: A reference to a datawindow control
		as_mandatorycol[]: Array of mandatory column 
   </ARGS>
   <USAGE>	window open	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-03-2013	2614		LHG008	First Version
		06/06/14		CR3427	CCY018	Extended function.
   </HISTORY>
********************************************************************/

integer li_upper
n_dw_style_service   lnv_style
s_system_base_parm lstr_parm[]

for li_upper = 1 to upperbound(as_mandatorycol)
	lstr_parm[li_upper].mandatorycol = as_mandatorycol[li_upper]
	lstr_parm[li_upper].duplicatecheck = false
	lstr_parm[li_upper].casesensitive = true
next

return wf_format_datawindow( adw_master, lstr_parm)

end function

private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol);/********************************************************************
   _registermandatorycol
   <DESC>	Mandatory column register for validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		adw_master: A reference to a DataWindow control
		as_mandatorycol: Mandatory column name
   </ARGS>
   <USAGE>	wf_format_datawindow()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-03-2013	2614		LHG008	First Version
		06/06/14		CR3247	CCY018	Extended function.
   </HISTORY>
********************************************************************/

return _registermandatorycol(adw_master, as_mandatorycol, false)
end function

public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation);/********************************************************************
   wf_validate
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_master
		anv_validation
   </ARGS>
   <USAGE> ref: cb_updadte.event clicked()	</USAGE>
   <HISTORY>
		Date     CR-Ref   Author   Comments
		30/05/14	CR3427   LHG008   First Version
		10/07/16		CR4362		HHX010	The messagebox should use the StopSign Icon
   </HISTORY>
********************************************************************/

long ll_return, ll_errorrow
integer li_errorcolumn
string  ls_message

if isvalid(anv_validation) then
	ll_return = anv_validation.of_validate(adw_master, ls_message, ll_errorrow, li_errorcolumn)
	if ll_return = C#Return.Failure then
		adw_master.setfocus()
		adw_master.setrow(ll_errorrow)
		adw_master.setcolumn(li_errorcolumn)
		messagebox("Update Error", ls_message, StopSign!)	
		return C#Return.Failure
	end if
end if

return c#return.Success
end function

private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol, boolean ab_duplicatecheck);/********************************************************************
   _registermandatorycol
   <DESC>	Mandatory column register for validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		adw_master: A reference to a DataWindow control
		as_mandatorycol: Mandatory column name
		ab_duplicatecheck: a check to see if the column needs to be unique.  when enabled system
   </ARGS>
   <USAGE>	wf_format_datawindow()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		06/06/14		CR3427	CCY018	First Version
   </HISTORY>
********************************************************************/

return _registermandatorycol(adw_master, as_mandatorycol, ab_duplicatecheck, true)
end function

public function integer wf_format_datawindow (datawindow adw_master, s_system_base_parm astr_parm[]);/********************************************************************
   wf_format_datawindow
   <DESC>	Mandatory column format and register	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_master: A reference to a datawindow control
		astr_parm[]: Array of mandatory column and if the columns need to be unique 
   </ARGS>
   <USAGE>	window open	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		06/06/14		CR3427	CCY018	First Version
   </HISTORY>
********************************************************************/

integer li_upper
n_dw_style_service   lnv_style

inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

for li_upper = 1 to upperbound(astr_parm)
	if isnull(astr_parm[li_upper].mandatorycol) or trim(astr_parm[li_upper].mandatorycol) = '' then continue
	
	lnv_style.of_registercolumn(astr_parm[li_upper].mandatorycol, true)
	
	if _registermandatorycol( adw_master, &
                             astr_parm[li_upper].mandatorycol, &
                             astr_parm[li_upper].duplicatecheck, &
                             astr_parm[li_upper].casesensitive) = C#Return.Failure then
		messagebox("Datawindow init failed", "Failed to register mandatory column " + astr_parm[li_upper].mandatorycol + ".")
	end if
next

if adw_master.object.datawindow.processing = '1' then
	return lnv_style.of_dwlistformater(adw_master, false)
else
	return lnv_style.of_dwformformater(adw_master)
end if

end function

private function integer _registermandatorycol (datawindow adw_master, string as_mandatorycol, boolean ab_duplicatecheck, boolean ab_casesensitive);/********************************************************************
   _registermandatorycol
   <DESC>	Mandatory column register for validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		adw_master: A reference to a DataWindow control
		as_mandatorycol: Mandatory column name
		ab_duplicatecheck: a check to see if the column needs to be unique.  when enabled system
		ab_casesensitive: case sensitive duplicate check
   </ARGS>
   <USAGE>	wf_format_datawindow()	</USAGE>
   <HISTORY>
		Date			CR-Ref	         Author	Comments
      06/06/14    CR3427	         CCY018	First Version
      07/25/14    CR3348 & CR3700   SSX014   Add the case insensitive duplicate check support 
   </HISTORY>
********************************************************************/

string ls_coltype, ls_displayname
integer li_return

//Do not use shared variable, eg. inv_servicemgr.of_loadservice(inv_validation, "n_dw_validation_service")
if not isvalid(inv_validation) then
	inv_validation = create n_dw_validation_service
end if

if isnull(as_mandatorycol) or trim(as_mandatorycol) = '' then return c#return.NoAction

ls_displayname = adw_master.describe(as_mandatorycol + "_t.text")
if ls_displayname = '!' or trim(ls_displayname) = '' then ls_displayname = as_mandatorycol

ls_coltype = lower(left(adw_master.describe(as_mandatorycol + ".Coltype"), 5))
choose case ls_coltype
	case 'char('
		li_return = inv_validation.of_registerrulestring(as_mandatorycol, true, ""/*as_validated*/, ls_displayname, ab_duplicatecheck, ab_casesensitive)		
	case 'numbe', 'real', 'long', 'ulong', 'int'
		li_return = inv_validation.of_registerrulenumber(as_mandatorycol, true, ls_displayname)
	case 'decim'
		li_return = inv_validation.of_registerruledecimal(as_mandatorycol, true, ls_displayname)
	case 'datet'
		li_return = inv_validation.of_registerruledatetime(as_mandatorycol, true, ls_displayname, ab_duplicatecheck)
	case else
		li_return = C#Return.Failure
end choose

return li_return
end function

public function integer wf_get_update_properties ();long ll_col, ll_colcount 
string ls_iskey

is_update_table = dw_1.describe( "datawindow.table.updatetable")
ll_colcount = long(dw_1.describe( "datawindow.column.count"))

for ll_col = 1 to ll_colcount
	ls_iskey = dw_1.describe( "#"+ string(ll_col) +".key")
	if ls_iskey = "yes" then
		is_key[upperbound(is_key) + 1] = dw_1.describe( "#"+ string(ll_col) +".name")
	end if
next

return c#return.Success
end function

public function string wf_getitem (long al_row, string as_colname);string ls_coltype, ls_value
mt_n_stringfunctions	lnv_stringService

ls_coltype = dw_1.describe(as_colname + ".coltype")

choose case lower(left(ls_coltype, 5))
	case "int", "long", "ulong", left("number", 5), "real"
		ls_value = string(dw_1.getitemnumber(al_row, as_colname))
	case left("decimal", 5)
		ls_value = string(dw_1.getitemdecimal(al_row, as_colname))
	case "date"
		ls_value = "'" + string(dw_1.getitemdate(al_row, as_colname)) + "'"
	case "time", "times"
		ls_value = "'" + string(dw_1.getitemtime(al_row, as_colname)) + "'"
	case left("datetime", 5)
		ls_value = "'" + string(dw_1.getitemdatetime(al_row, as_colname)) + "'"
	case else
		ls_value = dw_1.getitemstring(al_row, as_colname) 
		ls_value = lnv_stringService.of_replaceAll(ls_value, "'", "''", true)
		ls_value = "'" + ls_value + "'"
end choose

return ls_value
end function

public function integer wf_delete_row (long al_row);string ls_sql, ls_where, ls_value, ls_dbname
long ll_key

ls_sql = "DELETE FROM " + is_update_table

for ll_key = 1 to upperbound(is_key)
	ls_value = wf_getitem(al_row, is_key[ll_key])
	ls_dbname = dw_1.describe(is_key[ll_key] + ".dbname")
	if len(ls_where) > 0 then ls_where += " AND "
	ls_where += ls_dbname + " = " + ls_value
next

ls_sql += " WHERE " + ls_where

EXECUTE IMMEDIATE :ls_sql;
if sqlca.sqlcode = 0 then
	COMMIT;
	return c#return.Success
else
	ROLLBACK;
	return c#return.Failure
end if
end function

on w_system_base.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_refresh=create cb_refresh
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_refresh
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.dw_1
end on

on w_system_base.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_refresh)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.dw_1)
end on

event closequery;ib_showmessage = false
dw_1.accepttext()
if dw_1.modifiedcount() + dw_1.deletedcount() > 0 then
	if messagebox("Updates Pending", "Data has been changed, but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

if isvalid(inv_validation) then
	destroy inv_validation
end if

return 0
end event

event open;call super::open;this.triggerevent("ue_preopen")

dw_1.settransobject(sqlca)
dw_1.retrieve()

if ib_update_after_del then wf_get_update_properties()
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_system_base
end type

type cb_cancel from mt_u_commandbutton within w_system_base
integer x = 1536
integer y = 816
integer taborder = 49
string text = "&Cancel"
end type

event clicked;long ll_row

ll_row = dw_1.getrow()

dw_1.setredraw(false)
dw_1.retrieve()

if ll_row > 0 then
	dw_1.setrow(ll_row)
	dw_1.scrolltorow(ll_row)
end if
	
dw_1.setfocus()
dw_1.setredraw(true)
end event

type cb_refresh from mt_u_commandbutton within w_system_base
boolean visible = false
integer x = 1947
integer y = 1332
integer taborder = 60
string text = "&Refresh"
end type

event clicked;dw_1.retrieve()
end event

type cb_delete from mt_u_commandbutton within w_system_base
integer x = 1189
integer y = 816
integer taborder = 40
string text = "&Delete"
end type

event clicked;/********************************************************************
   clicked
   <DESC>	
		1.Perform the predelete process.
		2.delete select row.
		3.Perform the postdelete process.
	</DESC>
   <RETURN>	long:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

long ll_row

ll_row = dw_1.getrow()
if ll_row > 0 then
	if parent.event ue_predelete() = c#return.Failure then return c#return.Failure
	if parent.event ue_delete() = c#return.Failure then return c#return.Failure
	parent.event ue_postdelete()
end if
end event

type cb_update from mt_u_commandbutton within w_system_base
integer x = 841
integer y = 816
integer taborder = 30
string text = "&Update"
boolean default = true
end type

event clicked;/********************************************************************
   clicked
   <DESC>	Data validation and update	
		1.Perform the presave process.
		2.Data validation
		3.Perform the preupdate process.
		4.Update the changed objects.
		5.Perform the postupdate process.
	</DESC>
   <RETURN>	long:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01-03-2013 2614         LHG008        First Version
   	30-05-2013 CR3427       LHG008        Improvement
	10/06/14		CR3427		CCY018		Improvement.
   </HISTORY>
********************************************************************/

if dw_1.accepttext() = -1 then return c#return.Failure
if parent.event ue_presave() = c#return.Failure then
	return c#return.Failure
end if

if wf_validate(dw_1, inv_validation) = c#return.Failure then
	return c#return.Failure
end if

if parent.event ue_preupdate( ) = c#return.Failure then return c#return.Failure

if parent.event ue_update() = c#return.Failure then return c#return.Failure

parent.event ue_postupdate()

return C#Return.Success
end event

type cb_new from mt_u_commandbutton within w_system_base
integer x = 494
integer y = 816
integer taborder = 20
string text = "&New"
end type

event clicked;/********************************************************************
   clicked
   <DESC>	
		1.Perform the preadd process.
		2.insert a row.
		3.1.Perform the postadd process.
	</DESC>
   <RETURN>	long:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
   	02/07/14	CR3427		CCY018	First Version
   </HISTORY>
********************************************************************/

if dw_1.accepttext( ) = -1 then return c#return.Failure
if parent.event ue_preadd() = c#return.Failure then return c#return.Failure
if parent.event ue_add() = c#return.Failure then return c#return.Failure
parent.event ue_postadd() 
end event

type dw_1 from u_datagrid within w_system_base
integer x = 37
integer y = 32
integer width = 1842
integer height = 752
integer taborder = 10
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;if ib_newstandard = true then
else
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

event itemerror;call super::itemerror;if ib_showmessage = false then
	ib_showmessage = true
	return 1
end if
end event

event retrieveend;call super::retrieveend;if this.getrow() = 1 then
	this.event rowfocuschanged(1)
end if
end event

