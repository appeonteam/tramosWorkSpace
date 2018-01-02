$PBExportHeader$w_mreports.srw
$PBExportComments$This window lets the user edit a chosen charterers meeting reports and action status description relating to same charterer, listed in one view.
forward
global type w_mreports from w_sale_base
end type
type dw_mreports from u_datawindow_sqlca within w_mreports
end type
type cb_new from uo_cb_base within w_mreports
end type
type cb_modify from uo_cb_base within w_mreports
end type
type cb_delete from uo_cb_base within w_mreports
end type
type dw_action_status from u_datawindow_sqlca within w_mreports
end type
type cb_update from uo_cb_base within w_mreports
end type
type cb_close from uo_cb_base within w_mreports
end type
type dw_list_together from u_datawindow_sqlca within w_mreports
end type
type cb_cancel from uo_cb_base within w_mreports
end type
end forward

global type w_mreports from w_sale_base
int Width=2259
int Height=1337
boolean TitleBar=true
string Title="Meeting Reports"
dw_mreports dw_mreports
cb_new cb_new
cb_modify cb_modify
cb_delete cb_delete
dw_action_status dw_action_status
cb_update cb_update
cb_close cb_close
dw_list_together dw_list_together
cb_cancel cb_cancel
end type
global w_mreports w_mreports

type variables
s_chart istr_chart
Boolean ib_mod1,ib_mod2
end variables

forward prototypes
public subroutine wf_fill_list ()
public subroutine wf_buttons ()
public function integer wf_save ()
public subroutine wf_delete (long al_row)
end prototypes

public subroutine wf_fill_list ();dw_mreports.Retrieve(istr_chart.chart_nr)
dw_action_status.Retrieve(istr_chart.chart_nr)

Long ll_all_rows_r,ll_all_rows_s,ll_row,ll_new_row

/* Fill dummy-datawindow with charterers meeting reports */
ll_all_rows_r = dw_mreports.RowCount()
IF ll_all_rows_r > 0 THEN
	FOR ll_row = 1 TO ll_all_rows_r	
		dw_list_together.InsertRow(0)
		/* Copy columns */
		dw_list_together.SetItem(ll_row,"date",dw_mreports.GetItemDateTime(ll_Row,"ccs_mrep_d"))
		
/* Efterfølgende linie skal ændres til at hente kommentarfelt i stedet for desc */
		dw_list_together.SetItem(ll_row,"desc",dw_mreports.GetItemString(ll_Row,"ccs_mrep_desc"))
		
		dw_list_together.SetItem(ll_row,"key",dw_mreports.GetItemNumber(ll_Row,"ccs_mrep_pk"))
		dw_list_together.SetItem(ll_row,"rep_or_status","R")
	NEXT
END IF

/* Fill dummy-datawindow with charterers action status reports*/ 
ll_all_rows_s = dw_action_status.RowCount()
IF ll_all_rows_s > 0 THEN
	FOR ll_row =  1 TO  ll_all_rows_s	
		/* Copy columns */
		IF NOT IsNull(dw_action_status.GetItemDateTime(ll_Row,"ccs_acts_ccs_acts_sts_d")) THEN
			/* Only show actions with actual status description on */
			ll_new_row =	dw_list_together.InsertRow(0)
			dw_list_together.SetItem(ll_new_row,"date",dw_action_status.GetItemDateTime(ll_Row,"ccs_acts_ccs_acts_sts_d"))

/* Efterfølgende linie skal ændres til at hente kommentarfelt i stedet for desc */
			dw_list_together.SetItem(ll_new_row, "desc",dw_action_status.GetItemString(ll_Row,"ccs_acts_ccs_acts_sts_desc"))

			dw_list_together.SetItem(ll_new_row,"key",dw_action_status.GetItemNumber(ll_Row,"ccs_acts_ccs_acts_pk"))
			dw_list_together.SetItem(ll_new_row,"rep_or_status","S")
		END IF		
	NEXT
END IF
end subroutine

public subroutine wf_buttons ();cb_modify.Enabled = dw_list_together.GetSelectedRow(0) > 0
cb_delete.Enabled = cb_modify.Enabled

