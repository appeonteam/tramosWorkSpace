$PBExportHeader$n_interfacelogic.sru
$PBExportComments$base business logic code
forward
global type n_interfacelogic from n_interface
end type
end forward

global type n_interfacelogic from n_interface
end type
global n_interfacelogic n_interfacelogic

type variables
mt_n_datastore			ids_source[]			/* the source datastores */
oleobject 				iole_shellcmd			/* proven way to open mq series connectivity */
integer					ii_mastersource		/* used to determine which table is the master */
boolean					ib_sentmail	= false	
end variables

forward prototypes
public subroutine documentation ()
public function integer of_setfilter (string as_filterstring)
public function integer of_registersource (string as_sourcedataobject, boolean ab_master)
public function integer of_registersource (string as_sourcedataobject)
public function long of_oustandingtransactions ()
public function integer of_initialisefolder (ref string as_folder)
public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle)
public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename)
protected function integer of_generate (ref s_interface astr_interface, string as_filename)
protected function integer of_mqserieshandler (ref s_interface astr_interface, string as_filename)
protected function integer of_updatesource (string as_filename)
protected function integer of_updateinterfacedata (ref s_interface astr_interface)
public function string of_writefooterrecord (ref s_interface str_interface, string as_filename)
public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename)
public function string of_createfilename (ref s_interface astr_interface)
public function integer of_go (ref s_interface astr_interfaces[])
public function integer of_writetolog (s_interface astr_interface, string as_text, integer ai_loglevel)
public function integer of_filemove (string as_sourcename, string as_targetname, string as_updatemode)
public function integer of_filecopy (string as_sourcename, string as_targetname, string as_errorname)
public function integer of_outstandingfiles (s_interface astr_interface, string as_wildcard, ref string as_newfiles[])
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogic
	
	<OBJECT>
		Contains shared logic across all interfaces
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		ancestor object
	</USAGE>
   	<ALSO>
		
		n_interface
		|	+ *n_interfacelogic*
		|	|	+	n_interfacelogicvm
		|	|	+ 	n_interfacelogicax
			+ n_interfaceprocess
		
	
	</ALSO>
    	Date   		Ref    	Author   		Comments
  	03/01/12 	?      	AGL			First Version
	27/03/12		M5-5		AGL			Apply prefix to all filenames 
	13/09/16		CR3320	AGL			Use framework object to check outstanding confirmation files
	19/12/16		CR4592	AGL			Allow overwrite of confirmation files
********************************************************************/
end subroutine

public function integer of_setfilter (string as_filterstring);if ii_mastersource>0 then
	ids_source[ii_mastersource].setfilter(as_filterstring)
	ids_source[ii_mastersource].filter()
end if

return c#return.Success
end function

public function integer of_registersource (string as_sourcedataobject, boolean ab_master);integer li_index

li_index = upperbound(ids_source)+1

ids_source[li_index] = create mt_n_datastore
ids_source[li_index].dataobject = as_sourcedataobject
ids_source[li_index].settransobject(sqlca)

if ab_master then
	ii_mastersource = li_index
end if	

return c#return.Success
end function

public function integer of_registersource (string as_sourcedataobject);return of_registersource(as_sourcedataobject, true)
end function

public function long of_oustandingtransactions ();/* this is where we retreive the data and return the amount of oustanding records found */
long ll_index

for ll_index = 1 to upperbound(ids_source)
	/* perhaps add some particular retrieval arguments here */
next

return 1
end function

public function integer of_initialisefolder (ref string as_folder);if as_folder = "" or isnull(as_folder) then 
	of_writetolog("error, there is no path for the placement of the files", ii_LOG_IMPORTANT)
	as_folder = "error"
	return c#return.Failure
else
	/* Make sure the path ends with a '\' */
	as_folder = righttrim(as_folder)
	if right(as_folder,1) <> "\" then
		as_folder = as_folder + "\"
	end if
end if

return c#return.Success

end function

public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle);return c#return.Success
end function

public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename);/********************************************************************
   of_extendedlogic()
	
<DESC>   
	A placeholder to apply unique business logic if it is required.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	astr_interface: interface data structure
	as_filename: filename with the data
</ARGS>
<USAGE>
	What to do with the file we have generated????
	This function is useful if process has a unique business logic after the file
	has been generated.  
	The interface might want to send the file via mq series.  If that is the case
	the decendent object will call the appropriate function. of_mqserieshandler() 
	in this case.
</USAGE>
********************************************************************/

