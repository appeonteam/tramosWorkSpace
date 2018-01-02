$PBExportHeader$w_cont.srw
$PBExportComments$This window lets the user edit a selected contact person.
forward
global type w_cont from w_sale_base
end type
type cb_close from uo_cb_base within w_cont
end type
type cb_update from uo_cb_base within w_cont
end type
type cb_ownerlist from uo_cb_base within w_cont
end type
type dw_chartlist from u_datawindow_sqlca within w_cont
end type
type cb_cancel from uo_cb_base within w_cont
end type
type dw_gifts from u_datawindow_sqlca within w_cont
end type
type cb_new_gift from uo_cb_base within w_cont
end type
type cb_delete_gift from uo_cb_base within w_cont
end type
type cb_expand from uo_cb_base within w_cont
end type
type dw_cont from u_datawindow_sqlca within w_cont
end type
type gb_1 from uo_gb_base within w_cont
end type
end forward

global type w_cont from w_sale_base
int X=1
int Y=49
int Width=2899
int Height=1641
boolean TitleBar=true
string Title="Contact Details"
boolean MaxBox=false
boolean Resizable=false
cb_close cb_close
cb_update cb_update
cb_ownerlist cb_ownerlist
dw_chartlist dw_chartlist
cb_cancel cb_cancel
dw_gifts dw_gifts
cb_new_gift cb_new_gift
cb_delete_gift cb_delete_gift
cb_expand cb_expand
dw_cont dw_cont
gb_1 gb_1
end type
global w_cont w_cont

type variables
s_contact istr_param

Long il_chartnr = 0

Boolean ib_mod1,ib_mod2
end variables

forward prototypes
public function integer wf_save ()
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 07-08-96

 Description : Checks all required fields before updating a contact person. 		 

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
07-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_chart,ll_broker,ll_allrows,ll_row
Integer li_rtn

li_rtn = 1

/* Do not update before required (blue) fields have been entered*/

dw_cont.AcceptText()

ll_chart = dw_cont.GetItemNumber(dw_cont.GetRow(),"chart_nr")
ll_broker = dw_cont.GetItemNumber(dw_cont.GetRow(),"broker_nr")

/* Check Charterer or Broker has been entered */
IF ( ll_chart = 0  AND IsNull(ll_broker)) OR (IsNull(ll_chart) AND ll_broker = 0) THEN
		IF istr_param.chart_or_broker = "B" THEN
			MessageBox("Update Error","Please choose a Broker!")
			cb_ownerlist.SetFocus()
			Return 0
		ELSE
			MessageBox("Update Error","Please choose a Charterer!")
			cb_ownerlist.SetFocus()
			Return 0
		END IF
END IF	

/* Check contact name is entered */
IF IsNull(dw_cont.GetItemString(dw_cont.GetRow(),"ccs_cont_name")) OR dw_cont.GetItemString(dw_cont.GetRow(),"ccs_cont_name") = " " THEN
	MessageBox("Update Error","Please enter Contact Persons Name!")
	dw_cont.SetFocus()
	Return 0
END IF	
/* Check sales person has been entered */
//IF IsNull(dw_cont.GetItemString(dw_cont.GetRow(),"userid")) THEN
IF dw_cont.GetItemString(dw_cont.GetRow(),"userid") = " " THEN
	MessageBox("Update Error","Please choose an APM Contact!")
	Return 0
END IF												

/* Check all fields are entered in gift */

dw_gifts.AcceptText()
ll_allrows = dw_gifts.Rowcount()
IF ll_allrows > 0 THEN
	FOR ll_row = 1 TO ll_allrows
		IF IsNull(dw_gifts.GetItemDateTime(ll_row,"ccs_gift_d")) THEN
			MessageBox("Update Error","Please enter Gift date in row "+String(ll_row),Stopsign!)
			dw_gifts.ScrollToRow(ll_row)
			dw_gifts.SetColumn("ccs_gift_d")
			dw_gifts.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_gifts.GetItemString(ll_row,"ccs_gift_oca")) THEN
			MessageBox("Update Error","Please enter Gift Occation in row "+String(ll_row),Stopsign!)
			dw_gifts.ScrollToRow(ll_row)
			dw_gifts.SetColumn("ccs_gift_oca")
			dw_gifts.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_gifts.GetItemString(ll_row,"ccs_gift_desc")) THEN
			MessageBox("Update Error","Please enter Gift Description in row "+String(ll_row),Stopsign!)
			dw_gifts.ScrollToRow(ll_row)
			dw_gifts.SetColumn("ccs_gift_desc")
			dw_gifts.SetFocus()
		Return 0
		END IF
	NEXT	
