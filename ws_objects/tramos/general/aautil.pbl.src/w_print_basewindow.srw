$PBExportHeader$w_print_basewindow.srw
$PBExportComments$Standard print & preview window
forward
global type w_print_basewindow from mt_w_response
end type
type cbx_save_size from checkbox within w_print_basewindow
end type
type dw_print from uo_datawindow within w_print_basewindow
end type
type cb_fullpreview from commandbutton within w_print_basewindow
end type
type st_previewtext from statictext within w_print_basewindow
end type
type em_zoom from editmask within w_print_basewindow
end type
type cb_pageforward10 from commandbutton within w_print_basewindow
end type
type cb_pageforward from commandbutton within w_print_basewindow
end type
type cb_pageback from commandbutton within w_print_basewindow
end type
type cb_pageback10 from commandbutton within w_print_basewindow
end type
type st_percent from statictext within w_print_basewindow
end type
type st_1 from statictext within w_print_basewindow
end type
type st_misc_print_file from statictext within w_print_basewindow
end type
type cbx_misc_print_to_file from checkbox within w_print_basewindow
end type
type cbx_misc_collate_copies from checkbox within w_print_basewindow
end type
type sle_misc_print_file from singlelineedit within w_print_basewindow
end type
type cb_misc_file from commandbutton within w_print_basewindow
end type
type rb_range_pages from radiobutton within w_print_basewindow
end type
type rb_range_current from radiobutton within w_print_basewindow
end type
type rb_range_all from radiobutton within w_print_basewindow
end type
type cb_select_filecollate from commandbutton within w_print_basewindow
end type
type cb_select_pages from commandbutton within w_print_basewindow
end type
type cb_select_options from commandbutton within w_print_basewindow
end type
type st_range from statictext within w_print_basewindow
end type
type sle_range_range from singlelineedit within w_print_basewindow
end type
type cb_options_printer from commandbutton within w_print_basewindow
end type
type sle_options_no_copies from singlelineedit within w_print_basewindow
end type
type st_options_text from statictext within w_print_basewindow
end type
type st_options_2 from statictext within w_print_basewindow
end type
type st_optins_1 from statictext within w_print_basewindow
end type
type cb_cancel from commandbutton within w_print_basewindow
end type
type cb_print from commandbutton within w_print_basewindow
end type
type gb_misc_print from groupbox within w_print_basewindow
end type
type gb_range from groupbox within w_print_basewindow
end type
type gb_options from groupbox within w_print_basewindow
end type
type cb_saveas from commandbutton within w_print_basewindow
end type
end forward

global type w_print_basewindow from mt_w_response
integer width = 4567
integer height = 2284
string title = "Print "
long backcolor = 81324524
event ue_preprint pbm_custom03
event ue_printdefault pbm_custom51
cbx_save_size cbx_save_size
dw_print dw_print
cb_fullpreview cb_fullpreview
st_previewtext st_previewtext
em_zoom em_zoom
cb_pageforward10 cb_pageforward10
cb_pageforward cb_pageforward
cb_pageback cb_pageback
cb_pageback10 cb_pageback10
st_percent st_percent
st_1 st_1
st_misc_print_file st_misc_print_file
cbx_misc_print_to_file cbx_misc_print_to_file
cbx_misc_collate_copies cbx_misc_collate_copies
sle_misc_print_file sle_misc_print_file
cb_misc_file cb_misc_file
rb_range_pages rb_range_pages
rb_range_current rb_range_current
rb_range_all rb_range_all
cb_select_filecollate cb_select_filecollate
cb_select_pages cb_select_pages
cb_select_options cb_select_options
st_range st_range
sle_range_range sle_range_range
cb_options_printer cb_options_printer
sle_options_no_copies sle_options_no_copies
st_options_text st_options_text
st_options_2 st_options_2
st_optins_1 st_optins_1
cb_cancel cb_cancel
cb_print cb_print
gb_misc_print gb_misc_print
gb_range gb_range
gb_options gb_options
cb_saveas cb_saveas
end type
global w_print_basewindow w_print_basewindow

