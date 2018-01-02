$PBExportHeader$n_interfacelogicack.sru
$PBExportComments$business logic code for confirmation transactions (AX_IN)
forward
global type n_interfacelogicack from n_interfacelogic
end type
end forward

global type n_interfacelogicack from n_interfacelogic
end type
global n_interfacelogicack n_interfacelogicack

type variables


end variables

forward prototypes
public function integer of_go (ref s_interface astr_interfaces[])
public subroutine documentation ()
private function integer _email_voymaster_error (string as_status, long al_voymaster_trans_id, string as_axfilename)
private function integer _email_claim_error (string as_type, long al_claim_trans_key, long al_voymaster_trans_id, string as_axfilename)
private function boolean _release_claim_trans (ref string as_additionalmsg, long al_voymaster_trans_id)
private function boolean _release_voymaster_trans (ref string as_additionalmsg, long al_voymaster_trans_id)
private function integer _get_claim_total (integer al_voymaster_trans_id)
private function integer _get_pending_claims_total (integer al_voymaster_trans_id)
private function long _readfile (string as_filename, ref string as_context)
private function integer _get_dataobject_index (string as_doname)
end prototypes

public function integer of_go (ref s_interface astr_interfaces[]);/********************************************************************
   of_go()
   <DESC>	
		The main process, previously called of_process_confirmation_msg() this processes confirmation message	
	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filepath
		as_archivefolder
   </ARGS>
   <USAGE>	
	Used within TIM, handles all confirmation messages received from AX.
	System will only process first TRANS_LOG_MAIN_A record it finds.
	
	Voyage Master Batch (bmvm section)
	Source datastores used for this purpose in this method include:

	ids_source[1] = d_sq_gr_log_main_a #update
	ids_source[2] = d_ex_gr_confirm_msg #read
	ids_source[3] = d_sq_gr_bmvm_lookup_voymaster #update
	ids_source[4] = d_sq_gr_bmvm_lookup_voymastermod #update
	ids_source[5] = d_sq_gr_bmvm_lookup_transloga  #update
	ids_source[6] = d_sq_tb_trans_b  #update  // is this needed?
	ids_source[7] = d_sq_gr_bmvc_list_claimtranskeys #read
	ids_source[8] = d_ex_gr_voymaster_confirm_msg #read
	</USAGE>
	
   <HISTORY>
   	Date         		CR-Ref   Author    		Comments
   09/01/2012   	M5-5     ZSW001    	First Version
	11/02/2012		M5-5     ZSW001    	Additional Changes
	13/03/2012		M5-5     ZSW001    	Additional Changes
	27/03/2012	 	M5-5		AGL027		Intergrated into Interface Manager
	05/08/2015		CR3872	AGL027		Contain some batch management inside interface.
	14/11/2016		CR3320	AGL027		Voyage Master confirmation processing
   </HISTORY>
********************************************************************/

long		ll_pos, ll_confirm_row, ll_return, ll_trans_row, ll_trans_count, ll_trans_key_ack, ll_dummy
long 		ll_new_bpost, ll_trans_id, ll_claim, ll_sum_of_claims 
long 		ll_voymaster_trans_id, ll_cnote_trans_key, ll_claim_trans_key
integer 	li_filecount, li_fileindex, li_sendattempts, li_totalclaims
string	ls_archivefilepath, ls_workingfilepath, ls_f07_docnum, ls_axdate, ls_invoice_nr, ls_status, ls_message 
string 	ls_filename, ls_foundfilepath, ls_newfiles[], ls_text, ls_header, ls_detail, ls_axfilename, ls_errortext
string 	ls_detailtext, ls_linedesr, ls_additionalmsg, ls_successmsg, ls_failmsg, ls_trans_id, ls_type_flag
boolean 	lb_batch_update
integer	li_confirm_index
mt_n_stringfunctions	lnv_stringfunctions


CONSTANT string ls_ENTERCHAR = "~r~n"
CONSTANT string ls_DELIMITER = ";"
CONSTANT string ls_ERRORFLAG = "ERROR - "

