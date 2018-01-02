$PBExportHeader$w_crm_interface.srw
forward
global type w_crm_interface from mt_w_sheet
end type
type dw_export from mt_u_datawindow within w_crm_interface
end type
end forward

global type w_crm_interface from mt_w_sheet
boolean visible = false
integer width = 3826
integer height = 1616
string title = "CRM Interface"
boolean minbox = false
boolean maxbox = false
dw_export dw_export
end type
global w_crm_interface w_crm_interface

type variables
s_command_line	istr_command_line

n_error_service		inv_error_service		//Log file service
mt_n_stringfunctions	inv_stringfunctions	//Commend line parameters resolving object
n_service_manager		inv_service_manager	//Service manager
n_crm_interface		inv_crm_interface		//CRM interface

constant string	is_format_date = "yyyymmdd"	//Date format for file name


end variables

on w_crm_interface.create
int iCurrent
call super::create
this.dw_export=create dw_export
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_export
end on

on w_crm_interface.destroy
call super::destroy
destroy(this.dw_export)
end on

event open;call super::open;string	ls_commandline
n_dw_style_service   lnv_style

//Register the log file service
inv_service_manager.of_loadservice(inv_error_service, "n_error_service")
inv_crm_interface = create n_crm_interface

//Initialize parameters from command line structure
ls_commandline = message.stringparm
if isnull(ls_commandline) or ls_commandline = "" then
	inv_crm_interface.of_write_log( inv_crm_interface.is_LOG_INTERFACE_END, istr_command_line.as_log_level, c#log_level.is_LOW)
	destroy  inv_crm_interface
	close(this)
	return
else
	//If any error occured close window and exist application
	if inv_crm_interface.of_get_parameters(istr_command_line, ls_commandline) = c#return.Failure then
		inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_INTERFACE_END, istr_command_line.as_log_level, c#log_level.is_LOW)
		destroy  inv_crm_interface
		close(this)
		return
	end if
end if
//Connect database
inv_crm_interface.of_set_database(istr_command_line)

inv_crm_interface.of_connect_database()


//Set up data container resource
choose case lower(istr_command_line.as_export)
	case "f"
		dw_export.dataobject = "d_sp_gr_financials_crm"
	case "rsf"
		dw_export.dataobject = "d_sp_gr_recent_spot_fixtures"
	case else
		inv_crm_interface.of_write_log( inv_crm_interface.is_LOG_INTERFACE_END, istr_command_line.as_log_level, c#log_level.is_HIGH)
		destroy  inv_crm_interface
		close(this)
		return
end choose

inv_service_manager.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_export, false)

dw_export.settrans(sqlca)
//Retrieving data, When product phase, it would be changed to one retrieve sentence
dw_export.retrieve(0)
dw_export.setrowfocusindicator(Off!)


string	ls_filename
//Export the data as CSV format file
ls_filename = istr_command_line.as_folder_file + "\" + upper(istr_command_line.as_export) + "_" + string(today(), is_format_date) + ".CSV"
//Deleted the exists file
if fileexists(ls_filename) then 
	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_FILE_EXIST, istr_command_line.as_log_level, c#log_level.is_HIGH)
	if not filedelete(ls_filename) then inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_FILE_DELETE, istr_command_line.as_log_level, c#log_level.is_HIGH)
end if
//Save as CSV file
if dw_export.saveas(ls_filename, CSV!, true) = 1 then
	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_CSV_SUCCESS, istr_command_line.as_log_level, c#log_level.is_LOW)
else
	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_CSV_FAILED, istr_command_line.as_log_level, c#log_level.is_HIGH)
end if

inv_crm_interface.of_write_log( inv_crm_interface.is_LOG_INTERFACE_END, istr_command_line.as_log_level, c#log_level.is_LOW)
//according to running mode for application termination
if istr_command_line.as_mode = "window" then
	this.center = true
	this.visible = true
else
	destroy  inv_crm_interface
	close(this)
	return
end if



end event

type dw_export from mt_u_datawindow within w_crm_interface
integer x = 18
integer y = 20
integer width = 3749
integer height = 1472
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event retrieveend;call super::retrieveend;//string	ls_filename
////Export the data as CSV format file
//ls_filename = istr_command_line.as_folder_file + "\" + upper(istr_command_line.as_export) + "_" + string(today(), is_format_date) + ".CSV"
////Deleted the exists file
//if fileexists(ls_filename) then 
//	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_FILE_EXIST, istr_command_line.as_log_level, c#log_level.is_HIGH)
//	if not filedelete(ls_filename) then inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_FILE_DELETE, istr_command_line.as_log_level, c#log_level.is_HIGH)
//end if
////Save as CSV file
//if dw_export.saveas(ls_filename, CSV!, true) = 1 then
//	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_CSV_SUCCESS, istr_command_line.as_log_level, c#log_level.is_LOW)
//else
//	inv_crm_interface.of_write_log(inv_crm_interface.is_LOG_CSV_FAILED, istr_command_line.as_log_level, c#log_level.is_HIGH)
//end if
end event

event clicked;call super::clicked;integer li_selectedrow
if row > 0 then 
	li_selectedrow = this.getselectedrow(0)
	if li_selectedrow > 0 then this.selectrow(li_selectedrow, false)
	this.selectrow(row, not this.isselected(row))
end if
end event

event dberror;integer li_return, li_upper
string ls_receiver, ls_subject, ls_errormessage, ls_emailtext, ls_creator
constant string METHOD = "dberror"

mt_n_outgoingmail	lnv_mail

inv_error_service.of_dblogging( true )
ls_subject = "CRM Interface: unexpected error has occured. (dbcode=" + string(sqldbcode) + ")"

inv_error_service.of_addmsg(this.classdefinition, METHOD, sqlerrtext + "(dbcode=" + string(sqldbcode) + ")", sqlerrtext + "(dbcode=" + string(sqldbcode) + ")", 2)

if upperbound(istr_command_line.as_emailto) > 0 then
	lnv_mail = create mt_n_outgoingmail
	ls_receiver = istr_command_line.as_emailto[1]
		
	ls_emailtext = "There has been a problem with the CRM interface, error messages which lead up to the critical error follow:~r~n~r~n" + &
						sqlerrtext + "(dbcode=" + string(sqldbcode) + ")" + &
						"~r~n~r~nIt is recommended you resolve the problem and resend CRM file at your earliest convienience."
	
	li_return = lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receiver, ls_subject, ls_emailtext, ls_errormessage)
	
	//Set mail creator as this application is not running using tramos id
	if li_return = c#return.Failure then
		_addmessage(this.classdefinition, "dberror", "error, could not set creator when attempting to smtp mail, error detail:" + ls_errormessage, "")			
	else
		ls_creator = sqlca.logid
		li_return = lnv_mail.of_setcreator(ls_creator, ls_errormessage)
	end if
	
	//Add email address
	if li_return = c#return.Success then
		for li_upper = 2 to upperbound(istr_command_line.as_emailto)
			li_return = lnv_mail.of_addreceiver(istr_command_line.as_emailto[li_upper], ls_errormessage)
			if li_return = c#return.Failure then exit
		next
	end if
	
	//Sent mail
	if li_return = c#return.Failure then
		_addmessage(this.classdefinition, "dberror", "error can not send notification email, error detail:" + ls_errorMessage, "")
	else
		li_return = lnv_mail.of_sendmail(ls_errorMessage)
	end if			
		
	lnv_mail.of_reset()
	destroy lnv_mail		
end if

return 3

end event