type variables
Boolean ib_autoretrieve = false
Boolean ib_cancelprint
Long il_pagecount, il_curpage, il_x, il_y
Integer ii_mouseinside = -1
Integer ii_print_x,ii_print_width,ii_old_select
integer ii_old_func_select = 1
string is_print_init // printer setup
Boolean ib_timerpreview = false
Boolean ib_large
string is_hidelist[]
Integer ii_startup = 0 // 0 = setupl, 1 = small , 2 = large
Boolean ib_autoretrievePreview = true
Boolean ib_autoclose = false
Integer ii_startzoom = 90 
Boolean ib_first = True
String is_nohide = ""

integer ii_subpagecount
end variables

forward prototypes
public subroutine optionsselect (integer pi_select)
public subroutine setpagebuttons (integer pl_scroll)
public subroutine mousemove ()
public subroutine zoompreview (integer pl_zoom)
public subroutine showcontrols (boolean show)
public subroutine disableedit (ref singlelineedit acontrol)
public subroutine enableedit (ref singlelineedit acontrol)
public function integer mouseposition (boolean aisx)
public subroutine documentation ()
end prototypes

on ue_preprint;// the ue_preprint does nothing. It's only issued so that descendants can take control before printout
end on

on ue_printdefault;cb_print.Default = True
cb_select_pages.Default = False
cb_print.SetFocus()
end on

public subroutine optionsselect (integer pi_select);// Optionsselect controls the four top-buttons:  Options/Pages/File-Collate/Large(small)

Integer li_Count,ll_tmp
Boolean lb_visible,redrawOff

redrawoff = (ii_old_Select=4) Or (pi_select=4)
if redrawOff then redraw_off(this)

If ii_old_select = 4 Then 

	ib_large = false
	cb_fullpreview.text = "L&arge"	
	
	dw_print.width = ii_print_width
	dw_print.x = ii_print_x
	showcontrols(true)

	if pi_select = 4 then pi_select = ii_old_func_select
	
	if pi_select = 4 then pi_select = 5
end if

FOR li_count=1 TO 4
   
        lb_visible = (li_count = pi_select)      

        CHOOSE CASE li_Count 

	CASE 1
             cb_select_options.enabled = not lb_visible
             gb_options.visible = lb_visible
             st_optins_1.visible = lb_visible
             st_options_2.visible = lb_visible
             st_options_text.visible = lb_visible
             cb_options_printer.visible = lb_visible
             sle_options_no_copies.visible = lb_visible

        CASE 2
             cb_select_pages.enabled = not lb_visible
             gb_range.visible = lb_visible
             rb_range_all.visible = lb_visible
             rb_range_current.visible = lb_visible
             rb_range_pages.visible = lb_visible
             st_range.visible = lb_visible
             sle_range_range.visible = lb_visible

       CASE 3
             cb_select_filecollate.enabled = not lb_visible
             gb_misc_print.visible = lb_visible
             cb_misc_file.visible = lb_visible
             cbx_misc_collate_copies.visible = lb_visible
             cbx_misc_print_to_file.visible = lb_visible
             sle_misc_print_file.visible = lb_visible
             st_misc_print_file.visible = lb_visible
       CASE 4
	     if (pi_select=4) then
		     ib_large = true	
		     showcontrols(false)
	
		     cb_fullpreview.text = "S&mall"
		     ll_tmp = dw_print.x - gb_options.x	
	             dw_print.x=gb_options.x
        	     dw_print.width += ll_tmp
	     end if 	
       END CHOOSE

NEXT

ii_old_select = pi_select
if pi_select <> 4 then ii_old_func_select = pi_select

if redrawOff then redraw_on(this)


end subroutine

public subroutine setpagebuttons (integer pl_scroll);// This routine controls the page-buttons  <<   <   >   >>   ( 10 right, 1 right, 1 left, 10 left )
// AND scroll between the pages parameter -1 equals scroll 1 page back, +1 scroll 1 page forward etc.

if pl_scroll = 0 then
	il_curpage = long(dw_print.describe("evaluate('pageabs()', " + dw_print.object.datawindow.firstrowonpage + ")"))
