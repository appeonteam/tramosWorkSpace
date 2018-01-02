$PBExportHeader$u_port.sru
$PBExportComments$UserObject for getting information for a selected port code
forward
global type u_port from nonvisualobject
end type
end forward

global type u_port from nonvisualobject
end type
global u_port u_port

type variables
datastore ids_port
end variables

forward prototypes
public function integer of_getport (string as_port_code)
public function string of_getportname ()
end prototypes

public function integer of_getport (string as_port_code);IF ids_port.Retrieve(as_port_code) > 0 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Port not found. Object: u_port, Function: of_getPort")
	COMMIT;
	Return(-1)
END IF
end function

public function string of_getportname ();Return(ids_port.GetItemString(1,"port_n"))
end function

event constructor;ids_port = CREATE datastore
ids_port.DataObject = "d_port_detail"
ids_port.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_port
end event

on u_port.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_port.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

