$PBExportHeader$n_dw_validation_service.sru
forward
global type n_dw_validation_service from mt_n_baseservice
end type
end forward

global type n_dw_validation_service from mt_n_baseservice
end type
global n_dw_validation_service n_dw_validation_service

type variables
n_dw_column_definition inv_ruledefinition[]
private string _is_findclause=""  /* used predominately for the duplicate process, but can be reused */

/* used by the date comparision */
constant string is_NOT_EQUAL_TO = "<>"
constant string is_TO_BE_LESS_THAN = "<"
constant string is_TO_BE_GREATER_THAN = ">"
constant string is_TO_BE_LESS_THAN_OR_EQUAL_TO = "<="
constant string is_TO_BE_GREATER_THAN_OR_EQUAL_TO = ">="

boolean	ib_ignoreinvisiblecolumn

end variables

forward prototypes
public subroutine documentation ()
public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, datetime adt_compare, integer ai_daysprior, integer ai_daysafter, string as_fullname)
public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_fullname)
public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_minvalue, integer ai_maxvalue, string as_fullname)
public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_minvalue, integer ai_maxvalue, integer ai_boundary, string as_compare, string as_fullname)
public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, string as_fullname)
public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_boundary, string as_compare, string as_fullname)
public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_fullname)
public function integer of_validate (ref datawindow adw, boolean ab_locatecolumn)
public function integer of_validate (powerobject apo, ref string as_message, ref long al_errorrow, ref integer ai_errorcolumn)
public function integer of_setruleaswarning (integer ai_ruleid, boolean ab_info)
public function integer of_validate (ref mt_n_datastore ads, ref long al_row, ref integer ai_column)
public function integer of_setduplicatecheck (integer as_column)
public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_fullname, boolean ab_duplicatecheck)
public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_validated, string as_fullname, boolean ab_duplicatecheck)
public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_fullname, boolean ab_duplicatecheck)
public function string of_getfindclause ()
public function integer of_setfindclause (string as_findclause)
public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, integer ai_boundary, string as_compare, string as_fullname)
public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, string as_fullname)
public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, decimal ad_minvalue, decimal ad_maxvalue, integer ai_boundary, string as_compare, string as_fullname)
public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, decimal ad_minvalue, decimal ad_maxvalue, string as_fullname)
public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_operator, integer ai_daysprior, integer ai_daysafter, datetime adt_compare, string as_fullname, string as_secondarycolumnfullname, boolean ab_duplicatecheck)
public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_operator, string as_fullname, string as_secondaryfullname)
public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_fullname, boolean ab_duplicatecheck, boolean ab_casesenstive)
end prototypes

public subroutine documentation ();/********************************************************************
   n_dw_style_service: Datawindow validation Service
	
   <OBJECT> Applies a simple validation rule over a datawindow.</OBJECT>
   <DESC>Standard validation service.</DESC>
   <USAGE>Validates datawindow/datastore columns.
	Setup VALIDATION Service Sample
	=========================================
	- load the service in usual way -
		lnv_svcmgr.of_loadservice( lnv_transrules, "n_dw_validation_service")
	
	- register all columns requiring validation -
		li_rule = lnv_transrules.of_registerruledatetime("c_trans_val_date", false, datetime(today()),10,10,"transaction date")
		lnv_transrules.of_setruleaswarning( li_rule, true)
		lnv_transrules.of_registerrulestring("c_trans_comment", true, "comment")
		lnv_transrules.of_registerrulestring("c_trans_code", true, "transaction code")  
		lnv_transrules.of_registerruledatetime("c_trans_val_date", true, "transaction date")
		lnv_transrules.of_registerrulenumber( "c_trans_amount", true, "transaction amount" )  
	
	- do the validatation -
		if lnv_validatetransactions.of_validate( dw_claim_transaction , true) = c#return.Failure then return c#return.Failure
	
	</USAGE>
	<LIMITATION>
		* TODO: would be great to be able to maintain the registered columns registering only one time.
		  To be extended at anytime.
		* Duplicate checking has been made on a single column level (so we cannot check for multi column duplicates at this time)
		  It is only for string and datetime variable types.  We have not implemented the number version yet.
	</LIMITATION>
	<ALSO>   
		non visual user object - n_dw_column_defintion
		it is possible to apply many validation rules on the same column.  (see example above with c_trans_val_date)
		using the variable returned you may want to change the validation rule to only a warning. (see example above)
	</ALSO>
    
	 Date   Ref    Author      Comments
  03/01/11 ?      AGL027    	First Version
  05/01/11 ?     	AGL027    	Added multiple rules
  24/06/11 2450	AGL/JSU		Added functionality to check for duplicates
  30/06/11 2450	AGL/JSU		Applied additional clause option to the find duplicate process
  25/08/11 2567	AGL			Added decimal functionality to service
   24/09/11 2528   TTY004		In the  of_validate( datawindow adw, ref string as_message, ref long al_errorrow, ref integer ai_errorcolumn  )
                              Changed the "ldt_data" to "ls_data" when check for duplicates in the string type.
  06/06/13	2614	AGL			Extended the decimal column validation to include range/boundary checking										
  07/01/14  3240  ZSW001      Exclude the invisible column from validation
  14/01/14  3240  ZSW001      Fix the content of error text message
  15/01/14  3240  ZSW001      Fix the content of error text message
  06/03/14  3240  ZSW001      Add ib_ignoreinvisiblecolumn instance variable to decide whether to exclude the invisible column from validation
  31/08/15  3995  SSX014      Correct the error message in range/boundary checking.
********************************************************************/