else
	pl_scroll *= ii_subpagecount

	do while (pl_scroll > 0) and (il_curpage < il_pagecount or (il_curpage = il_pagecount and mod(pl_scroll, ii_subpagecount) <> 0))
		pl_scroll --
		dw_print.scrollnextpage()
		il_curpage = long(dw_print.describe("evaluate('pageabs()', " + dw_print.object.datawindow.firstrowonpage + ")"))
	loop
	
	do while (pl_scroll < 0) and (il_curpage > 1 or (il_curpage = 1 and mod(pl_scroll, ii_subpagecount) <> 0))
		pl_scroll ++
		dw_print.scrollpriorpage()
		il_curpage = long(dw_print.describe("evaluate('pageabs()', " + dw_print.object.datawindow.firstrowonpage + ")"))
	loop
end if

cb_pageback10.enabled = il_curpage > 1
cb_pageback.enabled = cb_pageback10.enabled
cb_pageforward.enabled = il_curpage < il_pagecount
cb_pageforward10.enabled = cb_pageforward.enabled

st_previewtext.text="page "+string(il_curpage)+ " of "+string(il_pagecount)
dw_print.setfocus()

end subroutine

public subroutine mousemove ();// This routine detects if the cursor is inside the print-preview, and shows either a magnify-cursor or 
// normal arrow cursor

Integer li_mouseinside

il_x=pointerx()
il_y=pointery()

If  (pointerx() >= dw_print.x) and (Pointerx() <= dw_print.x+dw_print.width) And &
    (pointery() >= dw_print.y) and (pointery() <= dw_print.y+dw_print.height) Then
	li_mouseinside = 1 
else
	li_mouseinside = 0
End if

if (li_mouseinside<>ii_mouseinside) then
	ii_mouseinside = li_mouseinside	
	
	If ii_mouseinside = 1 then
		dw_print.modify("datawindow.pointer='images\MAGNIFY.CUR'")
	else
		 dw_print.modify("datawindow.pointer='Arrow!'")
     	end if
end if



end subroutine

public subroutine zoompreview (integer pl_zoom);// Routine to select preview size

long ll_zoomvalue, ll_newvalue

ll_zoomvalue = integer(dw_print.describe("datawindow.print.preview.zoom"))

ll_newvalue = ll_zoomvalue + pl_zoom

If (ll_newvalue < 10) or (ll_newvalue > 200) Then
	beep(5)
else 
	dw_print.modify("datawindow.print.preview.zoom = " + string(ll_newvalue))
	em_zoom.text = string(ll_newvalue)
end if
end subroutine

public subroutine showcontrols (boolean show);// This rutine hides all controls that isnt to be shown, when the print-preview is large. 
//
// It works like this (belive it or not):
//
// All objects in the window is retrieved, and all objects that isnt in the "positivstring" (below) will
// be hided. At the same time, the windowname is stored in the is_hidelist.
// When the objects are about to be shown, the is_hidelist is traversed to times. First time the
// groupboxes will be shown, and second time all other objects.
// This prevents that some of the objects can/will be under the groupbox.

Integer li_count,li_groupcount

FOR li_groupcount = 1 To 2 
FOR li_count = 1 TO UpperBound(control[])

	If ((li_groupcount = 1 ) And (control[li_count].typeof()=groupbox!)) Or &
	   ((li_groupcount = 2 ) And (control[li_count].typeof() <> groupbox! ) ) Then 	

	If not show then

		If Pos("cb_cancelcb_fullpreviewcb_misc_filecb_options_printercb_pagebackcb_pageback10"+ &
       		          "cb_pageforwardcb_pageforward10cb_printcb_saveascb_select_filecollatecb_select_options" + &
               		  "cb_select_pagesem_zoomdw_printst_1st2st_previewtextcbx_save_size" + &
			  "st_percent"+is_nohide, control[li_count].classname() ) = 0 and control[li_count].visible then	
	       			
			 is_hidelist[li_count] = control[li_count].Classname()
			 control[li_count].visible = false
        	else
			is_hidelist[li_count] = ""
		end if
	else

		if is_hidelist[li_count] <> ""  then
			control[li_count].visible = true
			is_hidelist[li_count] = ""
		end if

	end if

	end if
NEXT
Next

if show then li_count = 0


end subroutine

public subroutine disableedit (ref singlelineedit acontrol);// This function sets the passed edit to disabled (and disabled color)

acontrol.backcolor = RGB ( 255, 255, 255 )
acontrol.enabled = False
end subroutine

