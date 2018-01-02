$PBExportHeader$n_interfacelogicax.sru
$PBExportComments$business logic code for ace transactions  (AX_OUT)
forward
global type n_interfacelogicax from n_interfacelogic
end type
end forward

global type n_interfacelogicax from n_interfacelogic
end type
global n_interfacelogicax n_interfacelogicax

type variables
long il_filetranscounter, il_transindex
double _id_transcounter
double id_debitsum, id_creditsum
string is_transtype[]
constant string is_TRANSPREFIX = "TX"
end variables

forward prototypes
public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename)
public function long of_oustandingtransactions ()
public subroutine documentation ()
public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle)
public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename)
public subroutine of_debitcreditsum (integer ad_debitcredit, double ad_valuedoc)
public function string of_writefooterrecord (ref s_interface str_interface, string as_filename)
protected function string of_writebstring (s_interface astr_interface, long al_apostrow, integer ai_ds_a, long al_bpostrow, integer ai_ds_b, string as_docnum)
public function string of_writeastring (s_interface astr_interface, long al_apostrow, integer ai_ds_a, ref double ad_transkey)
public function integer of_updatesourcetransitem (ref s_interface astr_interface)
public function string of_getnexttranscounter (ref double ad_transcounter)
public function integer of_registertranstypes (s_interface astr_interfaces[])
public function integer of_settranscounter (double ad_transcounter)
public function double of_gettranscounter ()
public function integer of_go (ref s_interface astr_interfaces[])
end prototypes

public function integer of_extendedlogic (ref s_interface astr_interface, string as_filename);//integer li_success
//if astr_interface.s_mqqueuemanager="" or isnull(astr_interface.s_mqqueuemanager) then
//	return c#return.NoAction
//else	
//	return of_mqserieshandler(astr_interface,as_filename)
//end if


/* archive folder if enabled */
if astr_interface.b_archive then
	of_filecopy(astr_interface.s_folderworking + as_filename, astr_interface.s_folderarchive + as_filename, "")
end if	
/* move file from working to out folder */
return of_filemove(astr_interface.s_folderworking + as_filename, astr_interface.s_folderout + as_filename, "")

end function

public function long of_oustandingtransactions ();/* this is where we retreive the data and return the amount of oustanding records found */

ids_source[ii_mastersource].retrieve(is_transtype) 		

return ids_source[ii_mastersource].rowcount()
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogic_ace
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		ACE transaction interface object
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
  	<ALSO>
		
		n_interface
		|	+  n_interfacelogic
		|	|	+	n_interfacelogicvm
		|	|	+ 	*n_interfacelogicax*
		|	+  n_interfaceprocess
		
	
	</ALSO>
    	Date   		Ref    			Author   		Comments
  	04/01/12 	M5-1  		AGL			First Version
	26/03/12		M5-5			AGL			Include voucher number in B-POST		  
	25/04/12		M5-5			AGL			ACE bug#137 - remove reformatted voyage number process
	04/10/16		CR4525		AGL			Strip linefeeds from transaction files
********************************************************************/
end subroutine

public function integer of_writefiledata (ref s_interface astr_interface, string as_filename, integer ai_filehandle);string ls_headerrecord, ls_recorddata, ls_footerrecord 
string ls_astring, ls_bstring, ls_docnum
integer li_filewriter, li_pos
long ll_apostrow, ll_bpostrow, ll_transactions, ll_rowcount
double ld_credit, ld_debit, ld_transkey
integer li_dsindex, li_ds_a, li_ds_b
string ls_transid, ls_transdate, ls_userid, ls_status, ls_vesselrefnr, ls_voyagenr, ls_startdate, ls_voyagetype, ls_voyagestatus, ls_linefeed