END IF


IF istr_param.cont_id > 0 THEN
//only contact person already created in the database can be asigned gifts, because of foreign key constraint 
	li_rtn = dw_gifts.Update()
END IF

IF li_rtn = 1 THEN
	f_update(dw_cont,w_tramos_main)
	Return 1
ELSE
	MessageBox("Update Error","Couldn't update gift. Please check and try again.",StopSign!)
	Return 0
END IF

end function

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 02-08-96

 Description : Create or modify a contact person

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables :modicate flags ib_mod1 and ib_mod2 is used to control whether modifications has been made to the window.
 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0 			JH		Initial version
06-08-96					JH		Modified event to handle open with new 
  
************************************************************************************/

Long ll_row, ll_tmp,ll_gifts
istr_param = Message.PowerObjectParm

/* Set modicate flag to  stop itemChanged event in contact detail datawindow indicating  changes in dw. */  
ib_mod1 = FALSE

IF istr_param.cont_id > 0 THEN
/* Modify an existing contact person*/
	this.title = "Contact Person - MODIFY"
	dw_cont.Retrieve(istr_param.cont_id)	
	COMMIT USING SQLCA;

	IF istr_param.chart_or_broker = "B" THEN
		dw_cont.Modify("chart_nr_t.Text = 'Broker:'")
	END IF
	
	ll_gifts = dw_gifts.Retrieve( istr_param.cont_id)	
	COMMIT USING SQLCA;
	
	
ELSE
	
/* Crate a new contact person */
	this.title = "Contact Person - NEW"
	ll_row = dw_cont.InsertRow(0)
	dw_cont.ScrollToRow(ll_row)
//	Set temparary variable to Null to use in  Broker or Chart-id as apropriate
	SetNull(ll_tmp)

	IF istr_param.owner_id = 0 THEN
	// No owner has been given
		cb_ownerlist.Visible = TRUE
		Open(w_cont_response,This)
		istr_param.chart_or_broker = Message.StringParm
	END IF	

	IF istr_param.chart_or_broker = "B"  THEN
		dw_cont.Modify("chart_nr_t.Text = 'Broker:'")
		dw_cont.SetItem(ll_row,"broker_nr",istr_param.owner_id)
		dw_cont.SetItem(ll_row,"chart_nr",ll_tmp)
		dw_cont.SetItem(ll_row,"brokers_broker_sn",istr_param.owner_short_name)
	ELSE		
		dw_cont.SetItem(ll_row,"chart_nr",istr_param.owner_id)
		dw_cont.SetItem(ll_row,"broker_nr",ll_tmp)
		dw_cont.SetItem(ll_row,"chart_chart_sn",istr_param.owner_short_name)
	END IF
	
END IF	


/* Set modicate flag to indicate to itemChanged event i contact detail datawindow that modified flag can be set */  
ib_mod1 = TRUE	

dw_cont.SetFocus()


end on

on w_cont.create
int iCurrent
call w_sale_base::create
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_ownerlist=create cb_ownerlist
this.dw_chartlist=create dw_chartlist
this.cb_cancel=create cb_cancel
this.dw_gifts=create dw_gifts
this.cb_new_gift=create cb_new_gift
this.cb_delete_gift=create cb_delete_gift
this.cb_expand=create cb_expand
this.dw_cont=create dw_cont
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_close
this.Control[iCurrent+2]=cb_update
this.Control[iCurrent+3]=cb_ownerlist
this.Control[iCurrent+4]=dw_chartlist
this.Control[iCurrent+5]=cb_cancel
this.Control[iCurrent+6]=dw_gifts
this.Control[iCurrent+7]=cb_new_gift
this.Control[iCurrent+8]=cb_delete_gift
this.Control[iCurrent+9]=cb_expand
this.Control[iCurrent+10]=dw_cont
this.Control[iCurrent+11]=gb_1
end on

