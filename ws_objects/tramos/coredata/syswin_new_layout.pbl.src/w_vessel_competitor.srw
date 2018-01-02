$PBExportHeader$w_vessel_competitor.srw
$PBExportComments$Maintainance of competitor vessel coredata
forward
global type w_vessel_competitor from w_coredata_ancestor
end type
type dw_next_open from mt_u_datawindow within tabpage_1
end type
type uo_pc from u_pc within w_vessel_competitor
end type
end forward

global type w_vessel_competitor from w_coredata_ancestor
integer width = 4311
integer height = 2432
string title = "Competitor Vessels"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
event ue_pcchanged ( long al_pc,  ref integer ai_return )
uo_pc uo_pc
end type
global w_vessel_competitor w_vessel_competitor

type variables
boolean		ib_isnew
long			il_pcnr_array[]
long	il_pcnr
datawindowchild idwc_owner, idwc_operator
end variables

forward prototypes
public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no)
public function datawindow uf_getdatawindow (userobject arg_object)
public function integer uf_validategeneral ()
public function integer uf_updatespending ()
public subroutine uf_updatepicklist ()
public subroutine documentation ()
end prototypes

event ue_pcchanged(long al_pc, ref integer ai_return);long ll_row
long	ll_pcnr[]
datawindowchild ldwc

if uf_updatesPending() = -1 then 
	cb_update.POST setFocus()
	ai_return = c#return.failure
	return
end if

il_pcnr =al_pc

IF al_pc = 999 THEN
	ll_pcnr = il_pcnr_array
ELSE	
	ll_pcnr[1] = al_pc
END IF

uo_SearchBox.cb_Clear.event Clicked( )

idwc_owner.setfilter("pc_nr=" + string(ll_pcnr[1]))
idwc_owner.filter()

tab_1.tabpage_1.dw_1.getchild("pc_nr", ldwc)
ldwc.setTransObject( sqlca)
ldwc.retrieve( uo_global.is_userid )  

IF dw_list.retrieve(ll_pcnr) = 0 THEN
	Messagebox("Message", "No vessels to be shown.")
	tab_1.tabpage_1.dw_1.retrieve(0)
	tab_1.tabpage_1.dw_next_open.retrieve(0)
ELSE
	dw_list.event Clicked(0,0,1,dw_list.object)
END IF

ai_return = c#return.success








end event

public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		If ldw_result.tag = string(arg_dw_no) Then
			Return ldw_result
		End if
   END IF
NEXT

RETURN ldw_result

end function

public function datawindow uf_getdatawindow (userobject arg_object);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		RETURN ldw_result
   END IF
NEXT

RETURN ldw_result

end function

public function integer uf_validategeneral ();string ls_competitor_name

tab_1.tabpage_1.dw_1.Accepttext()



ls_competitor_name = tab_1.tabpage_1.dw_1.GetItemString(1,"cal_clrk_name")
If IsNull(ls_competitor_name) Or (ls_competitor_name = "") Then
	MessageBox("Validation Error", "Please enter a competitor vessel name")
	tab_1.tabpage_1.dw_1.post setFocus()
	return -1
end if

if isNull(tab_1.tabpage_1.dw_1.getItemnumber(1, "pc_nr")) then
	MessageBox("Validation Error", "Please enter a profit center")
	tab_1.tabpage_1.dw_1.post setFocus()
	return -1
end if

return 1
end function

public function integer uf_updatespending ();long ll_anyModifications = 0

tab_1.tabpage_1.dw_1.acceptText()

ll_anymodifications = tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()

if ll_anymodifications > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	else
		tab_1.tabpage_1.dw_1.reset()
		return 0
	end if
end if


return 0
end function

public subroutine uf_updatepicklist ();integer li_vessel_nr, li_pcnr
long ll_row, ll_rc, ll_pc_row, ll_min, ll_max, ll_found
string ls_find_vessel_nr, ls_pcname, ls_dw_pcnr_filter, ls_vesselname
datawindowchild ldwc
integer li_unassigned

