$PBExportHeader$w_fileattach_converter.srw
forward
global type w_fileattach_converter from mt_w_sheet
end type
type cb_saveas from commandbutton within w_fileattach_converter
end type
type cb_findorphans from commandbutton within w_fileattach_converter
end type
type cbx_ole from checkbox within w_fileattach_converter
end type
type cb_open from commandbutton within w_fileattach_converter
end type
type cb_2 from commandbutton within w_fileattach_converter
end type
type st_4 from statictext within w_fileattach_converter
end type
type sle_temp from singlelineedit within w_fileattach_converter
end type
type cb_1 from commandbutton within w_fileattach_converter
end type
type st_1 from statictext within w_fileattach_converter
end type
type sle_1 from singlelineedit within w_fileattach_converter
end type
type uo_att from u_fileattach within w_fileattach_converter
end type
end forward

global type w_fileattach_converter from mt_w_sheet
integer width = 3163
integer height = 3164
string title = "File Attachment Control"
long backcolor = 32304364
cb_saveas cb_saveas
cb_findorphans cb_findorphans
cbx_ole cbx_ole
cb_open cb_open
cb_2 cb_2
st_4 st_4
sle_temp sle_temp
cb_1 cb_1
st_1 st_1
sle_1 sle_1
uo_att uo_att
end type
global w_fileattach_converter w_fileattach_converter

type variables
private string _is_filesatt_tablename
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_retreive ()
end prototypes

public subroutine documentation ();/********************************************************************
ObjectName: w_fileattach_converter

<OBJECT> 
	Hidden window object used to convert and manage attachments.
	Currently the main function is to convert attachments saved in olecontrol to direct binary data.
</OBJECT>
<DESC>
</DESC>
<USAGE>
	Accessed by double clicking on the u_fileattach`st_attachmentcounter object 5 times.
	Allows advanced user access to whole attachment table.
	Can also locate temporary folder designated to store files.
</USAGE>
<ALSO>
	u_fileattach				: property ib_convert_process true, determines functionality here
	n_fileattach_service	: specifically the of_convertblob() function
	
	Improvements may include:- 
		highlight which records are orphaned (no linked blob data in files database)
		a designated button to convert and another to open
		
</ALSO>
    Date   Ref    Author        Comments
  27/10/10 CR2171     AGL027     First Version
********************************************************************/

end subroutine

public function integer wf_retreive ();return 1
end function

on w_fileattach_converter.create
int iCurrent
call super::create
this.cb_saveas=create cb_saveas
this.cb_findorphans=create cb_findorphans
this.cbx_ole=create cbx_ole
this.cb_open=create cb_open
this.cb_2=create cb_2
this.st_4=create st_4
this.sle_temp=create sle_temp
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_1=create sle_1
this.uo_att=create uo_att
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saveas
this.Control[iCurrent+2]=this.cb_findorphans
this.Control[iCurrent+3]=this.cbx_ole
this.Control[iCurrent+4]=this.cb_open
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_temp
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_1
this.Control[iCurrent+11]=this.uo_att
end on

on w_fileattach_converter.destroy
call super::destroy
destroy(this.cb_saveas)
destroy(this.cb_findorphans)
destroy(this.cbx_ole)
destroy(this.cb_open)
destroy(this.cb_2)
destroy(this.st_4)
destroy(this.sle_temp)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.uo_att)
end on

event open;call super::open;/* st_3.text = "3 methods converting files saved through the ole control, determined by the extension/type~r~n~r~n" + &
"1. Microsoft Applications Excel, Powerpoint, Access, Word (all versions)~r~n" + &	
"Close olecontainer and click Close here afterwards.  The process will update the file in the db.~r~n~r~n" + &
"2. Outlook 2003~r~n" + &
"You must manually 'Save As' within Outlook's olecontainer. Select type 'standard Outlook Mesasge *.msg'.   Paste the path & filename from clipboard. Close the outlook message olecontainer and click Close here.  File will then be converted and saved to db.~r~n~r~n" + &
"3. All other file types including pdf, bmp, jpg, png etc.~r~n" + &
"Manually 'Save As' determined by olecontainer that opened your attachment.  Paste file and path from clipboard. Close olecontainer and click Close here too.  File will be converted and saved back into the db."
*/



	
end event

type cb_saveas from commandbutton within w_fileattach_converter
integer x = 1765
integer y = 20
integer width = 389
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Save As"
end type

event clicked;

uo_att.dw_file_listing.saveas("",EXCEL5!, true)

end event

type cb_findorphans from commandbutton within w_fileattach_converter
integer x = 2158
integer y = 20
integer width = 389
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select Orphans"
end type

