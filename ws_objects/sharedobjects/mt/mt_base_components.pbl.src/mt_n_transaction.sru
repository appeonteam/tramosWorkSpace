$PBExportHeader$mt_n_transaction.sru
$PBExportComments$Transaction Object
forward
global type mt_n_transaction from transaction
end type
end forward

global type mt_n_transaction from transaction
end type
global mt_n_transaction mt_n_transaction

type prototypes
// Declare ORACLE Standard Procedure                                                                         // QNYNT +9
//SUBROUTINE raise_application_error(integer err_code, string err_text) &
//RPCFUNC ALIAS FOR 'STANDARD.raise_oracle_error'

end prototypes

type variables
Boolean ib_read_only = FALSE

String is_connection_type, is_database = 'UNKNOWN'
String is_jag_server, is_jag_port, is_cache_name, is_application
string is_monitor_id = ''

end variables

forward prototypes
public function boolean of_is_connected ()
public subroutine of_parse_sql (string as_sql_syntax, ref string as_select, ref string as_where, ref string as_group_by, ref string as_order_by)
public function long of_row_count (string as_table_name)
public function integer of_rollback ()
public function integer of_disconnect ()
public function string of_syntax_from_sql (string as_sql_select, string as_presentation_style, ref string as_error_string)
public function string of_get_database ()
public function boolean of_sql_error (string as_title)
public function boolean of_connect ()
public function integer of_commit ()
public function integer of_setmonitorid (string as_monitor_id)
end prototypes

public function boolean of_is_connected ();/****************************************************************************************
 \\Ï//	Function : 	of_is_connected
 (@ @)	Access   : 	Public
  (±)		Returns  : 	Boolean
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Disconnets to DataBase
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

IF This.DBHandle() = 0 THEN
	Return FALSE	// transaction is not connected
ELSE
	Return TRUE		// transaction is connected
END IF

end function

public subroutine of_parse_sql (string as_sql_syntax, ref string as_select, ref string as_where, ref string as_group_by, ref string as_order_by);/****************************************************************************************
 \\Ï//	Function : 	of_parse_sql
 (@ @)	Access   : 	Public
  (±)		Returns  : 	None
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Parse SQL Statement and break it into select, order, group, where
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/
Integer 	li_pos

// get the ORDER BY portion
li_pos = Pos(Upper(as_sql_syntax), 'ORDER BY', 1)
IF li_pos > 0 THEN
	as_order_by		= ' ' + Right(as_sql_syntax, Len(as_sql_syntax) - li_pos +1)
	as_sql_syntax 	= Left(as_sql_syntax, li_pos -1)
END IF

// get the GROUP BY portion
li_pos = Pos(Upper(as_sql_syntax), 'GROUP BY', 1)
IF li_pos > 0 THEN
	as_group_by	= ' ' + Right(as_sql_syntax, Len(as_sql_syntax) - li_pos +1)
	as_sql_syntax 	= Left(as_sql_syntax, li_pos -1)
END IF

// get the WHERE condition
li_pos = Pos(Upper(as_sql_syntax), 'WHERE', 1)
IF li_pos > 0 THEN
	as_where = ' ' + Right(as_sql_syntax, Len(as_sql_syntax) - li_pos +1)
	as_select = Left(as_sql_syntax, li_pos -1)
ELSE
	as_select = as_sql_syntax
END IF

end subroutine

public function long of_row_count (string as_table_name);/****************************************************************************************
 \\Ï//	Function : 	of_row_count
 (@ @)	Access   : 	Public
  (±)		Returns  : 	Long, number of rows in a table
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Calculate the number pof rows in table, table name is passes as argument
             This function is using SQLSA (Dynamic Staging Area) and
				 SQLDA(Dynamic Description Area) to dynamicly calculate row count
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/
String ls_dynamic_sql
Long	 ll_row_count

SetPointer(HourGlass!)

// Build SQL statement dynamicly
ls_dynamic_sql = 'SELECT COUNT(*) FROM ' + as_table_name

PREPARE SQLSA FROM :ls_dynamic_sql;
IF of_sql_error('Prepare SQLSA') THEn Return -1

DESCRIBE SQLSA INTO SQLDA;
IF of_sql_error('Describe SQLSA') THEn Return -1

DECLARE dynamic_cursor DYNAMIC CURSOR FOR SQLSA ;
IF of_sql_error('Declare Dynamic Cursor') THEn Return -1

SetDynamicParm(SQLDA, 1, '')
IF of_sql_error('Set Dynamic Parm') THEn Return -1

OPEN DYNAMIC dynamic_cursor USING DESCRIPTOR SQLDA ;
IF of_sql_error('Open Dynamic Cursor') THEn Return -1

FETCH dynamic_cursor USING DESCRIPTOR SQLDA ;
IF of_sql_error('Fetch Dynamic Cursor') THEn Return -1

ll_row_count = GetDynamicNumber(SQLDA, 1)
IF of_sql_error('Get Dynamic Number') THEn Return -1

CLOSE dynamic_cursor;
IF of_sql_error('Close Dynamic Cursor') THEn Return -1

SetPointer(Arrow!)

Return ll_row_count

end function

public function integer of_rollback ();/****************************************************************************************
 \\Ï//	Function : 	of_rollback
 (@ @)	Access   : 	Public
  (±)		Returns  : 	SQLCODE
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Performs DataBase ROLLBACK
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

ROLLBACK USING This;

// check for DB errors
IF of_sql_error('Commit Error') THEN Return -1

IF IsValid(w_sql_spy) THEN
	w_sql_spy.wf_addText(ClassName(), 'ROLLBACK', 0)
END IF

Return This.SQLCode

end function

public function integer of_disconnect ();/****************************************************************************************
 \\Ï//	Function : 	of_disconnect
 (@ @)	Access   : 	Public
  (±)		Returns  : 	SQLCODE
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Disconnets to DataBase
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/
DISCONNECT USING This;

Return SQLCode

end function

public function string of_syntax_from_sql (string as_sql_select, string as_presentation_style, ref string as_error_string);/****************************************************************************************
 \\Ï//	Function : 	of_syntax_from_sql
 (@ @)	Access   : 	Public
  (±)		Returns  : 	String, dw syntax
 HEPEK	Arguments:  as_sql_select, as_presentation_style, as_error_string
-----------------------------------------------------------------------------------------
Description: Creates DW Syntax From SQl
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Return SyntaxFromSql(as_sql_select, as_presentation_style, as_error_string)

end function

public function string of_get_database ();/****************************************************************************************
 \\Ï//	Function : 	of_database
 (@ @)	Access   : 	Public
  (±)		Returns  : 	Boolean
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Determines which database the transaction is connected to
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

Return is_database
end function

public function boolean of_sql_error (string as_title);/****************************************************************************************
 \\Ï//	Function : 	of_sql_error
 (@ @)	Access   : 	Public
  (±)		Returns  : 	Boolean
 HEPEK	Arguments:  String (MessageBox Title)
-----------------------------------------------------------------------------------------
Description: Displays DataBase Error Message
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/

IF This.SqlCode >= 0 THEN Return FALSE // no DB Error

MessageBox(as_title, This.SqlErrText, StopSign!)

Return TRUE

end function

public function boolean of_connect ();/****************************************************************************************
 \\Ï//	Function : 	of_connect
 (@ @)	Access   : 	Public
  (±)		Returns  : 	SQLCODE
 HEPEK	Arguments:  None
-----------------------------------------------------------------------------------------
Description: Connect to DataBase and notify app manager
-----------------------------------------------------------------------------------------
Copyright © 1998 Hepek Corporation. All Rights Reserved.
****************************************************************************************/
n_service_manager  lnv_service
n_error_service    lnv_errservice

