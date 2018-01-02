$PBExportHeader$u_vesseltype_specialfeatures.sru
forward
global type u_vesseltype_specialfeatures from userobject
end type
type dw_specialfeatures from datawindow within u_vesseltype_specialfeatures
end type
end forward

global type u_vesseltype_specialfeatures from userobject
integer width = 2011
integer height = 1004
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 553648127
dw_specialfeatures dw_specialfeatures
end type
global u_vesseltype_specialfeatures u_vesseltype_specialfeatures

type variables
boolean		ib_dragdrop
long			il_vesseltypeid
long			il_movedrow
end variables

forward prototypes
public function integer of_getlist (integer ai_vesseltypeid)
public subroutine of_additem ()
public subroutine of_deleteitem ()
public function integer of_changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number)
end prototypes

public function integer of_getlist (integer ai_vesseltypeid);integer li_row

li_row = dw_specialfeatures.retrieve(ai_vesseltypeid)
//of_enableupdatecertificate(li_row)
return 1
end function

public subroutine of_additem ();//Add new item .... opens a window

dw_specialfeatures.accepttext( )
dw_specialfeatures.update()

openwithparm( w_shiptype_sfeatureitems, il_vesseltypeid )

dw_specialfeatures.retrieve(il_vesseltypeid)
end subroutine

public subroutine of_deleteitem ();long ll_row
long ll_response

ll_row = dw_specialfeatures.getselectedrow( 0)

IF ll_row < 1 THEN
	RETURN
END IF

ll_response = Messagebox("Deleting!","You are about to delete the selected row on tabpage Special Features~r~n" & 
                               , Question!, YesNo!, 2)
IF ll_response = 1 THEN
	dw_specialfeatures.deleterow(ll_row)
	IF dw_specialfeatures.update() <> 1 THEN
		Messagebox("Error","Update not done. This could be due to data on tabpage Special Features being used other places in the system or database error.~r~n~r~n")
		rollback;			  
		dw_specialfeatures.retrieve(il_vesseltypeid)
		RETURN
	END IF
END IF

end subroutine

public function integer of_changeorder (integer ai_moved_row, integer ai_row, ref datawindow adw, integer ai_number);/********************************************************************
   of_changeorder( /*integer ai_moved_row */,/*integer ai_row */,/*datawindow adw */,/*integer ai_number */)
   <DESC>     This function is change the order number when drag and drop			</DESC>
   <RETURN> Integer:	<LI> 1, X ok<LI> -1, X failed										</RETURN>
   <ACCESS> Private																					</ACCESS>
   <ARGS>    ai_moved_row: start row 
				  ai_row:end row
				  adw:datawindow you apply the dragdrop event
				  ai_number:number you want to chagne the order with
   </ARGS>
   <USAGE>  Called in dragdrop event of the adw												</USAGE>
********************************************************************/
integer li_row

for li_row = ai_moved_row to ai_row 
	adw.setitem(li_row,"cal_vest_sfeatures_sf_sort",adw.getitemnumber(li_row, "cal_vest_sfeatures_sf_sort") + ai_number)
next

return 1
end function

on u_vesseltype_specialfeatures.create
this.dw_specialfeatures=create dw_specialfeatures
this.Control[]={this.dw_specialfeatures}
end on

on u_vesseltype_specialfeatures.destroy
destroy(this.dw_specialfeatures)
end on

event constructor;dw_specialfeatures.settransobject( SQLCA)

ib_dragdrop = true

if uo_global.ii_access_level >= 0 then
	dw_specialfeatures.Object.DataWindow.ReadOnly="No"
else
	dw_specialfeatures.Object.DataWindow.ReadOnly="Yes"
end if


end event

type dw_specialfeatures from datawindow within u_vesseltype_specialfeatures
integer x = 23
integer y = 24
integer width = 1961
integer height = 960
integer taborder = 10
string dragicon = "images\DRAG.ICO"
string title = "none"
string dataobject = "d_sq_tb_features_by_vesseltype"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
IF row > 0 THEN
   this.selectRow(0,false)
   this.selectRow(row,true)
END IF

//change the order
if dwo.name = "cal_vest_sfeatures_sf_sort" and ib_dragdrop then
	il_movedRow = row
	this.drag(begin!)
end if	



end event

event dragdrop;long 		ll_rowstart, ll_rowend					
if uo_global.ii_access_level >= 0 then
	
if il_movedRow <> row and row <> 0 then
	ll_rowend = this.getitemnumber(row, "cal_vest_sfeatures_sf_sort")
	ll_rowstart = this.getitemnumber(il_movedRow, "cal_vest_sfeatures_sf_sort")
	if ll_rowstart < ll_rowend then
		if il_movedRow < row then
			of_changeorder( il_movedRow, row, dw_specialfeatures, -1 )
		else
			of_changeorder( row, il_movedrow , dw_specialfeatures, -1 )
		end if
	else
		if il_movedRow < row then
			of_changeorder( il_movedRow, row, dw_specialfeatures, 1 )
		else
			of_changeorder( row, il_movedrow , dw_specialfeatures, 1 )
		end if		
	end if
	this.setitem(il_movedRow,"cal_vest_sfeatures_sf_sort",ll_rowend)
	this.sort( )
end if

end if

end event