return c#return.Success
end function

protected function integer of_generate (ref s_interface astr_interface, string as_filename);/********************************************************************
   of_generate()
<DESC>   
	This function creates the file in the operation system 
	Calls the file writer functions to build the data.
	Updates the source table (basically fills in the filename column with what has been passed in)
	Calls the of_extendedlogic() function
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ast_interface: interface structire
	as_Arg2: Description
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

integer li_filehandle, li_fileclose

/* create and open the file.  lock file for reading/writing */
li_filehandle = fileopen(astr_interface.s_folderworking + as_filename, linemode!, write!, lockreadwrite!, append!)
if li_filehandle < 0 then
	of_writetolog("error, it was not possible to create or open the file.  check the folder exists " + astr_interface.s_folderworking,ii_LOG_IMPORTANT)
	return (c#return.Failure)
else
	/* this next function writes the header, detail and footer data into the file */
	if of_writefiledata(astr_interface, as_filename, li_filehandle) = c#return.Failure then	
		return c#return.Failure	
	else
		/* if previous process successful close file */
		li_fileclose = fileclose(li_filehandle)
		
		if li_fileclose < 0 then 
			/* file creation was not successful */
			of_writetolog("error, it was not possible to close the generated file " + as_filename, ii_LOG_IMPORTANT)
			return c#return.Failure
			
		elseif li_fileclose = 1 then
			/* file creation was successful. Insert file date, user and name into datawindow and save it. */
			of_writetolog(astr_interface, "info, processing " + as_filename,ii_LOG_NORMAL)
			if of_updatesource(as_filename) = c#return.Failure then
				return c#return.Failure 	
			else
				if of_extendedlogic(astr_interface, as_filename) = c#return.Failure then
					return c#return.Failure 	
				end if	
			end if
		end if	
	end if
end if

return c#return.Success
end function

protected function integer of_mqserieshandler (ref s_interface astr_interface, string as_filename);/********************************************************************
   of_mqserieshandler()

<DESC>   
	Used for all processes requiring MQ series processing
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_interface : structure containing interface data
	as_filename : newly created filename. (path resides inside structure)
</ARGS>
<USAGE>
	Designed to be called from decendent objects function: of_extendedlogic()

	Build up the parameters required to send the data to MQSeries. 
	
	ms-dos command file needs to contain soemthing like:
	
	'C:\MQS\UTIL\MQSUUWS %1 %2 %3 >%4'
	
	The parameters that it expects follow with example data
	
	%1 = file to send to queue   		1303120005.voy
	%2 = queue manager					TRAMOS
	%3 = queue name						ACE.TRANSACTIONS.TANK
	%4 = output file from MQSUUWS		tramos2wmq_voy.txt
</USAGE>
********************************************************************/


string ls_batchstring, ls_success, ls_outputfile, ls_mwsuuwsoutput
integer li_fromshell, li_filehandle, li_batfilehandle, li_filewriter
string ls_batchfilename = "mqseriesinterfacecontrol.cmd"

CONSTANT integer li_MAX = 3
CONSTANT integer li_MIN = 2
CONSTANT integer li_NORMAL = 1
CONSTANT boolean lb_WAIT = TRUE
CONSTANT boolean lb_NOWAIT = FALSE

ls_success="ends OK."

/* check the MQ series executable */
if not fileexists(gs_mqsuuwsfilename) then
	of_writetolog(astr_interface,"error, unable to locate MQSUUWS executable in application folder.",ii_LOG_IMPORTANT)
	return c#return.Failure	
end if	

/* create ms-dos command file if it doesn't exist already */
if not fileexists(ls_batchfilename) then
	li_batfilehandle = fileopen(ls_batchfilename, linemode!, write!, lockWrite!, append!)
	if li_batfilehandle<0 then
		of_writetolog(astr_interface,"error, unable to create mq series batch file " + ls_batchfilename + ".",ii_LOG_IMPORTANT)
		return c#return.Failure	
	else 
		li_filewriter = filewrite(li_batfilehandle,"MQSUUWS %1 %2 %3 >%4")
		fileclose(li_batfilehandle)
		if li_filewriter < 0 then
			of_writetolog(astr_interface,"error, it was not possible to create the ms-dos command file for mq series processing.",ii_LOG_IMPORTANT)
			return c#return.Failure
		else
			of_writetolog(astr_interface,"info, created ms-dos command file " + ls_batchfilename + " inside application folder for mq series processing.",ii_LOG_IMPORTANT)
		end if	
	end if	
end if	

/* build parameters to pass into ms-dos command file */
ls_batchstring = ls_batchfilename + " " + astr_interface.s_folderlocation + as_filename + " " + astr_interface.s_mqqueuemanager + " "
ls_outputfile="tramos2mq_" + astr_interface.s_description + ".txt"
ls_batchstring += astr_interface.s_mqqueuename + " " + ls_outputfile
	
/* execute os shell process */	
li_fromshell = iole_shellcmd.Run(ls_batchstring , li_MIN, lb_WAIT)

/* validate output from shell process */
of_writetolog(astr_interface,"info, return value from win.shell=" + string(li_fromshell),ii_LOG_NORMAL)
li_filehandle = FileOpen( ls_outputfile, TextMode! )
filereadex( li_filehandle, ls_mwsuuwsoutput )	
li_filehandle = fileclose( li_filehandle )
of_writetolog(astr_interface,"info, <mwsuuws output>",ii_LOG_DEBUG)
of_writetolog(ls_mwsuuwsoutput,ii_LOG_DEBUG)
of_writetolog(astr_interface,"info, </mwsuuws output>",ii_LOG_DEBUG)
if pos( ls_mwsuuwsoutput, ls_success ) < 1 then
	of_writetolog(astr_interface,"error, mqsuuws process failed for file " + as_filename + ".",ii_LOG_IMPORTANT)
	return c#return.Failure
else
	of_writetolog(astr_interface,"notice, mqsuuws returns:" + ls_success,ii_LOG_NORMAL)
	return c#return.Success
end if
end function

protected function integer of_updatesource (string as_filename);long ll_row
string ls_userid

ls_userid = sqlca.userid

for ll_row = 1 to ids_source[ii_mastersource].rowcount()
	ids_source[ii_mastersource].setitem(ll_row,"file_date",today())
	ids_source[ii_mastersource].setitem(ll_row,"file_name",as_filename)
next

if ids_source[ii_mastersource].update(true, false) <> 1 then
	of_writetolog("error, it was not possible to insert file data into the source table",ii_LOG_IMPORTANT)
	return c#return.Failure
end if


return c#return.Success

end function

protected function integer of_updateinterfacedata (ref s_interface astr_interface);long ll_index
mt_n_datastore lds_interfaces
integer li_returnflag = c#return.NoAction


	lds_interfaces = create mt_n_datastore
	lds_interfaces.dataobject="d_sq_gr_interfacelist"
	lds_interfaces.settransobject(sqlca)
	lds_interfaces.retrieve()
	
	if lds_interfaces.rowcount( )>0 then
		for ll_index = 1 to lds_interfaces.rowcount( )
			if lds_interfaces.getitemnumber(ll_index,"id") = astr_interface.l_id then
				lds_interfaces.setitem(ll_index,"last_processed",astr_interface.dtm_lastprocessed)
				lds_interfaces.setitem(ll_index,"filename_counter",astr_interface.i_filenamecounter)
				lds_interfaces.setitem(ll_index,"sourceref_counter",astr_interface.l_sourcereferencecounter)
				if lds_interfaces.update(true, false) = 1 then
					li_returnflag = c#return.Success				
				else
					li_returnflag = c#return.Failure				
				end if	
				exit 
			end if
		next
	end if

return li_returnflag
end function

public function string of_writefooterrecord (ref s_interface str_interface, string as_filename);return ""
end function

public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename);return ""
end function