public subroutine enableedit (ref singlelineedit acontrol);// This function sets the passed edit to enabled (and enabled color)


acontrol.enabled = true
acontrol.backColor = RGB ( 0, 255, 255 )
end subroutine

public function integer mouseposition (boolean aisx);// Not used p.t. To be used then PowerBuilder fixes the VerticalPositionScroll problem

Long ll_mousepos,ll_size,ll_pos,ll_windowsize
String ls_describetext

If aisx then
	ll_mousepos = pointerx() - dw_print.x
	ls_describetext = "horizontal"
	ll_windowsize = dw_print.width
Else
	ll_mousepos = pointery() - dw_print.y
	ls_describetext = "vertical"
	ll_windowsize = dw_print.height
end if
	
ll_size = integer(dw_print.describe("datawindow."+ls_describetext+"scrollmaximum"))
If ll_size = 0 Then ll_size = ll_windowsize

ll_pos =  integer(dw_print.describe("datawindow."+ls_describetext+"scrollposition"))

If ll_pos = 0 Then 
	ll_pos = ll_mousepos
Else 
	ll_pos = ll_pos + (ll_mousepos - ll_windowsize)
End if

Return((ll_pos*100) / ll_size)
end function

public subroutine documentation ();/********************************************************************
   w_print_basewindow
	
	<OBJECT>

	</OBJECT>
  	<DESC>
		
	</DESC>
  	<USAGE>
		used in infomaker reporting & disbursement reporting.
	</USAGE>
  	<ALSO>
		also referenced in sales and inside 2009 decommissioned tc hire module.
	</ALSO>
		Date    		Ref   	Author		Comments
		05/08/14		CR3708	AGL027		F1 help application coverage - corrected ancestor
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
		10/12/14    CR3727   LHG008      Fix bug for print only the current page showing in the preview pane.
********************************************************************/
end subroutine

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_print_basewindow
  
 Object     : 
  
 Event	 :  Open

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen & Peter Bendix-Toft
   
 Date       : 18-10-95

 Description : To use this w_print_basewindow, inherit it, and change dw_print to the datawindow
                       that is to be printed. If ib_autoretrieve is true (default false), w_print_basewindow will automaticly
			 retrieve() from dw_print in the activate event.

 Arguments : None

 Returns   : None

  Variables : ii_startup. Can be 0 (default) = remember_size enabled, resizable, reads system preview size.
                                                 1 small size = remember size disabled
                                                 2 large size = remember size disabled
                    ii_startup should be set in the inherited open event

                    ib_autoretrieve. If set to true, data will automaticly be retrieved in the preview datawindow
	                                        after the open event.

		    ib_autoretrievepreview. If set to true (default),  data will automaticly be print-previewed after
	                                                     each retrieve

                    ii_startzoom. Specifies initial zoom percent. Default is 75 %

	            ii_autoclose. If set to true (default false), the printwindow will automaticly close after printout.

 Other : Under normal circumstances nothing is to be done about the printbutton. But if processing is required before
             the actual printout, this can be done in the ue_preprint event. The ue_preprint event can also stop
             further print-processing by setting ib_cancelprint to true. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
23-11-95		2.0 			MI 		Now with scalable preview windows size.
28-11-95		2.1			MI		Now with ib_autoretrievepreview
08-12-95		2.1			MI		Some comments added
  
************************************************************************************/

// Set SQLCA and remember dw_print's position and size
dw_print.SetTransObject(SQLCA)

ii_print_x = dw_print.x
ii_print_width = dw_print.width

This.PostEvent("ue_printdefault")
		     
f_center_window(this)
end event

on closequery;// Display messagebox if trying to close the window while printing

If Not cb_cancel.enabled then
	MessageBox("Error", "You cannot close this window while printing")
	Message.ReturnValue = 1
end if
end on