if of_outstandingfiles(astr_interfaces[1], "*.txt", ls_newfiles) = 0 then return c#return.NoAction

/* validate connection */
if sqlca.sqlcode <> 0 then
		of_writetolog("critical database error, unable to connect to database. sqlcode="+string(sqlca.sqlcode) + " sqlerrtext='" + sqlca.sqlerrtext + "'",ii_LOG_IMPORTANT)
	sqlca.of_rollback()
	sqlca.of_disconnect()
	return c#return.Failure
end if
sqlca.of_commit()

li_fileindex = 1
do while li_fileindex <= upperbound(ls_newfiles)
	
	ls_foundfilepath = astr_interfaces[1].s_folderlocation + ls_newfiles[li_fileindex]
	ls_workingfilepath = astr_interfaces[1].s_folderworking + ls_newfiles[li_fileindex]
	ls_archivefilepath = astr_interfaces[1].s_folderarchive + ls_newfiles[li_fileindex]
	
	if of_filemove(ls_foundfilepath,ls_workingfilepath,"_REPLACE_")=c#return.Success then
	
		//Read the text from file
		ll_return = _readfile(ls_workingfilepath , ls_text)
		if ll_return < 0 then
			of_writetolog("error, failed to load file " + ls_workingfilepath,ii_LOG_IMPORTANT)
			li_fileindex++
			continue
		end if
	
		//Get header and detail information
		ll_pos = pos(ls_text, ls_ENTERCHAR)
		ls_header = left(ls_text, ll_pos - 1)
		ls_detail = mid(ls_text, ll_pos + len(ls_ENTERCHAR))
	
		//Get file name and success flag
		ls_axfilename = left(ls_header, pos(ls_header, ls_DELIMITER) - 1)
		
		ls_type_flag  = "confirmation"
		
		if upper(left(ls_axfilename,3)) = "VOY" then
			// todo - we need to find a better way in identifying the correct dataobeject for the job.
			li_confirm_index = _get_dataobject_index("d_ex_gr_voymaster_confirm_msg")  
		else
			li_confirm_index = _get_dataobject_index("d_ex_gr_confirm_msg")
		end if
	
		if pos(lower(ls_header), lower(ls_DELIMITER + ls_type_flag)) <= 0 then
			of_writetolog("error, invalid format for file " + ls_workingfilepath,3)
			li_fileindex++
			continue
		end if
		
		of_writetolog("succeeded to load file " + ls_workingfilepath,ii_LOG_NORMAL)
		
		//Import detail information
		ids_source[li_confirm_index].reset()
		ls_detail = lnv_stringfunctions.of_replace(ls_detail, ls_DELIMITER, "~t")
			
		ll_return = ids_source[li_confirm_index].importstring(ls_detail)
		if ll_return < 0 then
			of_writetolog("error, failed to import file " + ls_workingfilepath + " into Tramos",ii_LOG_IMPORTANT)
			li_fileindex++
			continue
		end if

		//Get all rows of the message
		for ll_confirm_row = 1 to ids_source[li_confirm_index].rowcount()

			ls_message = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "ax_message")
			if isnull(ls_message) then ls_message = ""

			ls_status = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "ax_status")
			if isnull(ls_status) then ls_status = ""

			
			if li_confirm_index = _get_dataobject_index("d_ex_gr_confirm_msg") then
				/* dedicated TRANS_LOG columns */
				ls_axdate = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "trans_date")
				if isnull(ls_axdate) then ls_axdate = ""
				
				ls_invoice_nr = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "ax_invoice_nr")
				if isnull(ls_invoice_nr) then ls_invoice_nr = ""
				

				ls_f07_docnum = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "f07_docnum")
				if isnull(ls_f07_docnum) then ls_f07_docnum = ""
				ls_detailtext = ls_axdate + ls_DELIMITER + ls_f07_docnum + ls_DELIMITER + ls_invoice_nr + &
						ls_DELIMITER + ls_status + ls_DELIMITER + ls_message + ls_ENTERCHAR
				
				if ls_f07_docnum = "" then
					of_writetolog("warning, F07_DOCNUM can't be empty",ii_LOG_IMPORTANT)
					ls_errortext += ls_detail
					continue
				end if
				
				//Retrieve and modify TRANS_LOG_MAIN_A
				ll_trans_count = ids_source[1].retrieve(ls_f07_docnum)
				if ll_trans_count <= 0 then
					of_writetolog("warning, failed to update TRANS_LOG_MAIN_A table with error: F07_DOCNUM " + ls_f07_docnum + " is not found",ii_LOG_IMPORTANT)
					ls_errortext += ls_detail
					continue
				elseif ll_trans_count > 1 then
					of_writetolog("warning, system expects to find 1 TRANS_LOG_MAIN_A record but has found " + string(ll_trans_count) + " system will process only 1st one found: F07_DOCNUM " + ls_f07_docnum ,ii_LOG_IMPORTANT)
				end if
				if ls_status = "0" then
					if left(ls_message, len(ls_ERRORFLAG)) = ls_ERRORFLAG then
						ls_message = mid(ls_message, len(ls_ERRORFLAG) + 1)
					end if
				end if
				if ls_axfilename <> "" then ids_source[1].setitem(1, "ax_file_name", ls_axfilename)
				if ls_axdate     <> "" then ids_source[1].setitem(1, "ax_date", datetime(ls_axdate))
				if ls_invoice_nr <> "" then ids_source[1].setitem(1, "ax_invoice_nr", ls_invoice_nr)
				if ls_status     <> "" then ids_source[1].setitem(1, "ax_status", long(ls_status))
				if ls_message    <> "" then ids_source[1].setitem(1, "ax_message", ls_message)
				
				/* bmvm code block - begin */
				lb_batch_update = true
				ls_successmsg = "info, BMVM able to update TRANS_LOG_MAIN_A table with F07_DOCNUM: " + ls_f07_docnum
				ls_failmsg = "warning, BMVM unable to update TRANS_LOG_MAIN_A. table with error: F07_DOCNUM = " + ls_f07_docnum + ". "
				ll_trans_key_ack = ids_source[1].getitemnumber(1, "trans_key")
				ls_linedesr = ids_source[1].getitemstring(1, "f41_linedesr") 			
				ids_source[4].retrieve(ll_trans_key_ack)
				
				if ids_source[4].rowcount() = 0 then 
					/* not a confirmation for a batch Voyage modification process so only update TRANS_LOG_MAIN_A */ 
					ls_successmsg = "processed, update to TRANS_LOG_MAIN_A table with F07_DOCNUM: " + ls_f07_docnum
					ls_failmsg = "warning, failed to update TRANS_LOG_MAIN_A table with error: F07_DOCNUM = " + ls_f07_docnum + ". "
				else 
				
					ll_voymaster_trans_id = ids_source[4].getitemnumber(1,"trans_id")
					ids_source[3].retrieve(ll_voymaster_trans_id)
					
					/* identified as a claim confirmation transaction */
					CHOOSE CASE lower(ls_linedesr)
						CASE "claimscreditnote"
							ll_cnote_trans_key = ll_trans_key_ack
						CASE "claims"
							ll_claim_trans_key = ll_trans_key_ack
						CASE ELSE
					END CHOOSE
			
					if lower(ls_message) = "success" then
						/* AX has accepted the transaction already sent, but which was it? */
			
						CHOOSE CASE lower(ls_linedesr)
							CASE "claimscreditnote"
								if _release_voymaster_trans(ls_additionalmsg,ll_voymaster_trans_id ) then
									of_writetolog("info, BMVM confirmation of credit note transaction from AX received, " + ls_additionalmsg, ii_LOG_IMPORTANT)	
								else
									lb_batch_update = false
									of_writetolog("error, BMVM unable to process claim and voyage master transactions for voyage number change " + &
														ids_source[3].getitemstring(1,"old_voyage_nr") + " to " + ids_source[3].getitemstring(1,"voyage_nr") + "on vessel " + &
														ids_source[3].getitemstring(1,"vessel_nr") ,ii_LOG_IMPORTANT)	
								end if
								
							CASE "claims"
								/* end point - we must have success on the credit note already and now the claim.  job done! */
								ids_source[4].setitem(1, "claim_finished", 1)
								if ids_source[4].update() = 1 then
									of_writetolog("info, BMVM confirmation of claim transaction from AX received", ii_LOG_IMPORTANT)
								else
									of_writetolog("error, BMVM unable to update claim status to success"  ,ii_LOG_IMPORTANT)									
									lb_batch_update = false
								end if	
								
							CASE ELSE
								// Nothing to do
						END CHOOSE
						
					else
						/* AX did not successfully process the original transaction! we try and resend */
						of_writetolog("warning, BMVM modify voyage transaction batch failed in AX", ii_LOG_IMPORTANT)	
	
						CHOOSE CASE lower(ls_linedesr)
							CASE "claimscreditnote"
									_email_claim_error("credit note", ll_trans_key_ack, ll_voymaster_trans_id, ls_axfilename)
								
							CASE "claims"
									_email_claim_error("claim", ll_trans_key_ack, ll_voymaster_trans_id, ls_axfilename)
								
							CASE ELSE
								// nothing to do now
						END CHOOSE
						
					end if
				end if		
				/* if everything has worked then commit the transactions */
				if lb_batch_update then
					if ids_source[1].update()=1 then
						of_writetolog(ls_successmsg,ii_LOG_IMPORTANT)	
						sqlca.of_commit()
					else
						ls_errortext = sqlca.sqlerrtext			
						of_writetolog(ls_failmsg + ls_errortext,ii_LOG_IMPORTANT)
						ls_errortext += ls_detailtext
						sqlca.of_rollback()
					end if
				else
					sqlca.of_rollback()
				end if


			elseif li_confirm_index = _get_dataobject_index("d_ex_gr_voymaster_confirm_msg") then
				/* dedicated VOYMASTER columns */				

				ls_trans_id = ids_source[li_confirm_index].getitemstring(ll_confirm_row, "trans_id")
				if isnull(ls_trans_id) then ls_trans_id = ""
				ls_detailtext = ls_trans_id + ls_DELIMITER + ls_status + ls_DELIMITER + ls_message + ls_ENTERCHAR
				if ls_trans_id = "" then
					of_writetolog("warning, TRANS_ID can't be empty",ii_LOG_IMPORTANT)
					ls_errortext += ls_detail
					continue
				end if

				/* retrieve and modify VOYMASTER data */
				ll_voymaster_trans_id = long(ls_trans_id)
				if ids_source[3].retrieve(ll_voymaster_trans_id) = 1 then
					
					ll_sum_of_claims = _get_claim_total(ll_voymaster_trans_id)
					ids_source[3].setitem(1,"ax_message", ls_message)
					
					if lower(ls_message) = "success" then
						
						if ll_sum_of_claims > 0 then	  // this check should catch only 'Modify' types that has claims attached
							lb_batch_update = _release_claim_trans(ls_additionalmsg, ll_voymaster_trans_id)
						else 
							lb_batch_update = true
						end if	
						
					else 
						_email_voymaster_error(ids_source[3].getitemstring(1,'status'), ll_voymaster_trans_id, ls_axfilename)
						lb_batch_update = true
					end if
					
					if lb_batch_update then 
						if ids_source[3].update()=1 then
							sqlca.of_commit()
						else
							ls_errortext = sqlca.sqlerrtext			
							of_writetolog(ls_failmsg + ls_errortext,ii_LOG_IMPORTANT)
							sqlca.of_rollback()
						end if
					else 
						ls_errortext = "error, unable to release the claim(s) transactions"			
						of_writetolog(ls_failmsg + ls_errortext,ii_LOG_IMPORTANT)
						sqlca.of_rollback()
					end if	
					
				end if
			end if	
		next
		
		/* use of own error process */
		if ls_errortext <> "" then
			of_writetolog("warning, transaction file " + ls_workingfilepath + " has a problem.  error=" + ls_errortext ,ii_LOG_IMPORTANT)	
			ls_errortext=""
		end if
		if of_updateinterfacedata(astr_interfaces[1]) <> c#return.Success then
			sqlca.of_rollback()
		else
			sqlca.of_commit()
		end if
	end if
	
	/* archive each file */
	if ls_workingfilepath<>ls_archivefilepath and ls_archivefilepath<>"" then
		of_filemove(ls_workingfilepath,ls_archivefilepath,"_REPLACE_")
	elseif 	ls_workingfilepath=ls_archivefilepath then
		/* leave as is */
	end if	
	
	li_fileindex++
