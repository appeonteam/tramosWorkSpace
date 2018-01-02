HA$PBExportHeader$w_public_report.srw
forward
global type w_public_report from window
end type
type dw_detail from datawindow within w_public_report
end type
type cb_retrieve from commandbutton within w_public_report
end type
type cb_delete from commandbutton within w_public_report
end type
type cb_update from commandbutton within w_public_report
end type
type dw_list from datawindow within w_public_report
end type
type cb_new from commandbutton within w_public_report
end type
type mle_syntax from multilineedit within w_public_report
end type
type cb_generate from commandbutton within w_public_report
end type
type dw_preview from datawindow within w_public_report
end type
end forward

global type w_public_report from window
integer width = 4672
integer height = 2520
boolean titlebar = true
string title = "Public Report"
boolean controlmenu = true
boolean minbox = true
string icon = "AppIcon!"
boolean center = true
dw_detail dw_detail
cb_retrieve cb_retrieve
cb_delete cb_delete
cb_update cb_update
dw_list dw_list
cb_new cb_new
mle_syntax mle_syntax
cb_generate cb_generate
dw_preview dw_preview
end type
global w_public_report w_public_report

type variables
long il_dargrow
boolean ib_modified
transaction itr_trans
end variables

forward prototypes
public function integer wf_delete ()
public function integer wf_new ()
public function integer wf_update ()
public function integer wf_checkmodified ()
public function integer wf_generate ()
public function integer wf_validate ()
public function string wf_hexdecode (string as_hexstring)
public function integer wf_hexasc2decode (ref string as_string)
public function boolean wf_init_transaction ()
public subroutine wf_set_autocommit ()
end prototypes

public function integer wf_delete ();string ls_report_name, ls_errtext
integer li_report_id, li_selectedrow

li_selectedrow = dw_list.getselectedrow(0)
if li_selectedrow > 0 then
	ls_report_name = dw_list.getitemstring(li_selectedrow, "report_name")
	if messagebox("Verify Delete", "Are you sure you want to delete the report?~n- " + ls_report_name, Question!, YesNo!, 1) = 2 then return 0
	
	li_report_id = dw_list.getitemnumber(li_selectedrow, "report_id")
	delete from PUBLIC_REPORT where REPORT_ID = :li_report_id;
	
	if sqlca.sqlcode = 0 then
		commit;
		dw_list.retrieve()
	else
		ls_errtext = sqlca.sqlerrtext
		rollback;
		messagebox('Error', ls_errtext)
		return -1
	end if
end if

return 1
end function

public function integer wf_new ();integer li_row, li_report_order, li_crnumber, li_fileid, li_filecount, li_index
integer li_report_id, li_old_report_id
string lsa_filename[], ls_fullname, ls_filestr, ls_dwsyntax
string ls_current_version, ls_dwobject_name, ls_report_desc
string ls_parm

constant string ls_EXPORTHEADER = "$PBExport" + "Header$", ls_EXPORTCOMMENTS = "$PBExport" + "Comments$"

n_string lnv_string

if wf_checkmodified() = -1 then return 1

select isnull(max(REPORT_ORDER), 0) into :li_report_order from PUBLIC_REPORT;
select CURRENT_VERSION into :ls_current_version from TRAMOS_VERSION;

dw_detail.post setfocus()

//Open Datawindow export file(*.srd) and import to dw_detail
if getfileopenname("Select DW Export File", ls_fullname, lsa_filename[], "srd", "DataWindows(*.srd), *.srd", "") < 1 then return -1

dw_list.setredraw(false)
dw_detail.setredraw(false)
mle_syntax.setredraw(false)

setnull(li_crnumber)

li_filecount = upperbound(lsa_filename)

//Multiple files selected
if li_filecount > 1 then
	openwithparm(w_input_report_info, ls_current_version)
	ls_parm = message.stringparm
	li_crnumber = integer(mid(ls_parm, 1, pos(ls_parm, '||') - 1))
	ls_current_version = mid(ls_parm, pos(ls_parm, '||') + 2)
end if