end subroutine

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mreports
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Checks all required fields before updating a meeting reports. 		 

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_allrows,ll_row,ll_tmprow

dw_list_together.AcceptText()

ll_allrows = dw_list_together.Rowcount()
//IF ll_allrows > 0 THEN
	/* Do not update before required fields have been entered*/
	FOR ll_row = 1 TO ll_allrows
		IF IsNull(dw_list_together.GetItemDateTime(ll_row,"date")) THEN
			MessageBox("Update Error","Please enter Meeting Report Date in row "+String(ll_row),Stopsign!)
			dw_list_together.ScrollToRow(ll_row)
			dw_list_together.SetColumn("date")
			dw_list_together.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_list_together.GetItemString(ll_row,"desc")) THEN
			MessageBox("Update Error","Please enter Meeting Report Description in row "+String(ll_row),Stopsign!)
			dw_list_together.ScrollToRow(ll_row)
			dw_list_together.SetColumn("desc")
			dw_list_together.SetFocus()
			Return 0
		END IF
	NEXT	



	/* For each row in the dummy window update its original datawindow */
	FOR ll_row = 1 TO ll_allrows
		CHOOSE CASE dw_list_together.GetItemString(ll_row,"rep_or_status")
			CASE "R"
			/* Enter changes to Meeting Report datawindow*/
				IF IsNull(dw_list_together.GetItemNumber(ll_row,"key")) THEN
					// A new meeting report
					ll_tmprow = dw_mreports.InsertRow(0)
					dw_mreports.SetItem(ll_tmprow,"chart_nr",istr_chart.chart_nr)
					dw_mreports.SetItem(ll_tmprow,"ccs_mrep_d",dw_list_together.GetItemDateTime(ll_row,"date"))
					dw_mreports.SetItem(ll_tmprow,"ccs_mrep_desc",dw_list_together.GetItemString(ll_row,"desc"))
				ELSE
					//Find and Modify an existing meeting report				
					ll_tmprow = dw_mreports.Find("ccs_mrep_pk = "&
							+String(dw_list_together.GetItemNumber(ll_row,"key")),1,dw_mreports.RowCount())
					dw_mreports.SetItem(ll_tmprow,"ccs_mrep_d",dw_list_together.GetItemDateTime(ll_row,"date"))
					dw_mreports.SetItem(ll_tmprow,"ccs_mrep_desc",dw_list_together.GetItemString(ll_row,"desc"))				
				END IF			

			CASE "S"
			/* Enter changes to action Status datawindow */			
				ll_tmprow = dw_action_status.Find("ccs_acts_ccs_acts_pk = "&
						+String(dw_list_together.GetItemNumber(ll_row,"key")),1,dw_action_status.RowCount())
				dw_action_status.SetItem(ll_tmprow,"ccs_acts_ccs_acts_sts_d",dw_list_together.GetItemDateTime(ll_row,"date"))
				dw_action_status.SetItem(ll_tmprow,"ccs_acts_ccs_acts_sts_desc",dw_list_together.GetItemString(ll_row,"desc"))				
		END CHOOSE
	NEXT

	
	/* Update the meeting report and action status datawindows */
	IF dw_mreports.Update() = 1 THEN
		IF dw_action_status.Update() = 1 THEN
		// Update ok
			COMMIT;
			// display updated window
			OpenWithParm(w_updated,0,w_tramos_main)
			Return 1
		ELSE
		// Update on action status failed
			Messagebox("DB Error","Couldn't update Action Status table. Please try later!") 
			ROLLBACK;
			Return 0
		END IF
		
	ELSE
	// Update on Meeting Report failed 
			Messagebox("DB Error","Couldn't update Meeting Report table. Please try later!") 
			ROLLBACK;
			Return 0
	END IF

	

//ELSE
//// No rows in list to update
//	Return 0
//END IF
//
end function

public subroutine wf_delete (long al_row);Long ll_tmprow


	ll_tmprow = dw_mreports.Find("ccs_mrep_pk = "&
							+String(dw_list_together.GetItemNumber(al_row,"key")),1,dw_mreports.RowCount())
	dw_mreports.DeleteRow(ll_tmprow)
	

