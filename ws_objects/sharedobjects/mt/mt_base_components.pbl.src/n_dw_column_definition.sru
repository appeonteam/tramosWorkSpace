$PBExportHeader$n_dw_column_definition.sru
forward
global type n_dw_column_definition from mt_n_nonvisualobject
end type
end forward

global type n_dw_column_definition from mt_n_nonvisualobject autoinstantiate
end type

type variables
/* general variables */
string 		is_column_name
boolean 		ib_mandatory
/* specific to formatter service */
boolean 		ib_special
/* datagrid specific variables */
integer 		ii_visible_default
boolean 		ib_resizable
integer 		ii_xpos
integer 		ii_width
string 		is_visible_expression
/* specific to validation service */
string 		is_secondarycolumn			// column name to validate against.  (datetime)
string 		is_operator			= ""		// used with is_validatedagainst working with secondary column this signifies the comparision required
string 		is_columntype					// string, number or datetime
string 		is_fullname						// full english name of the column so it can be identified
string 		is_secondarycolumnfullname	// full english name of the secondary column so it can be identified (datetime)
datetime 	idt_compare						// physical date to compare against.  usually today()
integer 		ii_daysprior					// used with idt_compare number of days prior allowed
integer 		ii_daysafter					// used with idt_compare number of days after allowed
integer 		ii_minvalue						// used with the number type.  minimum value allowed
integer 		ii_maxvalue						// used with the number type.  maximum value allowed
decimal		id_minvalue						// used with the decimal number type.  minimum value allowed
decimal		id_maxvalue						// used with the decimal number type.  maximum value allowed
integer 		ii_boundary						// used with the number type.  boundary amount allowed.
boolean		ib_duplicatecheck	= false 	// check column for any duplicates
boolean     ib_casesenstive   = true   // used with duplicates check
boolean 		ib_info 				= false	// if validation is used for just informing user of minor issue
string      is_validation_message = ""        // used when the data in the primary column does not pass the validation
string      is_validation_secondarymessage = ""  // used when the data in the secondary column does not pass the validation

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/*
/********************************************************************
   n_dw_column_definition: Container used primarily for the dw style service and dw_validation_service objects
   <OBJECT></OBJECT>
   <DESC></DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
  Date   	Ref	Author     		Comments
  15/07/10 	?     AGL027     			Not doing so much.. yet!
  05/01/11 	?		AGL027				Added validation service requirements
  24/06/11		CR2450	AGL/JSU		Added new property for checking duplicates
  06/06/13		CR2614	AGL			Extended the decimal column validation to include range/boundary checking
  16/07/15		CR4119	AGL027		Added new items into column definition
********************************************************************/


Currently used inside
n_dw_style_service 			The Datawindow Style Service
n_dw_grid_columns 			Grid overrides such as stopping user from resizing columns
n_dw_validation_service	

Future Ideas:
*/
end subroutine

on n_dw_column_definition.create
call super::create
end on

on n_dw_column_definition.destroy
call super::destroy
end on

