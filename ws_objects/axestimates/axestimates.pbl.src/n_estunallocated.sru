$PBExportHeader$n_estunallocated.sru
$PBExportComments$base estimation object.  Designed to be used by Tramos and scheduled server application
forward
global type n_estunallocated from n_estimate
end type
type delme_s_estimation from structure within n_estunallocated
end type
end forward

type delme_s_estimation from structure
	integer		i_vesselnr
	string		s_voyagenr
	datetime		dtm_startvoyage
	datetime		dtm_endvoyage
	long		l_calcid
	boolean		b_allocated
end type

global type n_estunallocated from n_estimate
end type
global n_estunallocated n_estunallocated

type variables


end variables

forward prototypes
public function string of_getportlist ()
public function integer of_writeoutdebug ()
public function decimal of_getbunkerprice ()
public function decimal of_getfinalbunkervalue ()
public function long of_getvoyagedurationinseconds ()
public function string of_getportarrivallist ()
public function integer of_load (ref n_autoschedule anv_autosched)
public subroutine documentation ()
end prototypes

public function string of_getportlist ();string ls_portlist="["
long ll_portindex

for ll_portindex = 1 to upperbound(istr_voy.str_portcalls)
	ls_portlist+=istr_voy.str_portcalls[ll_portindex].s_portcode + ", "
next
return mid(ls_portlist, 1, len(ls_portlist)-2) + "]"
end function

public function integer of_writeoutdebug ();long ll_row
if super::of_writeoutdebug() <> c#return.NoAction then
	_addmessage( this.classdefinition, "of_writeoutdebug()", "bunker price           :" + string(id_bunkerprice,"###,###,##0.00") + " USD", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "total distance         :" + string(of_getsumofdistance(),"###,###,##0.00") , "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "___________________________________", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "FINAL                  :" + string(of_getfinalbunkervalue(),"###,###,##0.00") , "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "___________________________________", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "port data", "")
	_addmessage( this.classdefinition, "of_writeoutdebug()", "-----------------------------------", "")
	
	
	for ll_row = 1 to upperbound(istr_voy.str_portcalls)
		_addmessage(this.classdefinition, "of_writeoutdebug()", "(" + string(ll_row,"00") + ") port code=" + istr_voy.str_portcalls[ll_row].s_portcode + &
			" estimated arrival date=" + string(istr_voy.str_portcalls[ll_row].dtm_portarrival,"dd/mm/yy hh:mm"), "")
	next
end if

return c#return.Success
end function

public function decimal of_getbunkerprice ();return id_bunkerprice
end function

public function decimal of_getfinalbunkervalue ();decimal {4} ld_days
decimal {2} ld_distance

ld_distance = of_getsumofdistance( )

if ld_distance<=0 then
	istr_voy.i_errorcode += 1
	return -1
end if
if id_avgspeed<=0 or isnull(id_avgspeed) then
	istr_voy.i_errorcode += 2
	return -2
end if
if id_avgcons<=0 or isnull(id_avgcons) then
	istr_voy.i_errorcode += 4
	return -3
end if
if id_bunkerprice<=0 or isnull(id_bunkerprice) then
	istr_voy.i_errorcode += 8
	return -4
end if

ld_days = (ld_distance / id_avgspeed) / 24
return ld_days * id_avgcons * id_bunkerprice
end function

public function long of_getvoyagedurationinseconds ();/* get number of seconds inside voyage */

if of_getavgofspeed( )<>0 and of_getsumofdistance( )>0 then
	return long((of_getsumofdistance( ) / of_getavgofspeed( )) * 3600)
else
	return 0
end if
end function

public function string of_getportarrivallist ();string ls_portarrival="["
long ll_portindex

for ll_portindex = 1 to upperbound(istr_voy.str_portcalls)
	ls_portarrival += "(" + string(ll_portindex) + ") " + string(istr_voy.str_portcalls[ll_portindex].dtm_portarrival, "dd/mm/yy hh:mm") + ", "
next
return mid(ls_portarrival, 1, len(ls_portarrival)-2) + "]"
end function

public function integer of_load (ref n_autoschedule anv_autosched);long ll_portrow, ll_journeyseconds
datetime ldtm_lastdatepoint
mt_n_datastore lds_procports

of_initds(lds_procports,"d_sq_gr_procportdata")
lds_procports.retrieve(istr_voy.i_vesselnr, istr_voy.s_voyagenr)

/* load main port data */
for ll_portrow = 1 to lds_procports.rowcount()
	istr_voy.str_portcalls[ll_portrow].s_portcode = lds_procports.getitemstring(ll_portrow,"port_code")
	istr_voy.str_portcalls[ll_portrow].i_pcn = lds_procports.getitemnumber(ll_portrow,"pcn")
	istr_voy.str_portcalls[ll_portrow].dtm_procdate = lds_procports.getitemdatetime(ll_portrow,"proc_date")	
	istr_voy.str_portcalls[ll_portrow].d_atobviacdistance = lds_procports.getitemdecimal(ll_portrow,"atobviac_distance")	
	if isnull(istr_voy.str_portcalls[ll_portrow].d_atobviacdistance) then
		istr_voy.str_portcalls[ll_portrow].d_atobviacdistance = -1
	end if	
next

/* get port arrivals for each port */
if of_getavgofspeed( ) <> 0 then
	ldtm_lastdatepoint = istr_voy.dtm_start
	for ll_portrow = 1 to lds_procports.rowcount()
		if istr_voy.str_portcalls[ll_portrow].d_atobviacdistance > 0 then
			ll_journeyseconds = long((istr_voy.str_portcalls[ll_portrow].d_atobviacdistance / of_getavgofspeed() ) * 3600)
			ldtm_lastdatepoint = of_adjustdatetime(ldtm_lastdatepoint,ll_journeyseconds)
			istr_voy.str_portcalls[ll_portrow].dtm_portarrival = ldtm_lastdatepoint	
		end if
	next
end if	

if isnull(istr_voy.dtm_end) then
	istr_voy.dtm_end = of_adjustdatetime(istr_voy.dtm_start, of_getvoyagedurationinseconds())
end if

istr_voy.d_totalbunker = of_getfinalbunkervalue( )

destroy lds_procports

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_estunallocated
	
	<OBJECT>
		Child object of n_estimate, this object contains specific business logic to
		generate estimation data for unallocated voyages
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
   <USAGE>
		when contract type of a voyage is equal to -1 the axestimation process uses this logic
	</USAGE>
   <ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    				Author   	Comments
  	07/03/12 	FINANCE08      	AGL027		First Version
	25/05/12		FINANCE08			AGL027		Fix bug when calculating days 
********************************************************************/
end subroutine

on n_estunallocated.create
call super::create
end on

on n_estunallocated.destroy
call super::destroy
end on