public function string of_createfilename (ref s_interface astr_interface);/********************************************************************
   of_createfilename()
	
<DESC>   
	Taken from (soon to be) obsolete application wmqtransactionlog, this function returns the standard filename

</DESC>
<RETURN>
	String:
		<LI> filename
		
	         1 
	1234567890123456789
	1301120012.TXT
	
	where chars 
	1-2   day of month
	3-2   month reference
	5-2   two digit year
	7-4 counter during current day.
	12-3 file extension		
		
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_interface: interface structure
</ARGS>
<USAGE>
	Call only once each time you want to generate a new file.  
	A limitation includes we can have only 9999 files in a single day.
	It also tests if file exists already.  In this case it logs the entry in logfile & returns 
	string 'error' instead of the filename.
</USAGE>
********************************************************************/

string ls_filename, ls_hexfilename
datetime ldt_filedate
integer li_fileno
datetime ldtm_date

if date(astr_interface.dtm_lastprocessed) <> today() then
	astr_interface.i_filenamecounter = 1
elseif (date(astr_interface.dtm_lastprocessed) = today()) and (astr_interface.i_filenamecounter < 9999) then
	astr_interface.i_filenamecounter ++
elseif (date(astr_interface.dtm_lastprocessed) = today()) and (astr_interface.i_filenamecounter > 9999) then
	of_writetolog("error, more than 9999 files for interface '" + astr_interface.s_description + "' have been generated. it is not possible to create more today!",ii_LOG_IMPORTANT)
	ls_filename = "error"
	return(ls_filename)
