$PBExportHeader$w_document_publication.srw
forward
global type w_document_publication from mt_w_sheet
end type
type cb_unselectall from mt_u_commandbutton within w_document_publication
end type
type cb_selectall from mt_u_commandbutton within w_document_publication
end type
type st_profitcenter from mt_u_statictext within w_document_publication
end type
type dw_profitcenter from mt_u_datawindow within w_document_publication
end type
type dw_detail from mt_u_datawindow within w_document_publication
end type
type cb_cancel from mt_u_commandbutton within w_document_publication
end type
type cb_delete from mt_u_commandbutton within w_document_publication
end type
type cb_update from mt_u_commandbutton within w_document_publication
end type
type cb_new from mt_u_commandbutton within w_document_publication
end type
type uo_att from u_fileattach within w_document_publication
end type
type uo_searchbox from u_searchbox within w_document_publication
end type
type gb_detail from mt_u_groupbox within w_document_publication
end type
type st_topbar from u_topbar_background within w_document_publication
end type
end forward

global type w_document_publication from mt_w_sheet
integer width = 4613
integer height = 2588
string title = "Shared Documents"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
event ue_attachmentchanged ( long al_currentrow )
event ue_amendedfile ( )
cb_unselectall cb_unselectall
cb_selectall cb_selectall
st_profitcenter st_profitcenter
dw_profitcenter dw_profitcenter
dw_detail dw_detail
cb_cancel cb_cancel
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
uo_att uo_att
uo_searchbox uo_searchbox
gb_detail gb_detail
st_topbar st_topbar
end type
global w_document_publication w_document_publication

type variables
integer 	ii_ext_argument
mt_n_datastore		ids_document_access
boolean	ib_fullaccess=false
private integer _ii_redraw
end variables

forward prototypes
public subroutine documentation ()
private subroutine wf_set_buttons (boolean ab_editmode)
private function integer wf_delete ()
private function integer wf_update ()
public subroutine wf_redraw_off ()
public subroutine wf_redraw_on ()
public subroutine wf_set_detailenabled (boolean ab_enable)
end prototypes

event ue_attachmentchanged(long al_currentrow);long ll_rows, ll_row, ll_pcnr, ll_found, ll_fileId

if al_currentrow < 1 then return

wf_redraw_off()

/* If creator or administrator  allow editing */
if uo_global.is_userid = uo_att.dw_file_listing.getItemString(al_currentrow, "userid") &
or uo_global.is_userid = uo_att.dw_file_listing.getItemString(al_currentrow, "owned_by" ) &
or uo_global.ii_access_level = c#usergroup.#ADMINISTRATOR  then
	wf_set_detailenabled(true)
	ib_fullaccess = true
else
	wf_set_detailenabled(false)
	ib_fullaccess = false
end if

ll_fileId = uo_att.dw_file_listing.getitemnumber(al_currentrow, "file_id")
dw_detail.retrieve(ll_fileId)

// Mark profitcenters allowed to see document
dw_profitcenter.selectrow( 0, FALSE )
ll_rows = ids_document_access.retrieve( ll_fileId )

for ll_row = 1 to ll_rows
	ll_pcnr = ids_document_access.getItemNumber(ll_row, "pc_nr")
	ll_found = dw_profitcenter.find("pc_nr="+string(ll_pcnr),1, 99999)
	if ll_found > 0 then dw_profitcenter.selectRow(ll_found, TRUE)
next
dw_profitcenter.resetUpdate()

wf_redraw_on()
end event

event ue_amendedfile();string	ls_doctype, ls_name
long		ll_list_row

SELECT ISNULL(FIRST_NAME,"")+" "+ISNULL(LAST_NAME,"")
  INTO :ls_name
  FROM USERS
 WHERE USERID = :uo_global.is_userid;

ll_list_row = uo_att.dw_file_listing.getrow()
ls_doctype = uo_att.ole_document.classlongname

dw_detail.setItem(1, "last_edited_name", ls_name)
dw_detail.setItem(1, "last_edited_by", uo_global.is_userid)
dw_detail.setItem(1, "updated_date", today())
dw_detail.setItem(1, "document_type", ls_doctype)
dw_detail.setItem(1, "file_name", uo_att.dw_file_listing.getItemstring(ll_list_row, "file_name"))

uo_att.dw_file_listing.setItem(ll_list_row, "updated_date", today())

dw_detail.post setFocus()

dw_profitcenter.enabled = true
post wf_set_buttons(true)	//use post since it will trigger event ue_attachmentchanged if current row is the first row
end event

