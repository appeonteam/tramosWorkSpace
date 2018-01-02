$PBExportHeader$n_sql_table_function.sru
$PBExportComments$The user object has one function which finds all column names and the position of the voyage number for a specified table.
forward
global type n_sql_table_function from nonvisualobject
end type
end forward

global type n_sql_table_function from nonvisualobject
end type
global n_sql_table_function n_sql_table_function

forward prototypes
public function integer uf_get_columns (string as_table, ref string as_columns[])
public function integer uf_get_columns_vessel (string as_table, ref string as_columns[])
end prototypes

public function integer uf_get_columns (string as_table, ref string as_columns[]);string ls_col_name
long ll_counter
integer li_position
// Declare cursor, to get the all the  columnnames  from the table 

DECLARE Col_cursor Cursor FOR
  SELECT SYSCOLUMNS_VIEW.name  
  FROM sysobjects,SYSCOLUMNS_VIEW  
  WHERE ( sysobjects.id = SYSCOLUMNS_VIEW.id ) and  
         ( ( sysobjects.name = :as_table ) AND  
         ( sysobjects.type = 'U' ) );   

open col_cursor;

do 
	FETCH col_cursor INTO :ls_col_name ;

if sqlca.sqlcode = 0 then 
	ll_counter++
	as_columns[ll_counter] = ls_col_name
	if ls_col_name = "VOYAGE_NR" then
		li_position = ll_counter
	end if
end if 

loop while sqlca.sqlcode = 0 

close col_cursor;

return li_position


end function

public function integer uf_get_columns_vessel (string as_table, ref string as_columns[]);string ls_col_name
long ll_counter
integer li_position
// Declare cursor, to get the all the  columnnames  from the table 

DECLARE Col_cursor Cursor FOR
  SELECT syscolumns.name  
  FROM sysobjects,syscolumns  
  WHERE ( sysobjects.id = syscolumns.id ) and  
         ( ( sysobjects.name = :as_table ) AND  
         ( sysobjects.type = 'U' ) );   

open col_cursor;

do 
	FETCH col_cursor INTO :ls_col_name ;

if sqlca.sqlcode = 0 then 
	ll_counter++
	as_columns[ll_counter] = ls_col_name
	if ls_col_name = "VESSEL_NR" then
		li_position = ll_counter
	end if
end if 

loop while sqlca.sqlcode = 0 

close col_cursor;

return li_position


end function

on n_sql_table_function.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sql_table_function.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