end if

astr_interface.dtm_lastprocessed = datetime(string(today(), "dd/mm/yyyy hh:mm"))

ls_filename = upper(astr_interface.s_filenameprefix + string(today(),"ddmmyy") + string(astr_interface.i_filenamecounter,"0000") + ".txt")

if fileexists(astr_interface.s_folderworking + ls_filename) then
	if filedelete(astr_interface.s_folderworking + ls_filename) then
		of_writetolog("warning, file '" + ls_filename + " already exists.  deleting existing file!",ii_LOG_IMPORTANT)
	else
		of_writetolog("error, file '" + ls_filename + "' already exists and can not delete previous file!",ii_LOG_IMPORTANT)
		ls_filename = "error"
	end if	
end if

return(ls_filename)
end function

public function integer of_go (ref s_interface astr_interfaces[]);/********************************************************************
   of_go()
<DESC>   
	The main process
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/



string ls_filename, ls_filepath
boolean lb_success=true


/* validate connection */
if sqlca.sqlcode <> 0 then
		of_writetolog("critical database error, unable to connect to database. sqlcode="+string(sqlca.sqlcode) + " sqlerrtext='" + sqlca.sqlerrtext + "'",ii_LOG_IMPORTANT)
	sqlca.of_rollback()
	sqlca.of_disconnect()
	return c#return.Failure
end if
sqlca.of_commit()

if of_oustandingtransactions()>0 then

	ls_filename = of_createfilename(astr_interfaces[1])
	if ls_filename = "error" Then 
		lb_success = false
	else
		if of_generate(astr_interfaces[1], ls_filename) = c#return.Failure then
			lb_success = false
		else
			/* update interface with updated structure */	
			if of_updateinterfacedata(astr_interfaces[1]) <> c#return.Success then
				lb_success = false
			end if	
		end if
	end if
	
	if lb_success then
		sqlca.of_commit()
		return c#return.Success		
	else
		sqlca.of_rollback()
		/* 
		important that rollback is before next call due to mail object
		forcing a commit on transactin object sqlca. 
		*/
		of_writetolog("critical error, process failed confirming rollback",ii_LOG_IMPORTANT)
		return c#return.Failure		
	end if	

else
	/* nothing to do */
	return c#return.NoAction
end if	
end function

public function integer of_writetolog (s_interface astr_interface, string as_text, integer ai_loglevel);return of_writetolog(as_text + " (" + astr_interface.s_name + ")", ai_loglevel)
end function

public function integer of_filemove (string as_sourcename, string as_targetname, string as_updatemode);/********************************************************************
of_filemove( /*string as_sourcename*/, /*string as_targetname*/, /*string as_errorname */ )

<DESC>
	when moving files this is 
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_sourcename : path and filename of source
	as_targetname : path and filename of target (filename matches that of as_sourcename)
	as_updatemode : if unable to simply move file option _REPLACE_ attempts to replace the target 
						 with source, if no option error message is written to log and function returns false
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
integer li_movesuccess, li_extensionpos
string ls_trucatedsource, ls_trucatedtarget, ls_existingrenamed

li_movesuccess = filemove(as_sourcename,as_targetname)

if len(as_sourcename)>52 then 
	ls_trucatedsource = "..." + right(as_sourcename,52)
else
	ls_trucatedsource = as_sourcename
end if	
if len(as_targetname)>52 then 
	ls_trucatedtarget = "..." + right(as_targetname,52)
else
	ls_trucatedtarget = as_targetname
end if

