$PBExportHeader$w_shiptype_sfeatureitems.srw
forward
global type w_shiptype_sfeatureitems from mt_w_sheet
end type
type cb_delete_item from commandbutton within w_shiptype_sfeatureitems
end type
type dw_sfeatures_items from datawindow within w_shiptype_sfeatureitems
end type
type cb_accept from commandbutton within w_shiptype_sfeatureitems
end type
type cb_1 from commandbutton within w_shiptype_sfeatureitems
end type
type cb_cancel from commandbutton within w_shiptype_sfeatureitems
end type
type sle_newitem from singlelineedit within w_shiptype_sfeatureitems
end type
type st_1 from statictext within w_shiptype_sfeatureitems
end type
end forward

global type w_shiptype_sfeatureitems from mt_w_sheet
integer width = 2254
integer height = 2012
string title = "Add Special Features Items"
boolean maxbox = false
cb_delete_item cb_delete_item
dw_sfeatures_items dw_sfeatures_items
cb_accept cb_accept
cb_1 cb_1
cb_cancel cb_cancel
sle_newitem sle_newitem
st_1 st_1
end type
global w_shiptype_sfeatureitems w_shiptype_sfeatureitems

type variables
long il_vesseltypeid
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_shiptype_sfeatureitems
	
	<OBJECT>
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

on w_shiptype_sfeatureitems.create
int iCurrent
call super::create
this.cb_delete_item=create cb_delete_item
this.dw_sfeatures_items=create dw_sfeatures_items
this.cb_accept=create cb_accept
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.sle_newitem=create sle_newitem
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete_item
this.Control[iCurrent+2]=this.dw_sfeatures_items
this.Control[iCurrent+3]=this.cb_accept
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.sle_newitem
this.Control[iCurrent+7]=this.st_1
end on

on w_shiptype_sfeatureitems.destroy
call super::destroy
destroy(this.cb_delete_item)
destroy(this.dw_sfeatures_items)
destroy(this.cb_accept)
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.sle_newitem)
destroy(this.st_1)
end on

event open;string	ls_vesseltypename
il_vesseltypeid = message.doubleparm

  	SELECT CAL_VEST.CAL_VEST_TYPE_NAME  
  	INTO :ls_vesseltypename
  	FROM CAL_VEST 
	WHERE CAL_VEST.CAL_VEST_TYPE_ID = :il_vesseltypeid
	commit using SQLCA;

this.title += " ("+string(ls_vesseltypename) + ")"

dw_sfeatures_items.setTransObject(sqlca)
dw_sfeatures_items.post retrieve(il_vesseltypeid)


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_shiptype_sfeatureitems
end type

type cb_delete_item from commandbutton within w_shiptype_sfeatureitems
boolean visible = false
integer x = 1856
integer y = 1800
integer width = 343
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Item"
end type

type dw_sfeatures_items from datawindow within w_shiptype_sfeatureitems
integer x = 27
integer y = 24
integer width = 1792
integer height = 1680
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_shiptype_sfeaturesitems"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string is_sort

if row=0 then

	if dwo.type = "text" then
	
		is_sort = dwo.Tag
		if is_sort<> "" then
			if right(is_sort,1) = "A" then 
				is_sort = replace(is_sort, len(is_sort),1, "D")
			else
				is_sort = replace(is_sort, len(is_sort),1, "A")
			end if
	
			if mid(is_sort,1,39) <> "cal_vest_sfeatures_items_sf_description" then
				this.setSort( is_sort + ", cal_vest_sfeatures_items_sf_description A")
			else
				this.setSort( is_sort)
			end if
			this.Sort()
			
			dwo.Tag = is_sort
			
			this.groupCalc()
		end if
	end if


end if
end event

type cb_accept from commandbutton within w_shiptype_sfeatureitems
integer x = 1851
integer y = 28
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Accept"
end type

event clicked;//accept changes
string 	ls_mod, ls_err
long		ll_row
integer	li_checked
long		ll_itemid,ll_newitemid
long 		ll_sort


