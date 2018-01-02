$PBExportHeader$u_iom_sin_vessel.sru
$PBExportComments$UserObject for getting information for a selected vessel number
forward
global type u_iom_sin_vessel from nonvisualobject
end type
end forward

global type u_iom_sin_vessel from nonvisualobject
end type
global u_iom_sin_vessel u_iom_sin_vessel

type variables
datastore ids_iom_sin_vessel
end variables

forward prototypes
public function boolean of_getvessel (integer ai_vessel_nr)
public subroutine of_getcrewelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7)
public function integer of_gettoelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, datetime adt_portarrivaldate)
end prototypes

public function boolean of_getvessel (integer ai_vessel_nr);IF ids_iom_sin_vessel.Retrieve(ai_vessel_nr) = 1 THEN
	COMMIT;
	Return(TRUE)
ELSE
	COMMIT;
	Return(FALSE)
END IF
end function

public subroutine of_getcrewelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7);as_el3 = ids_iom_sin_vessel.GetItemString(1, "coda_el3")
as_el4 = ids_iom_sin_vessel.GetItemString(1, "coda_el4")
as_el5 = ids_iom_sin_vessel.GetItemString(1, "coda_el5")
as_el6 = ids_iom_sin_vessel.GetItemString(1, "coda_el6")
as_el7 = ids_iom_sin_vessel.GetItemString(1, "coda_el7_crew")

Return
end subroutine

public function integer of_gettoelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, datetime adt_portarrivaldate);//	This function checks whether the T.O Expense shall be posted as 
// 	Crew expenses or not
// 	in order to post then as TO two things should be fullfilled
// 		1) the post as crew checkbox must be checked
// 		2) the port arrival date must be within given start and enddate
//
// 	If function return -1 then ignore element changes and use general rule
//

// Check if rule is selected
if ids_iom_sin_vessel.getItemNumber(1, "post_to_as_crew") = 0 then return -1

// If rule is selected check if port arrival date < startdate (outside)
if adt_portarrivaldate < ids_iom_sin_vessel.getItemDatetime(1, "post_to_startdate") then return -1

// If enddate given check if port arrival date > enddate (outside)
if not isNull(ids_iom_sin_vessel.getItemDatetime(1, "post_to_enddate")) then
	if adt_portarrivaldate > ids_iom_sin_vessel.getItemDatetime(1, "post_to_enddate") then return -1
end if

// Port arrival date is within given range and shall be posted as Crew Expense with a different element 7
as_el3 = ids_iom_sin_vessel.GetItemString(1, "coda_el3")
as_el4 = ids_iom_sin_vessel.GetItemString(1, "coda_el4")
as_el5 = ids_iom_sin_vessel.GetItemString(1, "coda_el5")
as_el6 = ids_iom_sin_vessel.GetItemString(1, "coda_el6")
as_el7 = ids_iom_sin_vessel.GetItemString(1, "coda_el7_to")
Return 1
end function

event constructor;ids_iom_sin_vessel = CREATE datastore
ids_iom_sin_vessel.DataObject = "d_one_iom_sin_vessel"
ids_iom_sin_vessel.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_iom_sin_vessel
end event

on u_iom_sin_vessel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_iom_sin_vessel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