public subroutine documentation ();
/********************************************************************
   ObjectName: w_document_publication
   <OBJECT> Window controlling general documents shared among the business</OBJECT>
   <DESC>Documents displayed are dependent on external/internal flag and profit center</DESC>
   <USAGE>Accessed from menubar</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    Author        Comments
	??/??/????  ??????   ??????		Created	 
  	12/07/2010  CR1951   AGL027     	Amended existing window so it uses the new file attachment
  method implemented across Tramos.
   11/10/2010	CR2159   AGL027		Transaction management on file attachment part.
	16/11/2010	CR2189 	AGL			Moved update and delete functionaility to this window object.  Fixed transaction issue
	09/09/2014  CR2420   LHG008      Process Improvement
	07/01/2015  CR3950   LHG008      Increase attachment limit from 20 MB to 50 MB
********************************************************************/

/*
See developer documentation in wiki.  Also check in line code in user object u_fileattach, mt_base_components.
*/
end subroutine

private subroutine wf_set_buttons (boolean ab_editmode);/********************************************************************
   wf_set_buttons
   <DESC>	Controls the command buttons availablity.  Basically if
	user clicks Update/Cancel enables New, Delete, user clicks New, or starts editing enables Update/Cancel	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ab_editmode: editing or not?
   </ARGS>
   <USAGE>	when event (click) of button/ editchanged calls function to control what the user is allowed to do	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		???      ???           ???      First Version
		03/11/14 CR2420        LHG008   Add search box
   </HISTORY>
********************************************************************/

cb_cancel.enabled = ab_editmode
cb_update.enabled = ab_editmode
cb_new.enabled = not(ab_editmode)
if ib_fullaccess then cb_delete.enabled = not(ab_editmode)
uo_att.enabled = not(ab_editmode)
uo_searchbox.enabled = not(ab_editmode)
end subroutine

private function integer wf_delete ();/********************************************************************
   wf_delete()
   <DESC>	complete delete functionaility.  some of this used to be within u_fileattach, but as this
	is specific to shared documents now contained all in here.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	 called from button	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
      ???      ???           ???      First Version
		09/09/14 CR2420        LHG008   Fix bug.
   </HISTORY>
********************************************************************/

long	ll_docID, ll_rows, ll_row, ll_fileid, ll_setselectedrow, ll_rtnval
string ls_docdesc

n_service_manager lnv_servicemgr
n_fileattach_service lnv_attservice

constant string METHOD_NAME = "wf_delete()"

ll_setselectedrow = uo_att.dw_file_listing.getselectedrow(0)
if ll_setselectedrow= 0 then return c#return.NoAction

ls_docdesc = uo_att.dw_file_listing.getitemstring(ll_setselectedrow, "description")

if MessageBox("Delete", "You are about to delete the file~r~n~r~nFile Description: " + ls_docdesc &
	+ "~r~n~r~nAre you sure you want to DELETE this?", Question!, YesNo!, 1)=2 then
	return c#return.NoAction
end if

/* delete profitcenter assignments */
ll_rows = ids_document_access.rowCount()
for ll_row = 1 to ll_rows
	ids_document_access.deleterow(0)
next

uo_att.dw_file_listing.setredraw(false)
ll_docID = uo_att.dw_file_listing.getitemnumber(ll_setselectedrow, "file_id")

if ids_document_access.update(true, false) = 1 then
	/* next work with the main listing */
	wf_set_buttons(false)
	if isnull(ll_docID) then
		ll_docID = uo_att.dw_file_listing.getitemnumber(ll_setselectedrow, "insert_index")
	end if
	
	/* delete attachment from files database */
	uo_att.dw_file_listing.deleterow(ll_setselectedrow)
	lnv_servicemgr.of_loadservice( lnv_attservice, "n_fileattach_service")		
	lnv_attservice.of_activate()
	ll_rtnval = lnv_attservice.of_deleteblob("DOCUMENT_PUBLICATION_FILES", ll_docID, true)
	if ll_rtnval = c#return.Failure then 
		rollback using sqlca;
		/* files transaction already rolled back */
		lnv_attservice.of_deactivate()
		_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the attached file.", "n/a")
	else
		commit using sqlca;
		/* files transaction already commited */
		ll_rtnval = c#return.Success
		ids_document_access.resetupdate()
		lnv_attservice.of_deactivate()
		
		/* set selected row as close as possible to deleted */
		if ll_setselectedrow > uo_att.dw_file_listing.rowcount() then
			ll_setselectedrow = uo_att.dw_file_listing.rowcount()
		end if
		
		if ll_setselectedrow <> 0 then
			uo_att.dw_file_listing.event rowfocuschanged(ll_setselectedrow)
		else
			wf_set_detailenabled(false)
		end if
	end if
	uo_att.dw_file_listing.setredraw(true)
else
	rollback using sqlca;
	uo_att.dw_file_listing.setredraw(true)
	_addmessage( this.classdefinition, METHOD_NAME, "Error deleting profitcenter access.", "n/a")
end if

uo_att.of_setfilecounter()

return ll_rtnval

end function