ll_row = dw_list.getSelectedRow(0)

if tab_1.tabpage_1.dw_1.rowCount() > 0 then
	li_vessel_nr = tab_1.tabpage_1.dw_1.GetItemNumber(1, "cal_clrk_id")
	ls_vesselname = tab_1.tabpage_1.dw_1.GetItemString(1, "cal_clrk_name")
	li_pcnr= tab_1.tabpage_1.dw_1.GetItemNumber(1, "pc_nr")
else
	setNull(li_vessel_nr)
end if

dw_list.setRedraw(false)
dw_list.Sort()
ll_found = dw_list.Find("cal_clrk_id = " + string(li_vessel_nr), 1, dw_list.rowCount() )
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("cal_clrk_id = " + string(li_vessel_nr), 1, dw_list.rowCount() )
End If
if ll_found > 0 then
	dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
	dw_list.setitem( ll_found, "cal_clrk_name", ls_vesselname)
	dw_list.setitem( ll_found, "pc_nr", li_pcnr)
end if 
dw_list.scrollToRow(ll_found)
dw_list.Filter()
if dw_list.getSelectedRow(0)>0 then dw_list.scrollToRow(dw_list.getSelectedRow(0)) 
dw_list.setRedraw(true)

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_vessel_competitor
	
   <OBJECT></DESC>
   <USAGE>   </USAGE>
   <ALSO></ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07		?      	Name Here	First Version
  	13/01/11		CR 2197	JMC112		Replace profit center list box by standard object u_pc
	13/07/12		CR2172	WWG004		Add a field commerical segment.
	10/08/12		CR2172	JMC112	 	Deletion of commercial segment value using delete key
	12/03/13		CR2658	LHG008		Change consumption type and add new column zone.
	12/08/14		CR3708  	AGL027		F1 help application coverage - corrected ancestor
	10/06/15		CR3998	CCY018		Add two columns Updated By and Updated At to every consumption type row.
	11/12/15		CR3381	XSZ004		Remove consumption tab.
********************************************************************/
end subroutine

on w_vessel_competitor.create
int iCurrent
call super::create
this.uo_pc=create uo_pc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pc
end on

on w_vessel_competitor.destroy
call super::destroy
destroy(this.uo_pc)
end on

event open;call super::open;datawindowchild ldwc
long ll_row, ll_rows
long ll_drc, ll_oa,ll_cap,ll_tc,ll_fo, ll_do, ll_mgo, ll_budget_comm
integer li_vessel
string ls_search_string
n_dw_style_service lnv_styleservice
n_service_manager lnv_servicemanager

lnv_servicemanager.of_loadservice( lnv_styleservice , "n_dw_style_service")

lnv_styleservice.of_registercolumn("cal_cons_type", true)
lnv_styleservice.of_registercolumn("zone_id", true) 

ib_isnew=false

dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_1.dw_next_open.setTransObject(SQLCA)

/* Retrieve Profitcenter available for user */
il_pcnr=uo_pc.of_retrieve( )

if il_pcnr=c#return.failure then 
	Messagebox("Message", "Retrieve profitcenter went wrong. Contact Administrator")
	return
end if

// build Profitcenter number array - for retrieval argument
uo_pc.of_getpcarray( il_pcnr_array)
// Insert 'All' item
uo_pc.of_addnew( 999,  "<All>")
il_pcnr = 999

// retrieve data for main "company" datawindow
tab_1.tabpage_1.dw_1.getchild("vessel_owner", idwc_owner )
idwc_owner.setTransObject( sqlca)
ll_rows = idwc_owner.retrieve(il_pcnr_array)   // 12 = Owner
if ll_rows < 1 then
	idwc_owner.insertRow(0)
	idwc_owner.setItem(1, "company", "No available")
	idwc_owner.setItem(1, "companyid", 0)