end subroutine

public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, datetime adt_compare, integer ai_daysprior, integer ai_daysafter, string as_fullname);/* validation rule : days before/after a date */
return of_registerruledatetime( as_column, ab_mandatory, "", "", ai_daysprior, ai_daysafter, adt_compare, as_fullname, "", false)



end function

public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_fullname);/* validation rule : check null datetime */
datetime ldt_dummy
setnull(ldt_dummy)
return of_registerruledatetime( as_column, ab_mandatory, "", "", 0, 0, ldt_dummy, as_fullname, "", false)



end function

public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_minvalue, integer ai_maxvalue, string as_fullname);/* validation rule : check number between a given number range */
return of_registerrulenumber( as_column, ab_mandatory, ai_minvalue, ai_maxvalue, 0, "", as_fullname)


end function

public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_minvalue, integer ai_maxvalue, integer ai_boundary, string as_compare, string as_fullname);/********************************************************************
  of_registerrulenumber( /*string as_column*/, /*boolean ab_mandatory*/, /*integer ai_minvalue*/, /*integer ai_maxvalue*/, /*integer ai_boundary*/, /*string as_compare*/, /*string as_fullname */)
  
   <DESC>   load validation rule array with number specific detail</DESC>
   <RETURN> Integer:
            <LI> > 0, reference to array element
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   	<ARGS>   
		as_column: column name definition
          ab_mandatory: if user must enter data in given column
		ai_minvalue: minimum value allowed <not implemented>
		ai_maxvalue: maximum value allowed <not implemented>
		ai_boundary: range allowed checked against another column/value <not implemented>
		as_compare: number column to check against
		as_fullname: full english name used to reference in message to user
	</ARGS>
   	<USAGE>  Once service is setup and rule is registered just call of_validate()</USAGE>
********************************************************************/
integer	li_newindex

if isnull(as_column) or len(trim(as_column))=0 then return c#return.Failure
as_column = Lower(Trim(as_column))
li_newindex = UpperBound(inv_ruledefinition) + 1
inv_ruledefinition[li_newindex].is_columntype = "number"
inv_ruledefinition[li_newindex].is_column_name = as_column
inv_ruledefinition[li_newindex].is_fullname = as_fullname
inv_ruledefinition[li_newindex].ib_mandatory = ab_mandatory
//inv_ruledefinition[li_newindex].is_secondarycolumn = as_compare
inv_ruledefinition[li_newindex].ii_boundary  = ai_boundary
inv_ruledefinition[li_newindex].ii_minvalue = ai_minvalue
inv_ruledefinition[li_newindex].ii_maxvalue = ai_maxvalue

return  li_newindex
end function

public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, string as_fullname);/* validation rule : check number column for null value */
return of_registerrulenumber( as_column, ab_mandatory, 0, 0, 0, "", as_fullname)

end function

