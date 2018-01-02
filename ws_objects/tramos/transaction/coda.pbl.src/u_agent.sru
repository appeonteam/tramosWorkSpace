$PBExportHeader$u_agent.sru
$PBExportComments$UserObject for getting information for a selected agent number
forward
global type u_agent from nonvisualobject
end type
end forward

global type u_agent from nonvisualobject
end type
global u_agent u_agent

type variables
datastore ids_agent
end variables

forward prototypes
public function integer of_getagent (integer ai_agent_nr)
public function boolean of_own ()
public function string of_getnominalaccount ()
public function string of_getshortname ()
public function boolean of_blocked ()
end prototypes

public function integer of_getagent (integer ai_agent_nr);IF ids_agent.Retrieve(ai_agent_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Agent not found. Object: u_agent, Function: of_getAgent")
	COMMIT;
	Return(-1)
END IF
end function

public function boolean of_own ();IF ids_agent.getItemNumber(1, "agent_custsupp") = 1 THEN
	Return(TRUE) /* Internal supplier */
ELSE
	Return(FALSE) /* Foreign supplier */
END IF
end function

public function string of_getnominalaccount ();string ls_nom_acc

ls_nom_acc = ids_agent.GetItemString(1,"nom_acc_nr")
IF IsNull(ls_nom_acc) THEN ls_nom_acc = ""
Return ls_nom_acc
end function

public function string of_getshortname ();Return ids_agent.GetItemString(1,"agent_sn")
end function

public function boolean of_blocked ();if ids_agent.getItemNumber(1, "agent_blocked") = 1 then
	return true
else
	return false
end if
end function

event constructor;ids_agent = CREATE datastore
ids_agent.DataObject = "dw_agent"
ids_agent.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_agent
end event

on u_agent.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_agent.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

