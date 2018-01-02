$PBExportHeader$w_tramos_about.srw
$PBExportComments$This is the "about" window for the system.
forward
global type w_tramos_about from mt_w_response
end type
type cb_ok from commandbutton within w_tramos_about
end type
type dw_about from datawindow within w_tramos_about
end type
end forward

global type w_tramos_about from mt_w_response
integer x = 658
integer y = 496
integer width = 1609
integer height = 1040
string title = "About"
long backcolor = 81324524
boolean ib_enablef1help = false
cb_ok cb_ok
dw_about dw_about
end type
global w_tramos_about w_tramos_about

type prototypes


end prototypes

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_tramos_about
	
   <OBJECT>	Changed the UI of About window </OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date         	CR-Ref      Author		Comments
		25/04/2013   	CR3158		WWA048		Changed the UI of About window.
		17/04/2014   	CR3240UAT  	CCY018		change copyright year to current year.
		12/08/2014 		CR3708   	AGL027		F1 help application coverage - corrected ancestor
   </HISTORY>
********************************************************************/
end subroutine

on w_tramos_about.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_about=create dw_about
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_about
end on

on w_tramos_about.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_about)
end on

event open;/********************************************************************
   w_login.open
   <DESC> Changed the UI of About window. </DESC>
   <RETURN>	</RETURN>
   <ACCESS>	Public </ACCESS>
   <ARGS> </ARGS>
   <USAGE> </USAGE>
	<HISTORY>
   	Date         CR-Ref       Author           Comments
   	22/04/2013   CR3158       WWA048           First Version
   </HISTORY>
********************************************************************/

string ls_version

dw_about.settransobject(sqlca)
dw_about.insertrow(0)

ls_version = uo_global.GetProgramFullVersion() + "; Produced " + uo_global.GetProgramDate()
dw_about.setitem(1, "version", ls_version)
dw_about.object.t_copyright.text = "Copyright ©1995-" + string(year(today())) + " Maersk Tankers A/S"

end event

type cb_ok from commandbutton within w_tramos_about
integer x = 594
integer y = 784
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

on clicked;Close(parent)
end on

type dw_about from datawindow within w_tramos_about
integer width = 1600
integer height = 960
integer taborder = 10
string title = "none"
string dataobject = "d_ex_ff_about"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

