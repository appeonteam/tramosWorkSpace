$PBExportHeader$w_unsettled_brokers.srw
$PBExportComments$Window to show and select unsettled brokers
forward
global type w_unsettled_brokers from mt_w_response
end type
type cb_select from commandbutton within w_unsettled_brokers
end type
type cb_close from commandbutton within w_unsettled_brokers
end type
type dw_unsettled_brokers from uo_datawindow within w_unsettled_brokers
end type
end forward

global type w_unsettled_brokers from mt_w_response
integer x = 672
integer y = 264
integer width = 1614
integer height = 1000
string title = "Brokers with unsettled accounts"
long backcolor = 81324524
cb_select cb_select
cb_close cb_close
dw_unsettled_brokers dw_unsettled_brokers
end type
global w_unsettled_brokers w_unsettled_brokers

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_unsettled_brokers
  
 Object     : 
  
 Event	 :  Open

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : This window shows brokers with unsettled commissions

 Arguments : None

 Returns   : Broker_no

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

// Set SQLCA and retrieve brokers. If no. brokers = 0 then disable the select button

dw_unsettled_brokers.dataobject = Message.StringParm

dw_unsettled_brokers.SetTransObject( SQLCA )

dw_unsettled_brokers.ib_auto = True

If dw_unsettled_brokers.retrieve () > 0 Then

	dw_unsettled_brokers.ScrollToRow (1)
	dw_unsettled_brokers.SelectRow ( 1, True )
Else
	cb_select.enabled = false
End if


end event

on w_unsettled_brokers.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_close=create cb_close
this.dw_unsettled_brokers=create dw_unsettled_brokers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_unsettled_brokers
end on

on w_unsettled_brokers.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_close)
destroy(this.dw_unsettled_brokers)
end on

type cb_select from commandbutton within w_unsettled_brokers
integer x = 933
integer y = 784
integer width = 256
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select"
boolean default = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_unsettled_brokers
  
 Object     : cb_select
  
 Event	 : Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Closes, and returns the selected broker

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


Long ll_Row, ll_Broker_No

ll_Row = dw_unsettled_brokers.GetRow()
If ll_Row > 0 Then

     ll_broker_no = dw_unsettled_brokers.GetItemNumber(ll_Row, "BROKERS_BROKER_NR" )
     CloseWithReturn ( parent, ll_broker_no )
	  Return
End if
end event

type cb_close from commandbutton within w_unsettled_brokers
integer x = 1225
integer y = 784
integer width = 256
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_unsettled_brokers
  
 Object     : cb_close
  
 Event	 : Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Closes, and dosn't return anything at all

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


Close ( parent )
end on

type dw_unsettled_brokers from uo_datawindow within w_unsettled_brokers
integer x = 55
integer y = 64
integer width = 1463
integer height = 688
integer taborder = 10
string dataobject = "dw_unsettled_brokers"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_unsettled_brokers
  
 Object     : dw_unsettled_brokers
  
 Event	 : DoubleClicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Closes, and returns the doubleclicked broker

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

Long  ll_broker_no

If Row > 0 Then

     ll_broker_no = dw_unsettled_brokers.GetItemNumber(Row, "BROKERS_BROKER_NR" )
     CloseWithReturn ( parent, ll_broker_no )
	  Return
End if
end event

