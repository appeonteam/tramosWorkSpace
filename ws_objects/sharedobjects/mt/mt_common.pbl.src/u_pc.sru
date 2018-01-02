$PBExportHeader$u_pc.sru
$PBExportComments$w_events_pc
forward
global type u_pc from mt_u_visualobject
end type
type st_label from statictext within u_pc
end type
type dw_pc from mt_u_datawindow within u_pc
end type
end forward

global type u_pc from mt_u_visualobject
integer width = 827
integer height = 156
st_label st_label
dw_pc dw_pc
end type
global u_pc u_pc

type variables
long	il_pcnr
end variables

forward prototypes
public subroutine of_setcurrentpc (long al_pcnr)
public subroutine of_setbackcolor (long al_color, boolean ab_showlabel)
public subroutine documentation ()
public function long of_retrieve ()
public function long of_getpc ()
public subroutine of_addnew (long al_pc, string as_pcname)
public subroutine of_getpcarray (ref long al_pcarray[])
public function string of_getpcname ()
public subroutine of_setlabelcolor (long al_color)
end prototypes

public subroutine of_setcurrentpc (long al_pcnr);/********************************************************************
   of_setcurrentpc
   <DESC> Changes profit center selection </DESC>
   <RETURN> </RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS>  al_pcnr: profit center number that should be selected </ARGS>
   <USAGE>	Usage to select the profit center selection
		Used in Vessel Window: changes the profit center selection, when the updated
			vessel belongs to a different profit center than the one selected.
	</USAGE>
********************************************************************/

datawindowchild	ldwc
long					ll_found

if al_pcnr < 1 then return

dw_pc.getchild( "pc_nr", ldwc )

ll_found = ldwc.find("pc_nr="+string(al_pcnr), 0, 9999999)

if ll_found < 1 then return

dw_pc.setItem(1, "pc_nr",al_pcnr)

dw_pc.event itemchanged(1, dw_pc.object.pc_nr, string(al_pcnr))

end subroutine

public subroutine of_setbackcolor (long al_color, boolean ab_showlabel);/********************************************************************
   of_setbackcolor
   <DESC> Changes profit background color and makes label invisible </DESC>
   <RETURN> </RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS>  al_color: color
		ab_showlabel: makes the lable visible or invisible </ARGS>
   <USAGE>	Usage in windows with the new color formating
	</USAGE>
********************************************************************/

this.backcolor = al_color
st_label.backcolor = al_color
dw_pc.object.datawindow.color = al_color

st_label.visible = ab_showlabel

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_pc	
   <OBJECT> standard visual object for profit center selection</OBJECT>
   <DESC> </DESC>
   <USAGE>
		Important Note:    (CONASW 1/8/11)
		Profit center number 999 is used for selecting "All" profit centers.
		This is added using function of_AddNew()		
	</USAGE>
   <ALSO>   </ALSO>
    Date      Ref     Author        Comments
 18/11/2010				 JMC112	      First Version
 13/01/2011	  CR2197	 JMC112	     Added function of_setbackcolor
 16/04/2013   CR3198  ZSW001       Added function of_setlabelcolor
********************************************************************/

end subroutine

public function long of_retrieve ();/********************************************************************
   of_retrieve()
   <DESC> Retrieves data. Default profit center is selected. </DESC>
   <RETURN> Integer:
            <LI> profit center number
            <LI> -1, X failed</RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS>  n/a</ARGS>
   <USAGE>called normally from the on open event of a dependent window
	</USAGE>
********************************************************************/

datawindowchild ldwc
long ll_row

dw_pc.settransobject(SQLCA)
dw_pc.retrieve()
if SQLCA.sqlcode<>-1 then
	ll_row = dw_pc.getrow()
	il_pcnr=dw_pc.getitemnumber(ll_row,"pc_nr")
else
	il_pcnr =  c#return.failure
end if

return il_pcnr

end function

public function long of_getpc ();
return dw_pc.getItemNumber(1, "pc_nr")
end function