private function integer wf_update ();/********************************************************************
   wf_update
   <DESC>	complete update functionaility.  some of this used to be within u_fileattach, but as this
	is specific to shared documents now contained all in here.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	called from button	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
      ???      ???           ???      First Version
		09/09/14 CR2420        LHG008   Process Improvement.
   </HISTORY>
********************************************************************/

long		ll_docID, ll_rows, ll_row, ll_count = 0, ll_insertrow, ll_fileid, ll_selectedrow
string	ls_name, ls_retMethod
integer	li_rtnval

n_attachment			lnv_attach
n_service_manager		lnv_servicemgr
n_fileattach_service lnv_attservice

constant string METHOD_NAME = "wf_update()"

ll_selectedrow = uo_att.dw_file_listing.getselectedrow(0)

if ll_selectedrow = 0 then return c#return.NoAction

/* validate document description */
dw_detail.accepttext( )
if isNull(dw_detail.getItemString(1, "document_description")) then
	MessageBox("Validation Error", "Please fill in a document description")
	dw_detail.post setColumn("document_description")
	dw_detail.post setFocus()
	return c#return.Failure
end if

/* profitcenter access delete old assignments */
ll_rows = ids_document_access.rowCount()
for ll_row = 1 to ll_rows
	ids_document_access.deleterow(0)
next

/* check new assignments */
ll_rows = dw_profitcenter.rowCount()
for ll_row = 1 to ll_rows
	if dw_profitcenter.isSelected(ll_row) then
		ll_count ++
		ll_insertrow = ids_document_access.insertRow(0)
		ids_document_access.setItem(ll_insertrow, "pc_nr", dw_profitcenter.getItemNumber(ll_row, "pc_nr"))
	end if
next

if ll_count < 1 then
	MessageBox("Validation Error", "Please select at least one Profitcenter")
	dw_detail.post setColumn("document_description")
	dw_detail.post setFocus()
	return c#return.Failure
end if

SELECT ISNULL(FIRST_NAME,"")+" "+ISNULL(LAST_NAME,"") 
	INTO :ls_name
	FROM USERS 
	WHERE USERID =  :uo_global.is_userid;

dw_detail.setItem(1, "last_edited_by",  uo_global.is_userid)
dw_detail.setItem(1, "last_edited_name", ls_name )
dw_detail.setItem(1, "updated_date", today())

/* prepare window state */
setpointer( hourglass!)
wf_redraw_off()

/* create new attachment in database */
if dw_detail.update(true, false) = 1 then
	ll_docID = dw_detail.getItemNumber(1, "document_id")
	ll_fileid = uo_att.dw_file_listing.getItemNumber(ll_selectedrow, "file_id")
	
	/* profit center access properties */
	ll_rows = ids_document_access.rowCount()
	for ll_row = 1 to ll_rows
		ids_document_access.setItem(ll_row, "document_id", ll_docID) 
	next
	
	if ids_document_access.update(true, false) = 1 then
		if isnull(ll_fileid) then  //new attachment
			ll_fileid = uo_att.dw_file_listing.getItemNumber(ll_selectedrow, "insert_index")
			uo_att.dw_file_listing.setitem(ll_selectedrow, "file_id", ll_docid)
		end if
		
		/* obtain blob from private array, replacing temp file_id with real id */
		if uo_att.of_getattachment( lnv_attach, ll_fileid, ll_docid) = c#return.Success then
			lnv_servicemgr.of_loadservice( lnv_attservice, "n_fileattach_service")		
			lnv_attservice.of_activate()
			ls_retMethod = lnv_attach.is_method
			
			if (ls_retMethod="new" or ls_retMethod = "mod") then
				li_rtnval = lnv_attservice.of_writeblob("DOCUMENT_PUBLICATION_FILES",ll_docid,lnv_attach.ibl_image, lnv_attach.il_file_size, true )
				if li_rtnval = c#return.Failure then
					rollback using sqlca;
					/* files transaction object already rolled back */
					_addmessage( this.classdefinition, METHOD_NAME, "Add/Modify Attachment Error.  Error attaching new file!", "n/a")
				end if
			end if
			
			lnv_attservice.of_deactivate()
		else
			rollback using sqlca;
			li_rtnval=c#return.Failure
		end if
		
		/* everything is successful, files transaction object is commited already */
		if li_rtnval <> c#return.Failure then
			commit using sqlca;
			dw_detail.resetupdate()
			ids_document_access.resetupdate()
			li_rtnval = c#return.Success
		end if
	else
		rollback using sqlca;
		li_rtnval=c#return.Failure
	end if
else
	rollback using sqlca;
	li_rtnval=c#return.Failure
end if

//No need to refresh ole and detail, but refresh file listing.
uo_att.ib_retrievedetail = false
wf_set_buttons(false)

uo_searchbox.cb_clear.event clicked()

