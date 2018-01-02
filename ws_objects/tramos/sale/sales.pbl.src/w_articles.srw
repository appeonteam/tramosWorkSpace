$PBExportHeader$w_articles.srw
$PBExportComments$This window lets the user edit the list of articles for a selected charterer.
forward
global type w_articles from w_sale_base
end type
type dw_list from u_datawindow_sqlca within w_articles
end type
type st_find from uo_st_base within w_articles
end type
type sle_find from uo_sle_base within w_articles
end type
type rb_date from uo_rb_base within w_articles
end type
type rb_headline from uo_rb_base within w_articles
end type
type rb_source from uo_rb_base within w_articles
end type
type cb_new from uo_cb_base within w_articles
end type
type cb_delete from uo_cb_base within w_articles
end type
type cb_close from uo_cb_base within w_articles
end type
type cb_update from uo_cb_base within w_articles
end type
type cb_refresh from uo_cb_base within w_articles
end type
type gb_sortsearch from uo_gb_base within w_articles
end type
end forward

global type w_articles from w_sale_base
int X=51
int Y=405
int Width=2812
int Height=1121
dw_list dw_list
st_find st_find
sle_find sle_find
rb_date rb_date
rb_headline rb_headline
rb_source rb_source
cb_new cb_new
cb_delete cb_delete
cb_close cb_close
cb_update cb_update
cb_refresh cb_refresh
gb_sortsearch gb_sortsearch
end type
global w_articles w_articles

type variables
s_chart istr_chart
String is_filter = "",is_current_column = "ccs_artc_d"
Long il_selectedrow
Boolean ib_mod1, ib_mod2
end variables

forward prototypes
public function integer wf_save ()
public subroutine wf_select_column (string as_column_name)
public subroutine wf_buttons ()
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Jeannettte Holland
   
 Date       : 19-08-96

 Description : Checks all required fields before updating articles		 

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_allrows,ll_row




/* Check all fields are entered in articles */

dw_list.AcceptText()
ll_allrows = dw_list.Rowcount()
IF ll_allrows > 0 THEN
	FOR ll_row = 1 TO ll_allrows
		IF IsNull(dw_list.GetItemDateTime(ll_row,"ccs_artc_d")) THEN
			MessageBox("Update Error","Please enter Date of Article in row "+String(ll_row),Stopsign!)
			dw_list.ScrollToRow(ll_row)
			dw_list.SetColumn("ccs_artc_d")
			dw_list.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_list.GetItemString(ll_row,"ccs_artc_head")) OR dw_list.GetItemString(ll_row,"ccs_artc_head") = "" THEN
			MessageBox("Update Error","Please enter Article's Headline in row "+String(ll_row),Stopsign!)
			dw_list.ScrollToRow(ll_row)
			dw_list.SetColumn("ccs_artc_head")
			dw_list.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_list.GetItemString(ll_row,"ccs_artc_sourc")) OR dw_list.GetItemString(ll_row,"ccs_artc_sourc") = "" THEN
			MessageBox("Update Error","Please enter Article Source in row "+String(ll_row),Stopsign!)
			dw_list.ScrollToRow(ll_row)
			dw_list.SetColumn("ccs_artc_sourc")
			dw_list.SetFocus()
		Return 0
		END IF
	NEXT	
END IF




IF f_update(dw_list,w_tramos_main) THEN	
	Return 1
ELSE
	Return 0
END IF

end function

public subroutine wf_select_column (string as_column_name);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : wf_select_column 
  
 Event	 : 

 Scope     : public
 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-08-96

 Description :Selects sort/search column in datawindow and sorts rows for this column in assending order.

 Arguments : A string giving the name of the column to be sorted 

 Returns   : none  

 Variables : The highlighed row: 'il_selectedrow'; the current column: 'is_current_column' and
			the find-string in edit field: 'is_filter'  in datawindow

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

is_current_column = as_column_name

dw_list.SelectRow(0,False)

CHOOSE CASE is_current_column
	CASE "ccs_artc_d"
	// It is a date column
		dw_list.SetSort(is_current_column+" D")
	CASE ELSE
		dw_list.SetSort(is_current_column+" A")
END CHOOSE

dw_list.Sort()
dw_list.SelectRow(1,TRUE)

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

end subroutine

public subroutine wf_buttons ();cb_delete.enabled = il_selectedrow > 0
cb_update.enabled = cb_delete.enabled