on w_cont.destroy
call w_sale_base::destroy
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_ownerlist)
destroy(this.dw_chartlist)
destroy(this.cb_cancel)
destroy(this.dw_gifts)
destroy(this.cb_new_gift)
destroy(this.cb_delete_gift)
destroy(this.cb_expand)
destroy(this.dw_cont)
destroy(this.gb_1)
end on

type cb_close from uo_cb_base within w_cont
int X=2506
int Y=1441
int Width=348
int Height=81
int TabOrder=100
string Text="Close"
boolean Cancel=true
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_closed
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 09-08-96

 Description : Close the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
09-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_ans

/* test if any changes were made */
dw_cont.AcceptText()
dw_gifts.AcceptText()

IF ib_mod2 OR dw_gifts.ModifiedCount() > 0 THEN
	li_ans = MessageBox("Warning","You have modified the contact person! Do you wish to save "&
						+"before closing?",Question!,YesNOCancel!)
END IF

IF li_ans = 1 THEN
	/* save changes before closing*/
	cb_update.TriggerEvent(Clicked!)
ELSEIF li_ans = 3 THEN
	/* Cancel close */
	Return
ELSE
	Close(Parent)
END IF
end on

type cb_update from uo_cb_base within w_cont
int X=2140
int Y=1441
int Width=348
int Height=81
int TabOrder=90
string Text="&Update"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_update
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 06-08-96

 Description : Update contact person

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-08-96		1.0 			JH		Initial version
  
************************************************************************************/

IF wf_save() = 1 THEN
	Close(Parent)
END IF


end on

type cb_ownerlist from uo_cb_base within w_cont
int X=1281
int Y=33
int Width=110
int Height=65
int TabOrder=80
boolean Visible=false
string Text="?"
end type

on clicked;call uo_cb_base::clicked;IF istr_param.chart_or_broker = "B" THEN
	// Contact belongs to a broker
	dw_chartlist.Title = "Double click to select Broker"
	dw_chartlist.DataObject  =  "dw_broker_list"
	dw_chartlist.SetTransObject(SQLCA)
	dw_chartlist.Retrieve()
	dw_chartlist.SetSort("broker_name A")
	dw_chartlist.Sort()	
ELSE
	dw_chartlist.Title = "Double click to select Charterer"
	dw_chartlist.Retrieve()
	dw_chartlist.SetSort("chart_n_1 A")
	dw_chartlist.Sort()
END IF


dw_chartlist.Visible = TRUE
dw_chartlist.SetFocus()

end on

type dw_chartlist from u_datawindow_sqlca within w_cont
int X=1153
int Y=1
int Width=1299
int Height=1393
int TabOrder=70
boolean Visible=false
string DataObject="dw_charterer_list"
boolean TitleBar=true
string Title=""
boolean VScrollBar=true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/* Take use of ancestors script */
ib_auto = True

dw_chartlist.SelectRow(0,FALSE)
dw_chartlist.SelectRow(dw_chartlist.GetRow(),TRUE)
end on

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : dw_chartlist
  
 Event	 : doubleclicked!
 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 

 Description :

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- -------	----- -------------------------------------
10/9-97	1.0		BO		Remove obsolete functions in PB 5.0
  
************************************************************************************/

Long 		ll_nr
String 	ls_shortname

/* ll_row = dw_chartlist.GetClickedRow() */


ll_nr = dw_chartlist.GetItemNumber(row,1)
ls_shortname = dw_chartlist.GetItemString(row,2)


IF istr_param.chart_or_broker = "B" THEN
	dw_cont.SetItem(1,"broker_nr",ll_nr)
	dw_cont.SetItem(1,"brokers_broker_sn",ls_shortname)
ELSE
	dw_cont.SetItem(1,"chart_nr",ll_nr)
	dw_cont.SetItem(1,"chart_chart_sn",ls_shortname)
END IF


This.Visible = FALSE




end event

on clicked;call u_datawindow_sqlca::clicked;/* Take use of ancestors script */

ib_auto = True
end on

type cb_cancel from uo_cb_base within w_cont
int X=1774
int Y=1441
int Width=348
int Height=81
int TabOrder=40
string Text="&Cancel"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_cancel
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 08-08-96

 Description : Cancel all changes made in window.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_newrow