mt_n_stringfunctions lnv_stringfunc
	
	/* Create the open record and insert it into the file  */
	il_filetranscounter=0
	ls_headerrecord = of_writeheaderrecord(astr_interface, as_filename)
	li_filewriter = filewrite(ai_filehandle,ls_headerrecord)
	ls_linefeed = char(13) + char(10)

	if li_filewriter < 0 then
		of_writetolog(astr_interface,"error, it was not possible to write the open header record to the file " + as_filename,ii_LOG_IMPORTANT)
		fileclose(ai_filehandle)
		return (c#return.Failure)
	end if	
	if ai_filehandle <> -1 then

		for li_dsindex = 1 to upperbound(ids_source)
			if ids_source[li_dsindex].dataobject="d_sq_tb_trans_a" then
				li_ds_a = li_dsindex
			elseif ids_source[li_dsindex].dataobject="d_sq_tb_trans_b" then
				li_ds_b = li_dsindex			
			end if
		next

		for ll_apostrow = 1 to ids_source[li_ds_a].rowcount()
			ls_astring = of_writeastring(astr_interface, ll_apostrow,  li_ds_a, ld_transkey)
			/* remove linefeed chars */
			ls_astring = lnv_stringfunc.of_replaceall( ls_astring, ls_linefeed, " ", true)
			li_filewriter = filewrite(ai_filehandle,ls_astring)
			if li_filewriter < 0 then
				of_writetolog(astr_interface,"error, it was not possible to write a record to the file " + as_filename,ii_LOG_IMPORTANT)
				fileclose(ai_filehandle)
				return c#return.Failure
			else 
				/* count the number of transactions */
				il_filetranscounter++
			end if				
			
			/* retrieve the B strings */
			ll_rowcount = ids_source[li_ds_b].retrieve(ld_transkey)
			if ll_rowcount>0 then
				ls_docnum = ids_source[li_ds_a].getitemstring(ll_apostrow, "f07_docnum")		
				for ll_bpostrow = 1 to ll_rowcount
				
					ls_bstring = of_writebstring(astr_interface,ll_apostrow, li_ds_a, ll_bpostrow, li_ds_b, ls_docnum)
					/* remove linefeed chars */
					ls_bstring = lnv_stringfunc.of_replaceall( ls_bstring, ls_linefeed, " ", true)
					
					li_filewriter = filewrite(ai_filehandle,ls_bstring)
					if li_filewriter < 0 then
						of_writetolog(astr_interface,"error, it was not possible to write a record to the file " + as_filename,ii_LOG_IMPORTANT)
						fileclose(ai_filehandle)
						return c#return.Failure
					else
						/* count the number of all transactions */
						il_filetranscounter++						
					end if 
				next
			end if
		next
	end if

	/* create the open record and insert it into the file  */
	ls_footerrecord = of_writefooterrecord(astr_interface, as_filename)
	li_filewriter = filewrite(ai_filehandle,ls_footerrecord)

	if li_filewriter < 0 then
		of_writetolog(astr_interface,"error, it was not possible to write the close footer record to the file " + as_filename,ii_LOG_IMPORTANT)
		fileclose(ai_filehandle)
		return (c#return.Failure)
	end if	


return c#return.Success	
end function

public function string of_writeheaderrecord (ref s_interface str_interface, string as_filename);string ls_openrec, ls_sourceref

str_interface.l_sourcereferencecounter++
ls_sourceref = String(str_interface.l_sourcereferencecounter)

/* TODO - what about linkcode??? CMS/CODA had default values */

// Create file
if isnull(as_filename) then as_filename = ""
if isnull(ls_sourceref) then ls_sourceref = ""

ls_openrec = as_filename+";"+ls_sourceref+";"+is_transtype[il_transindex]

// Return the string
Return(ls_openrec)
end function

public subroutine of_debitcreditsum (integer ad_debitcredit, double ad_valuedoc);/***********************************************************************************
Creator:	Teit Aunt
Date:		10-05-1999
Purpose:	Finding the sum of the debit and credit amounts
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
07-05-99		1.0		ta			Initial version
************************************************************************************/
	
/* Add debit to debit sum or credit to credit sum */
if ad_debitcredit = 161 then
	id_debitsum += ad_valuedoc
elseif ad_debitcredit = 160 then
	id_creditsum += ad_valuedoc
end if

end subroutine

public function string of_writefooterrecord (ref s_interface str_interface, string as_filename);string ls_footerrecord, ls_filetranscounter, ls_debitsum, ls_creditsum

ls_filetranscounter = string(il_filetranscounter)
ls_debitsum = string(id_debitsum)
ls_creditsum = string(id_creditsum)
if isnull(ls_filetranscounter) then ls_filetranscounter = ""
if isnull(ls_debitsum) then ls_debitsum = ""
if isnull(ls_creditsum) then ls_creditsum = ""

ls_footerrecord =ls_filetranscounter+";"+ls_debitsum+";"+ls_creditsum

return(ls_footerrecord)
end function

protected function string of_writebstring (s_interface astr_interface, long al_apostrow, integer ai_ds_a, long al_bpostrow, integer ai_ds_b, string as_docnum);/********************************************************************
   of_writebstring()
<DESC>   
	Generates a B post record with complex business logic.  Developed against the same logic as previous CODA
	file processing.
</DESC>
<RETURN>
	String:
		<LI> B post data
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_interface : currently not used here
	al_apostrow: used to locate record in a post table
	ai_ds_a: used to identify transaction a datastore
	al_bpostrow: used to locate record in b post table
	ai_ds_b: used to identify transaction b datastore
	as_docnum: passed in value for docnum reference
</ARGS>
<USAGE>
	called from of_writefiledata()
</USAGE>
********************************************************************/

/*	ls_bstring = of_writebstring(astr_interface,ll_row_a, li_ds_a, ll_row_b, li_ds_b, ls_docnum) */

string ls_bstring, ls_cmpcode, ls_yr, ls_period, ls_auth_user, ls_doccode, ls_docnum, &
			ls_doclinenum_b, ls_docdate, ls_destination, ls_el1_b, ls_el2_b, ls_el3_b, ls_el4_b, ls_el5_b, &
			ls_el6_b, ls_el7_b, ls_el8_b, ls_custsupp, ls_invoicenr, ls_vouchernr_b, ls_controlnr, &
			ls_paytype_or_sup, ls_bank_or_moneyord, ls_paymethod, ls_orderno, ls_line_type, ls_curdoc, &
			ls_debitcredit, ls_valuedoc, ls_valuedoc_dp, ls_valuehome, ls_valuehome_dp, ls_vatamo, &
			ls_vatamo_dp, ls_bunkerton, ls_m2, ls_heads, ls_days, ls_litres, ls_linedesa, ls_location, &
			ls_due_or_pay, ls_edittick
integer	li_year			
			
/* 
get data for B string. Data that are identical in A and B string is only stored in
the A datastore and must be retrieved from it. 
*/

/* A post */
ls_cmpcode = ids_source[ai_ds_a].getitemstring(al_apostrow,"f02_cmpcode")
if isnull(ls_cmpcode) then ls_cmpcode = ""

/* B post */
ls_yr = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f03_yr"))
if isnull(ls_yr) then ls_yr = ""

ls_period = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f04_period"),"00")
if isnull(ls_period) then ls_period = ""

/* A post */
ls_auth_user = ids_source[ai_ds_a].getitemstring(al_apostrow,"f05_auth_user")
if isnull(ls_auth_user) then ls_auth_user = ""
ls_doccode = ids_source[ai_ds_a].getitemstring(al_apostrow,"f06_doccode")
if isnull(ls_doccode) then ls_doccode = ""

/* brought into function as parameter argument */
ls_docnum = as_docnum
if isnull(ls_docnum) then ls_docnum = ""

/*  B post */
ls_doclinenum_b = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f08_doclinenum_b"))
if isnull(ls_doclinenum_b) then ls_doclinenum_b = ""

/* A post */
ls_docdate = string(ids_source[ai_ds_a].getitemdatetime(al_apostrow,"f09_docdate"),"dd-mm-yyyy")
if isnull(ls_docdate) then ls_docdate = ""
ls_destination = ids_source[ai_ds_a].getitemstring(al_apostrow,"f10_destination")
if isnull(ls_destination) then ls_destination = ""

/* B post */
ls_el1_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f11_el1_b")
if isnull(ls_el1_b) then ls_el1_b = ""
ls_el2_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f12_el2_b")
if isnull(ls_el2_b) then ls_el2_b = ""
ls_el3_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f13_el3_b")
if isnull(ls_el3_b) then ls_el3_b = ""
ls_el4_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f14_el4_b")
if isnull(ls_el4_b) then ls_el4_b = ""
ls_el5_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f15_el5_b")
if isnull(ls_el5_b) then ls_el5_b = ""
ls_el6_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f16_el6_b")
ls_el6_b = trim(ls_el6_b)
if isnull(ls_el6_b) then ls_el6_b = ""
ls_el7_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f17_el7_b")
if isnull(ls_el7_b) then ls_el7_b = ""
ls_el8_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f18_el8_b")
if isnull(ls_el8_b) then ls_el8_b = ""
ls_custsupp = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f19_custsupp")
if isnull(ls_custsupp) then ls_custsupp = ""
ls_vouchernr_b = ids_source[ai_ds_b].getitemstring(al_bpostrow,"f21_vouchernr")
if isnull(ls_vouchernr_b) then ls_vouchernr_b = ""

/* A post */
ls_controlnr = ids_source[ai_ds_a].getitemstring(al_apostrow,"f22_controlnr")
if isnull(ls_controlnr) then ls_controlnr = ""

ls_paytype_or_sup = ids_source[ai_ds_a].getitemstring(al_apostrow,"f23_paytype_or_sup")

if isnull(ls_paytype_or_sup) then ls_paytype_or_sup = ""
ls_bank_or_moneyord = ids_source[ai_ds_a].getitemstring(al_apostrow,"f24_bank_or_moneyord")
if isnull(ls_bank_or_moneyord) then ls_bank_or_moneyord = ""
ls_paymethod = ids_source[ai_ds_a].getitemstring(al_apostrow,"f25_paymethod_or_dateofissue")
if isnull(ls_paymethod) then ls_paymethod = ""
ls_orderno = ids_source[ai_ds_a].getitemstring(al_apostrow,"f26_orderno")
if isnull(ls_orderno) then ls_orderno = ""

/* B post */
ls_line_type = String(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f27_linetype"))
if isnull(ls_line_type) then ls_line_type = ""

/* A post */
ls_curdoc = ids_source[ai_ds_a].getitemstring(al_apostrow,"f28_curdoc")
if isnull(ls_curdoc) then ls_curdoc = ""

/* B post */
ls_debitcredit = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f29_debitcredit"))
if isnull(ls_debitcredit) then ls_debitcredit = ""

/* Valuedoc */
ls_valuedoc_dp = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f31_valuedoc_dp"))
if isnull(ls_valuedoc_dp) then ls_valuedoc_dp = ""
ls_valuedoc = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f30_valuedoc"))
if isnull(ls_valuedoc) then ls_valuedoc=""
if len(ls_valuedoc)< 3 and ls_valuedoc_dp = "2" then 
	ls_valuedoc = fill("0", 3 - len(ls_valuedoc)) + ls_valuedoc
end if	

/* Valuehome */
ls_valuehome_dp = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f33_valuehome_dp"))
if isnull(ls_valuehome_dp) then ls_valuehome_dp = ""
ls_valuehome = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f32_valuehome"))
if isnull(ls_valuehome) then ls_valuehome=""
if len(ls_valuehome)< 3 and ls_valuehome_dp = "2" then 
	ls_valuehome = fill("0", 3 - len(ls_valuehome)) + ls_valuehome
end if	

/* vatamo */
ls_vatamo_dp = String(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f35_vattype_or_valdual_dp"))
if isnull(ls_vatamo_dp) then ls_vatamo_dp = ""
ls_vatamo = string(ids_source[ai_ds_b].getitemnumber(al_bpostrow,"f34_vatamo_or_valdual"))
if isnull(ls_vatamo) then ls_vatamo=""
if len(ls_vatamo)< 3 and ls_vatamo_dp = "2" then 
	ls_vatamo = fill("0", 3 - len(ls_vatamo)) + ls_vatamo
end if	

ls_bunkerton = string(ids_source[ai_ds_b].getitemdecimal(al_bpostrow,"f36_bunkerton"))
if isnull(ls_bunkerton) then ls_bunkerton = ""

/* A post */
ls_m2 = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f37_m2"))
if isnull(ls_m2) then ls_m2 = ""
ls_heads = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f38_heads"))
if isnull(ls_heads) then ls_heads = ""
ls_days = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f39_days"))
if isnull(ls_days) then ls_days = ""
ls_litres = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f40_litres"))
if isnull(ls_litres) then ls_litres = ""
ls_location = ids_source[ai_ds_a].getitemstring(al_apostrow,"f42_location")
if isnull(ls_location) then ls_location = ""
ls_due_or_pay = string(ids_source[ai_ds_a].getitemdatetime(al_apostrow,"f43_due_or_payment_date"),"dd-mm-yyyy")
if isnull(ls_due_or_pay) then ls_due_or_pay = ""
ls_edittick = ids_source[ai_ds_a].getitemstring(al_apostrow,"f44_edittick")	
if isnull(ls_edittick) then ls_edittick = ""

/* A or B */
if  not isnull(ids_source[ai_ds_b].getitemstring(al_bpostrow, "f41_linedesr")) or &
	len( ids_source[ai_ds_b].getitemstring(al_bpostrow, "f41_linedesr")) > 2 then
	ls_linedesa = ids_source[ai_ds_b].getitemstring(al_bpostrow, "f41_linedesr")
	if isnull(ls_linedesa) then ls_linedesa = ""
else
	ls_linedesa = ids_source[ai_ds_a].getitemstring(al_apostrow, "f41_linedesr")
	if isnull(ls_linedesa) then ls_linedesa = ""
end if

if mid(ids_source[ai_ds_a].getitemstring(al_apostrow, "trans_type"),1,7) = "DisbExp" then
	ls_invoicenr = ids_source[ai_ds_b].getitemstring(al_bpostrow, "f20_invoicenr")
	if isnull(ls_invoicenr) then ls_invoicenr = ""
else
	ls_invoicenr = ids_source[ai_ds_a].getitemstring(al_apostrow,"f20_invoicenr")
	if isnull(ls_invoicenr) then ls_invoicenr = ""
end if

/* Create the B string that will be returned to of_writefiledata() */
ls_bstring = ""+";"+ls_cmpcode+";"+ls_yr+";"+ls_period+";"+ &
				ls_auth_user+";"+ls_doccode+";"+ls_docnum+";"+ls_doclinenum_b+";"+ls_docdate+";"+ &
				ls_destination+";"+ls_el1_b+";"+ls_el2_b+";"+ls_el3_b+";"+ls_el4_b+";"+ls_el5_b+";"+ls_el6_b+";"+ &
				ls_el7_b+";"+ls_el8_b+";"+ls_custsupp+";"+ls_invoicenr+";"+ls_vouchernr_b+";"+ls_controlnr+";"+ &
				ls_paytype_or_sup+";"+ls_bank_or_moneyord+";"+ls_paymethod+";"+ls_orderno+";"+ls_line_type+";"+ &
				ls_curdoc+";"+ls_debitcredit+";"+ls_valuedoc+";"+ls_valuedoc_dp+";"+ls_valuehome+";"+ &
				ls_valuehome_dp+";"+ls_vatamo+";"+ls_vatamo_dp+";"+ls_bunkerton+";"+ls_m2+";"+ls_heads+";"+ &
				ls_days+";"+ls_litres+";"+ls_linedesa+";"+ls_location+";"+ls_due_or_pay+";"+ls_edittick

/* add the amount from valuedoc to credit or debit sum */
of_debitcreditsum(double(ls_debitcredit),double(ls_valuedoc))

return(ls_bstring)

end function

public function string of_writeastring (s_interface astr_interface, long al_apostrow, integer ai_ds_a, ref double ad_transkey);/********************************************************************
   of_writeastring()
<DESC>   
	Generates a A post record with complex business logic. Developed against the same logic as previous CODA
	file processing.
</DESC>
<RETURN>
	String:
		<LI> A post data
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	astr_interface : currently not used here
	al_apostrow: used to locate record in a post table
	ai_ds_a: used to identify transaction a datastore
</ARGS>
<USAGE>
	called from of_writefiledata()
</USAGE>
********************************************************************/

String ls_key, ls_cmpcode, ls_yr, ls_period, ls_auth_user, ls_doccode, ls_docnum, &
			ls_doclinenum, ls_docdate, ls_destination, ls_el1, ls_el2, ls_el3, ls_el4, ls_el5, ls_el6, &
			ls_el7, ls_el8, ls_custsupp, ls_invoicenr, ls_vouchernr, ls_controlnr, ls_paytype_or_sup, &
			ls_bank_or_moneyord, ls_paymethod, ls_orderno, ls_line_type, ls_curdoc, ls_debitcredit, &
			ls_valuedoc, ls_valuedoc_dp, ls_valuehome, ls_valuehome_dp, ls_vatamo, ls_vatamo_dp, &
			ls_bunkerton, ls_m2, ls_heads, ls_days, ls_litres, ls_linedesa, ls_location, ls_due_or_pay, &
			ls_edittick, ls_astring
integer li_year

/* Get the key for retrieval of B transactions */
ls_key = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"trans_key"))
if isnull(ls_key) then  ls_key = ""

ls_cmpcode = ids_source[ai_ds_a].getitemstring(al_apostrow,"f02_cmpcode")
if isnull(ls_cmpcode) then  ls_cmpcode = ""
ls_yr = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f03_yr"))
if isnull(ls_yr) then  ls_yr = ""

ls_period = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f04_period"),"00")
if isnull(ls_period) then  ls_period = ""

ls_auth_user = ids_source[ai_ds_a].getitemstring(al_apostrow,"f05_auth_user")
if isnull(ls_auth_user) then  ls_auth_user = ""
ls_doccode = ids_source[ai_ds_a].getitemstring(al_apostrow,"f06_doccode")
if isnull(ls_doccode) then  ls_doccode = ""

ls_docnum = ids_source[ai_ds_a].getitemstring(al_apostrow,"f07_docnum")
if isnull(ls_docnum) then  ls_docnum = ""

ls_doclinenum = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f08_doclinenum"))
if isnull(ls_doclinenum) then  ls_doclinenum = ""
ls_docdate = string(ids_source[ai_ds_a].getitemdatetime(al_apostrow,"f09_docdate"),"dd-mm-yyyy")
if isnull(ls_docdate) then  ls_docdate = ""
ls_destination = ids_source[ai_ds_a].getitemstring(al_apostrow,"f10_destination")
if isnull(ls_destination) then  ls_destination = ""
ls_el1 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f11_el1")
if isnull(ls_el1) then  ls_el1 = ""
ls_el2 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f12_el2")
if isnull(ls_el2) then  ls_el2 = ""
ls_el3 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f13_el3")
if isnull(ls_el3) then  ls_el3 = ""
ls_el4 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f14_el4")
if isnull(ls_el4) then  ls_el4 = ""
ls_el5 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f15_el5")
if isnull(ls_el5) then  ls_el5 = ""
ls_el6 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f16_el6")
ls_el6 = trim(ls_el6)
if isnull(ls_el6) then  ls_el6 = ""
ls_el7 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f17_el7")
if isnull(ls_el7) then  ls_el7 = ""
ls_el8 = ids_source[ai_ds_a].getitemstring(al_apostrow,"f18_el8")
if isnull(ls_el8) then  ls_el8 = ""
ls_custsupp = ids_source[ai_ds_a].getitemstring(al_apostrow,"f19_custsupp")
if isnull(ls_custsupp) then  ls_custsupp = ""
ls_invoicenr = ids_source[ai_ds_a].getitemstring(al_apostrow,"f20_invoicenr")
if isnull(ls_invoicenr) then  ls_invoicenr = ""
ls_vouchernr = ids_source[ai_ds_a].getitemstring(al_apostrow,"f21_vouchernr")
if isnull(ls_vouchernr) then  ls_vouchernr = ""
ls_controlnr = ids_source[ai_ds_a].getitemstring(al_apostrow,"f22_controlnr")
if isnull(ls_controlnr) then  ls_controlnr = ""
ls_paytype_or_sup = ids_source[ai_ds_a].getitemstring(al_apostrow,"f23_paytype_or_sup")
if isnull(ls_paytype_or_sup) then  ls_paytype_or_sup = ""
ls_bank_or_moneyord = ids_source[ai_ds_a].getitemstring(al_apostrow,"f24_bank_or_moneyord")
if isnull(ls_bank_or_moneyord) then  ls_bank_or_moneyord = ""
ls_paymethod = ids_source[ai_ds_a].getitemstring(al_apostrow,"f25_paymethod_or_dateofissue")
if isnull(ls_paymethod) then  ls_paymethod = ""
ls_orderno = ids_source[ai_ds_a].getitemstring(al_apostrow,"f26_orderno")
if isnull(ls_orderno) then  ls_orderno = ""
ls_line_type = String(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f27_linetype"))
if isnull(ls_line_type) then  ls_line_type = ""
ls_curdoc = ids_source[ai_ds_a].getitemstring(al_apostrow,"f28_curdoc")
if isnull(ls_curdoc) then  ls_curdoc = ""
ls_debitcredit = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f29_debitcredit"))
if isnull(ls_debitcredit) then  ls_debitcredit = ""

/* Valuedoc */
ls_valuedoc_dp = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f31_valuedoc_dp"))
if isnull(ls_valuedoc_dp) then  ls_valuedoc_dp = ""
ls_valuedoc = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f30_valuedoc"))
if isnull(ls_valuedoc) then ls_valuedoc=""
if len(ls_valuedoc)< 3 and ls_valuedoc_dp = "2" then 
	ls_valuedoc = fill("0", 3 - len(ls_valuedoc)) + ls_valuedoc
end if	

/* Valuehome */
ls_valuehome_dp = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f33_valuehome_dp"))
if isnull(ls_valuehome_dp) then  ls_valuehome_dp = ""
ls_valuehome = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f32_valuehome"))
if isnull(ls_valuehome) then ls_valuehome=""
if len(ls_valuehome)< 3 and ls_valuehome_dp = "2" then  
	ls_valuehome = fill("0", 3 - len(ls_valuehome)) + ls_valuehome
end if	

/* Vatamo */
ls_vatamo_dp = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f35_vattyp_or_valdual_dp"))
if isnull(ls_vatamo_dp) then  ls_vatamo_dp = ""
ls_vatamo = string(ids_source[ai_ds_a].getitemnumber(al_apostrow,"f34_vatamo_or_valdual"))
if isnull(ls_vatamo) then ls_vatamo=""
if len(ls_vatamo)< 3 and ls_vatamo_dp = "2" then  
	ls_vatamo = fill("0", 3 - len(ls_vatamo)) + ls_vatamo
end if	

ls_bunkerton = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f36_bunkerton"))
if isnull(ls_bunkerton) then  ls_bunkerton = ""
ls_m2 = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f37_m2"))
if isnull(ls_m2) then  ls_m2 = ""
ls_heads = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f38_heads"))
if isnull(ls_heads) then  ls_heads = ""
ls_days = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f39_days"))
if isnull(ls_days) then  ls_days = ""
ls_litres = string(ids_source[ai_ds_a].getitemdecimal(al_apostrow,"f40_litres"))
if isnull(ls_litres) then  ls_litres = ""
ls_linedesa = ids_source[ai_ds_a].getitemstring(al_apostrow,"f41_linedesr")
if isnull(ls_linedesa) then  ls_linedesa = ""
ls_location = ids_source[ai_ds_a].getitemstring(al_apostrow,"f42_location")
if isnull(ls_location) then  ls_location = ""
ls_due_or_pay = string(ids_source[ai_ds_a].getitemdatetime(al_apostrow,"f43_due_or_payment_date"),"dd-mm-yyyy")
if isnull(ls_due_or_pay) then  ls_due_or_pay = ""
ls_edittick = ids_source[ai_ds_a].getitemstring(al_apostrow,"f44_edittick")	
if isnull(ls_edittick) then  ls_edittick = ""

/* create the A string */
ls_astring = ""+";"+ls_cmpcode+";"+ls_yr+";"+ls_period+";"+ &
				ls_auth_user+";"+ls_doccode+";"+ls_docnum+";"+ls_doclinenum+";"+ls_docdate+";"+ &
				ls_destination+";"+ls_el1+";"+ls_el2+";"+ls_el3+";"+ls_el4+";"+ls_el5+";"+ls_el6+";"+ &
				ls_el7+";"+ls_el8+";"+ls_custsupp+";"+ls_invoicenr+";"+ls_vouchernr+";"+ls_controlnr+";"+ &
				ls_paytype_or_sup+";"+ls_bank_or_moneyord+";"+ls_paymethod+";"+ls_orderno+";"+ls_line_type+";"+ &
				ls_curdoc+";"+ls_debitcredit+";"+ls_valuedoc+";"+ls_valuedoc_dp+";"+ls_valuehome+";"+ &
				ls_valuehome_dp+";"+ls_vatamo+";"+ls_vatamo_dp+";"+ls_bunkerton+";"+ls_m2+";"+ls_heads+";"+ &
				ls_days+";"+ls_litres+";"+ls_linedesa+";"+ls_location+";"+ls_due_or_pay+";"+ls_edittick

ad_transkey = double(ls_key)

/* add the amount from valuedoc to credit or debit sum */
of_debitcreditsum(double(ls_debitcredit),double(ls_valuedoc))
		
return(ls_astring)
end function

public function integer of_updatesourcetransitem (ref s_interface astr_interface);/* here we must loop through all records in current filtered selection and update the transaction code */

long ll_row
string ls_newtransnumber=""

for ll_row = 1 to ids_source[ii_mastersource].rowcount()
	ls_newtransnumber = of_getnexttranscounter(_id_transcounter)
	ids_source[ii_mastersource].setitem(ll_row,"f07_docnum",ls_newtransnumber)
next 	
if ids_source[ii_mastersource].update(true, false) <> 1 then
	of_writetolog(astr_interface,"error, it was not possible to insert transaction numbers into the source table",ii_LOG_IMPORTANT)
	return c#return.Failure
end if
	
return c#return.Success



end function

public function string of_getnexttranscounter (ref double ad_transcounter);/********************************************************************
   of_getnexttranscounter
<DESC>   
	Increments placeholder and returns string formatted transaction number with designated prefix.
</DESC>
<RETURN>
	String:
		<LI> formatted transaction number format: 	TX9999999999
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ad_transactioncounter: reference to variable used to store transaction number data within this object
</ARGS>
<USAGE>
	Call within the loop that updates the master data table.  of_updatesourcetransitem()
</USAGE>
********************************************************************/

ad_transcounter ++
return is_TRANSPREFIX + string(round(ad_transcounter,0),"0000000000")
end function

public function integer of_registertranstypes (s_interface astr_interfaces[]);long ll_index
string ls_dummy[]

is_transtype = ls_dummy

for ll_index = 1 to upperbound(astr_interfaces)
	is_transtype[upperbound(is_transtype) + 1] = astr_interfaces[ll_index].s_description
next

return c#return.Success
end function

public function integer of_settranscounter (double ad_transcounter);_id_transcounter = ad_transcounter
return c#return.Success
end function

public function double of_gettranscounter ();return _id_transcounter
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
	Public
</ACCESS>
<ARGS>   
	astr_interface: Saved detail of interface configuration
</ARGS>
<USAGE>
	This function has been modified compared to ancestor so we are able to generate a file for each
	TRANS_TYPE.  It also handles the processing of updating the transaction number (field 'f07_docnum')
	in the transaction table containing A posts.
</USAGE>
********************************************************************/


string ls_filename, ls_filepath
boolean lb_success=true
long ll_transrows, ll_currentrows


/* validate connection */
if sqlca.sqlcode <> 0 then
	of_writetolog("critical database error, unable to connect to database. sqlcode="+string(sqlca.sqlcode) + " sqlerrtext='" + sqlca.sqlerrtext + "'",ii_LOG_IMPORTANT)
	sqlca.of_rollback()
	sqlca.of_disconnect()
	return c#return.Failure
end if
sqlca.of_commit()

ll_transrows = of_oustandingtransactions()
if ll_transrows >0 then
	for il_transindex = 1 to upperbound(astr_interfaces)
		of_setfilter("trans_type='" + astr_interfaces[il_transindex].s_description + "'")
		ll_currentrows = ids_source[ii_mastersource].rowcount()
		if ll_currentrows > 0 then
			/* ax transaction table requires TX number format */
			if of_updatesourcetransitem(astr_interfaces[il_transindex]) = c#return.Failure then
				lb_success = false
			else		
				ls_filename = of_createfilename(astr_interfaces[il_transindex])
				if ls_filename = "error" Then 
					lb_success = false
				else
					if of_generate(astr_interfaces[il_transindex], ls_filename) = c#return.Failure then
						lb_success = false
					else
						/* update interface data with updated structure */	
						if of_updateinterfacedata(astr_interfaces[il_transindex]) <> c#return.Success then
							lb_success = false
						else
							ids_source[1].resetupdate()
							sqlca.of_commit()
						end if		
					end if
				end if
				/* validate if any rows left to process */
				ll_transrows = ll_transrows - ll_currentrows
				if ll_transrows = 0 or not(lb_success) then
					exit
				end if	
			end if
		end if	
		/* no need to preceed if we have an error already*/
	next

	if lb_success then
		if ll_transrows<>0 then
			of_writetolog("warning, mismatch between processed records and expected.  please check data.",ii_LOG_IMPORTANT)
		end if
		return c#return.Success		
	else
		sqlca.of_rollback()
		/* 
		important: the following function produces a commit on transaction sqlca
		when sending mail message.  so it is important to rollback unwanted changes beforehand.
		*/
		of_writetolog("critical error, process failed confirming rollback",ii_LOG_IMPORTANT)
		return c#return.Failure		
	end if	
	
else
	/* nothing to do */
	return c#return.NoAction
end if	
end function

on n_interfacelogicax.create
call super::create
end on

on n_interfacelogicax.destroy
call super::destroy
end on