public function integer of_registerrulenumber (string as_column, boolean ab_mandatory, integer ai_boundary, string as_compare, string as_fullname);/* validation rule : check number range against another number column */
return of_registerrulenumber( as_column, ab_mandatory, 0, 0, ai_boundary, as_compare, as_fullname)
end function

public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_fullname);/* validation rule : check string for null value */
return of_registerrulestring( as_column, ab_mandatory, "", as_fullname, false)
end function

public function integer of_validate (ref datawindow adw, boolean ab_locatecolumn);/********************************************************************
  of_validate( /*ref datawindow adw*/, /*boolean ab_showmessage */)

   <DESC>Used if validation process requires an error message and a positioning of row/column cursor</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>datawindow adw : datawindow to be used
   			boolean ab_locatecolumn : if we want the user to be directed to column and row where the error occured.
	</ARGS>
   <USAGE>  Currently called via the service manager directly on validation request.  If wanting to do something specific with validation
	message just use   of_validate( /*ref datawindow adw*/, /*ref string as_message*/, /*ref long al_errorrow*/, /*ref integer ai_errorcolumn */)
	</USAGE>
********************************************************************/

string						ls_colname, ls_data, ls_failed="", ls_message
long 						ll_rows, ll_row, ll_columncount, ll_data
integer 					li_column

constant string METHOD_NAME = "of_validate( /*ref datawindow adw*/, /*boolean ab_locatecolumn */)"
if of_validate( adw, ls_message, ll_row, li_column)=c#return.Failure then
	_addmessage( this.classdefinition, METHOD_NAME, ls_message, "user notification of validation error using validation service n_dw_validation_service")
	if ab_locatecolumn then
		adw.selectRow(0,false)
		adw.selectRow(ll_row,true)
		adw.setrow( ll_row)
		adw.scrolltorow(ll_row)
		adw.post setcolumn(li_column)
		adw.post setfocus()
		return c#return.Failure
	end if
end if
return c#return.Success
end function

public function integer of_validate (powerobject apo, ref string as_message, ref long al_errorrow, ref integer ai_errorcolumn);/********************************************************************
  of_validate( /*datawindow adw*/, /*ref string as_message*/, /*ref long al_errorrow*/, /*ref integer ai_errorcolumn */ )
		
   <DESC>   general validation script for validating user entries </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   
	datawindow adw : <reference> of the datawindow we are making the comparison on.
	string as_message : <reference> the message that will be stored and returned to the calling process.  returns "" if no error found
	long al_errorrow : <reference> to the row the error is found on.  returns 0 if no error found
	integer ai_errorcolumn : <reference> to the column number with the error.  returns 0 if no error found
	</ARGS>
   <USAGE>  business logic behind the button.
	TODO: would be preferable to use this one function to validate the actions too, this
	is left now due to not all columns being mandatory there.</USAGE>
********************************************************************/


string				ls_colname, ls_data, ls_find, ls_failed="", ls_fullname = "", ls_nullalternate, ls_visible, ls_fullsecondname
datawindow			ldw
mt_n_datastore		lds
long 					ll_rows, ll_row, ll_columncount, ll_column, ll_registeredcolumn, ll_found, ll_pos
boolean 				lb_ignorecolumn
long					ll_data
date					ld_data, ld_compare
datetime				ldt_data, ldt_secondarydata
decimal 				ldc_data
string            ls_compexpr, ls_tmp
mt_n_stringfunctions     lnv_string
boolean           lb_hasseconddata = false
integer           li_secondcolumn

constant string METHOD_NAME = "of_validate( /*datawindow adw*/, /*ref string as_message*/, /*ref long al_errorrow*/, /*ref integer ai_errorcolumn */)"

/* check powerbuilder object passed into function.  we support datawindow or a datastore */
lds = create mt_n_datastore
ai_errorcolumn = 0
al_errorrow = 0

choose case apo.typeOf()
	case 	datawindow!	
		// set as shared with local datastore
		ldw = apo
		lds.settransobject(sqlca)
		lds.dataobject = ldw.dataobject
		ldw.sharedata(lds)
	case 	datastore!
		// do nothing
		lds = apo		
	case 	datawindowchild!
		// not supported yet
	case else
		return c#return.NoAction
end choose

