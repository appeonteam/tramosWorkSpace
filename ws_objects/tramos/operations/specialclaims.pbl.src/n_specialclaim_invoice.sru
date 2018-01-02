$PBExportHeader$n_specialclaim_invoice.sru
$PBExportComments$Printing of invoices for Special Claims
forward
global type n_specialclaim_invoice from mt_n_nonvisualobject
end type
end forward

global type n_specialclaim_invoice from mt_n_nonvisualobject
end type
global n_specialclaim_invoice n_specialclaim_invoice

type variables
mt_n_datastore	ids_specialclaim
end variables

forward prototypes
public function integer of_print (long al_specialclaimid)
public subroutine documentation ()
private subroutine _insertfield (string as_bookmark, string as_content, ref oleobject aole_object, ref oleobject aole_bookmark)
end prototypes

public function integer of_print (long al_specialclaimid);/********************************************************************
   of_print
   <DESC> Generates an invoice based on a word template, and fills in all information
	needed from top to bottom.
	The fields are inserted in word using bookmarks </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  al_specialclaimid: Reference to the claim </ARGS>
   <USAGE> The function is dependent on the existence of the word templates</USAGE>
********************************************************************/
constant string METHOD_NAME = "of_print "
integer		li_vesselNr
string 		ls_vesselName, ls_profitcenterName
string		ls_vesselPrefix = "M.t.", ls_voyage, ls_userid, ls_fullname
datetime		ldt_cpdate
OLEObject 	ole_object, ole_bookmark

if ids_specialclaim.retrieve(al_specialclaimid) <> 1 then
	_addmessage( this.classdefinition, METHOD_NAME , "No Claim data available. Invoice can't be generated", "There is no data available for selected special claim id ("+string( al_specialClaimId ) +")")
	rollback;
	return c#return.failure
end if
commit;

SetPointer(Hourglass!)

SELECT VESSELS.VESSEL_NAME, 
		 PROFIT_C.PC_NAME 
INTO   :ls_vesselName, 
	    :ls_profitcenterName
FROM   VESSELS,   
	    PROFIT_C  
WHERE  PROFIT_C.PC_NR = VESSELS.PC_NR 
AND    VESSELS.VESSEL_NR = :li_vesselNr
USING SQLCA ;
COMMIT USING SQLCA;  

// Open word using OLE
ole_object = CREATE OLEObject

// Connect to word
if (ole_object.connecttonewobject("word.application")) = 0 then
	ole_Bookmark = Create OleObject
	ole_Bookmark.ConnectTonewObject("word.application.bookmark")	

	IF FileExists(uo_global.gs_template_path + "\misc_invoice.dot") THEN
		ole_object.documents.add(uo_global.gs_template_path + "\misc_invoice.dot")
	ELSE
		_addMessage(this.classdefinition, METHOD_NAME, "Wrong File Path in System Options","The file path for MS WORD Templates in 'System Options' the field 'File Path to MS Word templates' is not correct")
		Destroy ole_object
		Return c#return.failure	
	END IF
else
	_addMessage(this.classdefinition, METHOD_NAME, "OLE Error","Unable to start an OLE server process!")
	Destroy ole_object
	Return c#return.failure	
end if

// Get the CP date if any
ls_voyage = ids_specialclaim.getItemString(1, "voyage_nr")
SELECT CAL_CERP.CAL_CERP_DATE  
INTO :ldt_cpdate  
FROM CAL_CARG,   
	CAL_CERP,   
	VOYAGES  
WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID and  
	CAL_CARG.CAL_CALC_ID = VOYAGES.CAL_CALC_ID and  
	VOYAGES.VESSEL_NR = :li_vesselNr  AND  
	VOYAGES.VOYAGE_NR = :ls_voyage ;
if SQLCA.SQLcode = 100 then  //not found
	_insertField("Subject", ls_vesselPrefix + '"' + ls_vesselName + '"', ole_object, ole_bookmark)
