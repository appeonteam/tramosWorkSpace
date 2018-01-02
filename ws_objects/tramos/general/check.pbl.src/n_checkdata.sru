$PBExportHeader$n_checkdata.sru
$PBExportComments$general data linking calculation and operations
forward
global type n_checkdata from mt_n_nonvisualobject
end type
end forward

global type n_checkdata from mt_n_nonvisualobject
end type
global n_checkdata n_checkdata

type variables
/* calculation data */
long		il_calcid
long		il_estcalcid
long		il_calcalcid
long		il_fixtureid
integer	ii_calcstatus
/* operation data */
string	is_voyagenr
integer	ii_vesselnr
integer	ii_voyagetype
/* other data */
long ii_clrkid
long il_vsltypeid
integer ii_pcnr

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_checkdata
	
	<OBJECT>
		Placeholder for common values used by both Calc & Operations
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    		Author   		Comments
  	29/11/11 	D-CALC	AGL027		First Version
	08/11/13  	CR2658	AGL027		Add supporting variables
********************************************************************/


end subroutine

on n_checkdata.create
call super::create
end on

on n_checkdata.destroy
call super::destroy
end on