end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : 
  
 Event	 : Open!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-08-96

 Description : Lets the user edit list of articles for specified charterer

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A s_chart parsed in Message.PowerObjectParm

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

This.move(51,160)

istr_chart = Message.PowerObjectParm 
dw_list.Retrieve(istr_chart.chart_nr)
COMMIT USING SQLCA;

This.Title = "Articles for Charterer: "+istr_chart.chart_sn

wf_buttons()

sle_find.SetFocus()
end on

on w_articles.create
int iCurrent
call w_sale_base::create
this.dw_list=create dw_list
this.st_find=create st_find
this.sle_find=create sle_find
this.rb_date=create rb_date
this.rb_headline=create rb_headline
this.rb_source=create rb_source
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_refresh=create cb_refresh
this.gb_sortsearch=create gb_sortsearch
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_list
this.Control[iCurrent+2]=st_find
this.Control[iCurrent+3]=sle_find
this.Control[iCurrent+4]=rb_date
this.Control[iCurrent+5]=rb_headline
this.Control[iCurrent+6]=rb_source
this.Control[iCurrent+7]=cb_new
this.Control[iCurrent+8]=cb_delete
this.Control[iCurrent+9]=cb_close
this.Control[iCurrent+10]=cb_update
this.Control[iCurrent+11]=cb_refresh
this.Control[iCurrent+12]=gb_sortsearch
end on

on w_articles.destroy
call w_sale_base::destroy
destroy(this.dw_list)
destroy(this.st_find)
destroy(this.sle_find)
destroy(this.rb_date)
destroy(this.rb_headline)
destroy(this.rb_source)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_refresh)
destroy(this.gb_sortsearch)
end on

type dw_list from u_datawindow_sqlca within w_articles
int X=19
int Y=113
int Width=2323
int Height=769
int TabOrder=60
string DataObject="d_articles"
boolean VScrollBar=true
end type

on clicked;call u_datawindow_sqlca::clicked;
This.SelectRow(0,FALSE)

il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

wf_buttons()
end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;
This.SelectRow(0,FALSE)

il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

wf_buttons()
end on

type st_find from uo_st_base within w_articles
int X=37
int Y=17
int Width=147
int Height=65
string Text="Find:"
Alignment Alignment=Left!
end type

type sle_find from uo_sle_base within w_articles
event ue_keydown pbm_keydown
int X=202
int Y=17
int Width=1189
int Height=81
int TabOrder=10
end type

on ue_keydown;call uo_sle_base::ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : sle_find
  
 Event	 : ue_keydown

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-07-96

 Description :  Find matching string and posistion in datawindow.  

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Script copied from Martins code in w_list key_pressed script for sle_find

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

/* key pressed in datawindow
 capture up and down arrows to move the selection up and down*/

int li_movement 
long ll_row

If KeyDown (keyUparrow!) then
	li_movement = -1
End If


If KeyDown (keyDownarrow!) then
	li_movement = 1
End If

If li_movement <> 0 Then
	dw_list.SetRedraw(False)
	ll_row = dw_list.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_list.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_list.selectrow(0,False)
	dw_list.SelectRow(ll_row , True)
	dw_list.ScrollToRow (ll_row)

	IF dw_list.Describe(is_current_column+".ColType") = "datetime"  THEN
		sle_find.text = String(dw_list.GetItemDateTime(ll_row, is_current_column))	
	ELSE
		sle_find.text = dw_list.GetItemString(ll_row, is_current_column)		
	END IF
	

	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_list.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true
	Return
End If


/*Backspace*/ 

string	ls_character
long	ll_found_row
int		li_num_chars

ls_character = Char(message.wordparm)

If message.wordparm = 8   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
end if


/* Do case-insensitive search*/
String ls_tmp	
IF Len(is_filter) > 0 THEN
	IF dw_list.Describe(is_current_column+".ColType") = "datetime"  THEN
		ls_tmp = "Left(String("+is_current_column+"), " + String(len(is_filter))+ " )='"+is_filter+"'"
