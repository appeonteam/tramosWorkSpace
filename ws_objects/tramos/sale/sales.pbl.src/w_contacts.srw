$PBExportHeader$w_contacts.srw
$PBExportComments$This window lets the user edit contactpersons for a chosen charterer or broker.
forward
global type w_contacts from w_sale_base
end type
type cb_close from uo_cb_base within w_contacts
end type
type dw_contacts from u_datawindow_sqlca within w_contacts
end type
type cb_new from uo_cb_base within w_contacts
end type
type cb_modify from uo_cb_base within w_contacts
end type
type cb_delete from uo_cb_base within w_contacts
end type
type cb_refresh from uo_cb_base within w_contacts
end type
end forward

global type w_contacts from w_sale_base
integer x = 14
integer y = 740
integer width = 2885
integer height = 1168
string title = "Contact Persons"
cb_close cb_close
dw_contacts dw_contacts
cb_new cb_new
cb_modify cb_modify
cb_delete cb_delete
cb_refresh cb_refresh
end type
global w_contacts w_contacts

type variables
Long il_parametre 
s_contact istr_parm
end variables

forward prototypes
public subroutine wf_update_buttons ()
public subroutine documentation ()
end prototypes

public subroutine wf_update_buttons ();Long ll_row

ll_row = dw_contacts.GetRow()

cb_delete.enabled = ll_row > 0
cb_modify.enabled = cb_delete.enabled
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/08/14 CR3708            CCY018       modified event ue_getwidowname
   </HISTORY>
********************************************************************/
end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_contacts
  
 Object     : 
  
 Event	 : Open

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :26-07-96

 Description : Opens with a list of selected contact persons.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : istr_parm of type s_list.

 Other : A contact person works either for a Charterer or a Broker. 'He' has a charterer number if 'he' works for a 
		charterer and a broker number if 'he' works for a broker.  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
26-07-96		1.0	 		JH		Initial version
07-08-96					JH		Modified to use s_contact in PowerObjectParm
  
************************************************************************************/
Long ll_null
Long ll_rows

This.Move(14,450)
SetNull(ll_null)


istr_parm  = Message.PowerObjectParm

// Retrieve all contact persons where broker-nr or charterer-nr is owner_id

IF istr_parm.chart_or_broker = "B" THEN
// Contact person belongs to a broker
	ll_rows = dw_contacts.Retrieve(istr_parm.owner_id,ll_null)
	COMMIT USING SQLCA;
ELSE
// Contact person belongs to a charterer
	ll_rows = dw_contacts.Retrieve(ll_null,istr_parm.owner_id)
	COMMIT USING SQLCA;
END IF

IF ll_rows < 1 THEN
	// No rows retrieved - disable modify and delete button
	wf_update_buttons()
END IF

 


This.Title = "Contact Persons for: "+istr_parm.owner_short_name
end on

on w_contacts.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_contacts=create dw_contacts
this.cb_new=create cb_new
this.cb_modify=create cb_modify
this.cb_delete=create cb_delete
this.cb_refresh=create cb_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_contacts
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_modify
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_refresh
end on

on w_contacts.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_contacts)
destroy(this.cb_new)
destroy(this.cb_modify)
destroy(this.cb_delete)
destroy(this.cb_refresh)
end on

event ue_getwindowname;call super::ue_getwindowname;if istr_parm.chart_or_broker = "B" then
	as_windowname = this.classname( ) + "_broker"
else
	as_windowname = this.classname( ) + "_chart"
end if
end event