//ldw = create datawindow
//ldw = apo

/* any columns registered within the service? */
if upperbound(inv_ruledefinition)<1 then return c#return.NoAction


ll_rows = lds.rowCount()
for al_errorrow = 1 to ll_rows
	if lds.getitemstatus( al_errorrow, 0, primary!) = NewModified! or &
		lds.getitemstatus( al_errorrow, 0, primary!) = DataModified! then
		for ll_registeredcolumn = 1 to upperbound(inv_ruledefinition)
			if ib_ignoreinvisiblecolumn then
				ls_visible = lds.describe(inv_ruledefinition[ll_registeredcolumn].is_column_name + ".visible")
				ll_pos = pos(ls_visible, "~t")
				if ll_pos > 0 then
					ls_visible = mid(ls_visible, ll_pos + len("~t"))
					if right(ls_visible, len('"')) = '"' then ls_visible = left(ls_visible, len(ls_visible) - len('"'))
					ls_visible = lds.describe("evaluate('" + ls_visible + "', " + string(al_errorrow) + ")")
				end if
				if ls_visible = "0" then continue
			end if
			
			/* build string for error message */
			if inv_ruledefinition[ll_registeredcolumn].is_fullname<>"" then 
				ls_fullname = " inside " + inv_ruledefinition[ll_registeredcolumn].is_fullname
			else
				ls_fullname = ""
			end if
			
			/* for each column type, validate accordingly */
			choose case inv_ruledefinition[ll_registeredcolumn].is_columntype
				case "string"  
					ls_data = lds.getitemstring(al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_column_name )	
					/* check for mandatory */			
					if inv_ruledefinition[ll_registeredcolumn].ib_mandatory then
						if inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn<>"" then 
							ls_nullalternate = lds.getitemstring(al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn)
							if (ls_nullalternate="" or isnull(ls_nullalternate)) and (ls_data = "" or isnull(ls_data))  then
								as_message = "The data" + ls_fullname + " cannot be empty. Please amend before updating."
							end if
						else
							if ls_data = "" or isnull(ls_data) then 
								as_message = "The data" + ls_fullname + " cannot be empty. Please amend before updating."
							end if
						end if
					end if
					/* do we check for duplicates */
					if inv_ruledefinition[ll_registeredcolumn].ib_duplicatecheck then
						ls_tmp = lnv_string.of_replaceAll(ls_data,"'","~~'",false)
						if inv_ruledefinition[ll_registeredcolumn].ib_casesenstive then
							ls_compexpr = inv_ruledefinition[ll_registeredcolumn].is_column_name + "='" + ls_tmp + "'"
						else
							ls_compexpr = "Upper(" + inv_ruledefinition[ll_registeredcolumn].is_column_name + ") = '" + Upper(ls_tmp)+ "'"
						end if
						ls_find = ls_compexpr + " and getrow()<>" + string(al_errorrow)
						if of_getfindclause() <> "" then ls_find += " and " + of_getfindclause()
						ll_found = lds.find(ls_find ,1, ll_rows)
						if ll_found>0 then as_message = "The data" + ls_fullname + " cannot be duplicated. Please amend before updating."
					end if
					
				case "decimal"
					
					ldc_data = lds.getitemdecimal(al_errorrow,  inv_ruledefinition[ll_registeredcolumn].is_column_name )	
					/* check for mandatory */					
					if inv_ruledefinition[ll_registeredcolumn].ib_mandatory then
						if ldc_data = 0.0 or isnull(ldc_data) then as_message = "The data" + ls_fullname + " cannot be empty. Please amend before updating."		 
					end if
					/* boundary check */
					if  as_message="" and  inv_ruledefinition[ll_registeredcolumn].id_minvalue <> inv_ruledefinition[ll_registeredcolumn].id_maxvalue then
						if inv_ruledefinition[ll_registeredcolumn].id_minvalue > ldc_data then
							if inv_ruledefinition[ll_registeredcolumn].id_minvalue = 0 then
								as_message = "The " + inv_ruledefinition[ll_registeredcolumn].is_fullname + " cannot be negative."
							else
								as_message = "The data" + ls_fullname + " must be greater than or equal to " + string(inv_ruledefinition[ll_registeredcolumn].id_minvalue) + ". Please amend before updating."
							end if
						else
							if  inv_ruledefinition[ll_registeredcolumn].id_maxvalue < ldc_data then 
								as_message = "The data" + ls_fullname + " must be less than or equal to " + string(inv_ruledefinition[ll_registeredcolumn].id_maxvalue) + ". Please amend before updating."		 
							end if
						end if	
					end if
					
				case "number"
					
					ll_data = lds.getitemnumber(al_errorrow,  inv_ruledefinition[ll_registeredcolumn].is_column_name )	
					/* check for mandatory */					
					if inv_ruledefinition[ll_registeredcolumn].ib_mandatory then
						if ll_data = 0 or isnull(ll_data) then
							as_message = "The " + inv_ruledefinition[ll_registeredcolumn].is_fullname + " cannot be empty."
						end if
					end if
				case "datetime"
					ldt_data = lds.getitemdatetime(al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_column_name )	
					if inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn<>"" &
						and inv_ruledefinition[ll_registeredcolumn].is_operator<>"" &
						and inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname<>"" then
						lb_hasseconddata = true
						ldt_secondarydata = lds.getitemdatetime(al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn)
						li_secondcolumn = integer(lds.Describe(inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn + ".id"))
					end if
					/* check for mandatory */
					if inv_ruledefinition[ll_registeredcolumn].ib_mandatory then
						if ldt_data = datetime("") or isnull(ldt_data) then
							as_message = "The " + inv_ruledefinition[ll_registeredcolumn].is_fullname + " cannot be empty."
						else
							if lb_hasseconddata then
								ls_fullsecondname = inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname
								if ldt_secondarydata = datetime("") or isnull(ldt_secondarydata) then
									as_message = "The " + ls_fullsecondname + " cannot be empty."
									ai_errorcolumn = li_secondcolumn
								end if
							end if
						end if
					end if
					/* do check for duplicates? */
					if inv_ruledefinition[ll_registeredcolumn].ib_duplicatecheck then
						ls_find = inv_ruledefinition[ll_registeredcolumn].is_column_name + "=datetime('" + string(ldt_data)+ "') and getrow()<>" + string(al_errorrow)
						if of_getfindclause() <>"" then ls_find += " and " + of_getfindclause()
						ll_found = lds.find(ls_find,1, ll_rows)
						if ll_found>0 then as_message = "The data" + ls_fullname + " cannot be a duplicate. Please amend before updating."
					end if
					/* additional date/time validation */
					if  inv_ruledefinition[ll_registeredcolumn].ii_daysprior > 0 or  inv_ruledefinition[ll_registeredcolumn].ii_daysafter > 0 then
						if inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn="" then
							if not isnull(inv_ruledefinition[ll_registeredcolumn].idt_compare) then
								ld_data = date(ldt_data)
								ld_compare = date(inv_ruledefinition[ll_registeredcolumn].idt_compare)
								if ld_data < relativeDate( ld_compare, 0 - inv_ruledefinition[ll_registeredcolumn].ii_daysprior) then
									as_message = "The data" + ls_fullname + " entered in row# "+string(al_errorrow) +" is less than 10 days from today. Please amend before updating."
								end if
								if ld_data  > relativeDate( ld_compare, inv_ruledefinition[ll_registeredcolumn].ii_daysafter) then
									as_message = "The data" + ls_fullname + " entered in row# "+string(al_errorrow) +" is more than 10 days from today. Please amend before updating."								
								end if
							else						
								/* nothing to do as yet.. */
							end if
						end if
					else		

						/* compare with another datetime column instead of a date that has been passed in. */
						if lb_hasseconddata then
							
							/* as text here is simplified we must reload ls_fullname 
							TODO in future - simplify other error message structures */
							ls_fullname = inv_ruledefinition[ll_registeredcolumn].is_fullname

							ldt_secondarydata = lds.getitemdatetime(al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_secondarycolumn)	
							CHOOSE CASE inv_ruledefinition[ll_registeredcolumn].is_operator
								CASE ">"
									if not isnull(ldt_data) and not isnull(ldt_secondarydata) then
										if ldt_data > ldt_secondarydata then
											/* all is ok, bascially this also means data cannot be equal, although message is the same as ">=" */
										else
											as_message = "The " + ls_fullname + " cannot be before the " + inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname + "."
											ai_errorcolumn = li_secondcolumn
										end if
									end if
								CASE "<"
									if not isnull(ldt_data) and not isnull(ldt_secondarydata) then
										if ldt_data < ldt_secondarydata then
											/* all is ok, bascially this also means data cannot be equal, although message is the same as "<=" */
										else
											as_message = "The " + ls_fullname + " cannot be after the " + inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname + "."
											ai_errorcolumn = li_secondcolumn
										end if
									end if
								CASE ">="
									if not isnull(ldt_data) and not isnull(ldt_secondarydata) then
										if ldt_data >= ldt_secondarydata then
											/* all is ok */
										else
											as_message = "The " + ls_fullname + " cannot be before the " + inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname + "."
											ai_errorcolumn = li_secondcolumn
										end if
									end if
								CASE "<="
									if not isnull(ldt_data) and not isnull(ldt_secondarydata) then
										if ldt_data <= ldt_secondarydata then
										/* all is ok */
										else
											as_message = "The " + ls_fullname + " cannot be after the " + inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname + "."
											ai_errorcolumn = li_secondcolumn
										end if
									end if
								CASE "<>"	
									if not isnull(ldt_data) and not isnull(ldt_secondarydata) then
										if ldt_data <> ldt_secondarydata then
											/* all is ok */
										else
											as_message = "The " + ls_fullname + " cannot be equal to the " + inv_ruledefinition[ll_registeredcolumn].is_secondarycolumnfullname + "."
											ai_errorcolumn = li_secondcolumn
										end if
									end if
								CASE ELSE
									/* do nothing! */
							END CHOOSE		
						end if
					end if
				case "!", ""
			end choose					
			/* if error message generated check if it is to halt processing or only a warning */
			if as_message <> "" and not inv_ruledefinition[ll_registeredcolumn].ib_info then
				if ai_errorcolumn = 0 then ai_errorcolumn =  integer(lds.Describe(inv_ruledefinition[ll_registeredcolumn].is_column_name + ".id"))
				return c#return.Failure
			elseif as_message<>"" and inv_ruledefinition[ll_registeredcolumn].ib_info then
				/* we need to just display the warning message as continue as is */
				if lds.getitemstatus( al_errorrow, inv_ruledefinition[ll_registeredcolumn].is_column_name, Primary!)<>NotModified! then		
					as_message+="~r~n~r~nIn case this is correct, ignore this message, otherwise please correct the data."								
					_addmessage( this.classdefinition, METHOD_NAME, as_message, "user notification of information concerning validation")
				end if
				as_message = ""
			end if
		next	
	end if