else
	_insertField("Subject", ls_vesselPrefix + '"' + ls_vesselName + '" - Charter Party dated ' + string(ldt_cpdate, "d mmm yyyy") , ole_object, ole_bookmark)
end if
commit;

// Set claim information
ls_userid = ids_specialclaim.getItemString(1, "responsible_person")
SELECT FIRST_NAME + ' ' + LAST_NAME
INTO 	 :ls_fullname
FROM 	 USERS, SPECIAL_CLAIM
WHERE  USERS.USERID = SPECIAL_CLAIM.RESPONSIBLE_PERSON;

_insertField("Invoice", "SUPPORTING DOCUMENT:" , ole_object, ole_bookmark)
_insertField("Section", ls_profitcenterName, ole_object, ole_bookmark)
_insertField("Date", string(today(), "dd mmmm yyyy"), ole_object, ole_bookmark)
_insertField("Initials", ls_fullname, ole_object, ole_bookmark)
_insertField("Claimtype", ids_specialclaim.getItemString(1, "special_claim_type"), ole_object, ole_bookmark)
_insertField("Claimtype2", ids_specialclaim.getItemString(1, "amount_desc") + " amount", ole_object, ole_bookmark)
_insertField("Description", ids_specialclaim.getItemString(1, "special_claim_desc"), ole_object, ole_bookmark)
_insertField("Currency1", ids_specialclaim.getItemString(1, "curr_code"), ole_object, ole_bookmark)
_insertField("Currency2", ids_specialclaim.getItemString(1, "curr_code"), ole_object, ole_bookmark)
_insertField("AmountUSD1", string(ids_specialclaim.getItemNumber(1, "amount"), "#,##0.00"), ole_object, ole_bookmark)
_insertField("AmountUSD4", string(ids_specialclaim.getItemNumber(1, "amount"), "#,##0.00"), ole_object, ole_bookmark)

ole_object.visible = true

Destroy ole_Bookmark
Destroy ole_object

return c#return.success
end function

public subroutine documentation ();/********************************************************************
   n_specialclaim_invoice: Used for printing Claim Invoices
   <OBJECT> Opens a Word document invoice template based on profitcenter,
	and fills in all needed details from Claim, Customer, Profitcenter and Vessel </OBJECT>
   <DESC>only public function is of_print where a reference to the special claim is passed.</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>  </ALSO>
    Date   			Ref    	Author     Comments
  	09/07-10 	CR#1543		RMO003     Initial Version
	27/04/11	 	CR2375 		JMC		  Vat_nr from profit center
	02/02/12		M5-6			WWG004	  Change print template
********************************************************************/

end subroutine

private subroutine _insertfield (string as_bookmark, string as_content, ref oleobject aole_object, ref oleobject aole_bookmark);/********************************************************************
   _insertfield 
   <DESC> Find the bookmark in the document, and set the value passed </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_bookmark: Bookmark name
            		as_content: value toset at bookmark
				aole_object: reference to ole object (the document)
				aole_bookmark: reference to bookmark</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
constant string METHOD_NAME = "of_insertField"

If isnull(as_content) then return

If aole_object.activedocument.bookmarks.exists(as_bookmark) then
	aole_Bookmark = aole_Object.ActiveDocument.Bookmarks.Item(as_bookmark)
	aole_Bookmark.Range.Text = as_content
Else
	_addmessage( this.classdefinition, METHOD_NAME,"There was an error when trying to fill content in the Word Documnet Invoice", "The document do not have the specified field " + char(34) + as_bookmark + char(34) + " The document will be created without the missing field.")
End if
end subroutine

on n_specialclaim_invoice.create
call super::create
end on

on n_specialclaim_invoice.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_specialclaim = create mt_n_datastore
ids_specialclaim.dataObject = "d_sq_tb_specialclaim_table"
ids_specialclaim.setTransObject(sqlca)
end event