end if
// set the other "company" datawindows to share main dw
tab_1.tabpage_1.dw_1.getchild("vessel_operator", idwc_operator)
idwc_owner.sharedata(idwc_operator)

idwc_owner.setSort("company A")
idwc_owner.Sort()
idwc_owner.groupCalc()

tab_1.tabpage_1.dw_1.getchild("pc_nr", ldwc)
ldwc.setTransObject( sqlca)
ldwc.retrieve( uo_global.is_userid )  

// Retrieve vessel list
if dw_list.retrieve(il_pcnr_array) = 0 THEN
	Messagebox("Message", "No vessels to be shown.")
else
	// window may be opened (via calc module) as a response! window.  
	// if so we need to use the parameter received
	
	if isnull(Message.StringParm) or Message.StringParm="" then 
		ll_row=1
	else
		ll_row=dw_list.find("cal_clrk_name='"+Message.StringParm + "'",1,dw_list.rowcount())
		if ll_row<1 then ll_row=1
	end if
end if

// Init searchbox
uo_searchbox.of_Initialize(dw_list, "cal_clrk_name")
uo_searchbox.sle_Search.SetFocus()

// Sort DW and select row
dw_list.SetSort("cal_clrk_name")
dw_list.Sort()
dw_list.event Clicked(0,0,ll_row,dw_list.object)
dw_list.scrolltorow( ll_row)

// If External APM, then make readonly
If uo_global.ii_access_level = -1 then
	cb_update.Enabled = False
	cb_New.Enabled = False
	cb_Cancel.Enabled = False
	cb_Delete.Enabled = False
	tab_1.tabpage_1.dw_1.object.datawindow.readonly = "Yes"
End If

end event

event closequery;call super::closequery;if uf_updatesPending() = -1 then
	// prevent
	return 1
else
	//allow
	RETURN 0
end if
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_vessel_competitor
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_vessel_competitor
integer y = 192
end type

type st_1 from w_coredata_ancestor`st_1 within w_vessel_competitor
boolean visible = false
integer y = 16
string text = "Profit Center:"
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_vessel_competitor
boolean visible = false
integer y = 80
integer taborder = 100
boolean livescroll = false
end type

event dw_dddw::itemerror;call super::itemerror;return 1
end event

type dw_list from w_coredata_ancestor`dw_list within w_vessel_competitor
integer y = 432
integer height = 1760
integer taborder = 120
string dataobject = "d_vessel_picklist_competitor"
end type

event dw_list::clicked;long ll_competitor_id 
long ll_rows, ll_x

if row < 1 then return

datawindowchild	ldwc

// Call ancestor Clicked event to perform sorting
Super::Event Clicked(xpos, ypos, row, dwo)

if uf_updatespending() = -1 then return

if dw_list.rowcount() <1 then return

setPointer(hourGlass!)

// Retrieval argument for tabpages
ll_competitor_id = dw_list.getItemNumber(row, "cal_clrk_id")
dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

if  not isnull(this.getitemnumber(row,"pc_nr")) and il_pcnr = 999 then // <all> profit centers and empties too

	idwc_owner.setfilter("pc_nr=" + string(this.getitemnumber(row,"pc_nr")))
	idwc_owner.filter()
	
	idwc_owner.setSort("company A")
	idwc_owner.Sort()
	idwc_owner.groupCalc()
	
end if

// Retrieve tabpages

tab_1.tabpage_1.dw_1.POST Retrieve(ll_competitor_id)
tab_1.tabpage_1.dw_next_open. POST Retrieve(ll_competitor_id)


SetPointer(Arrow!)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;//If this.rowcount( )>1 then
//	If currentrow>0 Then This.event clicked(0, 0, currentrow, This.Object)
//end if
end event