loop

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogicack
	
	<OBJECT>
		business logic handling confirmation message processing
	</OBJECT>
   <DESC>
		Receives confirmation file from AX, archives and loads data received into Tramos DB.
		Handles standard messages as well as those received as part of batch process to change a voyage number.
	</DESC>
   <USAGE>
		Object Usage.
	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author	Comments
  	27/03/12 	M5-5  	AGL		First Version & intergration of Appeon code
	05/08/15		CR3872  	AGL		Added some logic to generate new transactions from here if required.
	21/10/16		CR3320	AGL		Redesigned BMVM process to handle voyage master confirmations
	19/12/16		CR4592	AGL		Allow overwrite of confirmation files
	27/04/17		CR4603	AGL		Use function of_sendmail() created in this CR for all SMTP mail processing. 
********************************************************************/
end subroutine

private function integer _email_voymaster_error (string as_status, long al_voymaster_trans_id, string as_axfilename);/********************************************************************
_email_voymaster_error( /*string as_type*/, /*string as_additionalinfo*/, /*long al_voymaster_trans_id */)

<DESC>
	validates if last confirmation has been received in a voyage ('credit note'/'claim') if it is so and there have been
	any errors reported by AX in any of the records received send a general email to inform AX admin that there is a problem
	requiring their attention.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_type:	'claim'/'credit note' User friendly text to apply into email content
	as_additonalinfo: more information from calling procedure that we need in email
	al_voymaster_trans_id: the voyage master record needed to locate the modify detail.
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

