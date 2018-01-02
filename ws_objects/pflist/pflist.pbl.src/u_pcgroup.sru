$PBExportHeader$u_pcgroup.sru
forward
global type u_pcgroup from userobject
end type
type st_label from statictext within u_pcgroup
end type
type dw_pcgroup from mt_u_datawindow within u_pcgroup
end type
end forward

global type u_pcgroup from userobject
integer width = 722
integer height = 176
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_label st_label
dw_pcgroup dw_pcgroup
end type
global u_pcgroup u_pcgroup

forward prototypes
public function integer uf_getpcgroup ()
public function integer uf_getpcgroup (integer ai_pc_nr)
public subroutine of_setbackcolor (long al_color, boolean ab_showlabel)
public subroutine of_setlabelcolor (long al_color)
public subroutine documentation ()
end prototypes

public function integer uf_getpcgroup ();/********************************************************************
   uf_getpcgroup( )
   <DESC> Returns the users default profit center group.  If this is not possible it returns error code -1</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS>  n/a</ARGS>
   <USAGE>called normally from the on open event of a dependent window
	Last modified: 13/08/09 AGL
	</USAGE>
********************************************************************/


datawindowchild ldwc
long ll_rows, ll_found_row 

dw_pcgroup.settransobject(SQLCA)

dw_pcgroup.getchild("PCGROUP_ID", ldwc)
ldwc.settransobject(SQLCA)
ldwc.retrieve( uo_global.is_userid )
ll_rows=ldwc.rowcount( )

//if ll_rows>0 then
//	dw_pcgroup.retrieve( uo_global.is_userid )
//	if SQLCA.sqlcode=-1 then
//	//	as_errormessage = "Error: Trade information not found. (" + SQLCA.sqlerrtext + ")"
//		return -1
//	else
//		// now we catch the users that may have a default pc that is not a member of a group,
//		// but do have access to other pc's
//		if isnull(dw_pcgroup.getitemnumber(dw_pcgroup.getrow(),"pcgroup_id")) then
//			ll_found_row=ldwc.find("pcgroup_pcgroup_id<>0", 1, ll_rows)
//			if ll_found_row>0 then
//				dw_pcgroup.setitem(dw_pcgroup.getrow(), "pcgroup_id", ldwc.getitemnumber(ll_found_row,"pcgroup_pcgroup_id"))  
//			else
//				return -1
//			end if
//		end if
//		return dw_pcgroup.getitemnumber(dw_pcgroup.getrow(),"pcgroup_id")
//	end if
//else
//	return -1
//end if

// better structured code to use than the above that was released in v.20 ...
integer li_retval; li_retval=-1

if ll_rows>0 then
	dw_pcgroup.retrieve( uo_global.is_userid )
	if SQLCA.sqlcode<>-1 then
		if isnull(dw_pcgroup.getitemnumber(dw_pcgroup.getrow(),"pcgroup_id")) then
			ll_found_row=ldwc.find("pcgroup_pcgroup_id<>0", 1, ll_rows)
			if ll_found_row>0 then
				dw_pcgroup.setitem(dw_pcgroup.getrow(), "pcgroup_id", ldwc.getitemnumber(ll_found_row,"pcgroup_pcgroup_id"))  
				li_retval=dw_pcgroup.getitemnumber(dw_pcgroup.getrow(),"pcgroup_id")
			end if
		else
			li_retval=dw_pcgroup.getitemnumber(dw_pcgroup.getrow(),"pcgroup_id")
		end if
	end if
end if

return li_retval

end function

public function integer uf_getpcgroup (integer ai_pc_nr);int li_pcgroup
	
	SELECT PCGROUP_ID
	INTO :li_pcgroup 
	FROM PROFIT_C  
	WHERE PC_NR = :ai_pc_nr 
	commit;
	
return li_pcgroup	
end function

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
dw_pcgroup.object.datawindow.color = al_color
//dw_pcgroup.object.datawindow.backgroud.color = al_color
//dw_pcgroup.object.pcgroup_id_t.backgroud.color = al_color
st_label.visible = ab_showlabel

end subroutine

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

public subroutine documentation ();/********************************************************************
	u_pcgroup
	
	<OBJECT>
	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>
		Fixture/Cargo List and Position List window
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
   14/08/17     CR4571   KSH092	   dw_pcgroup follow latest UX standards 
	</HISTORY>
********************************************************************/

end subroutine

on u_pcgroup.create
this.st_label=create st_label
this.dw_pcgroup=create dw_pcgroup
this.Control[]={this.st_label,&
this.dw_pcgroup}
end on

on u_pcgroup.destroy
destroy(this.st_label)
destroy(this.dw_pcgroup)
end on

type st_label from statictext within u_pcgroup
integer y = 12
integer width = 462
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profit Center Group"
boolean focusrectangle = false
end type

type dw_pcgroup from mt_u_datawindow within u_pcgroup
integer y = 68
integer width = 731
integer height = 88
integer taborder = 10
string dataobject = "d_pcgroup"
boolean border = false
end type

event itemchanged;/*
	This event calls the parents ue_pcgroupChanged() event.
	
	if parent window event returns 1 then we will 
	not update the selected in pcgroup dw.

	It is expected that all parent window events ue_pcgroupChanged() must 
	return an integer.
*/

window  lw_group
integer   li_pcgroupid

lw_group = parent.getparent( )

if this.of_itemchanged() = c#return.success then
	li_pcgroupid =  lw_group.dynamic event ue_pcgroupChanged(integer(data))
	if li_pcgroupid <> integer(data) and (lw_group.title = 'Fixture/Cargo List' or lw_group.title = 'Position List' or lw_group.title = 'Companies') then
		this.setitem(row, "pcgroup_id", li_pcgroupid)
		return 1	
	else
		return 0
	end if
else
	return 2
end if
end event

event itemerror;return 3
end event

event constructor;call super::constructor;dw_pcgroup.of_set_dddwspecs(true)
dw_pcgroup.inv_dddwsearch.of_register()
end event

