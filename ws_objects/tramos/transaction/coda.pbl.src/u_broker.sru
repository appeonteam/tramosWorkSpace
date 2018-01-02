$PBExportHeader$u_broker.sru
$PBExportComments$UserObject for getting information for a selected broker number
forward
global type u_broker from mt_n_nonvisualobject
end type
end forward

global type u_broker from mt_n_nonvisualobject
end type
global u_broker u_broker

type variables
datastore ids_broker
end variables

forward prototypes
public function integer of_getbroker (integer ai_broker_nr)
public function boolean of_own ()
public function string of_getnominalaccount ()
public function boolean of_blocked ()
end prototypes

public function integer of_getbroker (integer ai_broker_nr);IF ids_broker.Retrieve(ai_broker_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	_addmessage( this.classdefinition , "Retrieval error","Broker not found. Object: u_broker, Function: of_getBroker", "")
	COMMIT;
	Return(-1)
END IF
end function

public function boolean of_own ();IF ids_broker.getItemNumber(1, "broker_custsupp") = 1 THEN
	Return(TRUE) /* Internal supplier */
ELSE
	Return(FALSE) /* Foreign supplier */
END IF
end function

public function string of_getnominalaccount ();string ls_nom_acc

ls_nom_acc = ids_broker.GetItemString(1,"nom_acc_nr")
IF IsNull(ls_nom_acc) THEN ls_nom_acc = ""
Return ls_nom_acc

end function

public function boolean of_blocked ();if ids_broker.getItemNumber(1, "broker_blocked") = 1 then
	return true
else
	return false
end if
end function

event constructor;ids_broker = CREATE datastore
ids_broker.DataObject = "dw_broker"
ids_broker.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_broker
end event

on u_broker.create
call super::create
end on

on u_broker.destroy
call super::destroy
end on