type cb_close from w_coredata_ancestor`cb_close within w_vessel_competitor
integer x = 3872
integer y = 2212
integer taborder = 90
end type

event cb_close::clicked;call super::clicked;close(parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_vessel_competitor
integer x = 3465
integer y = 2212
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;datawindow ldw_d
long ll_currentrow

if tab_1.tabpage_1.dw_1.getrow()>0 then
	ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)
	ldw_d.reset()
	ib_isnew=false
	if dw_list.getrow()>0 then
		dw_list.EVENT POST Clicked(0, 0, dw_list.GetSelectedRow(0), dw_list.Object)
	end if
end if

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_vessel_competitor
integer x = 3058
integer y = 2212
integer taborder = 70
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_update, ll_row, ll_rowCount, ll_selectedrow, ll_fixture_id
dataWindow ldw_d
long ll_currentrow, ll_competitor_id

ll_currentrow = dw_list.getRow()

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)

// Deleting selected row depending on the selected tabpage (the general page or any other page)
CHOOSE CASE tab_1.SelectedTab
    CASE 1    //Free form
	  if ll_currentrow>0 then
			
			ll_response = Messagebox("Deleting!","You are about to delete a vessel and all information connected to it. ~r~n" + & 
											 "Do you wish to continue?", Question!, YesNo!, 2)
	
			// Main Competitor window
			IF ll_response = 1 THEN
				
				ll_competitor_id=tab_1.tabpage_1.dw_1.GetItemNumber(tab_1.tabpage_1.dw_1.getrow(),"cal_clrk_id")
	
			
				
				DELETE FROM CAL_CONS  
				WHERE CAL_CONS.CAL_CLRK_ID = :ll_competitor_id;
	
				if sqlca.sqlcode <> 0 then return
	
				ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
				if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
				IF ll_rc < 0 THEN
					rollback;
					tab_1.tabpage_1.dw_1.retrieve(ll_competitor_id)
					return
				ELSE
					commit;
					// All ok so we can now delete the vessel from the picklist
					dw_list.deleterow(ll_currentrow)
					// and do our update on that.
					uf_updatepicklist()
					uo_searchbox.cb_clear.EVENT POST clicked()
					dw_list.Sort()
					dw_list.event Clicked(0, 0, ll_currentrow, dw_list.object)
					dw_list.scrollToRow(ll_currentrow)
				END IF
		
			END IF
		else
			messagebox("Warning","There are no records to delete!")
		end if
	// Consumption
	CASE 2
		ll_row = ldw_d.getRow()
		IF ll_row < 1 THEN
			RETURN
		END IF
      ll_response = Messagebox("Deleting!","You are about to delete the selected consumption~r~n" & 
                               , Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			ldw_d.deleterow(ll_row)
  		END IF
END CHOOSE
end event

type cb_new from w_coredata_ancestor`cb_new within w_vessel_competitor
integer x = 2245
integer y = 2212
integer taborder = 50
end type

event cb_new::clicked;long ll_row
integer li_pc
dataWindow ldw_d
datawindowchild ldwc

