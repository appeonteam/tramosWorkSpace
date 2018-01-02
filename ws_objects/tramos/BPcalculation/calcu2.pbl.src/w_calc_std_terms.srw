$PBExportHeader$w_calc_std_terms.srw
$PBExportComments$Window for standard terms
forward
global type w_calc_std_terms from mt_w_response_calc
end type
type cb_1 from uo_cb_base within w_calc_std_terms
end type
type cb_close from uo_cb_base within w_calc_std_terms
end type
type dw_calc_std_terms from u_datawindow_sqlca within w_calc_std_terms
end type
type gb_1 from uo_gb_base within w_calc_std_terms
end type
end forward

global type w_calc_std_terms from mt_w_response_calc
integer x = 187
integer y = 140
integer width = 2089
integer height = 1476
string title = "Standard Terms"
cb_1 cb_1
cb_close cb_close
dw_calc_std_terms dw_calc_std_terms
gb_1 gb_1
end type
global w_calc_std_terms w_calc_std_terms

forward prototypes
public subroutine wf_save ()
public subroutine documentation ()
end prototypes

public subroutine wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_std_terms
  
 Object     : cb_save
  
 Event	 : clicked

 Scope     : lokal

 ************************************************************************************

 Author    : Teit Aunt
   
 Date       : 29-7-96

 Description : Updateing the modifikations made to the term's

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
17-7-1996	1.0			TA		Initial version  
************************************************************************************/
/*  Updateing the modifikations made to the term's */

Long ll_len, ll_rows
string ls_term
char lc_one, lc_two
boolean lb_ok = False

dw_calc_std_terms.AcceptText()
ll_rows = dw_calc_std_terms.RowCount()

ls_term = dw_calc_std_terms.GetItemString(ll_rows,"cal_ster_text")
ll_len = Len(ls_term)
If Not IsNull(ll_len) Or (ll_len <> 0) Then
	lc_one = Mid(ls_term, ll_len - 1, 1)
	lc_two = Mid(ls_term, ll_len, 1)
	If (Asc(lc_one) <> 13) Or (Asc(lc_two) <> 10)  Then
		ls_term = ls_term + "~r~n"
		dw_calc_std_terms.SetItem(ll_rows, "cal_ster_text", ls_term)
	End if
	If dw_calc_std_terms.Update(true,false)=1 Then
		COMMIT USING SQLCA;
		Open(w_updated)
		dw_calc_std_terms.ResetUpdate()
		lb_ok = True
	Else
		ROLLBACK USING SQLCA;
		MessageBox("Error","Not able to save text due to update error!")
	End If
End If

end subroutine

public subroutine documentation ();/********************************************************************
   w_calc_std_terms
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_std_terms
  
 Object     : 
  
 Event	 :  open

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 29-7-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
29-7-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Retrive data for terms data window */


long ll_rows
integer ll_TermNo

ll_TermNo = message.DoubleParm
If ll_TermNo > 0 Then
	ll_rows = dw_calc_std_terms.Retrieve(ll_TermNo )
	COMMIT;
	IF ll_rows < 1 THEN MessageBox( "Error","No terms retrieved." )
Else
	/* Scroll to a new row at the end of the table (from the new view button in the w_calc_std_terms window) */
	long ll_CurRow
	ll_CurRow = dw_calc_std_terms.InsertRow(0)
	dw_calc_std_terms.ScrollToRow(ll_CurRow)
End If

f_center_window(this)
end event

on w_calc_std_terms.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_close=create cb_close
this.dw_calc_std_terms=create dw_calc_std_terms
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_calc_std_terms
this.Control[iCurrent+4]=this.gb_1
end on

on w_calc_std_terms.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_close)
destroy(this.dw_calc_std_terms)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_std_terms
end type

type cb_1 from uo_cb_base within w_calc_std_terms
integer x = 1463
integer y = 1248
integer width = 256
integer height = 96
integer taborder = 30
string text = "&Update"
end type

event clicked;call super::clicked;dw_calc_std_terms.AcceptText()
wf_save()


end event

type cb_close from uo_cb_base within w_calc_std_terms
integer x = 1755
integer y = 1248
integer width = 238
integer height = 96
integer taborder = 40
string text = "&Close"
end type

event clicked;call super::clicked;dw_calc_std_terms.AcceptText()

If dw_calc_std_terms.ModifiedCount() > 0 Then
	If  MessageBox("Notice","You have unsave data. Do you want to save your changes ?",Question!,YesNo!,2) = 1 Then
		wf_save()
		Close(w_calc_std_terms)
	Else
		Close(w_calc_std_terms)
	End If
Else
	Close(w_calc_std_terms)
End If

end event

type dw_calc_std_terms from u_datawindow_sqlca within w_calc_std_terms
integer x = 55
integer y = 64
integer width = 1957
integer height = 1184
integer taborder = 10
string dataobject = "d_calc_std_terms"
boolean border = false
end type

type gb_1 from uo_gb_base within w_calc_std_terms
integer x = 18
integer width = 2030
integer height = 1376
integer taborder = 20
long backcolor = 81324524
string text = ""
end type