event activate;If ib_First Then

	// Things to do before the window is show for the first time. The functions is put in activate, so that decendants
        // can initialize all used variables inside the open-event. e.g. ii_startzoom

	If ib_Autoretrieve Then
  
		dw_print.SetTransObject(SQLCA)
 		dw_print.retrieve ( )
   	
	End if

	dw_print.Modify("DataWindow.Print.Preview.Zoom = "+String(ii_startzoom))
	dw_print.Modify("DataWindow.Print.Preview = Yes")

	em_zoom.text = string(ii_startzoom)

	ib_First = False

	// Select small or large size, according to ii_startup and/or size from .INI file

	If ii_startup <> 0 then 
		cbx_save_size.enabled = false
	end if

	if (ii_startup = 2) Then

	Long ll_tmp

		cb_select_options.enabled = true
		showcontrols(false)

		ib_large = true	
		cb_fullpreview.text = "S&mall"
		ll_tmp = dw_print.x - gb_options.x	
		dw_print.x=gb_options.x
		dw_print.width += ll_tmp

		ii_old_select = 4
		ii_old_func_Select = 1
	end if

	cbx_save_size.checked = false
End if
end event

event close;Long ll_set = 0

// If save_size enabled then remember preview size in uo_global file

if cbx_save_size.enabled then

	If (cbx_save_size.checked)  then
		If ib_large then ll_set = 2 else ll_set = 1
	End if
	
end if

end event

event timer;// Timercontrol for preview. Due to PowerBuilders slow preview update, retrieves should been done in an 
// timer event, so that the user can select whats needed, before the retrieve actual takes place.

If ib_timerpreview Then
	Timer(0)
	dw_print.Modify("DataWindow.Print.Preview.Zoom = "+em_zoom.Text)
	ib_timerpreview = false
	
	em_zoom.selecttext(1, len(em_zoom.text))
End if

end event

on mousemove;// Mouse has been moved, call MouseMove()

mousemove()
end on

on w_print_basewindow.create
int iCurrent
call super::create
this.cbx_save_size=create cbx_save_size
this.dw_print=create dw_print
this.cb_fullpreview=create cb_fullpreview
this.st_previewtext=create st_previewtext
this.em_zoom=create em_zoom
this.cb_pageforward10=create cb_pageforward10
this.cb_pageforward=create cb_pageforward
this.cb_pageback=create cb_pageback
this.cb_pageback10=create cb_pageback10
this.st_percent=create st_percent
this.st_1=create st_1
this.st_misc_print_file=create st_misc_print_file
this.cbx_misc_print_to_file=create cbx_misc_print_to_file
this.cbx_misc_collate_copies=create cbx_misc_collate_copies
this.sle_misc_print_file=create sle_misc_print_file
this.cb_misc_file=create cb_misc_file
this.rb_range_pages=create rb_range_pages
this.rb_range_current=create rb_range_current
this.rb_range_all=create rb_range_all
this.cb_select_filecollate=create cb_select_filecollate
this.cb_select_pages=create cb_select_pages
this.cb_select_options=create cb_select_options
this.st_range=create st_range
this.sle_range_range=create sle_range_range
this.cb_options_printer=create cb_options_printer
this.sle_options_no_copies=create sle_options_no_copies
this.st_options_text=create st_options_text
this.st_options_2=create st_options_2
this.st_optins_1=create st_optins_1
this.cb_cancel=create cb_cancel
this.cb_print=create cb_print
this.gb_misc_print=create gb_misc_print
this.gb_range=create gb_range
this.gb_options=create gb_options
this.cb_saveas=create cb_saveas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_save_size
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.cb_fullpreview
this.Control[iCurrent+4]=this.st_previewtext
this.Control[iCurrent+5]=this.em_zoom
this.Control[iCurrent+6]=this.cb_pageforward10
this.Control[iCurrent+7]=this.cb_pageforward
this.Control[iCurrent+8]=this.cb_pageback
this.Control[iCurrent+9]=this.cb_pageback10
this.Control[iCurrent+10]=this.st_percent
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.st_misc_print_file
this.Control[iCurrent+13]=this.cbx_misc_print_to_file
this.Control[iCurrent+14]=this.cbx_misc_collate_copies
this.Control[iCurrent+15]=this.sle_misc_print_file
this.Control[iCurrent+16]=this.cb_misc_file
this.Control[iCurrent+17]=this.rb_range_pages
this.Control[iCurrent+18]=this.rb_range_current
this.Control[iCurrent+19]=this.rb_range_all
this.Control[iCurrent+20]=this.cb_select_filecollate
this.Control[iCurrent+21]=this.cb_select_pages
this.Control[iCurrent+22]=this.cb_select_options
this.Control[iCurrent+23]=this.st_range
this.Control[iCurrent+24]=this.sle_range_range
this.Control[iCurrent+25]=this.cb_options_printer
this.Control[iCurrent+26]=this.sle_options_no_copies
this.Control[iCurrent+27]=this.st_options_text
this.Control[iCurrent+28]=this.st_options_2
this.Control[iCurrent+29]=this.st_optins_1
this.Control[iCurrent+30]=this.cb_cancel
this.Control[iCurrent+31]=this.cb_print
this.Control[iCurrent+32]=this.gb_misc_print
this.Control[iCurrent+33]=this.gb_range
this.Control[iCurrent+34]=this.gb_options
this.Control[iCurrent+35]=this.cb_saveas
end on