CHOOSE CASE li_movesuccess
	CASE -1
		of_writetolog("critical error moving file, can not read source file " + ls_trucatedsource,ii_LOG_IMPORTANT)
		return c#return.Failure
	CASE -2
		if upper(as_updatemode)="_REPLACE_" then
			if fileexists(as_targetname) then
     			if filedelete(as_targetname) then
					li_movesuccess = filemove(as_sourcename, as_targetname)
					if li_movesuccess = c#return.Success then
						of_writetolog("processed, replaced target " + ls_trucatedtarget + "." ,ii_LOG_NORMAL)	
						return c#return.Success
					else
						of_writetolog("error, could not access target " + ls_trucatedtarget + " to replace it, is file open by another process?",ii_LOG_IMPORTANT)															
					end if
				else
					of_writetolog("error, could not delete target file " + ls_trucatedtarget + ", is file open by another process?",ii_LOG_IMPORTANT)																				
				end if	
			else 
				of_writetolog("error, unable to move file " + ls_trucatedsource + " into " + ls_trucatedtarget + ".",ii_LOG_IMPORTANT)																								
			end If
		else
			of_writetolog("error, could not write file " + ls_trucatedsource + " to target location " + ls_trucatedtarget + ".",ii_LOG_IMPORTANT)							
		end if	
		return c#return.Failure		
	CASE ELSE
		of_writetolog("processed, successful move of file " + ls_trucatedsource + " to target " + ls_trucatedtarget,ii_LOG_NORMAL)		
		return c#return.Success
END CHOOSE

end function

public function integer of_filecopy (string as_sourcename, string as_targetname, string as_errorname);integer li_copysuccess
string ls_trucatedsource, ls_trucatedtarget
li_copysuccess = filecopy(as_sourcename,as_targetname)

if len(as_sourcename)>52 then 
	ls_trucatedsource = "..." + right(as_sourcename,52)
else
	ls_trucatedsource = as_sourcename
end if	
if len(as_targetname)>52 then 
	ls_trucatedtarget = "..." + right(as_targetname,52)
else
	ls_trucatedtarget = as_targetname
end if


CHOOSE CASE li_copysuccess
	CASE -1
		of_writetolog("critical error copying file, can not read source file " + ls_trucatedsource,ii_LOG_IMPORTANT)
		return c#return.Failure
	CASE -2
		if as_errorname<>"" then
			li_copysuccess = filecopy(as_sourcename,as_errorname)
			if li_copysuccess = c#return.Success then
				of_writetolog("could not access location " + ls_trucatedtarget + ", placed file in error folder " + as_errorname,ii_LOG_IMPORTANT)				
			else
				of_writetolog("error, could not copy file " + ls_trucatedsource + " into " + ls_trucatedtarget,ii_LOG_IMPORTANT)							
			end if
		else
			of_writetolog("error, could not write file " + ls_trucatedsource + " to target location " + ls_trucatedtarget + ".  no error folder defined.",ii_LOG_IMPORTANT)							
		end if	
		return c#return.Failure		
	CASE ELSE
		of_writetolog("processed, successful copy of file " + ls_trucatedsource + " to target " + ls_trucatedtarget,ii_LOG_NORMAL)		
		return c#return.Success
END CHOOSE

end function

public function integer of_outstandingfiles (s_interface astr_interface, string as_wildcard, ref string as_newfiles[]);/********************************************************************
   of_outstandingfiles( /*s_interface astr_interface*/, /*string as_wildcard*/, /*ref string as_newfiles[] */)
	
<DESC>   
	Used to test if there are any files to process
</DESC>
<RETURN>
	Integer:
		<LI> Number of files to process
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_interface: interface data structure
	as_wildcard: string matching filename, ie "*.wk", "*.txt"
	as_newfiles[]: array of files that require processing
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

integer 	li_fileindex, li_sum_of_tx_files
mt_n_filefunctions lnv_filefunc
n_dirattrib lnv_files[]

lnv_filefunc.of_dirlist( astr_interface.s_folderlocation + as_wildcard, 8224 , lnv_files[])
for li_fileindex = 1 to upperbound(lnv_files)
	  as_newfiles[li_fileindex] = lnv_files[li_fileindex].is_filename
next	
li_sum_of_tx_files = upperbound(as_newfiles[])
return li_sum_of_tx_files 	
end function

on n_interfacelogic.create
call super::create
end on

on n_interfacelogic.destroy
call super::destroy
end on

event constructor;call super::constructor;garbagecollect()
sqlca.of_connect()

iole_shellcmd = CREATE oleobject
iole_shellcmd.connecttonewobject( "WScript.Shell" )


end event

event destructor;call super::destructor;sqlca.of_disconnect()
garbagecollect()
// is_emailtext=""
destroy iole_shellcmd
end event

