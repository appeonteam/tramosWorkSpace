$PBExportHeader$n_service_manager.sru
forward
global type n_service_manager from mt_n_nonvisualobject
end type
type str_service_controller from structure within n_service_manager
end type
end forward

type str_service_controller from structure
	string		classname
	integer		counter
	mt_n_baseservice		service
end type

shared variables
str_service_controller sstr_service[]
end variables

global type n_service_manager from mt_n_nonvisualobject autoinstantiate
end type

type variables
public protectedwrite string ErrorMessage

private:
str_service_controller __istr_service[]
end variables

forward prototypes
public subroutine of_unloadallservices ()
private function integer __findservice (readonly boolean ab_shared, readonly string as_classname)
private function integer __getavailableindex (readonly boolean ab_shared)
private subroutine __loadservice (ref mt_n_baseservice anv_service, readonly string as_classname)
public function integer of_getserviceusage (readonly string as_classname)
public function integer of_loadservice (ref mt_n_baseservice anv_service, readonly string as_classname)
public subroutine of_unloadservice (readonly string as_classname, readonly boolean ab_destroy)
public subroutine of_unloadservice (readonly string as_classname)
public subroutine of_unloadservices (readonly boolean ab_destroy)
public subroutine of_unloadservices (readonly string as_classnames[])
private subroutine documentation ()
end prototypes

public subroutine of_unloadallservices ();of_unloadservices(true)

//ensure destruction
long llCounter, i

llCounter = UpperBound(sstr_service)
for i = 1 to llCounter
//	DestroyObject(sstr_service[i].Service)
next

//empty arrays
str_service_controller lstr_service[]
__istr_service = lstr_service
sstr_service = lstr_service
end subroutine

private function integer __findservice (readonly boolean ab_shared, readonly string as_classname);long i, llCount
str_service_controller lstr_service[]

if ab_shared then
	lstr_service = sstr_service
else
	lstr_service = __istr_service
end if

llCount = UpperBound(lstr_service)

for i = 1 to llCount
	if IsEqual(lstr_service[i].ClassName, as_className) &
		and IsValid(lstr_service[i].Service) then return i
next

return C#Return.Failure
end function

private function integer __getavailableindex (readonly boolean ab_shared);integer liCounter, i
str_service_controller lstr_service[]

//determine search shared or instance pool
if ab_shared then
	lstr_service = sstr_service
else
	lstr_service = __istr_service
end if

liCounter = UpperBound(lstr_service)

if liCounter > 0 then
	for i = 1 to liCounter
		if 0 = lstr_service[i].Counter then
			if IsValid(lstr_service[i].Service) then
				continue
			else
				return i
			end if
		end if
	next
	return liCounter + 1
else
	//return 1st index
	return 1
end if
end function

private subroutine __loadservice (ref mt_n_baseservice anv_service, readonly string as_classname);integer i, c
string lsError

//check if passed variable is instantiated
if IsValid(anv_service) then return

//search if class locally loaded
i = __findService(false, as_className)
if i > 0 then 
	//return reference
	anv_service = __istr_service[i].Service
	return
end if

//search if class is already shared
i = __findService(true, as_className)
try
	if i > 0 then 
		//add to local array
		c = UpperBound(__istr_service) + 1
		__istr_service[c].Classname = sstr_service[i].Classname
		__istr_service[c].Service = sstr_service[i].Service
		//increment usage counter
		sstr_service[i].Counter = sstr_service[i].counter + 1
	else
		//instantiate and share if does not exists
		i = __getAvailableIndex(true)
		//create shared
		sstr_service[i].Classname = as_className
		sstr_service[i].Service = create using as_className
		sstr_service[i].Counter = 1
		//add to local array
		c = __getAvailableIndex(false)
		__istr_service[c].Classname = sstr_service[i].Classname
		__istr_service[c].Service = sstr_service[i].Service
	end if
	//return reference
	anv_service = __istr_service[c].Service
catch (Throwable ex)
	lsError = ex.GetMessage()
finally
	ErrorMessage = lsError
end try
end subroutine

public function integer of_getserviceusage (readonly string as_classname);integer i

i = __findService(true, as_className)

if C#Return.Failure = i then return 0

return sstr_service[i].Counter
end function

public function integer of_loadservice (ref mt_n_baseservice anv_service, readonly string as_classname);try
	__loadService(anv_service, as_className)
catch (Throwable ex)
	return C#Return.Failure
end try

return C#Return.Success
end function

public subroutine of_unloadservice (readonly string as_classname, readonly boolean ab_destroy);integer i

//search for class
i = __findService(true, as_className)

if C#Return.Failure = i then return

//decrement counter
sstr_service[i].Counter --

//When service is #pooled, class is shared globally
//Always keep one instance active
if not ab_destroy then
	if sstr_service[i].Counter = 0 and &
		sstr_service[i].Service.#Pooled then return
end if

//DESTROY object if no more usage
if sstr_service[i].Counter = 0 then
	f_DestroyObject(sstr_service[i].Service)
	//reset index values
	sstr_service[i].Counter = 0
	SetNull(sstr_service[i].Classname)
end if


end subroutine

public subroutine of_unloadservice (readonly string as_classname);of_unloadservice(as_className, true)
end subroutine

public subroutine of_unloadservices (readonly boolean ab_destroy);/********************************************************************
   of_unloadservices
   <DESC>   Description</DESC>
   <RETURN> none</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ab_destroy: Description
   </ARGS>
   <USAGE>  loops through all loaded services and unloads them</USAGE>
********************************************************************/


long llCount, i

llCount = UPPERBOUND(__istr_service)

FOR i = 1 to llCount
	of_unloadservice(__istr_service[i].Classname, ab_destroy)
NEXT

post garbagecollect()
end subroutine

public subroutine of_unloadservices (readonly string as_classnames[]);long llCount, i

llCount = UPPERBOUND(as_classNames)

FOR i = 1 to llCount
	of_unloadservice(as_classNames[i], true)
NEXT
end subroutine

private subroutine documentation ();/*
/********************************************************************
   ObjectName: n_service_manager
   <OBJECT>Maersk Tankers Service Manager</OBJECT>
   <DESC>Manages all objects deemed to be a service.</DESC>
   <USAGE></USAGE>
   <ALSO>
			n_dw_sort_service
			n_dw_spy_service
			n_dw_style_service
			n_error_service
			n_fileattach_service
			n_transaction_spy_service
			
			NB: This whole library mt_services is dependent on mt_constants and mt_base_components.
	</ALSO>
    Date     Ref    Author        	Comments
    00/00/07 ?      RMO           	Created service manager object
	 01/06/10 ?      RMO/AGL			Set code into Production Tramos
	 20/09/10 2154	  AGL					Small problem with unloading the services due to garbagecollection
	 											process whilst a messagebox is used.  Just changed to POST
********************************************************************/
*/
end subroutine

on n_service_manager.create
call super::create
end on

on n_service_manager.destroy
call super::destroy
end on

event destructor;call super::destructor;of_unloadservices(false)

end event