for li_index = 1 to li_filecount
	li_report_order ++
	
	li_fileid = fileopen(lsa_filename[li_index], TextMode!)
	filereadex(li_fileid, ls_dwsyntax)
	fileclose(li_fileid)
	
	wf_hexasc2decode(ls_dwsyntax)
	
	//Reset
	dw_list.selectrow(0, false)
	dw_detail.reset()
	dw_preview.dataobject = ''
	mle_syntax.text = ''
	
	li_row = dw_detail.insertrow(0)
	
	dw_detail.setItem(li_row, "save_as_type", "XLSX!")
	dw_detail.setItem(li_row, "report_order", li_report_order)
	dw_detail.setItem(li_row, "create_date", today())
	dw_detail.setItem(li_row, "created_by", SQLCA.logid)
	
	//Set dwobject_name, report_name
	if pos(ls_dwsyntax, ls_EXPORTHEADER) > 0 then
		ls_dwobject_name = left(ls_dwsyntax, pos(ls_dwsyntax, ".srd") - 1)
		ls_dwsyntax = mid(ls_dwsyntax, len(ls_dwobject_name +".srd~r~n") + 1)
		ls_dwobject_name = mid(ls_dwobject_name, pos(ls_dwobject_name, ls_EXPORTHEADER) + len(ls_EXPORTHEADER))
		dw_detail.setItem(li_row, "dwobject_name", ls_dwobject_name)
		dw_detail.setItem(li_row, "report_name", ls_dwobject_name)
	end if
	
	//Set dwobject_name
	ls_report_desc = ''
	if pos(ls_dwsyntax, ls_EXPORTCOMMENTS) > 0 then
		ls_report_desc = left(ls_dwsyntax, pos(ls_dwsyntax, "~r~n") - 1)
		ls_dwsyntax = mid(ls_dwsyntax, len(ls_report_desc +"~r~n") + 1)
		ls_report_desc = mid(ls_report_desc, pos(ls_report_desc, ls_EXPORTCOMMENTS) + len(ls_EXPORTCOMMENTS))
		ls_report_desc = lnv_string.of_globalreplace(ls_report_desc, "~~r~~n", "~r~n")
	end if
	
	//Check whether the report exists
	li_old_report_id = 0
	li_report_id = dw_detail.getitemnumber(1, "report_id")
	select REPORT_ID into :li_old_report_id
	  from PUBLIC_REPORT
	 where DWOBJECT_NAME = :ls_dwobject_name
		and REPORT_ID <> :li_report_id;
	
	if li_old_report_id > 0 then
		if messagebox('Warning', "The report '" +  + ls_dwobject_name + "' already exists." &
										 + "~n~nDo you want to Replace it?", Question!, YesNo!, 2) = 1 then
			dw_detail.retrieve(li_old_report_id)
			dw_detail.setItem(li_row, "cr_number", li_crnumber)
		else
			if li_filecount > 1 then continue
		end if
	end if
	
	dw_detail.setItem(li_row, "report_desc", ls_report_desc)
	dw_detail.setItem(li_row, "release_version", ls_current_version)
	
	mle_syntax.text = ls_dwsyntax
	
	ib_modified = true
	
	if li_filecount > 1 then
		dw_detail.setItem(li_row, "cr_number", li_crnumber)
		wf_update()
	end if
next

if li_filecount > 1 then dw_list.event rowfocuschanged(1)

dw_list.setredraw(true)
dw_detail.setredraw(true)
mle_syntax.setredraw(true)

return 1
end function

public function integer wf_update ();string ls_report_syntax, ls_errtext
integer li_row, li_report_id
blob lblb_report_syntax

ls_report_syntax = mle_syntax.text

if dw_detail.accepttext() < 0 then return -1
if not ib_modified then return 0

if wf_validate() < 0 then return -1

if not dw_detail.getitemstatus(1, 0, Primary!) = NewModified! then
	dw_detail.setItem(1, "last_edit_date", today())
	dw_detail.setItem(1, "last_edit_by", SQLCA.logid)
end if

//update
if dw_detail.update(true, false) = 1 then
	li_report_id = dw_detail.getitemnumber(1, "report_id")
	lblb_report_syntax = blob(ls_report_syntax)
	
	updateblob PUBLIC_REPORT
			 set REPORT_SYNTAX = :lblb_report_syntax
		  where REPORT_ID = :li_report_id;
	
	if sqlca.sqlcode = 0 then
		commit;
		ib_modified = false
		dw_list.retrieve()
		li_row = dw_list.find("report_id = " + string(li_report_id), 1, dw_list.rowcount())
		if li_row <= 0 then li_row = 1
		dw_list.event rowfocuschanged(li_row)
	else
		ls_errtext = sqlca.sqlerrtext
		rollback;
		messagebox('Update Error', ls_errtext)
		return -1
	end if
else
	ls_errtext = message.stringparm
	rollback;
	messagebox('Update Error', ls_errtext)
	return -1
end if

return 1
end function

