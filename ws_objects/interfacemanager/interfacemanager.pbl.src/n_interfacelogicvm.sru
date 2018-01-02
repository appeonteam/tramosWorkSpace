$PBExportHeader$n_interfacelogicvm.sru
$PBExportComments$business logic code for voyage master data
forward
global type n_interfacelogicvm from n_interfacelogic
end type
end forward

global type n_interfacelogicvm from n_interfacelogic
end type
global n_interfacelogicvm n_interfacelogicvm

type variables
long il_transcounter=0
constant string is_TRANSTYPE="VoyMaster"
end variables

forward prototypes
public function long of_oustandingtransactions ()
public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle)
public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename)
public function string of_writefooterrecord (ref s_interface str_interface, string as_filename)
public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename)
public subroutine documentation ()
end prototypes

public function long of_oustandingtransactions ();
/* this is where we retreive the data and return the amount of oustanding records found */

/* only 1 ds element for this case */

ids_source[1].retrieve() 
return ids_source[1].rowcount()
end function

public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle);integer 	li_filewriter
long 		ll_row
long		ll_transactions
string 	ls_headerrecord
string		ls_recorddata
string		ls_footerrecord 
string 	ls_transid
string		ls_transdate   
string		ls_userid
string		ls_status
string		ls_vesselrefnr
string		ls_voyagenr
string		ls_startdate
string		ls_voyagetype
string		ls_voyagestatus
string		ls_companycode
string		ls_oldvoyagenr
	
	/* Create the open record and insert it into the file  */
	il_transcounter=0
	ls_headerrecord = of_writeheaderrecord(astr_interface, as_filename)
	li_filewriter = filewrite(ai_filehandle,ls_headerrecord)

	if li_filewriter < 0 then
		this._addmessage( this.classdefinition, "of_createfile()","error, it was not possible to write the open header record to the file " + as_filename, "")
		fileclose(ai_filehandle)
		return (c#return.Failure)
	end if	
	if ai_filehandle <> -1 then
		for ll_row = 1 to ids_source[1].rowcount()
			
			ls_transid = string(ids_source[1].getitemnumber(ll_row,"trans_id"))		
			if isnull(ls_transid) then ls_transid=""
			ls_transdate = string(ids_source[1].getitemdatetime(ll_row,"trans_date"),"dd-mm-yyyy hh:mm:ss")
			if isnull(ls_transdate) then ls_transdate=""			
			ls_userid = ids_source[1].getitemstring(ll_row,"userid")					
			if isnull(ls_userid) then ls_userid=""			
			ls_status = ids_source[1].getitemstring(ll_row,"status")			
			if isnull(ls_status) then ls_status=""			
			ls_vesselrefnr = ids_source[1].getitemstring(ll_row,"vessel_ref_nr")			
			if isnull(ls_vesselrefnr) then ls_vesselrefnr=""			
			ls_voyagenr = ids_source[1].getitemstring(ll_row,"voyage_nr")		
			if isnull(ls_voyagenr) then ls_voyagenr="" 
			ls_startdate = string(ids_source[1].getitemdatetime(ll_row,"start_date"),"dd-mm-yyyy hh:mm:ss")	
			if isnull(ls_startdate) then ls_startdate=""  			
			ls_voyagetype = ids_source[1].getitemstring(ll_row,"voyage_type")		
			if isnull(ls_voyagetype) then ls_voyagetype=""  			
			ls_voyagestatus = ids_source[1].getitemstring(ll_row,"voyage_status")			
			if isnull(ls_voyagestatus) then ls_voyagestatus=""		
			ls_companycode = ids_source[1].getitemstring(ll_row,"company_code")
			if isnull(ls_companycode) then ls_companycode=""		
			ls_oldvoyagenr = ids_source[1].getitemstring(ll_row,"old_voyage_nr")
			if isnull(ls_oldvoyagenr) then ls_oldvoyagenr=""		
			
			ls_recorddata = 	ls_transid+";"+ls_transdate+";"+ &
									ls_userid+";"+ls_status+";"+ls_vesselrefnr+";"+ &
									ls_voyagenr+";"+ls_startdate+";"+ls_voyagetype+";"+ &
									ls_voyagestatus+";"+ls_companycode+";"+ls_oldvoyagenr
			
			li_filewriter = filewrite(ai_filehandle,ls_recorddata)
			if li_filewriter < 0 then
				this._addmessage( this.classdefinition, "of_createfile()","error, it was not possible to write a record to the file " + as_filename, "")
				fileclose(ai_filehandle)
				return c#return.Failure
			else 
				// Count the number of transactions
				il_transcounter++
			end if	
		next
	end if

	/* Create the open record and insert it into the file  */
	ls_footerrecord = of_writefooterrecord(astr_interface, as_filename)
	li_filewriter = filewrite(ai_filehandle,ls_footerrecord)

	if li_filewriter < 0 then
		this._addmessage( this.classdefinition, "of_createfile()","error, it was not possible to write the close footer record to the file " + as_filename, "")
		fileclose(ai_filehandle)
		return (c#return.Failure)
	end if	


return c#return.Success	
end function

public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename);String ls_openrec, ls_linkcode, ls_sourceref

str_interface.l_sourcereferencecounter++
ls_sourceref = string(str_interface.l_sourcereferencecounter)

// Create file
if isnull(as_filename) then as_filename = ""
if isnull(ls_sourceref) then ls_sourceref = ""
ls_openrec = as_filename+";"+ls_sourceref+";"+is_TRANSTYPE

// Return the string
return(ls_openrec)
end function

public function string of_writefooterrecord (ref s_interface str_interface, string as_filename);return string(il_transcounter)
end function

public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename);//if astr_interface.s_mqqueuemanager="" or isnull(astr_interface.s_mqqueuemanager) then
//	return c#return.NoAction
//else	
//	return of_mqserieshandler(astr_interface,as_filename)
//end if
//

/* archive folder if enabled */
if astr_interface.b_archive then
	of_filecopy(astr_interface.s_folderworking + as_filename, astr_interface.s_folderarchive + as_filename, "")
end if	
/* move file from working to out folder */
return of_filemove(astr_interface.s_folderworking + as_filename, astr_interface.s_folderout + as_filename, "")

end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogic_vm
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		ACE voyage master interface object
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
  	<ALSO>
		
		n_interface
		|	+  n_interfacelogic
		|	|	+	*n_interfacelogicvm*
		|	|	+ 	n_interfacelogicax
		|	+  n_interfaceprocess
		
	
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		04/01/12 	M5-1     AGL				First Version
********************************************************************/
end subroutine

on n_interfacelogicvm.create
call super::create
end on

on n_interfacelogicvm.destroy
call super::destroy
end on

