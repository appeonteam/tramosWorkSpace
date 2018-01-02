$PBExportHeader$u_filter_show.sru
forward
global type u_filter_show from mt_u_visualobject
end type
type rb_bu from mt_u_radiobutton within u_filter_show
end type
type rb_all from mt_u_radiobutton within u_filter_show
end type
type rb_my from mt_u_radiobutton within u_filter_show
end type
type gb_show from mt_u_groupbox within u_filter_show
end type
end forward

global type u_filter_show from mt_u_visualobject
integer width = 439
integer height = 308
long backcolor = 22628899
rb_bu rb_bu
rb_all rb_all
rb_my rb_my
gb_show gb_show
end type
global u_filter_show u_filter_show

type variables
private string	_is_filter
private long	_il_bu
private window	_iw_parent
end variables

forward prototypes
public function string of_getfilter ()
public subroutine of_setbusinessunit (long al_bu)
public subroutine documentation ()
end prototypes

public function string of_getfilter ();/********************************************************************
   of_getfilter
   <DESC>	Get change request show filter	</DESC>
   <RETURN>	string: filter string	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call back from parent window	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-07-2011 2438         JMY014        		 First Version
   </HISTORY>
********************************************************************/
return _is_filter
end function

public subroutine of_setbusinessunit (long al_bu);/********************************************************************
   of_setbusinessunit
   <DESC>	Set up the current login user's business unit	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_bu
   </ARGS>
   <USAGE>	Called directly	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04-08-2011 2438         JMY014             First Version
   </HISTORY>
********************************************************************/
_il_bu = al_bu
end subroutine

public subroutine documentation ();/********************************************************************
   u_filter_show
   <OBJECT>		Change request show filter	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04-08-2011 2438         JMY014             First Version
   </HISTORY>
********************************************************************/
end subroutine

on u_filter_show.create
int iCurrent
call super::create
this.rb_bu=create rb_bu
this.rb_all=create rb_all
this.rb_my=create rb_my
this.gb_show=create gb_show
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_bu
this.Control[iCurrent+2]=this.rb_all
this.Control[iCurrent+3]=this.rb_my
this.Control[iCurrent+4]=this.gb_show
end on

on u_filter_show.destroy
call super::destroy
destroy(this.rb_bu)
destroy(this.rb_all)
destroy(this.rb_my)
destroy(this.gb_show)
end on

event constructor;call super::constructor;_iw_parent = parent
///* DEVELOPER show all change request */
//choose case upper(uo_global.is_userid)
//	case "AGL027", "JMC112", "JSU042", "CONASW", "RMO003", "HHE024"
//		rb_all.triggerevent(clicked!)
//	case else
//		rb_my.triggerevent(clicked!)
//end choose
end event

type rb_bu from mt_u_radiobutton within u_filter_show
integer x = 37
integer y = 224
integer width = 361
integer height = 56
integer taborder = 30
long textcolor = 16777215
long backcolor = 22628899
string text = "My &BU~'s CRs"
end type

event clicked;call super::clicked;_is_filter = "(bu_id="+string(_il_bu) + ")"
_iw_parent.dynamic function wf_filter()
end event

type rb_all from mt_u_radiobutton within u_filter_show
integer x = 37
integer y = 144
integer width = 361
integer height = 56
integer taborder = 20
long textcolor = 16777215
long backcolor = 22628899
string text = "&All CRs"
end type

event clicked;call super::clicked;_is_filter = ""
_iw_parent.dynamic function wf_filter()
end event

type rb_my from mt_u_radiobutton within u_filter_show
integer x = 37
integer y = 64
integer width = 361
integer height = 56
integer taborder = 10
long textcolor = 16777215
long backcolor = 22628899
string text = "&My CRs"
boolean checked = true
end type

event clicked;call super::clicked;_is_filter =  "(created_by='" +uo_global.is_userid+ "' or owner='" +uo_global.is_userid +"')"
_iw_parent.dynamic function wf_filter()
end event

type gb_show from mt_u_groupbox within u_filter_show
integer width = 439
integer height = 308
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Show"
end type

