$PBExportHeader$n_fileattach_trans.sru
forward
global type n_fileattach_trans from nonvisualobject
end type
end forward

global type n_fileattach_trans from nonvisualobject autoinstantiate
end type

type variables
protected:
mt_n_transaction  itr_fdb[]
end variables

forward prototypes
public function mt_n_transaction of_get (string as_dbname, boolean ab_created)
end prototypes

public function mt_n_transaction of_get (string as_dbname, boolean ab_created);/********************************************************************
   of_get
   <DESC>	Get the transaction to a file database	</DESC>
   <RETURN>	mt_n_transaction:
            <LI> a valid object of mt_n_transaction if succeeded
            <LI> an invalid object of mt_n_transaction if failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_dbname : the file database name
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		20/08/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_rc
mt_n_transaction ltr_found
long ll_i

if isnull(as_dbname) or as_dbname='' then
	return ltr_found
end if

for ll_i = 1 to upperbound (itr_fdb )
	if upper(itr_fdb[ll_i].Database) = upper(as_dbname) then
		ltr_found = itr_fdb[ll_i]
		exit
	end if
next

if (isnull(ltr_found) or not isvalid(ltr_found)) and ab_created then
	//create a new transaction
	ltr_found = create mt_n_transaction
	
	//set transaction properties
	ltr_found.DBMS = SQLCA.DBMS
	ltr_found.Database = as_dbname
	ltr_found.ServerName = SQLCA.ServerName
	ltr_found.LogId = "DocAdmin"
	ltr_found.LogPass= "xyDocAdmin12"
	ltr_found.AutoCommit = false
	//ACTIVATE UTF8
	ltr_found.DBParm = "release=15,UTF8=1, appname='TramosAppFiles' , host='TramosAppFiles'"
	
	//add the transaction to an array
	itr_fdb[ upperbound (itr_fdb ) + 1 ] = ltr_found
	
end if

return ltr_found


end function

on n_fileattach_trans.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_fileattach_trans.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;long ll_i
long ll_cnt

ll_cnt = upperbound( itr_fdb )
for ll_i = 1 to ll_cnt
	destroy itr_fdb[ll_i]
next
end event