public function integer wf_checkmodified ();long ll_answer

if ib_modified then
	ll_answer = messagebox("Updates Pending", "Data has been changed, but not saved. ~n~nWould you like to save data?", Question!, yesnocancel!)
	if ll_answer = 1 then
		if dw_detail.accepttext() < 0 then return -1
		
		if wf_update() = -1 then
			return -1
		end if
	elseif ll_answer = 3 then
		return -1
	end if
end if

ib_modified = false

return 1
end function

public function integer wf_generate ();string ls_errors, ls_dwsyntax_str

if len(trim(mle_syntax.text)) > 0 then
	ls_dwsyntax_str = mle_syntax.text
	
	dw_preview.create(ls_dwsyntax_str, ls_errors)
	
	if len(ls_errors) > 0 then
		messagebox("Generate Datawindow Failed", "Datawindow syntax errors: " + ls_errors)
		return -1
	end if
	
	return 1
end if

return 0
end function

public function integer wf_validate ();string ls_column_name, ls_errtext, ls_value, ls_report_syntax
integer li_count, li_report_id

ls_column_name = "cr_number"
if isnull(dw_detail.getitemnumber(1, ls_column_name)) then
	ls_errtext = "CR Number can not be null"
end if

if ls_errtext = '' then
	ls_column_name = "release_version"
	ls_value = dw_detail.getitemstring(1, ls_column_name)
	if isnull(ls_value) or trim(ls_value) = '' then
		ls_errtext = "Release Version can not be empty"
	end if
end if

if ls_errtext = '' then
	ls_column_name = "dwobject_name"
	ls_value = dw_detail.getitemstring(1, ls_column_name)
	if isnull(ls_value) or trim(ls_value) = '' then
		ls_errtext = "DW Object Name can not be empty"
	end if
	
	if ls_errtext = '' then
		li_report_id = dw_detail.getitemnumber(1, "report_id")
		select count(1) into :li_count
		  from PUBLIC_REPORT
		 where DWOBJECT_NAME = :ls_value
		   and REPORT_ID <> :li_report_id;
		if li_count > 0 then
			ls_errtext = "The report '" +  + ls_value + "' already exists"
		end if
	end if
end if

if ls_errtext = '' then
	ls_column_name = "report_name"
	ls_value = dw_detail.getitemstring(1, ls_column_name)
	if isnull(ls_value) or trim(ls_value) = '' then
		ls_errtext = "Report Name can not be empty"
	end if
end if

if len(ls_errtext) > 0 then
	dw_detail.setfocus()
	dw_detail.setcolumn(ls_column_name)
	messagebox('Validation Error', ls_errtext)
	return -1
end if

ls_report_syntax = mle_syntax.text
if isnull(ls_report_syntax) or trim(ls_report_syntax) = '' then
	mle_syntax.setfocus()
	messagebox('Validation Error', "Report Syntax can not be empty")
	return -1
end if

//Check syntax
dw_preview.setredraw(false)
dw_preview.create(ls_report_syntax, ls_errtext)
dw_preview.dataobject = ''
dw_preview.setredraw(true)

if len(ls_errtext) > 0 then
	mle_syntax.setfocus()
	messagebox("Validation Error", "Datawindow syntax errors: " + ls_errtext)
	return -1
end if

return 1
end function

public function string wf_hexdecode (string as_hexstring);//Converts hex string to character string
char lch_d, lch_hex[0 to 15] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
string ls_str
integer li_d, li_i, li_j, li_k, li_m

if isnull(as_hexstring) then return as_hexstring

li_j = len(as_hexstring) / 2

for li_i = 0 to li_j - 1
	//Get hight bytes
	lch_d = mid(as_hexstring, li_i * 2 + 1, 1)
	for li_m = 0 to 15
		if lch_hex[li_m] = lch_d then exit
	next
	
	//Get lower bytes
	lch_d = mid(as_hexstring, li_i * 2 + 2, 1)
	for li_k = 0 to 15
		if lch_hex[li_k] = lch_d then exit
	next
	
	//To decimal
	li_d = li_m * 16 + li_k
	
	//To character
	lch_d = char(li_d)
	
	//To string
	ls_str = ls_str + lch_d
next

return ls_str

end function