event clicked;

long ll_row, ll_number_of_rows
n_service_manager lnv_servicemgr
n_fileattach_service lnv_attservice

/* TODO: try and highlight rows where there are no file_id */

ll_number_of_rows = uo_att.dw_file_listing.rowcount( )
_is_filesatt_tablename = uo_att.dw_file_listing.Object.DataWindow.Table.UpdateTable + "_FILES"

lnv_servicemgr.of_loadservice( lnv_attservice, "n_fileattach_service")		
lnv_attservice.of_activate()
for ll_row = 1 to ll_number_of_rows
	if lnv_attservice.of_validatefileid(_is_filesatt_tablename, uo_att.dw_file_listing.getitemnumber(ll_row,"file_id")) = c#return.Failure then
		/* we need to highlight in the datawindow this row!!!! */
		if uo_att.dw_file_listing.Describe("redflag.type") = "!" then
			_addmessage( this.classdefinition, "cb_findorphans.clicked()", "not possible!", "no column named redflag in dataobject.  Can not highlight Orphans in this case!")
		else 
			uo_att.dw_file_listing.setitem(ll_row,"redflag",1)
		end if 
	end if	
next	
lnv_attservice.of_deactivate()


end event

type cbx_ole from checkbox within w_fileattach_converter
integer x = 2917
integer y = 24
integer width = 197
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
string text = "ole "
end type

type cb_open from commandbutton within w_fileattach_converter
integer x = 2546
integer y = 20
integer width = 361
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Open Selected"
end type

event clicked;long ll_row
boolean lb_ole, lb_convert_process

ll_row = uo_att.dw_file_listing.getrow()
if ll_row>0 then
	/* save old values */
	lb_ole = uo_att.ib_ole
	lb_convert_process = uo_att.ib_convert_process
	/* load temporary values */
	uo_att.ib_ole = cbx_ole.checked
	uo_att.ib_convert_process = false
	/* open the attachment */
	messagebox("file id #" + string(ll_row), "opening file - ole=" + string(uo_att.ib_ole) )
	uo_att.of_openattachment(ll_row)
	/* set back again */	
	uo_att.ib_ole = lb_ole
	uo_att.ib_convert_process = lb_convert_process
end if
end event

type cb_2 from commandbutton within w_fileattach_converter
integer x = 2638
integer y = 2908
integer width = 457
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Purge Temp Folder"
end type

event clicked;uo_att.lbx_tempfiles.visible = true
uo_att.lbx_tempfiles.height = uo_att.dw_file_listing.height - 100

if uo_att.of_purgetempfiles( ) = c#return.Success then
	// do nothing
end if



end event

type st_4 from statictext within w_fileattach_converter
integer x = 37
integer y = 2900
integer width = 443
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Temp folder for file attachments:"
boolean focusrectangle = false
end type

type sle_temp from singlelineedit within w_fileattach_converter
integer x = 512
integer y = 2908
integer width = 1870
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_fileattach_converter
integer x = 2642
integer y = 2808
integer width = 453
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;

string ls_tempfolder
mt_n_datastore lds_dummy

uo_att.visible = true
uo_att.lbx_tempfiles.visible = false

lds_dummy = create mt_n_datastore
lds_dummy.settransobject( sqlca )
lds_dummy.dataobject = sle_1.text

if  not isvalid(lds_dummy.object) then
	_addmessage( this.classdefinition, "cb_1.clicked()", "can not locate the source data!", "no dataobject exists for this implementation of u_fileattach")
	cbx_ole.enabled = false
	cb_saveas.enabled = false
	cb_open.enabled = false
	cb_findorphans.enabled = false
else
	cbx_ole.enabled = true
	cb_saveas.enabled = true
	cb_open.enabled = true
	cb_findorphans.enabled = true
	uo_att.is_dataobjectname = sle_1.text
	destroy lds_dummy
	uo_att.of_setresizablecolumns( true)
	uo_att.of_init()
end if
uo_att.of_gettempfoldername(sle_temp.text)


end event

type st_1 from statictext within w_fileattach_converter
integer x = 41
integer y = 2816
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "DataObject:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fileattach_converter
integer x = 512
integer y = 2804
integer width = 1870
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "d_sq_tb_creq_file_listing_converter"
borderstyle borderstyle = stylelowered!
end type

type uo_att from u_fileattach within w_fileattach_converter
boolean visible = false
integer x = 37
integer y = 128
integer width = 3031
integer height = 2648
integer taborder = 20
boolean ib_enable_update_button = true
boolean ib_convert_process = true
end type

on uo_att.destroy
call u_fileattach::destroy
end on