CHOOSE CASE tab_1.selectedTab
	CASE 1 

		long ll_drc, ll_oa,ll_cap,ll_tc,ll_fo, ll_do, ll_mgo, ll_budget_comm
		
		if uf_updatesPending() = -1 then return
		
		ib_isnew = true
		ll_row   = 1
		
		ldw_d = uf_getDataWindow(tab_1.Control[1])
		li_pc = il_pcnr
		
		ldw_d.reset()
		
		ll_row = ldw_d.insertRow(0)
		
		if li_pc<>999 then
			ldw_d.setitem(ll_row,"pc_nr",li_pc)
		end if
		
		If IsNull(ldw_d.GetItemNumber(ll_row, "cal_vest_type_id")) Then
			
			ll_drc = ldw_d.GetItemNumber(ll_row,"cal_drc")
			If IsNull(ll_drc) Then
				ldw_d.SetItem(1,"cal_drc",0)
			End If
			
			ll_oa = ldw_d.GetItemNumber(ll_row,"cal_oa")
			If IsNull(ll_oa) Then
				ldw_d.SetItem(1,"cal_oa",0)
			End If
			
			ll_cap = ldw_d.GetItemNumber(ll_row,"cal_cap")
			If IsNull(ll_cap) Then
				ldw_d.SetItem(1,"cal_cap",0)
			End If
			
			ll_tc = ldw_d.GetItemNumber(ll_row,"cal_tc")
			If IsNull(ll_tc) Then
				ldw_d.SetItem(1,"cal_tc",0)
			End If
			
			ll_budget_comm = ldw_d.GetItemNumber(ll_row,"cal_clrk_budget_comm")
			If IsNull(ll_budget_comm ) Then
				ldw_d.SetItem(1,"cal_clrk_budget_comm",0)
			End If
		
			ldw_d.SetItem(1,"competitor",1)
	
			ldw_d.ResetUpdate()
			if isnull(ldw_d.getItemNumber(1, "cal_clrk_id")) then ldw_d.setItemStatus(1,0,primary!, New!)
		End if
		
		ldw_d.scrollToRow(ll_row)
		
		ldw_d.POST setfocus()
		ldw_d.POST setcolumn("cal_clrk_name")
   CASE ELSE
		
	if tab_1.tabpage_1.dw_1.getrow()=0 then 
		messagebox("Error","You can not add consumption to a vessel that doesn't exist.")
		return
	end if
	
	ldw_d  = uf_getDataWindow(tab_1.Control[tab_1.selectedTab],1)
	ll_row = ldw_d.insertRow(0)
	
	ldw_d.scrollToRow(ll_row)
	ldw_d.setColumn(1)
	ldw_d.setfocus()
END CHOOSE

end event

type cb_update from w_coredata_ancestor`cb_update within w_vessel_competitor
integer x = 2651
integer y = 2212
integer taborder = 60
end type

event cb_update::clicked;long    ll_row, ll_null, ll_rc, ll_competitor_id
integer li_profitcenter, li_pcgroup
string  ls_competitor_name
boolean lb_nextopenModified=FALSE, lb_nextopenDeleted=FALSE

n_next_open_calculation	lnv_nextOpen

if tab_1.tabpage_1.dw_1.getrow()=0 then return

setnull(ll_null)

tab_1.tabpage_1.dw_1.acceptText()

if uf_validategeneral() = -1 then return

ll_row = tab_1.tabpage_1.dw_1.GetRow()

ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)

IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

ll_competitor_id   = tab_1.tabpage_1.dw_1.GetItemNumber(ll_row,"cal_clrk_id")
ls_competitor_name = tab_1.tabpage_1.dw_1.GetItemString(ll_row,"cal_clrk_name")
li_profitcenter    = tab_1.tabpage_1.dw_1.GetItemNumber(ll_row,"pc_nr")

if ib_isnew then
	
	ll_row = dw_list.insertRow(0)
	
	dw_list.setitem(ll_row,"cal_clrk_id",ll_competitor_id)
	dw_list.setitem(ll_row,"cal_clrk_name",ls_competitor_name)
	dw_list.setitem(ll_row,"pc_nr",li_profitcenter)
	
	/* Update dropdown on fixturelist */
	if isvalid(w_fixture_list) then
		w_fixture_list.POST uf_setDDDW(w_fixture_list.dw_fixture)
	end if
	
	ib_isnew=false
end if


/* Next Open Report */
/* Check if there has been changes in Next Open Port or Date */

if isnull(tab_1.tabpage_1.dw_1.getItemString(1, "next_open_port")) &
or isNull(tab_1.tabpage_1.dw_1.getItemDatetime(1, "next_open_date")) then
	lb_nextopenDeleted = TRUE
else
	if tab_1.tabpage_1.dw_1.getItemStatus(1, "next_open_port", primary!) 	= NewModified! &
	or tab_1.tabpage_1.dw_1.getItemStatus(1, "next_open_date", primary!) 	= NewModified! &
	or tab_1.tabpage_1.dw_1.getItemStatus(1, "next_open_port", primary!) 	= DataModified! &
	or tab_1.tabpage_1.dw_1.getItemStatus(1, "next_open_date", primary!) 	= DataModified! then
		lb_nextopenModified = TRUE
	end if
end if

tab_1.tabpage_1.dw_1.resetUpdate()

COMMIT;

uf_updatePicklist()

/* Next Open recalculation */
if lb_nextOpenDeleted or lb_nextopenModified then
	lnv_nextOpen = create n_next_open_calculation
end if

/* AGL get the profit center group from the pc_nr */
SELECT PCGROUP_ID INTO :li_pcgroup 
  FROM PROFIT_C  
 WHERE PC_NR = :li_profitcenter;

if lb_nextOpenDeleted then
	lnv_nextOpen.of_vesseldeleted( ll_competitor_id )
elseif lb_nextopenModified then
	lnv_nextOpen.of_vesselchanged( ll_competitor_id , li_pcgroup )
end if

if isvalid(lnv_nextOpen) then destroy lnv_nextOpen

RETURN 1
end event

type st_list from w_coredata_ancestor`st_list within w_vessel_competitor
integer y = 376
integer height = 80
string text = "Vessels:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_vessel_competitor
integer x = 1061
integer width = 3218
integer height = 2144
integer taborder = 10
boolean multiline = true
end type

