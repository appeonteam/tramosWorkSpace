$PBExportHeader$w_attachment_manager.srw
forward
global type w_attachment_manager from mt_w_master
end type
type uo_searchbox from u_searchbox within w_attachment_manager
end type
type cb_collapse from mt_u_commandbutton within w_attachment_manager
end type
type cb_expandall from mt_u_commandbutton within w_attachment_manager
end type
type uo_att from u_fileattach within w_attachment_manager
end type
end forward

global type w_attachment_manager from mt_w_master
integer width = 3296
integer height = 2568
string title = "Attachments"
boolean resizable = false
long backcolor = 32304364
boolean center = false
uo_searchbox uo_searchbox
cb_collapse cb_collapse
cb_expandall cb_expandall
uo_att uo_att
end type
global w_attachment_manager w_attachment_manager

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_attachment_manager: Window providing overview of attachments
   <OBJECT> Window</OBJECT>
   <DESC>    joins CP, Cargo, Voyage and Certificate attachments into
	one treeview where user can locate and search particular docs</DESC>
   <USAGE>  From menubar item</USAGE>
   <ALSO>   d_sq_tr_attachment_manager</ALSO>
    Date   Ref    	Author         Comments
  07/09/10 CR1896    AGL     			First Version - simple preview
  01/09/14 CR3781    CCY018			The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_attachment_manager.create
int iCurrent
call super::create
this.uo_searchbox=create uo_searchbox
this.cb_collapse=create cb_collapse
this.cb_expandall=create cb_expandall
this.uo_att=create uo_att
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_searchbox
this.Control[iCurrent+2]=this.cb_collapse
this.Control[iCurrent+3]=this.cb_expandall
this.Control[iCurrent+4]=this.uo_att
end on

on w_attachment_manager.destroy
call super::destroy
destroy(this.uo_searchbox)
destroy(this.cb_collapse)
destroy(this.cb_expandall)
destroy(this.uo_att)
end on

event open;call super::open;long ll_dummy
setnull(ll_dummy)

uo_att.of_init(ll_dummy)

// Init searchbox
uo_searchbox.of_Initialize(uo_att.dw_file_listing, "voyage_document_docname+level1+level2+level3")
uo_searchbox.sle_Search.SetFocus()


end event

type uo_searchbox from u_searchbox within w_attachment_manager
integer x = 41
integer y = 24
integer taborder = 20
long backcolor = 32304364
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

event ue_keypress;call super::ue_keypress;uo_att.of_setfilecounter( )
end event

event clearclicked;call super::clearclicked;uo_att.of_setfilecounter( )
end event

event constructor;call super::constructor;this.st_search.backcolor = c#color.MT_FORM_BG
end event

type cb_collapse from mt_u_commandbutton within w_attachment_manager
integer x = 379
integer y = 2364
integer taborder = 50
string text = "Collapse"
end type

event clicked;call super::clicked;integer li_ret

li_ret =  uo_att.dw_file_listing.collapseall( )
end event

type cb_expandall from mt_u_commandbutton within w_attachment_manager
integer x = 23
integer y = 2364
integer taborder = 40
string text = "Expand"
end type

event clicked;call super::clicked;integer li_ret

li_ret = uo_att.dw_file_listing.ExpandAll()
end event

type uo_att from u_fileattach within w_attachment_manager
integer x = 27
integer y = 204
integer width = 3191
integer height = 2136
integer taborder = 20
string is_dataobjectname = "d_sq_tr_attachment_manager"
boolean ib_ole = true
boolean ib_highlight_selectedrow = false
integer ii_buttonmode = 0
end type

on uo_att.destroy
call u_fileattach::destroy
end on