end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mreports
  
 Object     : 
  
 Event	 :Open!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 26-08-96

 Description : Open the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
26-08-96		1.0 			JH		Initial version
  
************************************************************************************/

Pointer lp_old_pointer

/* Set pointer while opening */
lp_old_pointer =  SetPointer(HourGlass!)

istr_chart = Message.PowerObjectParm

This.Title = "Meeting Reports for: "+istr_chart.chart_sn

/* Set modicate flag to  stop itemChanged event in datawindow indicating  changes in dw. */  
ib_mod1 = FALSE

/* Fill dummy datawindow with data from meeting reports and action status datawindow */
wf_fill_list()

IF dw_list_together.RowCount() > 0 THEN
	/* Sort the data in dummy datawindow */
	dw_list_together.SetSort("date D,desc A")
	dw_list_together.Sort()
	/* Highlight the curent row*/
	dw_list_together.SelectRow(dw_list_together.GetRow(),TRUE)
	cb_update.Enabled = TRUE
END IF



wf_buttons()

/* Set modicate flag to indicate to itemChanged event i contact detail datawindow that modified flag can be set */  
ib_mod1 = TRUE	

SetPointer(lp_old_pointer)

end on

on w_mreports.create
int iCurrent
call w_sale_base::create
this.dw_mreports=create dw_mreports
this.cb_new=create cb_new
this.cb_modify=create cb_modify
this.cb_delete=create cb_delete
this.dw_action_status=create dw_action_status
this.cb_update=create cb_update
this.cb_close=create cb_close
this.dw_list_together=create dw_list_together
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_mreports
this.Control[iCurrent+2]=cb_new
this.Control[iCurrent+3]=cb_modify
this.Control[iCurrent+4]=cb_delete
this.Control[iCurrent+5]=dw_action_status
this.Control[iCurrent+6]=cb_update
this.Control[iCurrent+7]=cb_close
this.Control[iCurrent+8]=dw_list_together
this.Control[iCurrent+9]=cb_cancel
end on

on w_mreports.destroy
call w_sale_base::destroy
destroy(this.dw_mreports)
destroy(this.cb_new)
destroy(this.cb_modify)
destroy(this.cb_delete)
destroy(this.dw_action_status)
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.dw_list_together)
destroy(this.cb_cancel)
end on

type dw_mreports from u_datawindow_sqlca within w_mreports
int X=1884
int Y=369
int Width=202
int Height=113
int TabOrder=90
boolean Visible=false
string DataObject="d_meeting_reports"
end type

type cb_new from uo_cb_base within w_mreports
int X=1847
int Y=17
int Width=330
int Height=81
int TabOrder=20
string Text="New"
end type

on clicked;call uo_cb_base::clicked;Long ll_new_row

dw_list_together.SetRedraw(FALSE)

dw_list_together.SelectRow(0,FALSE)
ll_new_row = dw_list_together.InsertRow(0)
dw_list_together.SetItem(ll_new_row,"rep_or_status","R")
dw_list_together.ScrollToRow(ll_new_row)
dw_list_together.SelectRow(ll_new_row,TRUE)
dw_list_together.SetColumn(1)
dw_list_together.SetFocus()

dw_list_together.SetRedraw(TRUE)

cb_update.Enabled = TRUE
wf_buttons()


end on

type cb_modify from uo_cb_base within w_mreports
int X=1847
int Y=209
int Width=330
int Height=81
int TabOrder=40
string Text="Expand Text"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mreport
  
 Object     : cb_modify
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 26-08-96

 Description :Expands meeting report description field in a responce window; so the user can edit this 

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
Long ll_row

ll_row = dw_list_together.GetRow()

dw_list_together.AcceptText()
lstr_parm.text =dw_list_together.GetItemString(ll_row,"desc")  
lstr_parm.name = "Modify Meeting Report"


/* Open the responce window and wait for return */	
OpenWithParm(w_expand_text,lstr_parm)

ls_rtn = Message.StringParm
/* Test if changes were made */
IF ls_rtn <> "!" THEN
	/* Insert changed text field */
	dw_list_together.SetItem(ll_row,"desc",ls_rtn)
END IF

dw_list_together.SetFocus()

wf_buttons()




