$PBExportHeader$mt_w_response.srw
forward
global type mt_w_response from mt_w_master
end type
type st_hidemenubar from statictext within mt_w_response
end type
end forward

global type mt_w_response from mt_w_master
integer width = 2505
integer height = 1384
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_hidemenubar st_hidemenubar
end type
global mt_w_response mt_w_response

type variables
boolean ib_enablef1help = true
end variables

forward prototypes
public subroutine documentation ()
public function integer of_center ()
end prototypes

public subroutine documentation ();/********************************************************************
	mt_w_response
	
	<OBJECT>
		Ancestor object for all response windows.
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
		Calculation module has an ancestor derived from this called 
		mt_w_response_calc
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - added 
		  												code to hidden statictext constructor to
														process the hidden menu and enable F1
		24/10/2016	CR3754		AGL027		Center the window properly; standard property on its own does not work as intended
	</HISTORY>
********************************************************************/
end subroutine

public function integer of_center ();environment env_env
getenvironment( env_env )
this.x = ( pixelstounits( env_env.screenwidth, &
        xpixelstounits! ) - this.width ) / 2
this.y = ( pixelstounits( env_env.screenheight, &
        ypixelstounits! ) - this.height ) /2
return c#return.Success
end function

on mt_w_response.create
int iCurrent
call super::create
this.st_hidemenubar=create st_hidemenubar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_hidemenubar
end on

on mt_w_response.destroy
call super::destroy
destroy(this.st_hidemenubar)
end on

type st_hidemenubar from statictext within mt_w_response
boolean visible = false
integer width = 827
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
string text = "hidden constructor code inside event"
boolean focusrectangle = false
end type

event constructor;n_service_manager		lnv_servicemgr
n_menu_service   lnv_menu

if ib_enablef1help then
	lnv_serviceMgr.of_loadservice( lnv_menu, "n_menu_service")	
	lnv_menu.of_addhelpmenu( parent, { "F1"})
end if
end event