uo_att.of_init(uo_global.is_userid, ii_ext_argument)
uo_att.of_cancelchanges(false)
ll_row = uo_att.dw_file_listing.find("file_id=" + string(ll_docid),1,uo_att.dw_file_listing.rowcount())
if ll_row > 0 then
	uo_att.dw_file_listing.event rowfocuschanged(ll_row)
else
	wf_set_detailenabled(false)
end if

uo_att.ib_retrievedetail = true
wf_redraw_on()

return li_rtnval
end function

public subroutine wf_redraw_off ();_ii_redraw++

this.Setredraw(false)

end subroutine

public subroutine wf_redraw_on ();if _ii_redraw > 0 then
   _ii_redraw --
else
	messagebox("warning", "redraw setting below zero")
end if

if _ii_redraw = 0 then
	this.setredraw(true)
end if
end subroutine

public subroutine wf_set_detailenabled (boolean ab_enable);/********************************************************************
   wf_set_detailenabled
   <DESC>	set details availablity	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_enable
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/11/14 CR2420        LHG008   First Version
   </HISTORY>
********************************************************************/

blob	lblb_filecontent

dw_profitcenter.enabled = ab_enable
cb_selectall.enabled = ab_enable
cb_unselectall.enabled = ab_enable
cb_delete.enabled = ab_enable

if ab_enable then
	dw_detail.object.datawindow.readonly = "no"
else
	dw_detail.object.datawindow.readonly = "yes"
end if

if uo_att.dw_file_listing.getselectedrow(0) = 0 then uo_att.ole_document.objectdata = lblb_filecontent
end subroutine

on w_document_publication.create
int iCurrent
call super::create
this.cb_unselectall=create cb_unselectall
this.cb_selectall=create cb_selectall
this.st_profitcenter=create st_profitcenter
this.dw_profitcenter=create dw_profitcenter
this.dw_detail=create dw_detail
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.uo_att=create uo_att
this.uo_searchbox=create uo_searchbox
this.gb_detail=create gb_detail
this.st_topbar=create st_topbar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_unselectall
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.st_profitcenter
this.Control[iCurrent+4]=this.dw_profitcenter
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_delete
this.Control[iCurrent+8]=this.cb_update
this.Control[iCurrent+9]=this.cb_new
this.Control[iCurrent+10]=this.uo_att
this.Control[iCurrent+11]=this.uo_searchbox
this.Control[iCurrent+12]=this.gb_detail
this.Control[iCurrent+13]=this.st_topbar
end on

on w_document_publication.destroy
call super::destroy
destroy(this.cb_unselectall)
destroy(this.cb_selectall)
destroy(this.st_profitcenter)
destroy(this.dw_profitcenter)
destroy(this.dw_detail)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.uo_att)
destroy(this.uo_searchbox)
destroy(this.gb_detail)
destroy(this.st_topbar)
end on

event open;call super::open;dw_detail.setTransObject(sqlca)
dw_profitcenter.setTransObject(sqlca)

ids_document_access = create mt_n_datastore
ids_document_access.dataObject = "d_sq_tb_document_access_profitcenter"
ids_document_access.setTransObject(sqlca)

/* setup datawindow formatter service */
n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_profitcenter, false)

/* setup mandatory columns */
lnv_style.of_registerColumn( "document_description",true,false)
lnv_style.of_registerColumn("owned_by",true,false)

lnv_style.of_dwformformater(dw_detail)

wf_set_buttons(false)

if uo_global.ii_access_level < 0 then
	ii_ext_argument = 1
else
	ii_ext_argument = 0
end if

uo_att.of_init( uo_global.is_userid, ii_ext_argument)

// temporary until other windows have been changed!
lnv_style.of_dwlistformater(uo_att.dw_file_listing, false)

if uo_att.dw_file_listing.rowcount() > 0 then
	dw_profitcenter.retrieve(uo_global.is_userid)
	event ue_attachmentchanged(1)
end if

uo_att.dw_file_listing.ib_setselectrow = true
uo_att.dw_file_listing.ib_columntitlesort = true
uo_att.dw_file_listing.ib_multicolumnsort = true
uo_att.dw_file_listing.ib_enablesortindex = false

//Initialize search box
uo_searchbox.of_initialize(uo_att.dw_file_listing, "description")
uo_searchbox.sle_search.post setfocus()

end event

event closequery;dw_detail.accepttext( )
dw_profitcenter.accepttext( )
if dw_detail.modifiedcount( ) &
+ dw_profitcenter.modifiedcount( ) &
+ dw_profitcenter.deletedcount( ) > 0 then 
	if MessageBox("Data not saved!", "Document data modified, but not saved~n~r~n~r" &
					 +"Would you like to update before closing", Question!, YesNo!, 1) = 1 then
		dw_detail.POST setFocus()
		cb_update.default = true
		return 1 //prevent window from closing
	end if
end if

return 0 //allow window to close
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_document_publication
end type

type cb_unselectall from mt_u_commandbutton within w_document_publication
integer x = 4187
integer y = 2240
integer taborder = 40
string text = "U&nselect All"
end type

