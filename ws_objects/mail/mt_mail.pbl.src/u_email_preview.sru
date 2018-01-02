$PBExportHeader$u_email_preview.sru
forward
global type u_email_preview from mt_u_visualobject
end type
type st_message from statictext within u_email_preview
end type
type st_attachments from statictext within u_email_preview
end type
type st_emailsubject from statictext within u_email_preview
end type
type st_emailto from statictext within u_email_preview
end type
type mle_message from multilineedit within u_email_preview
end type
type mle_attachments from multilineedit within u_email_preview
end type
type sle_emailsubject from singlelineedit within u_email_preview
end type
type st_emailfrom from statictext within u_email_preview
end type
type mle_emailto from multilineedit within u_email_preview
end type
type ddlb_emailfrom from dropdownlistbox within u_email_preview
end type
end forward

global type u_email_preview from mt_u_visualobject
integer width = 2725
integer height = 1884
st_message st_message
st_attachments st_attachments
st_emailsubject st_emailsubject
st_emailto st_emailto
mle_message mle_message
mle_attachments mle_attachments
sle_emailsubject sle_emailsubject
st_emailfrom st_emailfrom
mle_emailto mle_emailto
ddlb_emailfrom ddlb_emailfrom
end type
global u_email_preview u_email_preview

type variables

end variables

forward prototypes
public subroutine uf_refresh (s_email astr_email)
private function string uf_getstring (string as_array[])
public function string uf_get_subject ()
public function string uf_get_message ()
public function string uf_get_emailfrom ()
public subroutine documentation ()
public subroutine uf_init (s_email astr_email)
end prototypes

public subroutine uf_refresh (s_email astr_email);/********************************************************************
   uf_refresh 
   <DESC>	Fills in the fields: "email to" and "attachments"
	</DESC>
   <RETURN>
	</RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	astr_email: email structure
   	</ARGS>
   <USAGE>	Used to update the fields "email to" and "attachments",
					the other fields are not refreshed, because it can be changed
					by the user. 
	</USAGE>
********************************************************************/

//Email to
mle_emailto.text =uf_getstring(astr_email.emailto)

//Attachments
mle_attachments.text = uf_getstring(astr_email.attachments)
end subroutine

private function string uf_getstring (string as_array[]);long		ll_row
string	ls_tmp

if upperbound(as_array) = 0 then return ""

ls_tmp = ""
for ll_row = 1 to upperbound(as_array)
	ls_tmp = ls_tmp + "; " + as_array[ll_row]
next

return mid(ls_tmp,3)

end function

public function string uf_get_subject ();return sle_emailsubject.text
end function

public function string uf_get_message ();return mle_message.text
end function

public function string uf_get_emailfrom ();return ddlb_emailfrom.text
end function

public subroutine documentation ();/********************************************************************
ObjectName: u_email_preview - used to display an email message
<OBJECT>
This object displays an email message where the user can edit the Subject and 
Message fields. The user can also select the "Email from".
</OBJECT>
	
<USAGE> 

Functions:

uf_init() - Initializes the object

of_refresh() - Updates the fields: "email to" and "attachments". Does not updates the other
					fields because the user is free of changing it.
					To get the data changed by the user, use the following functions:
							- uf_get_emailfrom( )
							- uf_get_subject( )
							- uf_get_message( )

This object was implemented in a basic way, and it´s used in the w_mailcertificates. If
necessary, add more functions.
The fields "email To" and "Attachments" are read only.
</USAGE>
<ALSO> 
</ALSO>

Date   Ref   	Author        			     Comments
09/06/10       	Joana Carvalho     	First Version
********************************************************************/
end subroutine

public subroutine uf_init (s_email astr_email);/********************************************************************
   uf_init
   <DESC>	Initializes the object. Initializes the fields: From, Subject and Message		
	</DESC>
   <RETURN>
	</RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	astr_email: email structure
   	</ARGS>
   <USAGE>	Used to initialize an email message with default values.	</USAGE>
********************************************************************/