on w_print_basewindow.destroy
call super::destroy
destroy(this.cbx_save_size)
destroy(this.dw_print)
destroy(this.cb_fullpreview)
destroy(this.st_previewtext)
destroy(this.em_zoom)
destroy(this.cb_pageforward10)
destroy(this.cb_pageforward)
destroy(this.cb_pageback)
destroy(this.cb_pageback10)
destroy(this.st_percent)
destroy(this.st_1)
destroy(this.st_misc_print_file)
destroy(this.cbx_misc_print_to_file)
destroy(this.cbx_misc_collate_copies)
destroy(this.sle_misc_print_file)
destroy(this.cb_misc_file)
destroy(this.rb_range_pages)
destroy(this.rb_range_current)
destroy(this.rb_range_all)
destroy(this.cb_select_filecollate)
destroy(this.cb_select_pages)
destroy(this.cb_select_options)
destroy(this.st_range)
destroy(this.sle_range_range)
destroy(this.cb_options_printer)
destroy(this.sle_options_no_copies)
destroy(this.st_options_text)
destroy(this.st_options_2)
destroy(this.st_optins_1)
destroy(this.cb_cancel)
destroy(this.cb_print)
destroy(this.gb_misc_print)
destroy(this.gb_range)
destroy(this.gb_options)
destroy(this.cb_saveas)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_basewindow
end type

type cbx_save_size from checkbox within w_print_basewindow
integer x = 2139
integer y = 2084
integer width = 713
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Remember preview size"
end type

type dw_print from uo_datawindow within w_print_basewindow
event ue_mousemove pbm_mousemove
event ue_dwnkey pbm_dwnkey
integer x = 1152
integer y = 176
integer width = 3369
integer height = 1872
integer taborder = 190
string dataobject = "dw_1"
boolean hscrollbar = true
boolean vscrollbar = true
string icon = "None!"
borderstyle borderstyle = stylelowered!
end type

on ue_mousemove;call uo_datawindow::ue_mousemove;// Mousemove call Mousemove()

mousemove()
end on

event ue_dwnkey;if key = KeyPageUp! or key = KeyPageDown! then
	post setpagebuttons(0)
end if
end event

event retrieveend;call super::retrieveend;// dw_print.retrieveend, set to preview if ib_autoretrievepreview and update buttons etc.

if ib_autoretrievepreview then
	dw_print.modify("datawindow.print.preview.zoom = "+em_zoom.text)
	dw_print.modify("datawindow.print.preview = yes")
end if

ii_subpagecount = long(dw_print.describe("evaluate('pagecountacross()', 1)"))
il_pagecount = long(dw_print.describe("evaluate('pageabs()', " + string(dw_print.rowcount()) + ")"))

scrolltorow(1)
setpagebuttons(0)

this.setfocus()
end event

on clicked;call uo_datawindow::clicked;// dw_print.clicked, zoom preview

zoompreview(15)

end on

on rbuttondown;call uo_datawindow::rbuttondown;// dw_print.rightclicked, zoom preview

zoompreview(-15)

end on

event scrollvertical;call super::scrollvertical;setpagebuttons(0)
end event

type cb_fullpreview from commandbutton within w_print_basewindow
integer x = 1426
integer y = 64
integer width = 329
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "L&arge"
end type

on clicked;Optionsselect(4)
end on