next
/* no errors so we return back to calling process with success */
ai_errorcolumn=0
al_errorrow=0


return c#return.Success

end function

public function integer of_setruleaswarning (integer ai_ruleid, boolean ab_info);if upperbound(inv_ruledefinition)<ai_ruleid then return c#return.NoAction
inv_ruledefinition[ai_ruleid].ib_info = true
return c#return.Success
end function

public function integer of_validate (ref mt_n_datastore ads, ref long al_row, ref integer ai_column);/********************************************************************
  of_validate( /*ref datawindow adw*/, /*boolean ab_showmessage */)

   <DESC>Used if validation process requires an error message and a positioning of row/column cursor</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>datawindow adw : datawindow to be used
   			boolean ab_locatecolumn : if we want the user to be directed to column and row where the error occured.
	</ARGS>
   <USAGE>  Currently called via the service manager directly on validation request.  If wanting to do something specific with validation
	message just use   of_validate( /*ref datawindow adw*/, /*ref string as_message*/, /*ref long al_errorrow*/, /*ref integer ai_errorcolumn */)
	</USAGE>
********************************************************************/

string						ls_colname, ls_data, ls_failed="", ls_message
long 						ll_rows, ll_row, ll_columncount, ll_data
integer 					li_column

constant string METHOD_NAME = "of_validate( /*ref datawindow adw*/, /*boolean ab_locatecolumn */)"
if of_validate( ads, ls_message, al_row, ai_column)=c#return.Failure then
	_addmessage( this.classdefinition, METHOD_NAME, ls_message, "user notification of validation error using validation service n_dw_validation_service")
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_setduplicatecheck (integer as_column);


