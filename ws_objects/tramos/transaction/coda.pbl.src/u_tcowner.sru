$PBExportHeader$u_tcowner.sru
$PBExportComments$UserObject for getting information for a selected TC Owner number
forward
global type u_tcowner from nonvisualobject
end type
end forward

global type u_tcowner from nonvisualobject
end type
global u_tcowner u_tcowner

type variables
datastore ids_tcowner
end variables

forward prototypes
public function string of_getnominalaccount ()
public function boolean of_blocked ()
public function integer of_gettcowner (integer ai_tcowner_nr)
end prototypes

public function string of_getnominalaccount ();string ls_nom_acc

ls_nom_acc = ids_tcowner.GetItemString(1,"nom_acc_nr")
IF IsNull(ls_nom_acc) THEN ls_nom_acc = ""
Return ls_nom_acc
end function

public function boolean of_blocked ();if ids_tcowner.getItemNumber(1, "tcowner_blocked") = 1 then
	return true
else
	return false
end if
end function

public function integer of_gettcowner (integer ai_tcowner_nr);IF ids_tcowner.Retrieve(ai_tcowner_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","TC Owner not found. Object: u_tcowner, Function: of_getTCOwner")
	COMMIT;
	Return(-1)
END IF
end function

event constructor;ids_tcowner = CREATE datastore
ids_tcowner.DataObject = "dw_tcowner"
ids_tcowner.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_tcowner
end event

on u_tcowner.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tcowner.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

