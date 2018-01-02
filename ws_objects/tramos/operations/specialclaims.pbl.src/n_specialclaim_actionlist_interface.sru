$PBExportHeader$n_specialclaim_actionlist_interface.sru
$PBExportComments$Used to show all user actions
forward
global type n_specialclaim_actionlist_interface from mt_n_interface_master
end type
end forward

global type n_specialclaim_actionlist_interface from mt_n_interface_master
end type
global n_specialclaim_actionlist_interface n_specialclaim_actionlist_interface

forward prototypes
protected subroutine _setup ()
public subroutine documentation ()
end prototypes

protected subroutine _setup ();/********************************************************************
   _setup( )
   <DESC>   This function is made for holding all the datastore/dataset creations
	when the object is instantiated</DESC>
   <RETURN>(None)</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS>(None)</ARGS>
   <USAGE></USAGE>
********************************************************************/
_createdatastore( "actionlist", "d_sq_tb_specialclaim_actionlist", "")

end subroutine

public subroutine documentation ();/********************************************************************
   n_specialclaim_actionlist_interface: a 'container' (non visual window) used to show
	all user defined actions
   <OBJECT> This object holds 
		actionlist 	( istr_datastore[1].ds_data )
   <DESC> 	of_setup to initialize the dataset. Everything else is generic code</DESC>
   <USAGE> Normally this object will need a window, with the number of datawindow
	objects that you need to visualize. In order to find the dataset names go to the 
	__setup function, and see the names.
	
	Instantiate the object in a window, and use the of_share function, to connect the 
	visual datawindow with the dataset</USAGE>
   <ALSO> </ALSO>
    	Date   		Ref    			Author		Comments
  	14/07/10		CR#1543	RMO003		Initial Version
********************************************************************/

end subroutine

on n_specialclaim_actionlist_interface.create
call super::create
end on

on n_specialclaim_actionlist_interface.destroy
call super::destroy
end on