return c#return.Success
end function

public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_fullname, boolean ab_duplicatecheck);/* validation rule : check duplicate row */
datetime ldt_dummy
setnull(ldt_dummy)
return of_registerruledatetime( as_column, ab_mandatory, "", "", 0, 0, ldt_dummy, as_fullname, "", ab_duplicatecheck)




end function

public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_validated, string as_fullname, boolean ab_duplicatecheck);/* validation rule : check string with case senstivity */
return of_registerrulestring( as_column, ab_mandatory, "", as_fullname, ab_duplicatecheck, true)

end function

public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_fullname, boolean ab_duplicatecheck);/* validation rule : check string for null value */
return of_registerrulestring( as_column, ab_mandatory, "", as_fullname, ab_duplicatecheck)
end function

public function string of_getfindclause ();return _is_findclause
end function

public function integer of_setfindclause (string as_findclause);_is_findclause = as_findclause
return c#return.Success
end function

public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, integer ai_boundary, string as_compare, string as_fullname);/* validation rule : check number range against another number column */
return of_registerruledecimal( as_column, ab_mandatory, 0, 0, ai_boundary, as_compare, as_fullname)
end function

public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, string as_fullname);/* validation rule : check number column for null value */
return of_registerruledecimal( as_column, ab_mandatory, 0.0, 0.0, 0, "", as_fullname)