dw_sfeatures_items.accepttext( )
if dw_sfeatures_items.update(true, false) = -1 then
	MessageBox("Error", "Error updating table items!")
	return
end if


//select items table and aply changes

ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_items_sf_item_id.Update=No")
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_items_sf_description.Update=No")

ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_cal_vest_type_id.Update=Yes")
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_sf_item_id.Update=Yes")
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_sf_show_website.Update=Yes")
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_sf_sort.Update=Yes")
  
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_cal_vest_type_id.Key=yes" )
ls_err = ls_err + dw_sfeatures_items.Modify("cal_vest_sfeatures_sf_item_id.Key=yes" )

ls_err = ls_err + dw_sfeatures_items.Modify("DataWindow.Table.UpdateTable='CAL_VEST_SFEATURES'")

if ls_err <>"" then
	MessageBox("Error", "Error settings table= " + ls_err)
	return
end if
  
ll_sort = 0
dw_sfeatures_items.setSort("cal_vest_sfeatures_sf_sort D")
dw_sfeatures_items.sort()
  
for ll_row = dw_sfeatures_items.rowcount( ) to 1 step -1
	li_checked = dw_sfeatures_items.getitemnumber( ll_row, "itemused")
	ll_itemid = dw_sfeatures_items.getitemnumber( ll_row, "cal_vest_sfeatures_sf_item_id")
	if li_checked = 1 then
		ll_newitemid = dw_sfeatures_items.getitemnumber( ll_row, "cal_vest_sfeatures_items_sf_item_id")
		if isnull(ll_itemid) then
			//add new - row status
			dw_sfeatures_items.setitemstatus( ll_row, 0, Primary!, New!)
			 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_sf_item_id", ll_newitemid)
			 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_cal_vest_type_id",il_vesseltypeid)
			 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_sf_show_website",0)
			 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_sf_sort",-1)
		else
			dw_sfeatures_items.setitemstatus( ll_row, 0, Primary!, DataModified!)
			 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_sf_sort",ll_sort)
			 ll_sort = ll_sort +1 
		end if
	else
		if not isnull(ll_itemid) then
		//delete
			dw_sfeatures_items.deleterow(ll_row)
			//dw_sfeatures_items.setitemstatus( ll_row, 0, Primary!, New!)
		end if
		
	end if
next 

for ll_row = 1 to dw_sfeatures_items.rowcount( )
	if dw_sfeatures_items.getitemnumber( ll_row, "cal_vest_sfeatures_sf_sort") = -1 then
		 dw_sfeatures_items.setitem( ll_row,"cal_vest_sfeatures_sf_sort",ll_sort)
		  ll_sort = ll_sort +1 
	end if
next

dw_sfeatures_items.accepttext( )
if dw_sfeatures_items.update(true, false) = -1 then
	MessageBox("Error", "Error updating window!")
	return
end if



close(parent)

end event

type cb_1 from commandbutton within w_shiptype_sfeatureitems
integer x = 1481
integer y = 1800
integer width = 343
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add New"
end type

event clicked;string ls_newitem
long	li_finditem, li_row

ls_newitem=sle_newitem.text

li_finditem = dw_sfeatures_items.find( "cal_vest_sfeatures_items_sf_description = '" +  ls_newitem + "'", 0, dw_sfeatures_items.rowcount( ))

if li_finditem <> 0 then
	MessageBox("Error", "Item already exists in the list.")
	return
end if

li_row = dw_sfeatures_items.InsertRow(0)
dw_sfeatures_items.SetItem(li_Row, "cal_vest_sfeatures_items_sf_description",ls_newitem)

dw_sfeatures_items.scrolltorow(li_row)
end event

type cb_cancel from commandbutton within w_shiptype_sfeatureitems
integer x = 1856
integer y = 156
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(parent)
end event

type sle_newitem from singlelineedit within w_shiptype_sfeatureitems
integer x = 27
integer y = 1804
integer width = 1422
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_shiptype_sfeatureitems
integer x = 27
integer y = 1744
integer width = 576
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Add new Item into the list:"
boolean focusrectangle = false
end type

