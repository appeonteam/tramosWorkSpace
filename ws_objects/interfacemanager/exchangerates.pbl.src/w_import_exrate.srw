$PBExportHeader$w_import_exrate.srw
$PBExportComments$Import/Show Exchange rates used in TC Hire
forward
global type w_import_exrate from mt_w_sheet
end type
type dw_exrateuserselected from u_datagrid within w_import_exrate
end type
type dw_date from datawindow within w_import_exrate
end type
type cb_filter from commandbutton within w_import_exrate
end type
type rb_spec_date from radiobutton within w_import_exrate
end type
type rb_latest_date from radiobutton within w_import_exrate
end type
type dw_exrate from u_datagrid within w_import_exrate
end type
type cb_import from commandbutton within w_import_exrate
end type
type gb_filter from groupbox within w_import_exrate
end type
type st_1 from u_topbar_background within w_import_exrate
end type
end forward

global type w_import_exrate from mt_w_sheet
integer width = 1641
integer height = 2164
string title = "Import Exchange Rates"
boolean resizable = false
long backcolor = 32238571
string icon = "images\import_exchange _rates.ico"
event ue_postopen ( )
dw_exrateuserselected dw_exrateuserselected
dw_date dw_date
cb_filter cb_filter
rb_spec_date rb_spec_date
rb_latest_date rb_latest_date
dw_exrate dw_exrate
cb_import cb_import
gb_filter gb_filter
st_1 st_1
end type
global w_import_exrate w_import_exrate

type variables

Integer ii_Access=0
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_postopen();setPointer( hourglass! )
dw_exrate.retrieve()
setPointer( arrow! )

end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_import_exrate
	
	<OBJECT>
		Window for user to identify exrates in system and to force
		generation if file can be obtained.
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  	??/??/?? 	cr#????     RMO			First Version
  	13/07/12 	cr#2865     AGL027		added to MT framework
	  01/04/13	CR3172		AGL027		Moved into exchangerates library and refreshed the window. included new add to clipboard process
	01/09/14		CR3781		CCY018		The window title match with the text of a menu item
********************************************************************/
end subroutine

on w_import_exrate.create
int iCurrent
call super::create
this.dw_exrateuserselected=create dw_exrateuserselected
this.dw_date=create dw_date
this.cb_filter=create cb_filter
this.rb_spec_date=create rb_spec_date
this.rb_latest_date=create rb_latest_date
this.dw_exrate=create dw_exrate
this.cb_import=create cb_import
this.gb_filter=create gb_filter
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_exrateuserselected
this.Control[iCurrent+2]=this.dw_date
this.Control[iCurrent+3]=this.cb_filter
this.Control[iCurrent+4]=this.rb_spec_date
this.Control[iCurrent+5]=this.rb_latest_date
this.Control[iCurrent+6]=this.dw_exrate
this.Control[iCurrent+7]=this.cb_import
this.Control[iCurrent+8]=this.gb_filter
this.Control[iCurrent+9]=this.st_1
end on

on w_import_exrate.destroy
call super::destroy
destroy(this.dw_exrateuserselected)
destroy(this.dw_date)
destroy(this.cb_filter)
destroy(this.rb_spec_date)
destroy(this.rb_latest_date)
destroy(this.dw_exrate)
destroy(this.cb_import)
destroy(this.gb_filter)
destroy(this.st_1)
end on

event open;
n_service_manager  lnv_servicemanager 
n_dw_style_service	lnv_style
dw_exrate.settransobject(SQLCA)
dw_exrateuserselected.settransobject(SQLCA)
postevent("ue_postopen")

lnv_servicemanager.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_exrate, false)
lnv_style.of_dwlistformater(dw_exrateuserselected, false)

// If parm has been passed, then set access level
//If IsNumber(Message.DoubleParm) Then ii_Access = Integer(Message.StringParm)
//JMC112
 ii_Access = Integer(Message.DoubleParm)

end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_import_exrate
end type

type dw_exrateuserselected from u_datagrid within w_import_exrate
boolean visible = false
integer x = 37
integer y = 440
integer width = 1550
integer height = 1480
integer taborder = 20
string dataobject = "d_sq_tb_import_exrates"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if
end event

event doubleclicked;call super::doubleclicked;/* copy to clipboard the exchange rate user double clicks */
string ls_data
choose case dwo.name
case "exrate_dkk"
	ls_data = string(this.getitemdecimal(row, "exrate_dkk"))
	::Clipboard(ls_data)		
case "exrate_usd"
	ls_data = string(this.getitemdecimal(row, "exrate_usd"))
	::Clipboard(ls_data)	
