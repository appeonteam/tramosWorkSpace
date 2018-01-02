$PBExportHeader$n_interfacelogicexchangerates.sru
$PBExportComments$business logic code for Exchange Rates (Tramos incoming)
forward
global type n_interfacelogicexchangerates from n_interfacelogic
end type
end forward

global type n_interfacelogicexchangerates from n_interfacelogic
end type
global n_interfacelogicexchangerates n_interfacelogicexchangerates

type variables
mt_n_datastore		ids_target

end variables

forward prototypes
public function integer of_go (ref s_interface astr_interfaces[])
public subroutine documentation ()
public function integer of_registersource (string as_sourcedataobject)
public function integer of_updateinterfacedata (ref mt_n_datastore ads_target)
end prototypes

public function integer of_go (ref s_interface astr_interfaces[]);/********************************************************************
   of_go()
   <DESC>	The main process</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>

   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date        CR-Ref   Author    	Comments
	27/02/2013	 	CR3172	AGL027		Intergrated into Interface Manager
   </HISTORY>
********************************************************************/


integer  li_fileindex
string	ls_errortext="", ls_archivefilepath, ls_workingfilepath, ls_foundfilepath, ls_newfiles[]
string ls_dataline
integer li_rc, li_importfilehandle
decimal {6} ld_exrate_DKK, ld_exrate_USD
string ls_filename = ""
datetime ldt_date
long ll_row, ll_found
n_exchangerates lnv_exrate

if of_outstandingfiles(astr_interfaces[1], "*.txt", ls_newfiles) = 0 then return c#return.NoAction

/* validate connection */
if sqlca.sqlcode <> 0 then
		of_writetolog("critical database error, unable to connect to database. sqlcode="+string(sqlca.sqlcode) + " sqlerrtext='" + sqlca.sqlerrtext + "'",ii_LOG_IMPORTANT)
	sqlca.of_rollback()
	sqlca.of_disconnect()
	return c#return.Failure
end if
sqlca.of_commit()

/* under normal circumstances this will only have 1 file */
lnv_exrate = create n_exchangerates
li_fileindex = 1
do while li_fileindex <= upperbound(ls_newfiles)
	ls_filename += astr_interfaces[1].s_filenameprefix + string(today(), "yyyymmdd") + "~~" + ls_newfiles[li_fileindex]
	
	ls_foundfilepath = astr_interfaces[1].s_folderlocation + ls_newfiles[li_fileindex]
	ls_workingfilepath = astr_interfaces[1].s_folderworking + ls_filename
	ls_archivefilepath = astr_interfaces[1].s_folderarchive + ls_filename
	
	if of_filemove(ls_foundfilepath,ls_workingfilepath,"")=c#return.Success then
		/* read file and prepare update */
		if lnv_exrate.of_readfile(ids_source[1], ids_target, ls_workingfilepath, ls_errortext)=c#return.Success then
			if ls_errortext<>"" then of_writetolog(ls_errortext,ii_LOG_IMPORTANT)
			if lnv_exrate.of_update(ids_target) = c#return.Success then
				of_writetolog("completed exchange rate processing for file " + ls_workingfilepath,ii_LOG_IMPORTANT)
			else
				of_writetolog("error, update failed for file " + ls_workingfilepath,ii_LOG_IMPORTANT)				
			end if		
		else
			of_writetolog(ls_errortext,ii_LOG_IMPORTANT)
		end if
	end if
	
	/* archive file */
	if ls_workingfilepath<>ls_archivefilepath and ls_archivefilepath<>"" then
		of_filemove(ls_workingfilepath,ls_archivefilepath,"")
	elseif ls_workingfilepath=ls_archivefilepath then
		/* leave as is */
	end if	
	li_fileindex++
loop
destroy lnv_exrate

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogicack
	
	<OBJECT>
		business logic handling confirmation message processing
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author	Comments
  	27/03/12 	M5-5  AGL		First Version & intergration of Appeon code
********************************************************************/
end subroutine

public function integer of_registersource (string as_sourcedataobject);super::of_registersource(as_sourcedataobject, false)
/* setup target ds as well*/
ids_target = create mt_n_datastore
ids_target.dataobject = "d_sq_tb_import_exrates"
ids_target.settransobject(sqlca)
return c#return.Success
end function

public function integer of_updateinterfacedata (ref mt_n_datastore ads_target);if ads_target.update() = 1 then
	sqlca.of_commit()
else
	sqlca.of_rollback()
	Return c#return.Failure
end if

return c#return.Success
end function

on n_interfacelogicexchangerates.create
call super::create
end on

on n_interfacelogicexchangerates.destroy
call super::destroy
end on

