$PBExportHeader$n_generatedistances.sru
$PBExportComments$logic controlling access to estimation(s)
forward
global type n_generatedistances from mt_n_nonvisualobject
end type
end forward

global type n_generatedistances from mt_n_nonvisualobject
end type
global n_generatedistances n_generatedistances

type variables

end variables

forward prototypes
public subroutine documentation ()
public function integer of_loaddistances (string as_yyyy, string as_abctablepath)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_generatedistances
	
	<OBJECT>
		Used when application wants to load distances
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		when command string contains  /loaddistances:2012
	</USAGE>
   	<ALSO>
		n_autoschedule.of_setdistances()
	</ALSO>
    	Date   		Ref    	Author   		Comments
  	00/00/07 	?      	Name Here	First Version
  	08/02/16		CR4298	AGL027		Allow application to use its own path for atobviac tables.
********************************************************************/
end subroutine

public function integer of_loaddistances (string as_yyyy, string as_abctablepath);long ll_row


mt_n_datastore lds_firstvoyages
n_autoschedule	lnv_autosched


lnv_autosched = create n_autoschedule
lnv_autosched.of_init(as_abctablepath)

lds_firstvoyages = create mt_n_datastore
lds_firstvoyages.dataobject="d_sq_gr_vesselsfirstvoyageinyear"
lds_firstvoyages.settransobject( SQLCA )
lds_firstvoyages.retrieve(as_yyyy)

lds_firstvoyages.setfilter("not isNull(firstvoyage)")
lds_firstvoyages.filter()

for ll_row = 1 to lds_firstvoyages.rowcount()
	lnv_autosched.of_setdistances( lds_firstvoyages.getitemnumber(ll_row,"vessel_nr"), lds_firstvoyages.getitemstring(ll_row,"firstvoyage"))
	_addmessage( this.classdefinition, "of_loaddistances()","Distance in proceeding for vessel processed - " + string(lds_firstvoyages.getitemnumber(ll_row,"vessel_nr")), "")
next

destroy lnv_autosched
destroy lds_firstvoyages


return c#return.Success
end function

on n_generatedistances.create
call super::create
end on

on n_generatedistances.destroy
call super::destroy
end on

event constructor;call super::constructor;
uo_global = create uo_global_vars
uo_global.SetVessel_Nr(0)

uo_global.is_userid = "AGL027"
uo_global.of_setappstartedfrom()
uo_global.uf_load()


end event

event destructor;call super::destructor;destroy uo_global
end event