event clicked;call super::clicked;wf_set_buttons(true)
dw_profitcenter.selectRow(0, FALSE)
end event

type cb_selectall from mt_u_commandbutton within w_document_publication
integer x = 3840
integer y = 2240
integer taborder = 30
string text = "&Select All"
end type

event clicked;call super::clicked;wf_set_buttons(true)
dw_profitcenter.selectRow(0, TRUE)
end event

type st_profitcenter from mt_u_statictext within w_document_publication
integer x = 3150
integer y = 1040
integer width = 347
integer height = 180
long backcolor = 32304364
string text = "Document visible to (Profitcenter)"
alignment alignment = right!
end type

type dw_profitcenter from mt_u_datawindow within w_document_publication
integer x = 3511
integer y = 1040
integer width = 1015
integer height = 1184
integer taborder = 20
string dataobject = "d_sq_tb_document_user_profitcenter"
boolean vscrollbar = true
boolean border = false
end type

event clicked;wf_set_buttons(true)
if row > 0 then this.selectRow(row, not this.isSelected(row))
end event

type dw_detail from mt_u_datawindow within w_document_publication
integer x = 3150
integer y = 248
integer width = 1376
integer height = 772
integer taborder = 10
string dataobject = "d_sq_tb_doc_file_detail"
boolean minbox = true
boolean maxbox = true
boolean border = false
end type

event editchanged;
wf_set_buttons(true)

end event

event itemchanged;wf_set_buttons(true)
end event

type cb_cancel from mt_u_commandbutton within w_document_publication
integer x = 4224
integer y = 2384
integer taborder = 80
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;long ll_row

ll_row = uo_att.dw_file_listing.getselectedrow(0)

wf_set_buttons(false)
wf_redraw_off()

uo_att.ib_retrievedetail = false

// uo_att.of_clearImages( )
uo_att.of_cancelchanges()
uo_att.of_init(uo_global.is_userid, ii_ext_argument)

uo_att.ib_retrievedetail = true

if ll_row > 0 and ll_row <= uo_att.dw_file_listing.rowcount() then
	uo_att.dw_file_listing.event rowfocuschanged(ll_row)
else
	wf_set_detailenabled(false)
end if

wf_redraw_on()
end event

type cb_delete from mt_u_commandbutton within w_document_publication
integer x = 3877
integer y = 2384
integer taborder = 70
boolean bringtotop = true
string text = "&Delete"
end type

event clicked;wf_delete()
end event

type cb_update from mt_u_commandbutton within w_document_publication
integer x = 3529
integer y = 2384
integer taborder = 60
boolean bringtotop = true
string text = "&Update"
end type

event clicked;wf_update()
end event

type cb_new from mt_u_commandbutton within w_document_publication
integer x = 3182
integer y = 2384
integer taborder = 50
boolean bringtotop = true
string text = "&New"
end type

event clicked;string ls_doctype, ls_name
long ll_row, ll_list_row

wf_redraw_off()

if uo_att.of_addnewimage( ) = c#return.success then
	ll_list_row = uo_att.dw_file_listing.getrow()
	uo_att.dw_file_listing.event rowfocuschanged(ll_list_row)
	
	dw_detail.reset()
	dw_profitcenter.selectRow(0, false)
	ids_document_access.reset()
	ll_row = dw_detail.InsertRow(0)
	if ll_row < 1 then
		wf_redraw_on()
		MessageBox("Error", "Error inserting new document detail!")
		return
	end if
	
	dw_detail.setItem(ll_row, "created_by", uo_global.is_userid)
	SELECT ISNULL(FIRST_NAME,"")+" "+ISNULL(LAST_NAME,"") 
	  INTO :ls_name
	  FROM USERS 
	 WHERE USERID = :uo_global.is_userid;

	dw_detail.setItem(ll_row, "created_name", ls_name )
	dw_detail.setItem(ll_row, "last_edited_name", ls_name)
	dw_detail.setItem(ll_row, "owned_by", uo_global.is_userid)
	
	dw_detail.setItem(ll_row, "created_date", today())
	dw_detail.setItem(ll_row, "last_edited_by", uo_global.is_userid)
	dw_detail.setItem(ll_row, "updated_date", today())
	
	uo_att.dw_file_listing.setItem(ll_list_row, "created_date", today())
	uo_att.dw_file_listing.setItem(ll_list_row, "updated_date", today())
	uo_att.dw_file_listing.setItem(ll_list_row, "owned_by", uo_global.is_userid)
	
	ls_doctype = uo_att.ole_document.classlongname
	dw_detail.setItem(ll_row, "document_type", ls_doctype)
	dw_detail.setItem(ll_row, "external_access", 1)
	
	dw_detail.setItem(ll_row, "file_name", uo_att.dw_file_listing.getItemstring(ll_list_row, "file_name"))
	
	dw_detail.post setColumn("document_description")
	dw_detail.post setFocus()
	
	wf_set_detailenabled(true)
	ib_fullaccess = true
	wf_set_buttons(true)
	
	uo_att.dw_file_listing.setsort("created_date desc")
	uo_att.dw_file_listing.sort()