long ll_sum, ll_sumof_finished_cnotes, ll_error_in_cnote, ll_sumof_finished_claims, ll_error_in_claims
string ls_errormessage, ls_subject, ls_body

/* control that email should only be sent to AX Admin once per voyage for each type (claim / credit note) */
of_writetolog("sending email to BMVM mail responsible, VOYMASTER failed",ii_LOG_IMPORTANT)


CHOOSE CASE as_status
		CASE 'M'
			ls_subject = "Vessel " + ids_source[3].getitemstring(1,"vessel_ref_nr") + ": Modify voyage number (" + ids_source[3].getitemstring(1,"old_voyage_nr") + ">" + ids_source[3].getitemstring(1,"voyage_nr") + ") - error on " + as_status + " processing"
			ls_body = 			"Vessel: " + ids_source[3].getitemstring(1,"vessel_ref_nr") + c#string.CRLF + &
							"Old Voyage No: " + ids_source[3].getitemstring(1,"old_voyage_nr") + c#string.CRLF + &
							"New Voyage No: " + ids_source[3].getitemstring(1,"voyage_nr") + c#string.CRLF + & 
							"AX Message: " + ids_source[3].getitemstring(1,"ax_message") + c#string.CRLF + & 
							"TX DateTime: " + string(ids_source[3].getitemdatetime(1,"trans_date"),"dd/mm/yy hh:mm:ss") + c#string.CRLF + &
							"File Name: " + as_axfilename + c#string.CRLF + &
							"Number of Claims in Voyage: " + string(ll_sum) + c#string.CRLF + &
							"User ID: " + ids_source[3].getitemstring(1,"userid") + fill(c#string.CRLF,2) + &
							"Please follow up by correcting AX and resending confirmation file to Tramos."

	CASE 'D'	
			ls_subject = "Vessel " + ids_source[3].getitemstring(1,"vessel_ref_nr") + ": Delete voyage number (" + ids_source[3].getitemstring(1,"voyage_nr") + ") - error on " + as_status + " processing"
			ls_body =	"Vessel: " + ids_source[3].getitemstring(1,"vessel_ref_nr") + c#string.CRLF + &
							"Voyage No: " + ids_source[3].getitemstring(1,"voyage_nr") + c#string.CRLF + & 
							"AX Message: " + ids_source[3].getitemstring(1,"ax_message") + c#string.CRLF + & 
							"TX DateTime: " + string(ids_source[3].getitemdatetime(1,"trans_date"),"dd/mm/yy hh:mm:ss") + c#string.CRLF + &
							"File Name: " + as_axfilename + c#string.CRLF + &
							"User ID: " + ids_source[3].getitemstring(1,"userid") + fill(c#string.CRLF,2) + &
							"Please follow up by correcting AX and resending confirmation file to Tramos."
	
	CASE 'C'		
			ls_subject = "Vessel " + ids_source[3].getitemstring(1,"vessel_ref_nr") + ": Create voyage number (" + ids_source[3].getitemstring(1,"voyage_nr") + ") - error on " + as_status + " processing"
			ls_body =	"Vessel: " + ids_source[3].getitemstring(1,"vessel_ref_nr") + c#string.CRLF + &
							"Voyage No: " + ids_source[3].getitemstring(1,"voyage_nr") + c#string.CRLF + & 
							"AX Message: " + ids_source[3].getitemstring(1,"ax_message") + c#string.CRLF + & 
							"TX DateTime: " + string(ids_source[3].getitemdatetime(1,"trans_date"),"dd/mm/yy hh:mm:ss") + c#string.CRLF + &
							"File Name: " + as_axfilename + c#string.CRLF + &
							"User ID: " + ids_source[3].getitemstring(1,"userid") + fill(c#string.CRLF,2) + &
							"Please follow up by correcting AX and resending confirmation file to Tramos."
END CHOOSE	

	
	
if of_sendmail(C#EMAIL.TRAMOSSUPPORT, gs_bmvm_mailto, ls_subject, ls_body, ls_errormessage) = c#return.Failure then
	of_writetolog("error, could not set creator when attempting to smtp mail, error detail:" + ls_errormessage,ii_LOG_NORMAL)	
	return c#return.Failure
end if	

return c#return.Success
end function

private function integer _email_claim_error (string as_type, long al_claim_trans_key, long al_voymaster_trans_id, string as_axfilename);/********************************************************************
_email_claim_error( /*string as_type*/, /*string as_additionalinfo*/, /*long al_voymaster_trans_id */)

<DESC>
	validates if last confirmation has been received in a voyage ('credit note'/'claim') if it is so and there have been
	any errors reported by AX in any of the records received send a general email to inform AX admin that there is a problem
	requiring their attention.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_type:	'claim'/'credit note' User friendly text to apply into email content
	as_additonalinfo: more information from calling procedure that we need in email
	al_voymaster_trans_id: the voyage master record needed to locate the modify detail.
	
	
	ids_source[1] = d_sq_gr_log_main_a #update
	ids_source[2] = d_ex_gr_confirm_msg #read
	ids_source[3] = d_sq_gr_bmvm_lookup_voymaster #update
	ids_source[4] = d_sq_gr_bmvm_lookup_voymastermod #update
	ids_source[5] = d_sq_gr_bmvm_lookup_transloga  #update
	ids_source[6] = d_sq_tb_trans_b  #update  // is this needed?
	ids_source[7] = d_sq_gr_bmvc_list_claimtranskeys #read
	ids_source[8] = d_ex_gr_voymaster_confirm_msg #read
	
	
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

long ll_sum, ll_sumof_finished_cnotes, ll_error_in_cnote, ll_sumof_finished_claims, ll_error_in_claims
string ls_errormessage, ls_subject, ls_body, ls_ax_message

/* control that email should only be sent to AX Admin once per voyage for each type (claim / credit note) */
of_writetolog("sending email to BMVM mail responsible",ii_LOG_IMPORTANT)

ls_subject = "Vessel " + ids_source[3].getitemstring(1,"vessel_ref_nr") + ": Modify voyage number (" + ids_source[3].getitemstring(1,"old_voyage_nr") + ">" + ids_source[3].getitemstring(1,"voyage_nr") + ") - error on " + as_type + " processing"

SELECT AX_MESSAGE 
INTO :ls_ax_message
FROM TRANS_LOG_MAIN_A
WHERE TRANS_KEY = :al_claim_trans_key;

if isnull(ls_ax_message) then
	ls_ax_message = "n/a"
end if	

ls_body = 			"Vessel: " + ids_source[3].getitemstring(1,"vessel_ref_nr") + c#string.CRLF + &
						"Old Voyage No: " + ids_source[3].getitemstring(1,"old_voyage_nr") + c#string.CRLF + &
						"New Voyage No: " + ids_source[3].getitemstring(1,"voyage_nr") + c#string.CRLF + & 
						"AX Message: " + ls_ax_message + c#string.CRLF + & 
						"TX DateTime: " + string(ids_source[3].getitemdatetime(1,"trans_date"),"dd/mm/yy hh:mm:ss") + c#string.CRLF + &
						"Trans Key: " + string(al_claim_trans_key) + c#string.CRLF + &
						"File Name: " + as_axfilename + c#string.CRLF + &
						"Claim Transaction Type: " + as_type + c#string.CRLF + &
						"User ID: " + ids_source[3].getitemstring(1,"userid") + fill(c#string.CRLF,2) + &
						"A claim sent to AX returned an error during the BMVM modify voyage number process.  Please follow up, this halts the process until a successful confirmation transaction is received by Tramos."

	
if of_sendmail(C#EMAIL.TRAMOSSUPPORT, gs_bmvm_mailto, ls_subject, ls_body, ls_errormessage) = c#return.Failure then
	of_writetolog("error, could not set creator when attempting to smtp mail, error detail:" + ls_errormessage,ii_LOG_NORMAL)	
	return c#return.Failure
end if	

return c#return.Success
end function

private function boolean _release_claim_trans (ref string as_additionalmsg, long al_voymaster_trans_id);/********************************************************************
_release_claim_trans( /*integer li_successvalue*/, /*ref string as_additionalmsg */)

<DESC>
	Sets success flag on claim.  Checks all claims on voyage and if all 
	are complete release the claim(s) & voyage master to AX
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	as_additionalmsg: give calling procedure a little more detail about situation
	al_voymaster_trans_id: required to check pending claims and also no. of claims in batch
	ai_flag: attempts is multiplied by -1 if methos was sent from error logic.
</ARGS>
<USAGE>
	Voyage Master Batch Process (bmvm section)
	Source datastores used in this method include:

	ids_source[5] = d_sq_gr_bmvm_lookup_transloga  #update
	ids_source[7] = d_sq_gr_bmvc_list_claimtranskeys #read 
</USAGE>
********************************************************************/

long ll_claim, ll_sum_of_claims, ll_claimids[]
boolean lb_success = true

/* already retrieved 'voyage master modify' recordset earlier */
ll_sum_of_claims = ids_source[7].retrieve(al_voymaster_trans_id)
/* get array of claim trans keys */
ll_claimids = ids_source[7].object.claim_trans_key.primary
ids_source[5].retrieve(ll_claimids)					
if ids_source[5].rowcount() > 0 then
	/* release the claims that will fit into new voyage */
	for ll_claim = 1 to ids_source[5].rowcount()
		ids_source[5].setitem(ll_claim, "file_name", "")
	next
else	
	lb_success = false
end if	
if lb_success then
	if ids_source[5].update() = 1 then
		as_additionalmsg = "now enabled claim transactions" 
	else
		lb_success = false
	end if
end if

return lb_success
end function

private function boolean _release_voymaster_trans (ref string as_additionalmsg, long al_voymaster_trans_id);/********************************************************************
_release_voymaster_trans( /*integer li_successvalue*/, /*ref string as_additionalmsg */)

<DESC>
	Sets success flag on claimcredit note.  Checks all creditnote claims on voyage and if all 
	are complete releases the voyage master to AX
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_additionalmsg: give calling procedure a little more detail about situation
	al_voymaster_trans_id: required to check pending claims and also no. of claims in batch
</ARGS>
<USAGE>
	Voyage Master Batch Process (bmvm section)
	Source datastores used in this method include:
	
	ids_source[3] = d_sq_gr_bmvm_lookup_voymaster  #update
	ids_source[4] = d_sq_gr_bmvm_lookup_voymastermod #update
</USAGE>
********************************************************************/

long ll_claim, ll_sum_of_claims, ll_claimids[]
boolean lb_success = false

if ids_source[3].rowcount() = 1 then	
	/* validate if all credit note transactions have been received */
	if _get_pending_claims_total(al_voymaster_trans_id) > 1 then
		/* not all credit notes have been received yet, we can only mark this credit note to success */
		ids_source[4].setitem(1, "cnote_finished", 1)
		if ids_source[4].update() <> 1 then
			lb_success = false
		else
			as_additionalmsg = "still pending credit notes to process" 
			lb_success = true
		end if
	else	
		/* we have all the claims processed.  Now we can execute the modify voyage master transaction! */
		ids_source[3].setitem(1, "file_name", "")
		if ids_source[3].update() = 1 then
			ids_source[4].setitem(1, "cnote_finished", 1)
			if ids_source[4].update() = 1 then
				lb_success = true								
			end if	
		end if	
	end if 
end if

return lb_success
end function

private function integer _get_claim_total (integer al_voymaster_trans_id);/********************************************************************
_get_claim_total( /*integer al_voymaster_trans_id*/) 

<DESC>
	gets the total number of claims that are attached to a voyage master record, if any...
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
	al_voymaster_trans_id: used to look up VOYAGE_MASTER_MODIFY table to locate claims linked to it
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
integer li_totalclaims

SELECT count(1) INTO :li_totalclaims 
FROM VOYAGE_MASTER_MODIFY 
WHERE TRANS_ID=:al_voymaster_trans_id;

return li_totalclaims
end function

private function integer _get_pending_claims_total (integer al_voymaster_trans_id);/********************************************************************
_get_pending_claims_total( /*integer al_voymaster_trans_id*/, /*integer ai_max_attempts */) 

<DESC>
	gets the total number of claims that are still waiting successful confirmation of credit note.
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
	al_voymaster_trans_id: used to look up VOYAGE_MASTER_MODIFY table to locate claims linked to it
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
integer li_totalclaims

SELECT count(1) INTO :li_totalclaims 
FROM VOYAGE_MASTER_MODIFY 
WHERE TRANS_ID=:al_voymaster_trans_id AND CNOTE_FINISHED=0;

return li_totalclaims
end function

private function long _readfile (string as_filename, ref string as_context);/********************************************************************
   _readfile( /*string as_filename*/, /*ref string as_context */)
   <DESC>	Reads data from the specified file	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filename
		as_context
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         	CR-Ref      Author       	Comments
   	07/01/2012   	M5-5        ZSW001       	First Version
		13/09/2016		CR3320		AGL027			Changed method used as it was not adaptable for more than 1 type of confirmation message file
   </HISTORY>
********************************************************************/

string	ls_buffer
long		ll_filenum, ll_readcounts

as_context = ""

ll_filenum = fileopen(as_filename, TextMode!, read!, lockreadwrite!)
if ll_filenum < 0 then return c#return.Failure
filereadex(ll_filenum, as_context)
fileclose(ll_filenum)

return c#return.Success

end function

private function integer _get_dataobject_index (string as_doname);long ll_index
for ll_index = 1 to upperbound(ids_source)
	if ids_source[ll_index].dataobject = as_doname then
		return ll_index
	end if	
next
return 0
end function

on n_interfacelogicack.create
call super::create
end on

on n_interfacelogicack.destroy
call super::destroy
end on