event tab_1::selectionchanged;CHOOSE CASE newindex
	CASE 6
		cb_new.enabled = false
		cb_delete.enabled = false	
END CHOOSE

CHOOSE CASE oldindex
	CASE 6
		cb_new.enabled = true
		cb_delete.enabled = true
END CHOOSE
	
end event

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3182
integer height = 2028
string text = "General  "
dw_next_open dw_next_open
end type

on tabpage_1.create
this.dw_next_open=create dw_next_open
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_next_open
end on

on tabpage_1.destroy
call super::destroy
destroy(this.dw_next_open)
end on

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
string tag = "1"
integer x = 27
integer y = 0
integer width = 3209
integer height = 2032
string dataobject = "d_vessel_detail_competitor"
end type

event dw_1::ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "tcowner_nr" 
			this.setItem(this.getRow(), "tcowner_nr", ll_null)
		case "cal_vest_type_id" 
			this.setItem(this.getRow(), "cal_vest_type_id", ll_null)
		case "comm_segment_id" 
			this.setItem(this.getRow(), "comm_segment_id", ll_null)
	end choose
end if
	
end event

event dw_1::itemchanged;call super::itemchanged;integer li_pc, li_null;setNull(li_null)


accepttext( )
choose case dwo.name

	CASE "pc_nr"
		li_pc=this.getitemnumber(row,"pc_nr")
		
		idwc_owner.setfilter("")
		
		this.post setitem(row,"vessel_owner",li_null)
		this.post setitem(row,"vessel_operator",li_null)

		idwc_owner.setfilter("pc_nr=" + string(li_pc))
		idwc_owner.filter()
		idwc_owner.setSort("company A")
		idwc_owner.Sort()
		idwc_owner.groupCalc()

end choose

end event

event dw_1::dberror;call super::dberror;long ll_errCode

if sqldbcode=547 then  // dependent foreign key error
	messagebox("Error","It is not possible to delete this record as the competitor is still referenced in the fixture list.~r~nPlease note that this action may still have removed the consumption data.")
	return 1
end if

end event

type dw_next_open from mt_u_datawindow within tabpage_1
integer x = 2304
integer y = 1368
integer width = 786
integer height = 552
integer taborder = 130
boolean bringtotop = true
string dataobject = "d_sq_tb_comp_vessel_next_open"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = styleraised!
end type

type uo_pc from u_pc within w_vessel_competitor
integer x = 37
integer y = 24
integer width = 937
integer taborder = 110
boolean bringtotop = true
end type

on uo_pc.destroy
call u_pc::destroy
end on

