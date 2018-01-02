$PBExportHeader$w_sale_response.srw
$PBExportComments$Sales Response Window to be inherited by all reponse windows in sales.
forward
global type w_sale_response from mt_w_response
end type
end forward

global type w_sale_response from mt_w_response
end type
global w_sale_response w_sale_response

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_sale_response
	
	<OBJECT>
	Ancestor object for all sales related response windows.
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/

end subroutine

on w_sale_response.create
call super::create
end on

on w_sale_response.destroy
call super::destroy
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_sale_response
end type