end if

wf_redraw_on()
end event

type uo_att from u_fileattach within w_document_publication
integer x = 41
integer y = 240
integer width = 3045
integer height = 2140
integer taborder = 100
boolean bringtotop = true
string is_dataobjectname = "d_sq_tb_doc_file_listing"
boolean ib_ole = true
boolean ib_show_ole = true
integer ii_ole_height = 1000
integer ii_buttonmode = 0
long il_max_size_bytes = 52428800
end type

on uo_att.destroy
call u_fileattach::destroy
end on

event ue_childclicked;call super::ue_childclicked;if row = 1 then
	uo_att.dw_file_listing.event rowfocuschanged(row)
end if
end event

type uo_searchbox from u_searchbox within w_document_publication
integer x = 37
integer y = 32
integer taborder = 90
boolean bringtotop = true
boolean ib_standard_ui_topbar = true
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

event ue_keypress;call super::ue_keypress;if uo_att.dw_file_listing.getrow() = 0 or uo_att.dw_file_listing.getrow() <> uo_att.dw_file_listing.getselectedrow(0) then
	wf_set_detailenabled(false)
end if

uo_att.ib_retrievedetail = true

uo_att.of_setfilecounter()
wf_redraw_on()
end event

event clearclicked;call super::clearclicked;long ll_row

ll_row = uo_att.dw_file_listing.getrow()
if ll_row > 0 then
	uo_att.dw_file_listing.event rowfocuschanged(ll_row)
end if

uo_att.of_setfilecounter()
end event

event ue_prekeypress;call super::ue_prekeypress;wf_redraw_off()
if key <> keyenter! then uo_att.ib_retrievedetail = false

return c#return.Success
end event

type gb_detail from mt_u_groupbox within w_document_publication
integer x = 3109
integer y = 208
integer width = 1458
integer height = 2160
integer weight = 400
string facename = "Tahoma"
long backcolor = 32304364
string text = ""
end type