end on

type cb_delete from uo_cb_base within w_mreports
int X=1847
int Y=113
int Width=330
int Height=81
int TabOrder=30
string Text="Delete"
end type

event clicked;call super::clicked;Long ll_row
Integer li_ans


ll_row = dw_list_together.GetSelectedRow(0)


CHOOSE CASE dw_list_together.GetItemString(ll_row,"rep_or_status")
	CASE "R"
		li_ans = MessageBox("Warning","You are about to delete a Meeting Report. Continue?",Question!,YesNo!,2)
		IF li_ans = 1 THEN
			IF NOT IsNull(dw_list_together.GetItemNumber(ll_row,"key")) THEN
				wf_delete(ll_row)
			END IF	
			dw_list_together.DeleteRow(ll_row)
		END IF
	CASE "S"
		li_ans = MessageBox("Warning","This is an Action Status Report. It can not be deleted here.")
		
END CHOOSE



	

	
//	/* Update the meeting report and action status datawindows */
//	IF dw_mreports.Update() = 1 THEN
//		IF dw_action_status.Update() = 1 THEN
//		// Update ok
//			COMMIT;
//			// display updated window
//			OpenWithParm(w_updated,0,w_tramos_main)
//			Return 1
//		ELSE
//		// Update on action status failed 
//			ROLLBACK;
//			Return 0
//		END IF
//	ELSE
//	// Update on Meeting Report failed 
//			ROLLBACK;
//			Return 0
//	END IF




wf_buttons()
end event

type dw_action_status from u_datawindow_sqlca within w_mreports
int X=1866
int Y=625
int Width=129
int Height=161
int TabOrder=80
boolean Visible=false
string DataObject="d_status_reports"
end type

type cb_update from uo_cb_base within w_mreports
int X=1482
int Y=1121
int Width=330
int Height=81
int TabOrder=60
boolean Enabled=false
string Text="Update"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mreports
  
 Object     : cb_update
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Update Meeting reports and action status description

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/

IF wf_save() = 1 THEN
	Close(Parent)
END IF


end on

type cb_close from uo_cb_base within w_mreports
int X=1847
int Y=1121
int Width=330
int Height=81
int TabOrder=70
string Text="Close"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mreports
  
 Object     : cb_closed
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 26-08-96

 Description : Close the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
26-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_ans


dw_list_together.AcceptText()

/* test if any changes were made */
IF  ib_mod2   THEN
	li_ans = MessageBox("Warning","You have modified Meeting Reports! Do you wish to save "&
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

type dw_list_together from u_datawindow_sqlca within w_mreports
int X=19
int Y=17
int Width=1793
int Height=1073
int TabOrder=10
string DataObject="d_meet_stat"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/* run ancestor script*/
ib_auto = TRUE

wf_buttons()
end on

on itemchanged;call u_datawindow_sqlca::itemchanged;IF ib_mod1 THEN
	/* Changes to the datawindow must be indicated */
	ib_mod2 = TRUE
END IF
end on

on clicked;call u_datawindow_sqlca::clicked;/* run ancestor script*/
ib_auto = TRUE

wf_buttons()
end on

type cb_cancel from uo_cb_base within w_mreports
int X=1116
int Y=1121
int Width=330
int Height=81
int TabOrder=50
string Text="Cancel"
end type

on clicked;call uo_cb_base::clicked;Long ll_row,ll_all_rows

dw_list_together.SetRedraw(FALSE)

ll_all_rows = dw_list_together.RowCount() 

IF ll_all_rows > 0 THEN
	/* Clear dummy datawindow for rows*/
	FOR ll_row = 1 TO ll_all_rows
		dw_list_together.DeleteRow(1)
	NEXT

	/* Insert original rows into dummy datawindow */
	wf_fill_list()

	IF dw_list_together.RowCount() > 0 THEN
		dw_list_together.SetSort("date D,desc A")
		dw_list_together.Sort()
	
		dw_list_together.SelectRow(0,FALSE)
		dw_list_together.SelectRow(dw_list_together.GetRow(),TRUE)
	END IF
	
	wf_buttons()
END IF

dw_list_together.SetRedraw(TRUE)

end on