public subroutine of_addnew (long al_pc, string as_pcname);/********************************************************************
   of_addnew( )
   <DESC> Adds a new item in the profit center list</DESC>
   <RETURN> </RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS> 
		al_pc  - new profit center id
		as_pcname - new profit center name
	</ARGS>
   <USAGE>called normally from open event of a dependent window.
		Example: used in Vessels Window to add the item <All>
	</USAGE>
********************************************************************/


datawindowchild ldwc
long	ll_row

dw_pc.getchild( "pc_nr", ldwc )
ll_row = ldwc.insertRow(1)
ldwc.setItem(ll_row, "pc_name", as_pcname)
ldwc.setItem(ll_row, "pc_nr", al_pc )

if dw_pc.rowcount() <= 0 then
	ll_row = dw_pc.insertRow(1)
else
	ll_row = 1
end if

dw_pc.object.pc_nr[ll_row] = al_pc
dw_pc.setRow(1)

il_pcnr = 999

end subroutine

public subroutine of_getpcarray (ref long al_pcarray[]);/********************************************************************
   of_getpcarray( )
   <DESC> Initializes and returns an array of profit centers </DESC>
   <RETURN> </RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS> 
		al_pcarray[]  - returned pc array
	</ARGS>
   <USAGE>called normally from open event of a dependent window.
		Example: used in Vessels Window 
	</USAGE>
********************************************************************/
datawindowchild	ldwc
long	ll_rows, ll_row

dw_pc.getchild ("pc_nr", ldwc)
ll_rows = ldwc.rowCount()

for ll_row = 1 to ll_rows
	al_pcarray[][ll_row] = ldwc.getItemNumber(ll_row, "pc_nr")
next

end subroutine

public function string of_getpcname ();
return dw_pc.getItemString(1, "pc_name")
end function

public subroutine of_setlabelcolor (long al_color);/********************************************************************
   of_setlabelcolor
   <DESC>	set the label's color	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_color
   </ARGS>
   <USAGE>	Usage in windows with the new color formating	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	16/04/2013   CR3198       ZSW001       First Version
   </HISTORY>
********************************************************************/

st_label.textcolor = al_color

end subroutine

on u_pc.create
int iCurrent
call super::create
this.st_label=create st_label
this.dw_pc=create dw_pc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_label
this.Control[iCurrent+2]=this.dw_pc
end on

on u_pc.destroy
call super::destroy
destroy(this.st_label)
destroy(this.dw_pc)
end on

event constructor;call super::constructor;dw_pc.width = this.width

dw_pc.modify("pc_nr.width = " + string(this.width - long(dw_pc.describe("pc_nr.x"))))

end event

type st_label from statictext within u_pc
integer x = 5
integer y = 8
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit Center"
boolean focusrectangle = false
end type

type dw_pc from mt_u_datawindow within u_pc
integer y = 76
integer width = 823
integer height = 72
integer taborder = 10
string dataobject = "d_pc"
boolean border = false
borderstyle borderstyle = StyleBox!
end type

event itemchanged;
/********************************************************************
   itemchanged event
   <DESC> This event calls the parents ue_pcChanged() event. </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		long row: Selected row
		dwoobject dwo: datawindow
		string	data: value selected (pc_nr)
   </ARGS>
   <USAGE>	
	Optionally the parent window can have the event pcChanged(...) defined:
		 ue_pcChanged(value long al_row, value long al_pcnr, ref integer ai_return)
		 	al_row - selected row
			al_pcnr - profit center nr
			ai_return - returns failure or success (in case of failure, this event returns 1
							and itemerror event occurs. The profit center selection rolls back.
	</USAGE>
********************************************************************/


window  lw_group
integer li_return

lw_group = parent.getparent( )

lw_group.dynamic event ue_pcChanged(long(data), li_return)

//If returns failure, then itemerror event is called, and profit center list does not change
if li_return = c#return.failure then
	return 1
end if

il_pcnr = long(data)

return  0

end event

event itemerror;//happens when dw_pc.itemchanged fails

il_pcnr = this.getItemNumber(1,1,primary!,false)

//sets back
this.setItem(1,1,il_pcnr)

return 1
end event