type st_topbar from u_topbar_background within w_document_publication
integer width = 4800
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
05w_document_publication.bin 
2C00003000e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe0000000600000005000000070000000a00000008000000090000000b0000000c0000000d0000000f0000000e000000100000001200000011000000140000001300000015fffffffe00000016fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000001fb25c862011cf1b770702ac9f85f31901000000000000000000000000cf14cfc001ca26ee000000030000104000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000440047007c004d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101000a00000001000000180000000c0000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000004d00440000007c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010008ffffffffffffffff000000070000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000fffffffefffffffefffffffefffffffefffffffefffffffefffffffefffffffe00000009fffffffefffffffe0000000cfffffffefffffffefffffffefffffffe00000011fffffffefffffffefffffffefffffffefffffffe00000017fffffffefffffffe0000001a0000001bfffffffefffffffefffffffefffffffe00000020fffffffefffffffefffffffefffffffe00000025fffffffefffffffefffffffe000000290000002afffffffefffffffe0000002d0000002e0000002f000000300000003100000032fffffffefffffffefffffffe000000360000003700000038000000390000003a0000003b0000003c0000003d0000003e0000003ffffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
28ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0200000100000000000000000000000000000000002034f000000000000000000000000000000000000000000000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d701000000000000000000000000000000000000000000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d70000000000000000fffffd00000000ff000000000000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d700000000000000000000000000000000000000000000000000000000000000000000000000000000315600040007302e6372654d0079727500000000003ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d700000000000000000000000000000000000000000000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d70000000000000000000000000000000000000000000000000000000000000000000000000000000032560004000b342e616e694261447972d77365740a3d70a3004003d7000000000000000000000000000000000000000000000000000000000000000000000000004d004400690044007400630000003b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020010ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000002700000000005000440069004c007400730000003b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200100000000400000006ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000020000002900000000004d00440072004f006f0069003b006e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000001700000000007300550072006500690044003b006d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010200120000000500000009ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000001f00000000004d004400690044007400630065004e003b0077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020016ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000500000017000000000065004e004400770044004d00630069003b0074000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020016000000080000000affffffff000000000000000000000000000000000000000000000000000000000000000000000000000000060000001700000000006900420061006e007900720061004400650074003b0073000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff0000000bffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000070000001b0000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000080000007700000000000000050000000000000000000100000007000000060000694c504400007473000900014477654e6369444d0100007442000b0072616e6974614479000073650007000172657355006d694409000100444d44004e746369000077650006000169444d440000746300070001724f4d44006e6f69000001000000000000000000317600083134302e000c312e2042444c302e3176312e3134793dd97f3ff0a85800000000000000000000000000000000000000000000000000000000000000007542000f656e6973624f73737463656a030001732300140061636f4c3834236c30333134383335310035233100000000000000000000000006000000534552000152474d4c0003000000424400010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000001000000020000
2F000c000065442d4269726373726f7470000100006544000a69726373726f747000010000000000000000000000000005000000000000000000010000000200000004000061746144000100006552000e72756f736548656372656461000000010000000000000000015e01a40044004c007c004200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101000a00000003000000130000000e0000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee00000000000000000000000000610044006100740000003b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000cffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000a000000280000000000650052006f007300720075006500630065004800640061007200650000007c0000000000000000000000000000000000000000000000000000000000000000010100200000000d00000012000000100000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000020018ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000b0000005800000000002d0042006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000102001c0000000f00000011ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000d000000020000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000e000000380000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000f000000340000000000650052006f007300720075006500630065004800640061007200650000007c000000000000000000000000000000000000000000000000000000000000000001010020ffffffff00000017000000150000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000020018ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000100000005700000000002d0042006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000102001c0000001400000016ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000012000000020000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000013000000380000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000140000003b000000007542000f656e6973624f73737463656a030001732300140061636f4c3834236c30333134383335310034233100000000000000000000000006000000534552000152474d440002000000004d00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000001000000020000000c000065442d4269726373726f7470000100006544000a69726373726f74700001000000000000000000000000000500000000000000000001000000030000000300000142444c02000000014d44000e000000736552006372756f616548650172656400000000000000000000000000000000000000000000000000000000000000000000000000000000
2C000000000000000000000000000000000000000000000000000000000000000031560006322e302e7542001c656e6973624f73737463656a2e34207320322e306d726f66b852746151eb851e00013ff000000000000000002ee000003a9800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000420056004900410066006e0000006f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020010ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000150000000400000000004c004f00490045006500740073006d0000007c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010014000000020000001d0000001a0000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000004c004f004f0045006a006200630065004300740075006f0074006e0000003b000000000000000000000000000000000000000000000000000000000000000001020020ffffffff0000001bffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000016000000420000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000180000002a000000000000000500000000000000000001000000010000000e00004f454c4f63656a62756f43740000746e000000010000000000000000000000000000000000000000ffffffff000000030000000400000001ffffffff000000020000000000002ee000003a980000005c00090001002e0300000000000000000500050000010200000000000100000005000d010400050000020900000000000000000005ffff0201000400ff0103000000050008020b000000000000000000050236020c000301c50000000000000000000000000000000000000000414e00000000494e000000000000000000000000000000000000000000000000000000000000000000000000424d41534e495f4100004c540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031560006332e302e75420021656e6973624f73737463656a2e35207320302e3020636f446974704f7b736e6fe147ae14003ff07affffff00000000ff000000002e312e3500302e33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031560006302e312e75420025656e6973624f73737463656a2e3520736552203074726f70656853204c2074659a74736999999999ff3ff19912ffffff524f4200004f00020065006c007200500073006500300030000000300000000000000000000000000000000000000000000000000000000000000000000000000000000001020018ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000190000009e0000000000750042006c0069004f006400690072006900670000006e00000000000000000000000000000000000000000000000000000000000000000000000000000000010200180000001c0000001effffffff0000000000000000000000000000000000000000000000000000000000000000000000000000001c0000000b00000000006f0044004f006300740070006f00690073006e0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000001020018ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000001d0000003b00000000006f0046006d0072007400610065005600730072006f00690000006e0000000000000000000000000000000000000000000000000000000000000000000000000102001c0000001900000025ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000001e000000080000000000650052006f0070007400720068005300650065007300740000007c0000000000000000000000000000000000000000000000000000000000000000000000000101001cffffffffffffffff000000210000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee00000000000000000000000000650052006f0070007400720068005300650065004c007400730069003b0074000000000000000000000000000000000000000000000000000000000000000001020022ffffffff00000022ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000001f000000570000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072
24006400650000000000000000000000000000000000020032ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000002b000000000042005600500041006f00720065006a007400630061004e0065006d0000000000000000000000000000000000000000000000000000000000000000000000000102001e0000002000000024ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000220000001200000000726f7065656853744c737465007473690000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000001000000010000000f00006f706552685374724c746565007473690000010000000000000000000000000000000000000000000000000700720050006a006f00630065000000740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007542000f656e6973624f73737463656a030001732300140061636f4c3834236c30333134383335310033233100000000000000000000000006000000534552000152474d55000a00445245534552434f000000530000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000001000000020000000c000065442d4269726373726f7470000100006544000a69726373726f7470000100000000000000000000006c00410072006500650074004d0072006e006100670061007200650000003b000000000000000000000000000000000000000000000000000000000000000001020020ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000230000000c0000000000650052006f007300720075006500630065004800640061007200650000007c000000000000000000000000000000000000000000000000000000000000000001010020000000230000002a000000270000000000000000000000000000000000000000cf14cfc001ca26eecf14cfc001ca26ee000000000000000000000000006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000020018ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000240000005f00000000002d0042006500440063007300690072007400700072006f0000003b0000000000000000000000000000000000000000000000000000000000000000000000000102001c0000002600000028ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000026000000020000000000750042006900730065006e007300730062004f0065006a0074006300200073006500520065007300760072006400650000000000000000000000000000000000020032ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000270000003800000000006f0044007500630065006d0074006e00750053006d006d00720061003b0079000000000000000000000000000000000000000000000000000000000000000001020022ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000280000008400000000006f0046006d007200740061006f004c006100630065006c006f005300740072000000000000000000000000000000000000000000000000000000000000000001020022000000290000002cffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000002b0000000d0000000000530005006d00750061006d00790072006e0049006f0066006d007200740061006f00690000006e00000000000000000000000000000000000000000000000001020028ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000002c000001b500000000315600040020302e6d6d7553207972616f666e4974616d72736e6f69726f46202074616d302e3156000000003ff00000000000002e41000b6f4d2e50656c6c6500000072ffffd600000000ff000000000b000000502e4100656f4d2e72656c6c00000000ffffffd600257102c5a245eeffffffd600257102c5a245ee0000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000474e414c474e455f4853494c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000fffe00020105f29f85e010684ff9000891abd9b3272b00000001f29f85e010684ff9000891abd9b3272b00000030000001850000001300000001000000a000000002000000a800000003000000b400000004000000c000000005000000d400000006000000e000000007000000ec00000008000000f8000000090000010c0000000a000001180000000b000001240000000d000001300000000c0000013c0000000e000001480000000f00000150000000100000015800000012000001608000000200000170000000000000017800000002000004e40000001e00000001000000000000001e00000001000000000000001e0000000c2e502e416c656f4d0072656c0000001e00000001000000000000001e00000001000000000000001e00000001000000000000001e0000000c2e502e416c656f4d0072656c0000001e000000020000003100000040000000000000000000000040000000000000000000000040804f030001c6228e00000040804f030001c6228e0000000300000000000000030000000000000003000000000000001e000000076f73756200006a6200000003000000000000000100000000000000010000000000000000000000000000000000000000325600040007342e6372654dd77972750a3d70a3004003d700000000000000000000000000000000000000000000000000000000000000000000000000000000315600040007302e6372654d0079727500000000003ff000000000000000000000000000000000000000000000000000000000000000000000000005000000012400000024022401240424032406240524082407240a2409240c240b240e240d2410240f24122411241424132416241524182417241a2419241c241b241e241d0020241f00220021002400230026002500280027002a0029002c002b002e002d0030002f00320031003400330036003500380037003a0039003c003b003e003d0040003f00420041004400430046004500480047004a0049004c004b004e004d0050004f00520051005400530056005500580057005a00590042005600500041006f00720065006a0074006300610048004d007300630061006f007200000073000000000000000000000000000000000000000000000000000200280000002b0000002effffffff0000000000000000000000000000000000000000000000000000000000000000000000000000003300000004000000000075004e0062006d00720065006f0046006d0072007400610061004d0061006e00650067003b00720000000000000000000000000000000000000000000000000002002affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000034000000040000000000750042006900730065006e007300730062004f0065006a00740063002000730065005200650073007600720064006500000000000000000000000000000000010200320000002d0000002fffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000035000002a90000000000610045006c00720065006900740073006f00430070006d00740061006200690065006c006f0046006d0072007400610065005600730072006f00690000006e00020040ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000400000000400000000005c005b005e005d0060005f00620061006400630066006500680067006a0069006c006b006e006d0070006f00720071007400730076007500780077007a0079007c007b007e007d0080007f00820081008400830086008500880087008a0089008c008b008e008d0090008f00920091009400930096009500980097009a0099009c009b009e009d00a0009f00a200a100a400a300a600a500a800a700aa00a900ac00ab00ae00ad00b000af00b200b100b400b300b600b500b800b700ba00b900bc00bb00be00bd00c000bf00c200c100c400c300c600c500c800c700ca00c900cc00cb00ce00cd00d000cf00d200d100d400d300d600d500d800d700da00d900dc00db00de00dd00e000df00e200e100e400e300e600e500e800e700ea00e900ec00eb00ee00ed00f000ef00f200f100f400f300f600f500f800f700fa00f900fc00fb00fe00fd00a100ff00000000000100000008000000130000626d754e6f46726574616d72616e614d007265670e000100656c410072657472616e614d0072656708000100454c4f006d6574490000017344000f006d75636f53746e65616d6d7500007972000a00014f636f446f6974700000736e00030001014d44470c000000706552005374726f746565680000017352000e00756f736548656372656461650000017200000000000000000000000000000000000000000000000000302e35015e023405c201eb00001000001f50300022b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15w_document_publication.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
