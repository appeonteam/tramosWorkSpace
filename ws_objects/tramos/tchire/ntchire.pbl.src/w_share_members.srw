$PBExportHeader$w_share_members.srw
$PBExportComments$This window is linked to TC Contract.
forward
global type w_share_members from mt_w_response
end type
type cb_delete from commandbutton within w_share_members
end type
type cb_insert from commandbutton within w_share_members
end type
type cb_cancel from commandbutton within w_share_members
end type
type dw_members from u_ntchire_grid_dw within w_share_members
end type
end forward

global type w_share_members from mt_w_response
integer x = 800
integer y = 400
integer width = 2153
integer height = 1440
string title = "Enter Share Members"
boolean ib_setdefaultbackgroundcolor = true
cb_delete cb_delete
cb_insert cb_insert
cb_cancel cb_cancel
dw_members dw_members
end type
global w_share_members w_share_members

type variables
long 	il_contractID
n_ds	ids_data
n_service_manager inv_servicemgr
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_validate ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_share_members
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
		Date			CR-Ref		Author 		Comments
     	11/08/2014	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		26/01/2015	CR3750      KSH092      Change UI  
	</HISTORY>
********************************************************************/
end subroutine

public function integer wf_validate ();long ll_no_of_rows, ll_row

dw_members.acceptText()
ll_no_of_rows = dw_members.rowCount()

/* Simple validation */
if ll_no_of_rows > 0 then
	for ll_row = 1 to ll_no_of_rows
		if isnull(dw_members.getItemNumber(ll_row, "tcowner_nr")) or &
			isnull(dw_members.getItemNumber(ll_row, "percent_share")) then
				MessageBox("Validation Error", "Please fill in all required fields in row: " +string(ll_row))
				dw_members.scrollToRow(ll_row)
				dw_members.POST setfocus()
				return -1
		end if
		if not (dw_members.getItemNumber(ll_row, "percent_share") > 0) then
			MessageBox("Validation Error", "Please enter percent in row: " +string(ll_row))
			dw_members.scrollToRow(ll_row)
			dw_members.POST setColumn("percent_share")
			dw_members.POST setfocus()
			return -1
		end if
	next
	/* check that sum = 100 */
	if round(dw_members.getItemDecimal(1, "sum_pct"),2) <> 100 then
		MessageBox("Validation Error", "Total percent must be 100.~n~rCurrent value is = "+string(round(dw_members.getItemDecimal(1, "sum_pct"),2)))
		dw_members.POST setColumn("percent_share")
		dw_members.POST setfocus()
		return -1
	end if
end if
return 1
end function

on w_share_members.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_cancel=create cb_cancel
this.dw_members=create dw_members
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_insert
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_members
end on

on w_share_members.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_cancel)
destroy(this.dw_members)
end on

event open;call super::open;n_dw_style_service   lnv_style


inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_members, false)

ids_data = message.powerObjectParm

ids_data.sharedata(dw_members)
il_contractID = dw_members.getItemNumber(1, "contract_id")

dw_members.setrowfocusindicator( focusRect!)
dw_members.POST setfocus()
end event

event closequery;call super::closequery;if wf_validate( ) < 0 then
	return 1
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_share_members
end type

type cb_delete from commandbutton within w_share_members
integer x = 1426
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;dw_members.deleteRow(0)

dw_members.POST setColumn("tcowner_sn")
dw_members.POST setfocus()
end event

type cb_insert from commandbutton within w_share_members
integer x = 1079
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;long ll_row

ll_row = dw_members.getRow()

if ll_row > 0 then
	ll_row = dw_members.insertRow(ll_row)
else
	ll_row = dw_members.insertRow(0)
end if

if not isNull(il_contractID) then
	dw_members.setItem(ll_row, "contract_id", il_contractID)
end if
dw_members.setItem(ll_row, "apm_company", 0)
dw_members.scrollToRow(ll_row)
dw_members.POST setColumn("tcowner_sn")
dw_members.POST setfocus()
end event

type cb_cancel from commandbutton within w_share_members
integer x = 1778
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;ids_data.retrieve(il_contractID)

end event

type dw_members from u_ntchire_grid_dw within w_share_members
integer x = 18
integer y = 16
integer width = 2103
integer height = 1192
integer taborder = 10
string dataobject = "d_tc_contract_share_members"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;STRING ls_rc, ls_fullname, ls_shortname
LONG	ll_rc

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "tcowner_sn" //open list to choose a pool member
			ls_rc = f_select_from_list("dw_active_tcowner_list", 2, "Short Name", 3, "Long Name", 1, "Select TC Owner", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT TCOWNER_N_1, TCOWNER_SN INTO :ls_fullname, :ls_shortname
				FROM TCOWNERS WHERE TCOWNER_NR = :ll_rc;
				this.SetItem(row, "tcowner_ln", ls_fullname)
				this.SetItem(row, "tcowner_sn", ls_shortname)
				this.SetItem(row, "tcowner_nr", ll_rc)
			END IF
    END CHOOSE
end if
end event

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! and this.getColumnName() = "tcowner_sn" then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.tcowner_sn)
end if
end event