public function integer wf_hexasc2decode (ref string as_string);//Converts HEXASCII Encoding string to character string. eg. $$HEX2$$e6002000$$ENDHEX$$-> '$$HEX1$$e600$$ENDHEX$$', $$HEX4$$e600e600e6002000$$ENDHEX$$-> '$$HEX3$$e600e600e600$$ENDHEX$$'
constant string ls_SEPARATOR = "$$", ls_HEXBEGIN = ls_SEPARATOR + "HEX", ls_HEXEND = ls_SEPARATOR + 'ENDHEX' + ls_SEPARATOR
long ll_count, ll_i, ll_j, ll_k
string ls_hex, ls_str

ll_i = pos(as_string, ls_HEXBEGIN)
do while ll_i > 0
	ll_j = pos(as_string, ls_SEPARATOR, ll_i + len(ls_HEXBEGIN)) + len(ls_SEPARATOR) //Find hex string begin position
	ll_k = pos(as_string, ls_HEXEND, ll_j) //Find hex string end position
	ls_hex = mid(as_string, ll_j, ll_k - ll_j) //Get hex string
	
	ls_str = wf_hexdecode(ls_hex) //Converts hex string to character string
	
	as_string = replace(as_string, ll_i, ll_k + len(ls_HEXEND) - ll_i, ls_str)
	ll_i = pos(as_string, ls_HEXBEGIN, ll_i)
	
	ll_count ++
loop

return ll_count
end function

public function boolean wf_init_transaction ();/********************************************************************
   wf_init_transaction
   <DESC>	Init the transaction for public report</DESC>
   <RETURN>	boolean </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date     CR-Ref		Author		Comments
		07-03-17	CR4619		XSZ004		First Version
   </HISTORY>
********************************************************************/

boolean lb_ret

lb_ret = true

itr_trans = create transaction

itr_trans.autocommit = sqlca.autocommit
itr_trans.dbms       = sqlca.DBMS
itr_trans.Database   = sqlca.Database
itr_trans.Servername = sqlca.ServerName
itr_trans.UserID     = sqlca.userid
itr_trans.DBPass     = sqlca.dbpass
itr_trans.Logid      = sqlca.logid
itr_trans.LogPass    = sqlca.LogPass
itr_trans.Dbparm     = sqlca.DBParm 

connect using itr_trans;
	
if itr_trans.sqlcode <> 0 then	
	messagebox("Database Error","Could not attach to Database." + "~n~nMessage: " + itr_trans.sqlerrtext, stopsign!)
	lb_ret = false
end if

return lb_ret
end function

public subroutine wf_set_autocommit ();/********************************************************************
   wf_set_autocommit
   <DESC> Set autocommit for transaction</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_check_autocommit
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date     CR-Ref		Author		Comments
		07-03-17	CR4619		XSZ004		First Version
   </HISTORY>
********************************************************************/

boolean lb_autocommit

if dw_detail.rowcount() > 0 then
	lb_autocommit = (dw_detail.getitemnumber(1, "auto_commit") = 1)
end if	

itr_trans.autocommit = lb_autocommit
end subroutine

on w_public_report.create
this.dw_detail=create dw_detail
this.cb_retrieve=create cb_retrieve
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.dw_list=create dw_list
this.cb_new=create cb_new
this.mle_syntax=create mle_syntax
this.cb_generate=create cb_generate
this.dw_preview=create dw_preview
this.Control[]={this.dw_detail,&
this.cb_retrieve,&
this.cb_delete,&
this.cb_update,&
this.dw_list,&
this.cb_new,&
this.mle_syntax,&
this.cb_generate,&
this.dw_preview}
end on

on w_public_report.destroy
destroy(this.dw_detail)
destroy(this.cb_retrieve)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.dw_list)
destroy(this.cb_new)
destroy(this.mle_syntax)
destroy(this.cb_generate)
destroy(this.dw_preview)
end on

event open;if not wf_init_transaction() then 
	close(this)
	return 
end if

dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_list.retrieve()
end event

event closequery;this.setfocus()
if wf_checkmodified() = -1 then return 1
if isvalid(w_main) then w_main.bringtotop = true
end event

event close;disconnect using itr_trans;
destroy itr_trans
end event

type dw_detail from datawindow within w_public_report
integer x = 1061
integer y = 16
integer width = 3218
integer height = 448
integer taborder = 30
string title = "none"
string dataobject = "d_pubreport_detail"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_modified = true
end event

event itemchanged;ib_modified = true
end event

event itemfocuschanged;if this.getcolumnname() = 'cr_number' then
	this.selecttext(1, len(this.gettext()))
end if
end event

event dberror;message.stringparm = sqlerrtext
return 1
end event

type cb_retrieve from commandbutton within w_public_report
integer x = 4297
integer y = 352
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
end type