long ll_row
string ls_tmp 

//Email from
if upperbound(astr_email.emailfrom) > 0 then
	for ll_row = 1 to upperbound(astr_email.emailfrom) 
		ddlb_emailfrom.additem(astr_email.emailfrom[ll_row])
	next 
	if astr_email.emailfrom_selection_pos = 0 then astr_email.emailfrom_selection_pos = 1
	ddlb_emailfrom.selectitem( astr_email.emailfrom_selection_pos)
end if

//Email to (email addresses separated by semicolon)
mle_emailto.text =uf_getstring(astr_email.emailto)

//Subject
sle_emailsubject.text =astr_email.subject

//Attachments (files separated by semicolon)
mle_attachments.text = uf_getstring(astr_email.attachments)

//Message
mle_message.text  = astr_email.message

//Email to
mle_emailto.text =uf_getstring(astr_email.emailto)

//Attachments
mle_attachments.text = uf_getstring(astr_email.attachments)

end subroutine

on u_email_preview.create
int iCurrent
call super::create
this.st_message=create st_message
this.st_attachments=create st_attachments
this.st_emailsubject=create st_emailsubject
this.st_emailto=create st_emailto
this.mle_message=create mle_message
this.mle_attachments=create mle_attachments
this.sle_emailsubject=create sle_emailsubject
this.st_emailfrom=create st_emailfrom
this.mle_emailto=create mle_emailto
this.ddlb_emailfrom=create ddlb_emailfrom
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_message
this.Control[iCurrent+2]=this.st_attachments
this.Control[iCurrent+3]=this.st_emailsubject
this.Control[iCurrent+4]=this.st_emailto
this.Control[iCurrent+5]=this.mle_message
this.Control[iCurrent+6]=this.mle_attachments
this.Control[iCurrent+7]=this.sle_emailsubject
this.Control[iCurrent+8]=this.st_emailfrom
this.Control[iCurrent+9]=this.mle_emailto
this.Control[iCurrent+10]=this.ddlb_emailfrom
end on

on u_email_preview.destroy
call super::destroy
destroy(this.st_message)
destroy(this.st_attachments)
destroy(this.st_emailsubject)
destroy(this.st_emailto)
destroy(this.mle_message)
destroy(this.mle_attachments)
destroy(this.sle_emailsubject)
destroy(this.st_emailfrom)
destroy(this.mle_emailto)
destroy(this.ddlb_emailfrom)
end on

type st_message from statictext within u_email_preview
integer x = 23
integer y = 576
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Message"
boolean focusrectangle = false
end type

type st_attachments from statictext within u_email_preview
integer x = 23
integer y = 388
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Attachments"
boolean focusrectangle = false
end type

type st_emailsubject from statictext within u_email_preview
integer x = 23
integer y = 308
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Subject"
boolean focusrectangle = false
boolean disabledlook = true
end type

type st_emailto from statictext within u_email_preview
integer x = 23
integer y = 116
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "To"
boolean focusrectangle = false
boolean disabledlook = true
end type

type mle_message from multilineedit within u_email_preview
integer x = 18
integer y = 648
integer width = 2679
integer height = 1208
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type mle_attachments from multilineedit within u_email_preview
integer x = 329
integer y = 388
integer width = 2368
integer height = 152
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_emailsubject from singlelineedit within u_email_preview
integer x = 215
integer y = 292
integer width = 2482
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_emailfrom from statictext within u_email_preview
integer x = 23
integer y = 36
integer width = 174
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "From"
boolean focusrectangle = false
boolean disabledlook = true
end type

type mle_emailto from multilineedit within u_email_preview
integer x = 215
integer y = 116
integer width = 2482
integer height = 152
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_emailfrom from dropdownlistbox within u_email_preview
integer x = 215
integer y = 16
integer width = 951
integer height = 352
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
borderstyle borderstyle = stylelowered!
end type