//		MessageBox("info", ls_tmp)
		ll_found_row = dw_list.Find(ls_tmp,1,99999)
	ELSE
		ll_found_row = dw_list.Find(Lower(is_current_column) + ">='" + Lower(is_filter) + "'",1, 99999)
	END IF

	IF ll_found_row > 0 THEN 
		dw_list.SetRedraw(FALSE)
		dw_list.SelectRow(0, FALSE)
		dw_list.ScrollToRow(ll_found_row)
		dw_list.SelectRow(ll_found_row, TRUE)
		dw_list.SetRedraw(TRUE)
	/* is_filterer function did not find any matching row*/
	ELSE
            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
	/* Throw away last character*/
		message.processed = true
	END IF
	/* is_filter er length is 0, so unhighlight former selected row*/
ELSE
	dw_list.SelectRow(0, FALSE)
	ll_found_row = 0
END IF

/* Remember number of highlighted row*/
il_selectedrow = ll_found_row	

wf_buttons()		


end on

type rb_date from uo_rb_base within w_articles
int X=2414
int Y=65
int TabOrder=30
string Text="Date"
boolean Checked=true
end type

on clicked;call uo_rb_base::clicked;wf_select_column("ccs_artc_d")
end on

type rb_headline from uo_rb_base within w_articles
int X=2414
int Y=145
int Width=293
int Height=65
int TabOrder=40
string Text="Headline"
end type

on clicked;call uo_rb_base::clicked;wf_select_column("ccs_artc_head")
end on

type rb_source from uo_rb_base within w_articles
int X=2414
int Y=217
int TabOrder=50
string Text="Source"
end type

on clicked;call uo_rb_base::clicked;wf_select_column("ccs_artc_sourc")
end on

type cb_new from uo_cb_base within w_articles
int X=2396
int Y=385
int Width=348
int Height=81
int TabOrder=70
string Text="&New"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : cb_new
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-08-96

 Description : Insert new row in article list to create new article

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0 			JH		Initial version
  
************************************************************************************/
//Long ll_newrow

	dw_list.SelectRow(0,False)
	il_selectedrow = dw_list.InsertRow(0)
	dw_list.SetItem(il_selectedrow,"chart_nr",istr_chart.chart_nr)
	dw_list.ScrollToRow(il_selectedrow)
	dw_list.SelectRow(il_selectedrow,TRUE)
	dw_list.SetColumn("ccs_artc_d")
	dw_list.SetFocus()

	wf_buttons()
end on

type cb_delete from uo_cb_base within w_articles
int X=2396
int Y=481
int Width=348
int Height=81
int TabOrder=80
string Text="&Delete"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : cb_delete
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-08-96

 Description : Delete row in article list 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_ans
Long ll_row


li_ans = MessageBox("Warning","You are about to delete an article. Continue?",Question!,YesNo!,2)
IF li_ans = 1 THEN
// Process Yes
	ll_row = dw_list.GetRow()
	dw_list.DeleteRow(ll_row)
	IF dw_list.Rowcount() < 1 THEN
		This.Enabled = FALSE
		cb_update.Enabled = TRUE
	ELSE
		dw_list.SetFocus()
	END IF
END IF

end on

type cb_close from uo_cb_base within w_articles
int X=1555
int Y=913
int Width=348
int Height=81
int TabOrder=110
string Text="Close"
boolean Cancel=true
end type

on clicked;call uo_cb_base::clicked;Integer li_ans

/* test if any changes were made */
dw_list.AcceptText()

IF dw_list.ModifiedCount() > 0 THEN
	li_ans = MessageBox("Warning","You have modified Articles! Do you wish to save "&
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

type cb_update from uo_cb_base within w_articles
int X=1171
int Y=913
int Width=348
int Height=81
int TabOrder=100
string Text="&Update"
end type

on clicked;call uo_cb_base::clicked;IF wf_save() = 1 THEN
	Close(Parent)
END IF

end on

type cb_refresh from uo_cb_base within w_articles
int X=787
int Y=913
int Width=348
int Height=81
int TabOrder=90
string Text="&Refresh"
end type

on clicked;call uo_cb_base::clicked;sle_find.Text = ""
dw_list.Retrieve(istr_chart.chart_nr)

dw_list.SelectRow(0,FALSE)

il_selectedrow = dw_list.GetRow()
dw_list.SelectRow(il_selectedrow,TRUE)

wf_buttons()


end on

type gb_sortsearch from uo_gb_base within w_articles
int X=2359
int Y=1
int Width=403
int Height=321
int TabOrder=20
string Text="Sort/Search"
end type