event clicked;boolean lb_autocommit

if not isvalid(dw_preview.object) then
	if wf_generate() < 0 then return
end if

wf_set_autocommit()

dw_preview.settransobject(itr_trans)
dw_preview.retrieve()
end event

type cb_delete from commandbutton within w_public_report
boolean visible = false
integer x = 4809
integer y = 144
integer width = 329
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;wf_delete()
end event

type cb_update from commandbutton within w_public_report
integer x = 4297
integer y = 128
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;wf_update()
end event

type dw_list from datawindow within w_public_report
event ue_key pbm_dwnkey
integer x = 18
integer y = 16
integer width = 1024
integer height = 2400
integer taborder = 40
string title = "none"
string dataobject = "d_pubreport_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;if key = KeyDelete! then
//	wf_delete()
end if
end event

event rowfocuschanged;integer li_report_id
blob lblb_report_syntax

if currentrow > 0 and currentrow <= this.rowcount() then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	
	li_report_id = this.getitemnumber(currentrow, "report_id")
	
	dw_detail.retrieve(li_report_id)
	
	selectblob REPORT_SYNTAX into :lblb_report_syntax
			from PUBLIC_REPORT
		  where REPORT_ID = :li_report_id;
	
	mle_syntax.text = string(lblb_report_syntax)
	
	dw_preview.dataobject = ''
	ib_modified = false
end if
end event

event rowfocuschanging;if wf_checkmodified() = -1 then return 1
end event

event clicked;string ls_sort_col, ls_sortexpr, ls_old_sortexpr, ls_sort_type = ' A'
boolean lb_muit_col_sort
long ll_positon

if this.getrow() = row then
	if wf_checkmodified() = -1 then return 1
	this.event rowfocuschanged(row)
end if

//Colunm header sort
if not isvalid(dwo) then return 0 
if dwo.name = 'datawindow' then return 0
if dwo.band <> "header" then return 0

lb_muit_col_sort = keydown(KeyControl!)

ls_sort_col = dwo.name
if right(ls_sort_col, 2) = '_t' then
	
	ls_sort_col = left(ls_sort_col, len(ls_sort_col) - 2)
	if this.describe(ls_sort_col + ".type") <> 'column' and this.describe(ls_sort_col + ".type") <> 'compute' then return 0
	
	//Get current sort definition
	ls_old_sortexpr = this.describe("datawindow.table.sort")
	if ls_old_sortexpr <> '!' and ls_old_sortexpr <> '?' then
		ll_positon = pos(ls_old_sortexpr, ls_sort_col)
		
		if ll_positon > 0 then
			if mid(ls_old_sortexpr, ll_positon + len(ls_sort_col), 2) = ' A' then ls_sort_type = ' D'
			
			if lb_muit_col_sort then
				//Clear the sort expression of clicked column
				if ll_positon = 1 then
					ls_old_sortexpr = replace(ls_old_sortexpr, ll_positon, len(ls_sort_col) + len(ls_sort_type), '')
				else
					ls_old_sortexpr = replace(ls_old_sortexpr, ll_positon - 1, len(ls_sort_col) + len(ls_sort_type) + 1, '')
				end if
			end if
		end if
		
		//If not Multi-column sorting then clear the old sort expression
		if not lb_muit_col_sort then
			ls_old_sortexpr = ''
		end if
	else
		ls_old_sortexpr = ''
	end if
	
	if len(ls_old_sortexpr) > 0 then ls_old_sortexpr += ','
	ls_sortexpr = ls_old_sortexpr + ls_sort_col + ls_sort_type
	
	this.setsort(ls_sortexpr)
	this.sort()
	return 1
end if
end event

event doubleclicked;wf_generate()
end event

type cb_new from commandbutton within w_public_report
integer x = 4297
integer y = 16
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;wf_new()
end event

type mle_syntax from multilineedit within w_public_report
event ue_key pbm_keyup
integer x = 1061
integer y = 480
integer width = 3566
integer height = 1120
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
end type

event ue_key;if key = keya! and keyflags = 2 then
	this.selecttext(1, len(this.text))
end if
end event

event modified;ib_modified = true
end event

type cb_generate from commandbutton within w_public_report
integer x = 4297
integer y = 240
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Generate"
end type

event clicked;wf_generate()
end event

type dw_preview from datawindow within w_public_report
integer x = 1061
integer y = 1616
integer width = 3566
integer height = 800
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
end if
end event

event constructor;this.setrowfocusindicator(FocusRect!)
end event

