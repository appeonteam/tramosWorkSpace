$PBExportHeader$w_advanced_rp_groups.srw
$PBExportComments$This sheet is to maintain Advanced Routing Point Groups
forward
global type w_advanced_rp_groups from w_sheet
end type
type cb_close from commandbutton within w_advanced_rp_groups
end type
type cb_release from commandbutton within w_advanced_rp_groups
end type
type cb_connect from commandbutton within w_advanced_rp_groups
end type
type dw_rp_groups from u_dw within w_advanced_rp_groups
end type
type dw_connected_rp from u_dw within w_advanced_rp_groups
end type
type dw_released_rp from u_dw within w_advanced_rp_groups
end type
type gb_1 from groupbox within w_advanced_rp_groups
end type
type gb_2 from groupbox within w_advanced_rp_groups
end type
end forward

global type w_advanced_rp_groups from w_sheet
integer width = 3031
integer height = 1860
string title = "Advanced Routing Point Groups"
boolean resizable = false
boolean center = true
cb_close cb_close
cb_release cb_release
cb_connect cb_connect
dw_rp_groups dw_rp_groups
dw_connected_rp dw_connected_rp
dw_released_rp dw_released_rp
gb_1 gb_1
gb_2 gb_2
end type
global w_advanced_rp_groups w_advanced_rp_groups

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_advanced_rp_groups
   <OBJECT> The window containing define the ATOBVITC.</OBJECT>
   <DESC>  </DESC>
   <USAGE>  </USAGE>
   <ALSO>	</ALSO>
Date   		Ref   		Author         Comments
04/09/13		CR3314		WWG004			When connect or release a routing point it'll a FK error.
28/08/14		CR3781		CCY018			The window title match with the text of a menu item
*************************************************************************************************************************/

end subroutine

on w_advanced_rp_groups.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_release=create cb_release
this.cb_connect=create cb_connect
this.dw_rp_groups=create dw_rp_groups
this.dw_connected_rp=create dw_connected_rp
this.dw_released_rp=create dw_released_rp
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_release
this.Control[iCurrent+3]=this.cb_connect
this.Control[iCurrent+4]=this.dw_rp_groups
this.Control[iCurrent+5]=this.dw_connected_rp
this.Control[iCurrent+6]=this.dw_released_rp
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_advanced_rp_groups.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_release)
destroy(this.cb_connect)
destroy(this.dw_rp_groups)
destroy(this.dw_connected_rp)
destroy(this.dw_released_rp)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;//  Set the Transaction Object for all the dws 
dw_rp_groups.inv_linkage.of_SetTransObject(sqlca)

//  Call the retrieve on the top-level datawindow.  This 
//  will retrieve all the datawindows in the linked chain 
dw_rp_groups.of_Retrieve()
dw_released_rp.of_retrieve()

//Set-up user access
Choose case uo_global.ii_access_level
	Case 2, 3 // Supervisor, // Administration
		cb_connect.enabled = TRUE
		cb_release.enabled = TRUE
	Case 1 // User
		cb_connect.enabled = FALSE
		cb_release.enabled = FALSE
End choose

end event

event pfc_preopen;call super::pfc_preopen;dw_rp_groups.of_SetLinkage(true)
dw_connected_rp.of_SetLinkage(true)

dw_connected_rp.inv_linkage.of_SetMaster(dw_rp_groups) 
dw_connected_rp.inv_linkage.of_Register("abc_advanced_groupid", "abc_advanced_groupid") 
dw_connected_rp.inv_linkage.of_SetStyle(dw_connected_rp.inv_linkage.RETRIEVE)

dw_rp_groups.SetRowFocusIndicator(FocusRect!)  
dw_connected_rp.SetRowFocusIndicator(FocusRect!)


end event

type cb_close from commandbutton within w_advanced_rp_groups
integer x = 2656
integer y = 1660
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_release from commandbutton within w_advanced_rp_groups
integer x = 2318
integer y = 780
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Release"
end type

event clicked;datawindow	ldw_source, ldw_target
long			ll_source_row, ll_target_row, ll_rpgroup_row
long			ll_groupid, ll_null

setNull(ll_null)

ldw_source = dw_connected_rp
ldw_target = dw_released_rp

ll_source_row 	= ldw_source.getrow()
ll_rpgroup_row	= dw_rp_groups.getrow()

if ll_source_row < 1 then return

ldw_source.setitem(ll_source_row, "abc_advanced_groupid", ll_null)

if ldw_source.update() = 1 then
	commit;
	
	ll_groupid = dw_rp_groups.getitemnumber(ll_rpgroup_row, "abc_advanced_groupid")
	dw_connected_rp.retrieve(ll_groupid)
	dw_released_rp.retrieve()
else
	rollback;
end if
end event

type cb_connect from commandbutton within w_advanced_rp_groups
integer x = 1787
integer y = 780
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Co&nnect "
end type

event clicked;datawindow	ldw_source, ldw_target
long			ll_source_row, ll_target_row, ll_rpgroup_row
long			ll_groupid

ldw_source = dw_released_rp
ldw_target = dw_connected_rp

ll_rpgroup_row	= dw_rp_groups.getrow()
ll_source_row	= ldw_source.getRow()

if ll_source_row < 1 then return

ll_groupid = dw_rp_groups.getitemnumber(ll_rpgroup_row, "abc_advanced_groupid")

ldw_source.setitem(ll_source_row, "abc_advanced_groupid", ll_groupid)

if ldw_source.update() = 1 then
	commit;
	
	dw_connected_rp.retrieve(ll_groupid)
	dw_released_rp.retrieve()
else
	rollback;
end if
end event

type dw_rp_groups from u_dw within w_advanced_rp_groups
integer x = 64
integer y = 80
integer width = 1312
integer height = 1504
integer taborder = 10
string dataobject = "d_sq_tb_maintain_rp_group"
end type

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

type dw_connected_rp from u_dw within w_advanced_rp_groups
integer x = 1536
integer y = 80
integer width = 1399
integer height = 660
integer taborder = 20
string dataobject = "d_connected_rp"
boolean ib_rmbmenu = false
end type

type dw_released_rp from u_dw within w_advanced_rp_groups
integer x = 1536
integer y = 924
integer width = 1399
integer height = 660
integer taborder = 30
string dataobject = "d_released_rp"
boolean vscrollbar = false
boolean ib_rmbmenu = false
end type

event constructor;call super::constructor;this.of_setTransobject( sqlca )

setRowFocusindicator( FocusRect! )
end event

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

type gb_1 from groupbox within w_advanced_rp_groups
integer x = 1486
integer width = 1509
integer height = 1624
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Advanced Routing Points"
end type

type gb_2 from groupbox within w_advanced_rp_groups
integer x = 18
integer width = 1413
integer height = 1624
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Groups"
end type