SetPointer(HourGlass!)

CONNECT USING This;

// CR3783 - update the monitor record when the transaction is connected
if this.SQLCode = 0 then
	lnv_service.of_loadservice( lnv_errservice , "n_error_service")
	lnv_errservice.of_addmsg(this.classdefinition, &
		"of_connect()", "Transaction is connected", "", 0, is_monitor_id)
	this.SQLCode = 0
end if

// check for DB errors
IF of_sql_error('Connect to DataBase') THEN Return FALSE

// Determine the DB type connected to
IF Upper(DBMS) = 'ODBC' THEN
	CHOOSE CASE This.SqlReturnData
		CASE 'Sybase SQL Anywhere', 'Adaptive Server Anywhere'
			is_database = 'ASA'
		CASE 'Microsoft SQL Server'
			is_database = 'MSQL'
	END CHOOSE
ELSE
	IF Upper(Left(DBMS, 1)) = 'O' THEN 
		is_database = 'ORACLE'
	ELSEIF Upper(Left(DBMS, 1)) = 'SYC' THEN 
		is_database = 'SYBASE'
	END IF
END IF

Return TRUE

end function

public function integer of_commit ();n_service_manager  lnv_service

commit using this;

if isvalid(w_transaction_spy) then
	n_transaction_spy_service		lnv_transpy
	lnv_service.of_loadservice( lnv_transpy , "n_transaction_spy_service")
	lnv_transpy.of_addMonitorDetail(classdefinition, "of_commit()", "commit")
end if

if isvalid(w_sqlsyntax_spy) then
	n_dw_spy_service		lnv_dwspy
	lnv_service.of_loadservice( lnv_dwspy , "n_dw_spy_service")
	lnv_dwspy.of_addMonitorDetail(classdefinition, "of_commit()", "commit")
end if

return c#return.success



end function

public function integer of_setmonitorid (string as_monitor_id);if not isnull(as_monitor_id) then
	is_monitor_id = as_monitor_id
	return c#return.Success
end if

return c#return.Failure
end function

on mt_n_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event sqlpreview;if isvalid(w_transaction_spy)  then
	n_service_Manager  lnv_service
	n_transaction_spy_service		lnv_spy
	lnv_service.of_loadservice( lnv_spy , "n_transaction_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", sqlsyntax)
end if
end event