end function

public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, decimal ad_minvalue, decimal ad_maxvalue, integer ai_boundary, string as_compare, string as_fullname);/********************************************************************
  of_registerruledecimal( /*string as_column*/, /*boolean ab_mandatory*/, /*decimal ad_minvalue*/, /*decimal ad_maxvalue*/, /*integer ai_boundary*/, /*string as_compare*/, /*string as_fullname */)
  
   <DESC>   load validation rule array with number specific detail</DESC>
   <RETURN> Integer:
            <LI> > 0, reference to array element
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   	<ARGS>   
		as_column: column name definition
          ab_mandatory: if user must enter data in given column
		ad_minvalue: minimum value allowed 
		ad_maxvalue: maximum value allowed 
		ai_boundary: range allowed checked against another column/value <not implemented>
		as_compare: number column to check against
		as_fullname: full english name used to reference in message to user
	</ARGS>
   	<USAGE>  Once service is setup and rule is registered just call of_validate()</USAGE>
********************************************************************/
integer	li_newindex

if isnull(as_column) or len(trim(as_column))=0 then return c#return.Failure
as_column = Lower(Trim(as_column))
li_newindex = UpperBound(inv_ruledefinition) + 1
inv_ruledefinition[li_newindex].is_columntype = "decimal"
inv_ruledefinition[li_newindex].is_column_name = as_column
inv_ruledefinition[li_newindex].is_fullname = as_fullname
inv_ruledefinition[li_newindex].ib_mandatory = ab_mandatory
inv_ruledefinition[li_newindex].is_secondarycolumn = as_compare
inv_ruledefinition[li_newindex].ii_boundary  = ai_boundary
inv_ruledefinition[li_newindex].id_minvalue = ad_minvalue
inv_ruledefinition[li_newindex].id_maxvalue = ad_maxvalue

return  li_newindex
end function

public function integer of_registerruledecimal (string as_column, boolean ab_mandatory, decimal ad_minvalue, decimal ad_maxvalue, string as_fullname);/* validation rule : check number between a given number range */
return of_registerruledecimal( as_column, ab_mandatory, ad_minvalue, ad_maxvalue, 0, "", as_fullname)


end function

