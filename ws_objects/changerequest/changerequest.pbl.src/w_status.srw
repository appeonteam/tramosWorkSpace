$PBExportHeader$w_status.srw
$PBExportComments$Maintain Change Request Status
forward
global type w_status from w_system_base
end type
type vtb_red from vtrackbar within w_status
end type
type vtb_green from vtrackbar within w_status
end type
type vtb_blue from vtrackbar within w_status
end type
type st_1 from statictext within w_status
end type
type st_2 from statictext within w_status
end type
type st_3 from statictext within w_status
end type
type gb_1 from groupbox within w_status
end type
end forward

global type w_status from w_system_base
integer width = 3593
integer height = 1232
string title = "Statuses"
vtb_red vtb_red
vtb_green vtb_green
vtb_blue vtb_blue
st_1 st_1
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_status w_status

forward prototypes
public subroutine wf_trackmoved ()
public subroutine wf_settrack (long al_color)
public subroutine documentation ()
end prototypes

public subroutine wf_trackmoved ();long 	ll_row

ll_row = dw_1.getrow()
if ll_row < 1 then return

dw_1.setItem(ll_row, "text_color", rgb(vtb_red.position,vtb_green.position,vtb_blue.position))

return
end subroutine

public subroutine wf_settrack (long al_color);long 	ll_red, ll_green, ll_blue

ll_blue 	= 	int(al_color/65536)
ll_green	=	int(mod(al_color,65536)/256)
ll_red 	=  mod(mod(al_color,65536),256)

vtb_red.position		= ll_red
vtb_green.position	= ll_green
vtb_blue.position		= ll_blue

return
end subroutine

public subroutine documentation ();/********************************************************************
   w_status
   <OBJECT>		CREQ Status maintain	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01-29-2013 CR2614       LHG008        Change GUI
   	18/07/2013 CR3254       LHG008        Fix stuff related with Initial status/Rejected status
	28/08/2014	CR3781	    CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_status.create
int iCurrent
call super::create
this.vtb_red=create vtb_red
this.vtb_green=create vtb_green
this.vtb_blue=create vtb_blue
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.vtb_red
this.Control[iCurrent+2]=this.vtb_green
this.Control[iCurrent+3]=this.vtb_blue
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.gb_1
end on

on w_status.destroy
call super::destroy
destroy(this.vtb_red)
destroy(this.vtb_green)
destroy(this.vtb_blue)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"status_description", "status_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_status
end type

type cb_cancel from w_system_base`cb_cancel within w_status
integer x = 3205
integer y = 1024
end type

type cb_refresh from w_system_base`cb_refresh within w_status
integer x = 4059
integer y = 288
end type

type cb_delete from w_system_base`cb_delete within w_status
integer x = 2857
integer y = 1024
end type

event cb_delete::clicked;long ll_cont, ll_status_id

ll_status_id = dw_1.getitemnumber(dw_1.getrow(), "status_id")
//Check dependence
if not isnull(ll_status_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.STATUS_ID = :ll_status_id
		AND CREQ_REQUEST.STATUS_ID IS NOT NULL;
		
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM CREQ_TYPE_STATUS
		 WHERE CREQ_TYPE_STATUS.STATUS_ID = :ll_status_id
			AND CREQ_TYPE_STATUS.STATUS_ID IS NOT NULL;
	end if
	
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM CREQ_STATUS_CHANGED_LOG
		 WHERE CREQ_STATUS_CHANGED_LOG.STATUS_ID = :ll_status_id
			AND CREQ_STATUS_CHANGED_LOG.STATUS_ID IS NOT NULL;
	end if
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this status.")
	return
end if

call super::clicked

end event

type cb_update from w_system_base`cb_update within w_status
integer x = 2510
integer y = 1024
end type

event cb_update::clicked;long 		ll_row
integer	li_count

for ll_row = 1 to dw_1.rowcount()
	if dw_1.getitemnumber(ll_row, "initial_status") = 1 then
		li_count++
	end if
next
if li_count <> 1 then
	messagebox("Validation", "There must be one and only one status marked as Initial")
	return c#return.Failure
end if

li_count=0
for ll_row = 1 to dw_1.rowcount()
	if dw_1.getitemnumber(ll_row, "rejected_status") = 1 then
		li_count++
	end if
	if isnull(dw_1.getitemnumber(ll_row, "text_color")) then
		dw_1.setitem(ll_row, "text_color", 1)
	end if
next
if li_count <> 1 then
	messagebox("Validation", "There must be one and only one status marked as Rejected")
	return c#return.Failure
end if

call super::clicked

if ancestorreturnvalue = C#Return.Success then
	if isvalid(w_type) then
		w_type.event ue_refresh_initialstatus()
	end if
end if

return ancestorreturnvalue
end event

type cb_new from w_system_base`cb_new within w_status
integer x = 2162
integer y = 1024
end type

type dw_1 from w_system_base`dw_1 within w_status
integer width = 2779
integer height = 976
string dataobject = "d_sq_gr_status"
end type

event dw_1::rowfocuschanged;if currentrow < 1 then return

wf_setTrack(this.getItemNumber(currentrow, "text_color"))
end event

event dw_1::itemchanged;call super::itemchanged;string ls_colname
long ll_find

ls_colname = dwo.name
choose case ls_colname
	case "initial_status", "rejected_status"
		if data = '1' then
			ll_find = this.find(ls_colname + " = 1", 1, this.rowcount())
			if ll_find > 0 then
				this.setitem(ll_find, ls_colname, 0)
			end if
			messagebox("Warning", "You must Maintain Types and Work Flow after you changed " + this.describe(ls_colname + ".CheckBox.Text") + " Status")
		else
			messagebox("Infomation", "There must be one and only one status marked as " +	this.describe(ls_colname + ".CheckBox.Text"))
			return 2
		end if
end choose
end event

type vtb_red from vtrackbar within w_status
integer x = 2926
integer y = 120
integer width = 146
integer height = 880
boolean bringtotop = true
integer maxposition = 255
integer tickfrequency = 10
end type

event moved;wf_trackmoved()
end event

type vtb_green from vtrackbar within w_status
integer x = 3127
integer y = 120
integer width = 146
integer height = 880
boolean bringtotop = true
integer maxposition = 255
integer tickfrequency = 10
end type

event moved;wf_trackmoved()
end event

type vtb_blue from vtrackbar within w_status
integer x = 3328
integer y = 120
integer width = 146
integer height = 880
boolean bringtotop = true
integer maxposition = 255
integer tickfrequency = 10
end type

event moved;wf_trackmoved()
end event

type st_1 from statictext within w_status
integer x = 2935
integer y = 76
integer width = 128
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Red"
boolean focusrectangle = false
end type

type st_2 from statictext within w_status
integer x = 3109
integer y = 76
integer width = 183
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 32768
long backcolor = 67108864
string text = "Green"
boolean focusrectangle = false
end type

type st_3 from statictext within w_status
integer x = 3333
integer y = 76
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "Blue"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_status
integer x = 2853
integer y = 16
integer width = 695
integer height = 992
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Text Color"
end type

