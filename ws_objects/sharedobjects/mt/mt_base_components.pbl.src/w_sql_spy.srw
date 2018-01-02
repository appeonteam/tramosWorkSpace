$PBExportHeader$w_sql_spy.srw
forward
global type w_sql_spy from mt_w_sheet
end type
type mle_sql from mt_u_multilineedit within w_sql_spy
end type
end forward

global type w_sql_spy from mt_w_sheet
mle_sql mle_sql
end type
global w_sql_spy w_sql_spy

forward prototypes
public subroutine wf_addtext (string as_classname, string as_start_end, long al_rowcount)
public subroutine wf_addtext (string as_classname, string as_text, sqlpreviewfunction request, sqlpreviewtype sqltype)
public subroutine documentation ()
end prototypes

public subroutine wf_addtext (string as_classname, string as_start_end, long al_rowcount);/********************************************************************
   wf_addText
   <DESC> Adds message into MultiLineEdit after a database transaction has been
	performed </DESC>
   <RETURN> (None) </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  as_className: From where is this function called
            		as_start_end: Which action/event was fired
				al_rowCount: If end of retrieval, how many rows retrieved /ARGS>
   <USAGE>  </USAGE>
********************************************************************/
mle_sql.SetRedraw(FALSE)

IF as_start_end = 'START' THEN
	mle_sql.Text = mle_sql.Text + as_className + &
								' Retrieve Start at: ' + String(Now(), 'HH:MM:SS:FF') + '.~r~n'
ELSEIF as_start_end = 'END' THEN
	mle_sql.Text = mle_sql.Text + as_className + &
								' Retrieve End at: ' + String(Now(), 'HH:MM:SS:FF') + &
								', Rows Retrieved: ' + String(al_rowCount) + '.~r~n~r~n'
ELSEIF as_start_end = 'COMMIT' THEN
	mle_sql.Text = mle_sql.Text + as_className + &
								' performed COMMIT at: ' + String(Now(), 'HH:MM:SS') + '.~r~n~r~n'
ELSEIF as_start_end = 'ROLLBACK' THEN
	mle_sql.Text = mle_sql.Text + as_className + &
								' performed ROLLBACK at: ' + String(Now(), 'HH:MM:SS') + '.~r~n~r~n'
ELSE
	MessageBox('Sql Spy', 'Invalid Parameter', StopSign!)
END IF

mle_sql.SetRedraw(TRUE)
end subroutine

public subroutine wf_addtext (string as_classname, string as_text, sqlpreviewfunction request, sqlpreviewtype sqltype);/********************************************************************
   wf_addText
   <DESC> Adds message into MultiLineEdit after a database transaction has been
	performed </DESC>
   <RETURN> (None) </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  as_className: From where is this function called
            		as_start_end: Which action/event was fired
				al_rowCount: If end of retrieval, how many rows retrieved /ARGS>
   <USAGE>  </USAGE>
	<History>
	09/07-13  CR3254	LHC010		Replace n_string_service
	</History>
********************************************************************/

mle_sql.SetRedraw(FALSE)

mt_n_stringfunctions	lnv_stringService

as_text = lnv_stringService.of_replaceAll(as_text, '~r~n', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '~t', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, '  ', ' ', true)
as_text = lnv_stringService.of_replaceAll(as_text, ',', ', ', true)

IF sqltype = PreviewSelect! THEN // SELECT STATEMENT
	mle_sql.Text = mle_sql.Text + as_text + '~r~n'
ELSE
	mle_sql.Text = mle_sql.Text + as_className + ': ' + as_text + '~r~n~r~n'
END IF

mle_sql.SetRedraw(TRUE)


end subroutine

public subroutine documentation ();/********************************************************************
   w_sql_spy: Used to monitor communication to the database
   <OBJECT> When this window is open, all activity from and to the database is monitored
	and shown. There are two functions registred for the window one is called from 
	datastore/datawindow sqlpreview event</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    Author        Comments
  04/07-08 	?      	rmo003     	Initial version
  09/07-13  CR3254	LHC010		Replace n_string_service
********************************************************************/

end subroutine

on w_sql_spy.create
int iCurrent
call super::create
this.mle_sql=create mle_sql
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_sql
end on

on w_sql_spy.destroy
call super::destroy
destroy(this.mle_sql)
end on

type mle_sql from mt_u_multilineedit within w_sql_spy
integer x = 32
integer y = 20
integer width = 2400
integer height = 1104
integer taborder = 10
string text = ""
boolean vscrollbar = true
end type

