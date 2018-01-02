$PBExportHeader$w_userlist_management.srw
$PBExportComments$User List for management approval
forward
global type w_userlist_management from mt_w_sheet
end type
type st_rows from statictext within w_userlist_management
end type
type dw_list from mt_u_datawindow within w_userlist_management
end type
type cb_save from mt_u_commandbutton within w_userlist_management
end type
type cb_retrieve from mt_u_commandbutton within w_userlist_management
end type
end forward

global type w_userlist_management from mt_w_sheet
integer width = 4626
integer height = 2516
string title = "User List - Management"
st_rows st_rows
dw_list dw_list
cb_save cb_save
cb_retrieve cb_retrieve
end type
global w_userlist_management w_userlist_management

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_userlist_management
   <OBJECT> List of users - management list 	</OBJECT>
   <USAGE> List is created twice a year and is sent to managers for approval
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments	
   08/06/11	CR2460	JMC112	First Version
</HISTORY>    
********************************************************************/
end subroutine

on w_userlist_management.create
int iCurrent
call super::create
this.st_rows=create st_rows
this.dw_list=create dw_list
this.cb_save=create cb_save
this.cb_retrieve=create cb_retrieve
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_rows
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.cb_save
this.Control[iCurrent+4]=this.cb_retrieve
end on

on w_userlist_management.destroy
call super::destroy
destroy(this.st_rows)
destroy(this.dw_list)
destroy(this.cb_save)
destroy(this.cb_retrieve)
end on

event open;call super::open;
n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

dw_list.setredraw(FALSE)

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")

lnv_dwStyle.of_dwlistformater(dw_list, true)

dw_list.setredraw(TRUE)
end event

type st_rows from statictext within w_userlist_management
integer x = 41
integer y = 2288
integer width = 1705
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type dw_list from mt_u_datawindow within w_userlist_management
integer x = 37
integer y = 44
integer width = 4507
integer height = 2228
integer taborder = 10
string dataobject = "d_sq_tb_userlist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean ib_columntitlesort = true
end type

type cb_save from mt_u_commandbutton within w_userlist_management
integer x = 3835
integer y = 2292
integer taborder = 20
string text = "Save as..."
end type

event clicked;call super::clicked;dw_list.saveas()
end event

type cb_retrieve from mt_u_commandbutton within w_userlist_management
integer x = 4206
integer y = 2292
integer taborder = 10
string text = "Retrieve"
end type

event clicked;call super::clicked;//Retrieves data

long	ll_row, ll_rows, ll_totalpc
long	ll_user_number_pc, ll_rowpc, ll_rowspc
string	ls_pclist, ls_userid
mt_n_datastore	lds_userpc

st_rows.text = "" 

dw_list.setredraw(FALSE)

select count(*)
INTO :ll_totalpc
FROM PROFIT_C;
COMMIT USING SQLCA;

dw_list.SetTransObject(SQLCA)

lds_userpc = create mt_n_datastore
lds_userpc.dataobject = "d_profit_center_name"
lds_userpc.SetTransObject(SQLCA)

ll_rows = dw_list.Retrieve()

//Write the list of profit centers that the user has access
for ll_row = 1 to ll_rows
	ls_pclist = ""
	ll_user_number_pc = dw_list.getitemnumber(ll_row, "countpc" )
	if ll_user_number_pc <> ll_totalpc then
		ls_userid = dw_list.getitemstring(ll_row, "userid" )
		ll_rowspc = lds_userpc.retrieve(ls_userid)
		for ll_rowpc=1 to ll_rowspc
			ls_pclist = ls_pclist + lds_userpc.getitemstring(ll_rowpc, "pc_name") + ", "
		next 
		dw_list.setitem(ll_row, "profit_center_list", ls_pclist)
	end if
next 

dw_list.accepttext()

st_rows.text = string(ll_rows) + " rows" 

dw_list.setredraw(TRUE)

destroy(lds_userpc)
end event