public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_operator, integer ai_daysprior, integer ai_daysafter, datetime adt_compare, string as_fullname, string as_secondarycolumnfullname, boolean ab_duplicatecheck);/********************************************************************
  of_registerruledatetime( /*string as_column*/, /*boolean ab_mandatory*/, /*string as_secondarycolumnt*/, /*integer ai_daysprior*/, /*integer ai_daysafter*/, /*datetime adt_compare*/, /*string as_fullname */, /*string as_secondarycolumnfullname */, /*boolean ab_duplicatecheck*/)
  
   <DESC>   load validation rule array with datetime specific detail</DESC>
   <RETURN> Integer:
            <LI> > 0, reference to array element
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   	<ARGS>   
		as_column: column name definition
          ab_mandatory: if user must enter data in given column
		as_secondarycolumn: column name of another datetime field to check against <not implemented>	 
		as_operator: used with validateagainst.  should it be >,<,>=,<=, <> etc. 
		ai_daysprior: days prior either column (as_validatedagainst) or actual date passed (adt_compare)
		ai_daysafter: days after either column (as_validatedagainst) or actual date passed (adt_compare)
		adt_compare: a datetime variable to check against
		as_fullname: full english name used to reference in message to user
		as_secondarycolumnfullname: full english name used to reference second column that used to compared
		ab_duplicatecheck: ??
	</ARGS>
   	<USAGE>  Once service is setup and rule is registered just call of_validate()</USAGE>
********************************************************************/

integer	li_newindex

if isnull(as_column) or len(trim(as_column))=0 then return c#return.Failure
as_column = Lower(Trim(as_column))
li_newindex = UpperBound(inv_ruledefinition) + 1
inv_ruledefinition[li_newindex].is_columntype = "datetime"
inv_ruledefinition[li_newindex].is_column_name = as_column
inv_ruledefinition[li_newindex].is_fullname = as_fullname
inv_ruledefinition[li_newindex].ib_mandatory = ab_mandatory
inv_ruledefinition[li_newindex].is_secondarycolumn = as_secondarycolumn
inv_ruledefinition[li_newindex].is_secondarycolumnfullname = as_secondarycolumnfullname
inv_ruledefinition[li_newindex].is_operator = as_operator
inv_ruledefinition[li_newindex].ii_daysprior = ai_daysprior
inv_ruledefinition[li_newindex].ii_daysafter = ai_daysafter
inv_ruledefinition[li_newindex].idt_compare = adt_compare
inv_ruledefinition[li_newindex].ib_duplicatecheck  = ab_duplicatecheck

return li_newindex
end function

public function integer of_registerruledatetime (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_operator, string as_fullname, string as_secondaryfullname);/* validation rule : check against another datetime column */
datetime ldt_dummy
setnull(ldt_dummy)
return of_registerruledatetime( as_column, ab_mandatory, as_secondarycolumn, as_operator, 0, 0, ldt_dummy, as_fullname, as_secondaryfullname, false)

end function

public function integer of_registerrulestring (string as_column, boolean ab_mandatory, string as_secondarycolumn, string as_fullname, boolean ab_duplicatecheck, boolean ab_casesenstive);/********************************************************************
  of_registerrulestring( /*string as_column*/, /*boolean ab_mandatory*/, /*string as_validated*/, /*string as_fullname */)
  
   <DESC>    load validation rule array with string specific detail</DESC>
   <RETURN> Integer:
            <LI> > 0, reference to array element
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   	<ARGS>   
		as_column: column name definition
          ab_mandatory: if user must enter data in given column
		as_secondarycolumn: column name to check against <not implemented>
		as_fullname: full english name used to reference in message to user
		ab_duplicatecheck: a check to see if the column needs to be unique.  when enabled system
		validates duplicates.
	</ARGS>
   	<USAGE>  Once service is setup and rule is registered just call of_validate()</USAGE>
********************************************************************/

integer	li_newindex
if isnull(as_column) or len(trim(as_column))=0 then return c#return.Failure
as_column = Lower(Trim(as_column))
li_newindex = UpperBound(inv_ruledefinition) + 1
inv_ruledefinition[li_newindex].is_columntype = "string"
inv_ruledefinition[li_newindex].is_column_name = as_column
inv_ruledefinition[li_newindex].is_fullname = as_fullname
inv_ruledefinition[li_newindex].ib_mandatory = ab_mandatory
inv_ruledefinition[li_newindex].is_secondarycolumn = as_secondarycolumn
inv_ruledefinition[li_newindex].ib_duplicatecheck = ab_duplicatecheck
inv_ruledefinition[li_newindex].ib_casesenstive = ab_casesenstive

return li_newindex

end function

on n_dw_validation_service.create
call super::create
end on

on n_dw_validation_service.destroy
call super::destroy
end on

event constructor;call super::constructor;this.#pooled=false

end event