IF istr_param.cont_id > 0 THEN
// Get original data
	dw_cont.Retrieve(istr_param.cont_id)
	dw_gifts.Retrieve(istr_param.cont_id)
ELSE
// Insert new blank row
	dw_cont.DeleteRow(1)
	ll_newrow = dw_cont.InsertRow(0)
	dw_cont.ScrollToRow(ll_newrow)

END IF
dw_cont.SetFocus()




end on

type dw_gifts from u_datawindow_sqlca within w_cont
int X=37
int Y=1041
int Width=2396
int Height=353
int TabOrder=60
string DataObject="d_gifts"
boolean VScrollBar=true
boolean LiveScroll=false
end type

event clicked;call super::clicked;/* cb_delete_gift.Enabled = dw_gifts.GetClickedRow() > 0 */
cb_delete_gift.Enabled = row > 0
end event

type cb_new_gift from uo_cb_base within w_cont
int X=2469
int Y=1041
int Width=348
int Height=81
int TabOrder=30
string Text="&New"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_new_gift
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 07-08-96

 Description : Insert new row in gift list to create new gift

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
07-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_newrow

IF istr_param.cont_id < 1 THEN
	MessageBox("Infomation","Please update new contact person first and reenter to asign gifts !")
	
ELSE
	ll_newrow = dw_gifts.InsertRow(0)
	dw_gifts.SetItem(ll_newrow,"ccs_cont_pk",istr_param.cont_id)
	dw_gifts.ScrollToRow(ll_newrow)
	dw_gifts.SetColumn("ccs_gift_d")
	dw_gifts.SetFocus()
	cb_delete_gift.Enabled = TRUE
END IF
end event

type cb_delete_gift from uo_cb_base within w_cont
int X=2469
int Y=1137
int Width=348
int Height=81
int TabOrder=20
boolean Enabled=false
string Text="&Delete"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_delete_gift
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 07-08-96

 Description : Delete row in gift list 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
07-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_ans
Long ll_row


li_ans = MessageBox("Warning","You are about to delete a gift. Continue?",Question!,YesNo!)
IF li_ans = 1 THEN
// Process Yes
	ll_row = dw_gifts.GetRow()
	dw_gifts.DeleteRow(ll_row)
	IF dw_gifts.Rowcount() < 1 THEN
		This.Enabled = FALSE
	ELSE
		dw_gifts.SetFocus()
	END IF
END IF

end on

type cb_expand from uo_cb_base within w_cont
int X=2469
int Y=721
int Width=348
int Height=81
int TabOrder=10
string Text="&Expand"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cont
  
 Object     : cb_expand
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 03-08-96

 Description :Expands text field in a responce window; so the user can edit this 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
03-08-96		1.0 			JH		Initial version
  
************************************************************************************/


s_expand_text lstr_parm
String ls_rtn

dw_cont.AcceptText()
lstr_parm.text =dw_cont.GetItemString(1,"ccs_cont_ccs_cont_desc")  
lstr_parm.name = dw_cont.GetItemString(1,"ccs_cont_name")

cb_cancel.Enabled = FALSE
cb_close.Enabled = FALSE
cb_update.Enabled = FALSE
/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)

ls_rtn = Message.StringParm
/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_cont.SetItem(1,"ccs_cont_ccs_cont_desc",ls_rtn)
END IF
cb_cancel.Enabled = TRUE
cb_close.Enabled = TRUE
cb_update.Enabled = TRUE	



end on

type dw_cont from u_datawindow_sqlca within w_cont
int X=19
int Y=17
int Width=2835
int Height=961
int TabOrder=110
string DataObject="d_cont"
end type

on getfocus;call u_datawindow_sqlca::getfocus;cb_delete_gift.Enabled = False
end on

on itemchanged;call u_datawindow_sqlca::itemchanged;
IF ib_mod1 THEN
	/* Changes to the datawindow must be indicated */
	ib_mod2 = TRUE
END IF

end on

type gb_1 from uo_gb_base within w_cont
int X=19
int Y=977
int Width=2835
int Height=449
int TabOrder=50
string Text="Gifts:"
BorderStyle BorderStyle=StyleBox!
int Weight=700
end type