type st_hidemenubar from w_sale_base`st_hidemenubar within w_contacts
end type

type cb_close from uo_cb_base within w_contacts
integer x = 2487
integer y = 960
integer width = 311
integer height = 80
integer taborder = 50
string text = "Close"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;Close(Parent)
end on

type dw_contacts from u_datawindow_sqlca within w_contacts
integer x = 37
integer y = 32
integer width = 2395
integer height = 1008
integer taborder = 60
string dataobject = "d_cont_list"
boolean hscrollbar = true
boolean vscrollbar = true
end type

on rowfocuschanged;// Override ancestors script
Long ll_row

	ll_row = GetRow()
	
	If ll_row <> GetSelectedRow(0) Then
		SelectRow(0,False)
		SelectRow(ll_row,True)
		SetRow(ll_Row)
		ScrollToRow(ll_row)
	End if
end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_modify.TriggerEvent(Clicked!)
end on

event clicked;// Override ancestors script

	if row = 0 Then row = GetSelectedRow(0)

	If row > 0 Then
	 	SetRow(row)
		SelectRow(row,True)
		ScrollToRow(row)	
		wf_update_buttons()
	END IF

	

end event

type cb_new from uo_cb_base within w_contacts
integer x = 2469
integer y = 32
integer width = 311
integer height = 80
integer taborder = 40
string text = "&New"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :w_contacts 
  
 Object     : cb_new
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 29-07-96

 Description : Create a new contact person.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-07-96		1.0	 		JH		Initial version
  
************************************************************************************/


// Structure to send in PowerObjectParm


// Contact person do not exist yet
istr_parm.cont_id = 0

OpenSheetWithParm(w_cont,istr_parm,w_tramos_main,7,Original!)

end on

type cb_modify from uo_cb_base within w_contacts
integer x = 2469
integer y = 320
integer width = 311
integer height = 80
integer taborder = 30
string text = "&Modify"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_contacts
  
 Object     : cb_modify
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 29-07-96

 Description : Edit  a selected contact person 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-07-96		1.0	 		JH		Initial version
  
************************************************************************************/


Long ll_row

ll_row = dw_contacts.GetRow()

IF ll_row > 0 THEN
	/* Get selected Contact persons key and set in instance of s_contact */	
	istr_parm.cont_id = dw_contacts.GetItemNumber(ll_row,"ccs_cont_ccs_cont_pk")
	OpenSheetWithParm(w_cont,istr_parm,w_tramos_main,7,Original!)

END IF


end on

type cb_delete from uo_cb_base within w_contacts
integer x = 2469
integer y = 128
integer width = 311
integer height = 80
integer taborder = 20
string text = "&Delete"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_contacts
  
 Object     : cb_delete
  
 Event	 : clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 02-09-96

 Description : Make cascade delete on contact persons and gifts

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-09-96		1.0	 		JH		Initial version
  
************************************************************************************/


Long ll_row,ll_cont_id

ll_row = dw_contacts.GetRow()
ll_cont_id = dw_contacts.GetItemNumber(ll_row,"ccs_cont_ccs_cont_pk" )

IF  ll_Row <> 0 THEN
	IF MessageBox("Delete","You are about to DELETE !~r~nThis will cause all gifts for this person to be deleted"&
						+" as well.~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return
	
	DELETE 
			FROM CCS_GIFT
			WHERE CCS_CONT_PK = :ll_cont_id;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("SQL error",SQLCA.SQLErrText,Information!)
				ROLLBACK;
				Return
			ELSE
				dw_contacts.DeleteRow(ll_row)
				dw_contacts.Update()
				IF SQLCA.SQLCode = 0 THEN
					COMMIT;
				ELSE
					ROLLBACK;
				END IF

			END IF	
END IF

IF dw_contacts.Rowcount() < 1 THEN This.Enabled = FALSE
end on

type cb_refresh from uo_cb_base within w_contacts
integer x = 2469
integer y = 224
integer width = 311
integer height = 80
integer taborder = 10
string text = "&Refresh"
end type

on clicked;call uo_cb_base::clicked;Long ll_null

SetNull(ll_null)

IF istr_parm.chart_or_broker = "B" THEN
// Contact person belongs to a broker
	dw_contacts.Retrieve(istr_parm.owner_id,ll_null)
ELSE
// Contact person belongs to a charterer
	 dw_contacts.Retrieve(ll_null,istr_parm.owner_id)
END IF

cb_delete.Enabled = False
cb_modify.Enabled = False
end on

