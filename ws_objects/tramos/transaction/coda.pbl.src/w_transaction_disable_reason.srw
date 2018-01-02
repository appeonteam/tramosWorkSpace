$PBExportHeader$w_transaction_disable_reason.srw
$PBExportComments$Window with dw for disable text of a transaction from transaction log.
forward
global type w_transaction_disable_reason from mt_w_response
end type
type st_1 from statictext within w_transaction_disable_reason
end type
type cb_cancel from commandbutton within w_transaction_disable_reason
end type
type cb_save from commandbutton within w_transaction_disable_reason
end type
type mle_disable_reason from multilineedit within w_transaction_disable_reason
end type
end forward

global type w_transaction_disable_reason from mt_w_response
integer x = 1074
integer y = 484
integer width = 1298
integer height = 376
string title = "Disabled Reason"
boolean resizable = true
long backcolor = 81324524
st_1 st_1
cb_cancel cb_cancel
cb_save cb_save
mle_disable_reason mle_disable_reason
end type
global w_transaction_disable_reason w_transaction_disable_reason

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_transaction_disable_reason
	
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
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_transaction_disable_reason.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.mle_disable_reason=create mle_disable_reason
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_save
this.Control[iCurrent+4]=this.mle_disable_reason
end on

on w_transaction_disable_reason.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.mle_disable_reason)
end on

event open;/***********************************************************************************
Creator:	Teit Aunt
Date:		19-05-1999
Purpose:	Opens the disable reason window with the text from the disable reason field.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
19-05-99		1.0		ta			Initial version
************************************************************************************/
String ls_reason

// Get text and insert into multiline edit
ls_reason = Message.StringParm
mle_disable_reason.text = ls_reason

// Select current text and give it the focus
mle_disable_reason.SelectText(1, Len(mle_disable_reason.text))
mle_disable_reason.SetFocus()
end event

type st_1 from statictext within w_transaction_disable_reason
integer x = 41
integer y = 156
integer width = 535
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Max. 50 characters"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_transaction_disable_reason
integer x = 585
integer y = 136
integer width = 297
integer height = 100
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		19-05-1999
Purpose:	Close the disable reason window with no change to the text from the disable
			reason field.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
19-05-99		1.0		ta			Initial version
************************************************************************************/

// Close the window
CloseWithReturn(Parent,"NoChange")

end event

type cb_save from commandbutton within w_transaction_disable_reason
integer x = 923
integer y = 136
integer width = 297
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
boolean default = true
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		19-05-1999
Purpose:	Close the disable reason window and returns the text from the multi line edit 
			to the disable reason field where it will be saved when the update button is 
			pushed.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
19-05-99		1.0		ta			Initial version
************************************************************************************/
String ls_text
Integer li_rownum

// Returns the new content in disabe reason to the data store
CloseWithReturn(Parent,mle_disable_reason.text)

end event

type mle_disable_reason from multilineedit within w_transaction_disable_reason
integer x = 37
integer y = 24
integer width = 1184
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