type st_previewtext from statictext within w_print_basewindow
integer x = 1152
integer y = 2084
integer width = 951
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type em_zoom from editmask within w_print_basewindow
event ue_zoomchanged pbm_enchange
integer x = 2542
integer y = 56
integer width = 238
integer height = 96
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "30"
string mask = "###"
boolean spin = true
string displaydata = "30~t30/65~t65/100~t100/200~t200/"
double increment = 1
string minmax = "1~~200"
boolean usecodetable = true
end type

on ue_zoomchanged;ib_timerpreview = true
Timer(1.0)


end on

type cb_pageforward10 from commandbutton within w_print_basewindow
integer x = 2194
integer y = 64
integer width = 128
integer height = 80
integer taborder = 180
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = ">>"
end type

on clicked;SetPageButtons(10)
end on

type cb_pageforward from commandbutton within w_print_basewindow
integer x = 2066
integer y = 64
integer width = 128
integer height = 80
integer taborder = 170
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = ">"
end type

on clicked;SetPageButtons(1)
end on

type cb_pageback from commandbutton within w_print_basewindow
integer x = 1920
integer y = 64
integer width = 128
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "<"
end type

on clicked;SetPageButtons(-1)

end on

type cb_pageback10 from commandbutton within w_print_basewindow
integer x = 1792
integer y = 64
integer width = 128
integer height = 80
integer taborder = 150
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "<<"
end type

on clicked;
SetPageButtons(-10)
end on

type st_percent from statictext within w_print_basewindow
integer x = 2798
integer y = 72
integer width = 59
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "%"
boolean focusrectangle = false
end type

type st_1 from statictext within w_print_basewindow
integer x = 2359
integer y = 72
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Zoom:"
boolean focusrectangle = false
end type

type st_misc_print_file from statictext within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 480
integer width = 238
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Print file:"
boolean focusrectangle = false
end type

type cbx_misc_print_to_file from checkbox within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 272
integer width = 421
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Print to &file"
end type

on clicked;If checked then 
   enableedit (sle_misc_print_file )
   cb_misc_file.enabled = true
Else
   disableedit ( sle_misc_print_file )
   cb_misc_file.enabled = false
End if
end on

type cbx_misc_collate_copies from checkbox within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 368
integer width = 503
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Collate Cop&ies"
boolean checked = true
end type

type sle_misc_print_file from singlelineedit within w_print_basewindow
boolean visible = false
integer x = 293
integer y = 464
integer width = 786
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
end type

type cb_misc_file from commandbutton within w_print_basewindow
boolean visible = false
integer x = 823
integer y = 576
integer width = 256
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Fi&le"
end type

event clicked;
string ls_tmp, ls_file

If  GetFileSaveName("Print To File", ls_file, ls_tmp, "PRN", "Print (*.PRN),*.PRN") = 1 Then
    sle_misc_print_file.Text = ls_file
End if


end event

type rb_range_pages from radiobutton within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 416
integer width = 274
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Pa&ges:"
end type

on clicked;enableedit(sle_range_range)
end on

type rb_range_current from radiobutton within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 336
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "C&urrent"
end type

on clicked;disableedit(sle_range_range)
end on

type rb_range_all from radiobutton within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 256
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "&All"
boolean checked = true
end type

on clicked;disableedit(sle_range_range)
end on

type cb_select_filecollate from commandbutton within w_print_basewindow
integer x = 750
integer y = 64
integer width = 352
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Fi&le..."
end type

on clicked;Optionsselect(3)
end on

type cb_select_pages from commandbutton within w_print_basewindow
integer x = 402
integer y = 64
integer width = 329
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "P&ages"
end type

on clicked;Optionsselect(2)
end on

type cb_select_options from commandbutton within w_print_basewindow
integer x = 55
integer y = 64
integer width = 329
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Options..."
end type

on clicked;Optionsselect(1)
end on

type st_range from statictext within w_print_basewindow
boolean visible = false
integer x = 55
integer y = 528
integer width = 1042
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Enter page number and/or page ranges seperated by commas. For example 2,5,8-10"
boolean focusrectangle = false
end type

type sle_range_range from singlelineedit within w_print_basewindow
boolean visible = false
integer x = 329
integer y = 416
integer width = 750
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
end type

type cb_options_printer from commandbutton within w_print_basewindow
integer x = 823
integer y = 576
integer width = 261
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pr&inter..."
end type

on clicked;printsetup()
st_options_text.text =dw_print.describe("datawindow.printer")