end choose	

end event

type dw_date from datawindow within w_import_exrate
boolean visible = false
integer x = 1033
integer y = 204
integer width = 297
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_filter from commandbutton within w_import_exrate
boolean visible = false
integer x = 1339
integer y = 204
integer width = 169
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filter!"
boolean default = true
end type

event clicked;date ld_filter
datetime ldt_filter
n_service_manager  lnv_servicemanager 
n_dw_style_service	lnv_style

dw_date.accepttext()
ld_filter = dw_date.getitemdate(1,"date_value")
ldt_filter = datetime(ld_filter)
If IsNull(ldt_filter) then
	MessageBox("Date not provided", "Please provide a date (dd/mm/yyyy)!", exclamation!)
else
	dw_exrateuserselected.retrieve(ldt_filter)
//	dw_exrate.visible=false
//	dw_exrateuserselected.visible=true
end if
end event

type rb_spec_date from radiobutton within w_import_exrate
integer x = 105
integer y = 216
integer width = 805
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Specific Rate Date (dd/mm/yyyy):"
end type

event clicked;parent.dw_date.visible = true
parent.cb_filter.visible = true
dw_date.insertrow(0)
dw_date.setfocus()
dw_exrate.visible=false
dw_exrateuserselected.visible=true
end event

type rb_latest_date from radiobutton within w_import_exrate
integer x = 105
integer y = 120
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Latest Rate Date"
boolean checked = true
end type

event clicked;parent.dw_date.reset()
parent.dw_date.visible = false
parent.cb_filter.visible = false
dw_exrate.retrieve()
dw_exrate.visible=true
dw_exrateuserselected.visible=false
end event

type dw_exrate from u_datagrid within w_import_exrate
integer x = 37
integer y = 436
integer width = 1550
integer height = 1480
integer taborder = 10
string dataobject = "d_sq_gr_latestcurrencycodes"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if
end event

event doubleclicked;call super::doubleclicked;/* copy to clipboard the exchange rate user double clicks */
string ls_data
choose case dwo.name
case "exrate_dkk"
	ls_data = string(this.getitemdecimal(row, "exrate_dkk"))
	::Clipboard(ls_data)		
case "exrate_usd"
	ls_data = string(this.getitemdecimal(row, "exrate_usd"))
	::Clipboard(ls_data)	
end choose	
end event

type cb_import from commandbutton within w_import_exrate
integer x = 1275
integer y = 1952
integer width = 311
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import"
end type

event clicked;string docname, named, ls_error, ls_filepath, ls_errortext
integer value
mt_n_datastore lds_target, lds_source
// u_import_ex_rate luo_import
n_exchangerates 	lnv_exrate

if ii_Access<3 then
	messagebox("Info","Only Administrators can import exchange rates!")
	return
end if

value = GetFileOpenName("Select File", &
		+ ls_filepath, named, "DOC", &
		+ "Text Files (*.TXT),*.TXT," &
		+ "Doc Files (*.DOC),*.DOC")

if value = 1 then
	lnv_exrate = create n_exchangerates
	/* create source and target data */
	lds_source = create mt_n_datastore
	lds_source.dataobject = "d_sq_tb_currcodes"
	lds_source.settransobject(sqlca)
	lds_source.retrieve( ) 
	
	lds_target = create mt_n_datastore
	lds_target.dataobject = "d_sq_tb_import_exrates"
	lds_target.settransobject(sqlca)
	/* read file and prepare update */
	if lnv_exrate.of_readfile(lds_source, lds_target, ls_filepath, ls_errortext)=c#return.Success then
		if ls_errortext<>"" then
			_addmessage( this.classdefinition, "w_import_exrate.cb_import.clicked()", ls_errortext , "info message")
		end if		
		if lnv_exrate.of_update(lds_target) = c#return.Success then
			_addmessage( this.classdefinition, "w_import_exrate.cb_import.clicked()", "completed exchange rate processing for file " + ls_filepath , "info message")			
		else
			_addmessage( this.classdefinition, "w_import_exrate.cb_import.clicked()", "error, update failed for file " + ls_filepath , "info message")
		end if		
	else
		_addmessage( this.classdefinition, "w_import_exrate.cb_import.clicked()", ls_errortext , "error message")
	end if
	destroy lnv_exrate
end if

end event

type gb_filter from groupbox within w_import_exrate
integer x = 59
integer y = 28
integer width = 1504
integer height = 288
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 553648127
string text = "Filter"
end type

type st_1 from u_topbar_background within w_import_exrate
integer height = 376
end type