end on

type sle_options_no_copies from singlelineedit within w_print_basewindow
integer x = 293
integer y = 352
integer width = 146
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "1"
boolean autohscroll = false
end type

type st_options_text from statictext within w_print_basewindow
integer x = 293
integer y = 272
integer width = 567
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "none"
boolean focusrectangle = false
end type

event constructor; text = dw_print.describe('datawindow.printer')
end event

type st_options_2 from statictext within w_print_basewindow
integer x = 55
integer y = 368
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Cop&ies:"
boolean focusrectangle = false
end type

type st_optins_1 from statictext within w_print_basewindow
integer x = 55
integer y = 272
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Printer:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_print_basewindow
integer x = 672
integer y = 2084
integer width = 274
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

on clicked;Close(Parent)
end on

type cb_print from commandbutton within w_print_basewindow
event ue_close1 pbm_custom01
integer x = 55
integer y = 2084
integer width = 274
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
boolean default = true
end type

on ue_close1;closewithreturn(parent,1)
end on

event clicked;// Routine for the printbutton.
// Before the printout is started, an ue_preprint event is issued, so that descendants can put in
// control before the printout (thanks to PowerBuilders objects, which really isn't real objects !!!)
// Also, descendants can cancel the printout, by setting ib_cancelprint to TRUE.

string ls_tmp, ls_docname
Long ll_Row

cb_cancel.enabled = false
ib_cancelprint = false
Parent.TriggerEvent("ue_preprint")
if ib_cancelprint then 
	cb_cancel.enabled = true
	return
end if

// Printout was not cancelled, build an print setup string, containing no copies, selected printer etc. etc.

if cbx_misc_collate_copies.checked then 
	is_Print_init = is_Print_init + " datawindow.print.collate = yes" 
else
	is_Print_init = is_Print_init + " datawindow.print.collate = no"
end if

if rb_range_current.checked then
	ls_tmp = string(il_curpage)
elseif rb_range_pages.checked then
	ls_tmp = sle_range_range.text
else 
	ls_tmp = ""
End if

is_Print_init = is_Print_init +  " datawindow.print.page.range = '"+ls_tmp+"'"
if len(sle_options_no_copies.text) > 0 Then 
	is_Print_init=is_Print_init + " datawindow.print.copies = "+sle_options_no_copies.text
End if

If cbx_misc_print_to_file.checked and sle_misc_print_file.text="" Then
	ls_tmp = ""  
	
	If GetFileSaveName("Print to file", ls_docname, ls_tmp, "PRN", "Print (*.PRN),*.PRN") = 1 then
		sle_misc_print_file.text = ls_docname   
	else
		cb_cancel.enabled = true
		return
	end if
end if

if cbx_misc_print_to_file.checked then 
	is_Print_init = is_Print_init + " datawindow.print.filename = '"+sle_misc_print_file.text+"'"
Else
 	is_Print_init = is_Print_init + " datawindow.print.filename = '' "
End If

ls_tmp = dw_print.modify(is_Print_init)
if len(ls_tmp) > 0 then 
	messagebox("Error Setting Print Options", "Error message = " +ls_tmp +" ~r~nCommand = " + is_Print_init)
	cb_cancel.enabled = true
	return
end if

if dw_print.Print () <> 1 Then
	messagebox("error", "print() returned with error")
	cb_cancel.enabled = true
    	Return
End if

cb_cancel.enabled = true

If ib_autoclose then PostEvent("ue_close1")


end event

type gb_misc_print from groupbox within w_print_basewindow
boolean visible = false
integer x = 18
integer y = 192
integer width = 1097
integer height = 496
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "File/Collate"
end type

type gb_range from groupbox within w_print_basewindow
boolean visible = false
integer x = 18
integer y = 192
integer width = 1097
integer height = 496
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Page range"
end type

type gb_options from groupbox within w_print_basewindow
integer x = 18
integer y = 192
integer width = 1097
integer height = 496
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Printer options"
end type

type cb_saveas from commandbutton within w_print_basewindow
event clicked pbm_bnclicked
integer x = 361
integer y = 2084
integer width = 274
integer height = 80
integer taborder = 131
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&SaveAs..."
end type

event clicked;dw_print.SaveAs()
end event

