$PBExportHeader$w_convert_clarkson.srw
$PBExportComments$Used when the clarkson database in TRAMOS is updated
forward
global type w_convert_clarkson from mt_w_response_calc
end type
type cb_doit from commandbutton within w_convert_clarkson
end type
type cb_close from commandbutton within w_convert_clarkson
end type
type st_1 from statictext within w_convert_clarkson
end type
type st_nolines_read from statictext within w_convert_clarkson
end type
type rb_bulk from uo_rb_base within w_convert_clarkson
end type
type rb_tank from uo_rb_base within w_convert_clarkson
end type
type rb_gas from uo_rb_base within w_convert_clarkson
end type
type gb_1 from uo_gb_base within w_convert_clarkson
end type
type st_2 from uo_st_base within w_convert_clarkson
end type
type sle_path from uo_sle_base within w_convert_clarkson
end type
type dw_convert_clarkson from u_datawindow_sqlca within w_convert_clarkson
end type
type st_3 from uo_st_base within w_convert_clarkson
end type
type cb_1 from commandbutton within w_convert_clarkson
end type
end forward

global type w_convert_clarkson from mt_w_response_calc
integer x = 677
integer y = 564
integer width = 1294
integer height = 1004
string title = "Update Clarkson Table"
cb_doit cb_doit
cb_close cb_close
st_1 st_1
st_nolines_read st_nolines_read
rb_bulk rb_bulk
rb_tank rb_tank
rb_gas rb_gas
gb_1 gb_1
st_2 st_2
sle_path sle_path
dw_convert_clarkson dw_convert_clarkson
st_3 st_3
cb_1 cb_1
end type
global w_convert_clarkson w_convert_clarkson

type variables
Boolean ib_working, ib_cancel
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_convert_clarkson
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on open;call mt_w_response_calc::open;rb_bulk.Checked = True



end on

on w_convert_clarkson.create
int iCurrent
call super::create
this.cb_doit=create cb_doit
this.cb_close=create cb_close
this.st_1=create st_1
this.st_nolines_read=create st_nolines_read
this.rb_bulk=create rb_bulk
this.rb_tank=create rb_tank
this.rb_gas=create rb_gas
this.gb_1=create gb_1
this.st_2=create st_2
this.sle_path=create sle_path
this.dw_convert_clarkson=create dw_convert_clarkson
this.st_3=create st_3
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_doit
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_nolines_read
this.Control[iCurrent+5]=this.rb_bulk
this.Control[iCurrent+6]=this.rb_tank
this.Control[iCurrent+7]=this.rb_gas
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_path
this.Control[iCurrent+11]=this.dw_convert_clarkson
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.cb_1
end on

on w_convert_clarkson.destroy
call super::destroy
destroy(this.cb_doit)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.st_nolines_read)
destroy(this.rb_bulk)
destroy(this.rb_tank)
destroy(this.rb_gas)
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.sle_path)
destroy(this.dw_convert_clarkson)
destroy(this.st_3)
destroy(this.cb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_convert_clarkson
end type

type cb_doit from commandbutton within w_convert_clarkson
integer x = 530
integer y = 752
integer width = 251
integer height = 108
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;ib_working = true
ib_cancel = false
cb_close.text = "&Cancel"

Integer li_handle, li_result, li_year, li_month, li_type, li_status, li_barrels, li_vsl1
integer li_sbt, li_dbt, li_ctanks, li_wtanks, li_ex, li_ownercat, li_t1no
integer li_t2no, li_hatches, li_grain, li_holds, li_reliq1, li_reliq3

Long ll_row, ll_dwt, ll_cbm, ll_reliq2

String ls_vsl1, ls_vsl2, ls_lr, ls_name, ls_owner, ls_ssteel, ls_poly 
String ls_yard, ls_flag, ls_draft, ls_loa, ls_beam, ls_society, ls_prop, ls_speed, ls_imo1, ls_imo2, ls_imo3 
String ls_epoxy, ls_zink, ls_chgtype, ls_chgdate, ls_launch, ls_hullno, ls_ex, ls_cons
String ls_lakes, ls_gear, ls_hdim1, ls_hdim2, ls_hdim3
String ls_t2type, ls_t2shape, ls_t1type, ls_t1shape, ls_datastring, ls_path, ls_bhp
String ls_dummy, ls_tmp1, ls_tmp2

date ld_chgdate, ld_launch

double ld_grt, ld_loa, ld_beam, ld_draft, ld_cons, ld_speed

SetPointer(Hourglass!)

If rb_tank.checked = True Then
	ls_path = sle_path.Text
	li_handle = FileOpen(ls_path, LineMode!)
	If li_handle > 0 Then
		DO
			If Mod(ll_row, 20)=0 Then  
				Yield()
				st_nolines_read.text = String(ll_row)
				
				If ib_cancel Then
					ib_cancel = false

					If MessageBox("Cancel", "Do you want to stop ?", Question!, YesNo!, 2) = 1 Then
						Exit
					End if										
				End if		
			End if

			li_result = FileRead(li_Handle, ls_datastring) 
			ll_row ++

			If li_result > 0 Then // Der er noget data
				li_vsl1 = Integer(Trim(Mid(ls_datastring, 0, 1)))
				ls_vsl2 = Trim(Mid(ls_datastring, 2, 5))
				ls_lr = Trim(Mid(ls_datastring, 7, 7))
				ls_name = Trim(Mid(ls_datastring, 14, 30))
				ll_dwt = Long(Trim(Mid(ls_datastring, 44, 6)))
				li_year = Integer(Trim(Mid(ls_datastring, 50, 4)))
				li_month = Integer(Trim(Mid(ls_datastring, 54, 2)))
				li_type = Integer(Trim(Mid(ls_datastring, 56, 3)))
				li_status = Integer(Trim(Mid(ls_datastring, 59, 2)))
				ls_owner = Trim(Mid(ls_datastring, 61, 20))
				li_ownercat = Integer(Trim(Mid(ls_datastring, 81, 1)))
				ls_yard = Trim(Mid(ls_datastring, 82, 15))
				ls_flag = Trim(Mid(ls_datastring, 97, 3))
				li_barrels = Integer(Trim(Mid(ls_datastring, 100, 6)))

				ls_draft = Trim(Mid(ls_datastring,106, 5))
				ls_tmp1 = Mid(ls_draft,1,Pos(ls_draft,".") -1)
				ls_tmp2 = Mid(ls_draft,Pos(ls_draft,".") +1)
				ld_draft = double(ls_tmp1 +","+ls_tmp2)

				ls_loa = Trim(Mid(ls_datastring,111, 6))
				ls_tmp1 = Mid(ls_loa,1,Pos(ls_loa,".") -1)
				ls_tmp2 = Mid(ls_loa,Pos(ls_loa,".") +1)
				ld_loa = double(ls_tmp1 +","+ls_tmp2)

				ls_beam = Trim(Mid(ls_datastring,117,5))
				ls_tmp1 = Mid(ls_beam,1,Pos(ls_beam,".") -1)
				ls_tmp2 = Mid(ls_beam,Pos(ls_beam,".") +1)
				ld_beam = double(ls_tmp1 +","+ls_tmp2)

				ld_grt = double(Trim(Mid(ls_datastring,122,6)))
				ls_society = Trim(Mid(ls_datastring,128,8))
				ls_prop = Trim(Mid(ls_datastring,136, 2))

				ls_tmp1 = ""
				ls_tmp2 = ""
				ls_speed  = Trim(Mid(ls_datastring,138, 5))
				ls_tmp1 = Mid(ls_speed,1,Pos(ls_speed,".") -1)
				ls_tmp2 = Mid(ls_speed,Pos(ls_speed,".") +1)
				ld_speed = double(ls_tmp1 +","+ls_tmp2)

				ls_tmp1 = ""
				ls_tmp2 = ""
				ls_cons  = Trim(Mid(ls_datastring,143,6))
				ls_tmp1 = Mid(ls_cons,1,Pos(ls_cons,".") -1)
				ls_tmp2 = Mid(ls_cons,Pos(ls_cons,".") +1)
				ld_cons = double(ls_tmp1 +","+ls_tmp2)

				li_sbt  = integer(Trim(Mid(ls_datastring,149,1)))
				li_dbt  = integer(Trim(Mid(ls_datastring,150,1)))
				li_ctanks  = integer(Trim(Mid(ls_datastring,151,2)))
				li_wtanks  = integer(Trim(Mid(ls_datastring,153,2)))
				ls_imo1  = Trim(Mid(ls_datastring,155,1))
				ls_imo2  = Trim(Mid(ls_datastring,156,1))
				ls_imo3  = Trim(Mid(ls_datastring,157,1))
				ls_ssteel  = Trim(Mid(ls_datastring,158,1))
				ls_poly  = Trim(Mid(ls_datastring,159,1))
				ls_epoxy  = Trim(Mid(ls_datastring,160,1))
				ls_zink  = Trim(Mid(ls_datastring,161,1))
				ls_chgtype = Trim(Mid(ls_datastring,162,4))

				// This is to ensure that it is a valid date
				ls_chgdate  = Trim(Mid(ls_datastring,166,8))
				If (IsNull(ls_chgdate) or (ls_chgdate = ""))Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)
				If (ld_chgdate = date("00-01-00")) Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)

				// This is to ensure that it is a valid date
				ls_launch  = Trim(Mid(ls_datastring,174,8))
				If (IsNull(ls_launch) or (ls_launch = ""))Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)
				If (ld_launch = date("00-01-00")) Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)

				ls_hullno  = Trim(Mid(ls_datastring,182,4))
				li_ex  = integer(Trim(Mid(ls_datastring,186,30)))

				// Insert into the Clarkson table. Lav select for hvert skib. Hvis det eksistere skal det opdateres, hvis ikke 
				// skal det indsættes i tabellen. Der skal laves update for hvert skib. Test på SQLCode for at se om der
				// er flere skibe med samme nøgle.

				SELECT CAL_CLAR.CAL_CLRK_VSL2
				INTO :ls_dummy
				FROM CAL_CLAR
				WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

				If SQLCA.SQLCode = 0 Then
					UPDATE CAL_CLAR
					SET  CAL_CLRK_VSL1 = :li_vsl1,
						CAL_CLRK_VSL2 = :ls_vsl2,
						CAL_CLRK_LR = :ls_lr,
						CAL_CLRK_NAME = :ls_name,
						CAL_CLRK_DWT = :ll_dwt,
						CAL_CLRK_BUILD_MONTH = :li_month,
						CAL_CLRK_BUILD_YEAR = :li_year,
						CAL_CLRK_TYPE = :li_type,
						CAL_CLRK_STATUS = :li_status,
						CAL_CLRK_OWNER = :ls_owner,
						CAL_CLRK_OWN_CAT = :li_ownercat,
						CAL_CLRK_YARD = :ls_yard,
						CAL_CLRK_FLAG = :ls_flag,
						CAL_CLRK_BARRELS = :li_barrels,
						CAL_DRAFT = :ld_draft,
						CAL_LOA = :ld_loa,
						CAL_BEAM = :ld_beam,
						CAL_GRT = :ld_grt,
						CAL_CLRK_SOCIETY = :ls_society,
						CAL_CLRK_PROP = :ls_prop,
						CAL_CLRK_SPEED = :ld_speed,
						CAL_CLRK_CONS = :ld_cons,
						CAL_CLRK_SBT = :li_sbt,
						CAL_CLRK_D_HULLS = :li_dbt,
						CAL_CLRK_C_TANKS = :li_ctanks,
						CAL_CLRK_W_TANKS = :li_wtanks,
						CAL_CLRK_IMO_1 = :ls_imo1,
						CAL_CLRK_IMO_2 = :ls_imo2,
						CAL_CLRK_IMO_3 = :ls_imo3,
						CAL_CLRK_SSTEEL = :ls_ssteel,
						CAL_CLRK_POLY = :ls_poly,
						CAL_CLRK_EPOXY = :ls_epoxy,
						CAL_CLRK_ZINC = :ls_zink,
						CAL_CLRK_CHGTYPE = :ls_chgtype,
						CAL_CLRK_CHGDATE = :ld_chgdate,
						CAL_CLRK_LAUNCH = :ld_launch,
						CAL_CLRK_HULL_NR = :ls_hullno
					WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

					If SQLCA.SQLCode = - 1Then
						MessageBox("SQL error, update "+string(ll_row),SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If

				Elseif SQLCA.SQLCode = 100 Then

					INSERT INTO CAL_CLAR
						(CAL_CLAR.CAL_CLRK_VSL1,
						CAL_CLAR.CAL_CLRK_VSL2,
						CAL_CLAR.CAL_CLRK_LR,
						CAL_CLAR.CAL_CLRK_NAME,
						CAL_CLAR.CAL_CLRK_DWT,
						CAL_CLAR.CAL_CLRK_BUILD_MONTH,
						CAL_CLAR.CAL_CLRK_BUILD_YEAR,
						CAL_CLAR.CAL_CLRK_TYPE,
						CAL_CLAR.CAL_CLRK_STATUS,
						CAL_CLAR.CAL_CLRK_OWNER,
						CAL_CLAR.CAL_CLRK_OWN_CAT,
						CAL_CLAR.CAL_CLRK_YARD,
						CAL_CLAR.CAL_CLRK_FLAG,
						CAL_CLAR.CAL_CLRK_BARRELS,
						CAL_CLAR.CAL_DRAFT,
						CAL_CLAR.CAL_LOA,
						CAL_CLAR.CAL_BEAM,
						CAL_CLAR.CAL_GRT,
						CAL_CLAR.CAL_CLRK_SOCIETY,
						CAL_CLAR.CAL_CLRK_PROP,
						CAL_CLAR.CAL_CLRK_SPEED,
						CAL_CLAR.CAL_CLRK_CONS,
						CAL_CLAR.CAL_CLRK_SBT,
						CAL_CLAR.CAL_CLRK_D_HULLS,
						CAL_CLAR.CAL_CLRK_C_TANKS,
						CAL_CLAR.CAL_CLRK_W_TANKS,
						CAL_CLAR.CAL_CLRK_IMO_1,
						CAL_CLAR.CAL_CLRK_IMO_2,
						CAL_CLAR.CAL_CLRK_IMO_3,
						CAL_CLAR.CAL_CLRK_SSTEEL,
						CAL_CLAR.CAL_CLRK_POLY,
						CAL_CLAR.CAL_CLRK_EPOXY,
						CAL_CLAR.CAL_CLRK_ZINC,
						CAL_CLAR.CAL_CLRK_CHGTYPE,
						CAL_CLAR.CAL_CLRK_CHGDATE,
						CAL_CLAR.CAL_CLRK_LAUNCH,
						CAL_CLAR.CAL_CLRK_HULL_NR)
					VALUES
						(:li_vsl1,
						:ls_vsl2,
						:ls_lr,
						:ls_name,
						:ll_dwt,
						:li_month,
						:li_year,
						:li_type,
						:li_status,
						:ls_owner,
						:li_ownercat,
						:ls_yard,
						:ls_flag,
						:li_barrels,
						:ld_draft,
						:ld_loa,
						:ld_beam,
						:ld_grt,
						:ls_society,
						:ls_prop,
						:ld_speed,
						:ld_cons,
						:li_sbt,
						:li_dbt,
						:li_ctanks,
						:li_wtanks,
						:ls_imo1,
						:ls_imo2,
						:ls_imo3,
						:ls_ssteel,
						:ls_poly,
						:ls_epoxy,
						:ls_zink,
						:ls_chgtype,
						:ld_chgdate,
						:ld_launch,
						:ls_hullno);

					If SQLCA.SQLCode = -1Then
						MessageBox("SQL error, insert "+string(ll_row),SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If

				elseif SQLCA.SQLCode = -1Then
					MessageBox("SQL error, select "+string(ll_row)+" "+ls_vsl2,SQLCA.SQLErrText,Information!)
				End If
			End if
		
		LOOP UNTIL li_result < 0

		If li_result = -1 Then MessageBox("Error", "There was an error during fileread")
		FileClose(li_handle)
	Else
		MessageBox("Error", "Error during opening of file. Tjek that: ~r~n &
					1 The file has been unziped if it's a zip file. ~r~n &
					2 The full path is included in 'Path' ")
	End if
End if

If rb_gas.checked = true Then
	ls_path = sle_path.Text
	li_handle = FileOpen(ls_path, LineMode!)
	If li_handle > 0 Then
		DO
			If Mod(ll_row, 20)=0 Then 
				Yield()
				st_nolines_read.text = String(ll_row)
				If ib_cancel Then
					ib_cancel = false
					If MessageBox("Cancel", "Do you want to stop?", Question!, YesNo!, 2) = 1 Then
						Exit
					End if										
				End if		
			End if

			li_result = FileRead(li_Handle, ls_datastring) 
			ll_row ++

			If li_result > 0 Then // Der er noget data
				ls_vsl1 = Trim(Mid(ls_datastring, 0, 1))
				ls_vsl2 = Trim(Mid(ls_datastring, 2, 5))
				ls_name = Trim(Mid(ls_datastring, 7, 30))
				ll_cbm = Long(Trim(Mid(ls_datastring, 37, 6)))
				li_year = Integer(Trim(Mid(ls_datastring, 43, 4)))
				li_month = Integer(Trim(Mid(ls_datastring, 47, 2)))
				li_type = Integer(Trim(Mid(ls_datastring, 49, 3)))
				li_status = Integer(Trim(Mid(ls_datastring, 52, 2)))
				ls_owner = Trim(Mid(ls_datastring, 54, 20))
				li_ownercat = Integer(Trim(Mid(ls_datastring, 74, 1)))
				ls_yard = Trim(Mid(ls_datastring, 75, 15))
				ll_dwt = Long(Trim(Mid(ls_datastring, 90, 6)))
				ls_flag = Trim(Mid(ls_datastring, 96, 3))

				ls_draft = Trim(Mid(ls_datastring,99, 5))
				ls_tmp1 = Mid(ls_draft,1,Pos(ls_draft,".") -1)
				ls_tmp2 = Mid(ls_draft,Pos(ls_draft,".") +1)
				ld_draft = double(ls_tmp1 +","+ls_tmp2)

				ls_loa = Trim(Mid(ls_datastring,105, 6))
				ls_tmp1 = Mid(ls_loa,1,Pos(ls_loa,".") -1)
				ls_tmp2 = Mid(ls_loa,Pos(ls_loa,".") +1)
				ld_loa = double(ls_tmp1 +","+ls_tmp2)

				ls_beam = Trim(Mid(ls_datastring,111,5))
				ls_tmp1 = Mid(ls_beam,1,Pos(ls_beam,".") -1)
				ls_tmp2 = Mid(ls_beam,Pos(ls_beam,".") +1)
				ld_beam = double(ls_tmp1 +","+ls_tmp2)


				ld_grt = Double(Trim(Mid(ls_datastring,116,6)))
				ls_society = Trim(Mid(ls_datastring,122,8))
				ls_bhp = Trim(Mid(ls_datastring,130, 6))

				ls_speed  = Trim(Mid(ls_datastring,136, 5))
				ls_tmp1 = Mid(ls_speed,1,Pos(ls_speed,".") -1)
				ls_tmp2 = Mid(ls_speed,Pos(ls_speed,".") +1)
				ld_speed = double(ls_tmp1 +","+ls_tmp2)

				ls_cons  = Trim(Mid(ls_datastring,141,6))
				ls_tmp1 = Mid(ls_cons,1,Pos(ls_cons,".") -1)
				ls_tmp2 = Mid(ls_cons,Pos(ls_cons,".") +1)
				ld_cons = double(ls_tmp1 +","+ls_tmp2)

				li_t1no  = Integer(Trim(Mid(ls_datastring,147,2)))
				ls_t1type  = Trim(Mid(ls_datastring,149,2))
				ls_t1shape  = Trim(Mid(ls_datastring,151,2))
				li_t2no  = Integer(Trim(Mid(ls_datastring,153,2)))
				ls_t2type  = Trim(Mid(ls_datastring,155,2))
				ls_t2shape  = Trim(Mid(ls_datastring,157,2))
				li_reliq1  = Integer(Trim(Mid(ls_datastring,159,2)))
				ll_reliq2  = long(Trim(Mid(ls_datastring,161,7)))
				li_reliq3  = Integer(Trim(Mid(ls_datastring,168,3)))
				ls_chgtype = Trim(Mid(ls_datastring,171,4))

				// This is to ensure that it is a valid date
				ls_chgdate  = Trim(Mid(ls_datastring,175,8))
				If (IsNull(ls_chgdate) or (ls_chgdate = ""))Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)
				If (ld_chgdate = date("00-01-00")) Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)

				// This is to ensure that it is a valid date
				ls_launch  = Trim(Mid(ls_datastring,183,8))
				If (IsNull(ls_launch) or (ls_launch = ""))Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)
				If (ld_launch = date("00-01-00")) Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)

				ls_hullno  = Trim(Mid(ls_datastring,191,4))
				ls_ex  = Trim(Mid(ls_datastring,195,30))
				/* The field sbt does not allow null values */
				li_sbt = 1

				// Insert into the Clarkson table
				SELECT CAL_CLAR.CAL_CLRK_VSL2
				INTO :ls_dummy
				FROM CAL_CLAR
				WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

				If SQLCA.SQLCode = 0 Then
					UPDATE CAL_CLAR
					SET  CAL_CLRK_VSL1 = :li_vsl1,
						CAL_CLRK_VSL2 = :ls_vsl2,
						CAL_CLRK_NAME = :ls_name,
						CAL_CBM = :ll_cbm,
						CAL_CLRK_DWT = :ll_dwt,
						CAL_CLRK_BUILD_YEAR = :li_year,
						CAL_CLRK_BUILD_MONTH = :lI_month,
						CAL_CLRK_TYPE = :li_type,
						CAL_CLRK_STATUS = :li_status,
						CAL_CLRK_OWNER = :ls_owner,
						CAL_CLRK_OWN_CAT = :li_ownercat,
						CAL_CLRK_YARD = :ls_yard,
						CAL_CLRK_FLAG = :ls_flag,
						CAL_DRAFT = :ld_draft,
						CAL_LOA = :ld_loa,
						CAL_BEAM = :ld_beam,
						CAL_GRT = :ld_grt,
						CAL_CLRK_SOCIETY = :ls_society,
						CAL_CLRK_BHP = :ls_bhp,
						CAL_CLRK_T1NO = :li_t1no,
						CAL_CLRK_T1TYPE = :ls_t1type,
						CAL_CLRK_T1SHAPE = :ls_t1shape,
						CAL_CLRK_T2NO = :li_t2no,
						CAL_CLRK_T2TYPE = :ls_t2type,
						CAL_CLRK_T2SHAPE = :ls_t2shape,
						CAL_CLRK_RELIQ1 = :li_reliq1,
						CAL_CLRK_RELIQ2 = :ll_reliq2,
						CAL_CLRK_RELIQ3 = :li_reliq3,
						CAL_CLRK_CHGTYPE = :ls_chgtype,
						CAL_CLRK_CHGDATE = :ld_chgdate,
						CAL_CLRK_LAUNCH = :ld_launch,
						CAL_CLRK_HULL_NR = :ls_hullno,
						CAL_CLRK_EX = :ls_ex,
						CAL_CLRK_SPEED = :ld_speed,
						CAL_CLRK_CONS = :ld_cons,
						CAL_CLRK_SBT = :li_sbt
					WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

					If SQLCA.SQLCode = -1Then
						MessageBox("SQL error, update",SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If

				Elseif SQLCA.SQLCode = 100 Then

					INSERT INTO CAL_CLAR
						(CAL_CLAR.CAL_CLRK_VSL1,
						CAL_CLAR.CAL_CLRK_VSL2,
						CAL_CLAR.CAL_CLRK_NAME,
						CAL_CLAR.CAL_CBM,
						CAL_CLAR.CAL_CLRK_DWT,
						CAL_CLAR.CAL_CLRK_BUILD_YEAR,
						CAL_CLAR.CAL_CLRK_BUILD_MONTH,
						CAL_CLAR.CAL_CLRK_TYPE,
						CAL_CLAR.CAL_CLRK_STATUS,
						CAL_CLAR.CAL_CLRK_OWNER,
						CAL_CLAR.CAL_CLRK_OWN_CAT,
						CAL_CLAR.CAL_CLRK_YARD,
						CAL_CLAR.CAL_CLRK_FLAG,
						CAL_CLAR.CAL_DRAFT,
						CAL_CLAR.CAL_LOA,
						CAL_CLAR.CAL_BEAM,
						CAL_CLAR.CAL_GRT,
						CAL_CLAR.CAL_CLRK_SOCIETY,
						CAL_CLAR.CAL_CLRK_BHP,
						CAL_CLAR.CAL_CLRK_T1NO,
						CAL_CLAR.CAL_CLRK_T1TYPE,
						CAL_CLAR.CAL_CLRK_T1SHAPE,
						CAL_CLAR.CAL_CLRK_T2NO,
						CAL_CLAR.CAL_CLRK_T2TYPE,
						CAL_CLAR.CAL_CLRK_T2SHAPE,
						CAL_CLAR.CAL_CLRK_RELIQ1,
						CAL_CLAR.CAL_CLRK_RELIQ2,
						CAL_CLAR.CAL_CLRK_RELIQ3,
						CAL_CLAR.CAL_CLRK_CHGTYPE,
						CAL_CLAR.CAL_CLRK_CHGDATE,
						CAL_CLAR.CAL_CLRK_LAUNCH,
						CAL_CLAR.CAL_CLRK_HULL_NR,
						CAL_CLAR.CAL_CLRK_EX,
						CAL_CLAR.CAL_CLRK_SPEED,
						CAL_CLAR.CAL_CLRK_CONS,
						CAL_CLAR.CAL_CLRK_SBT)
					VALUES
						(:li_vsl1,
						:ls_vsl2,
						:ls_name,
						:ll_cbm,
						:ll_dwt,
						:li_year,
						:lI_month,
						:li_type,
						:li_status,
						:ls_owner,
						:li_ownercat,
						:ls_yard,
						:ls_flag,
						:ld_draft,
						:ld_loa,
						:ld_beam,
						:ld_grt,
						:ls_society,
						:ls_bhp,
						:li_t1no,
						:ls_t1type,
						:ls_t1shape,
						:li_t2no,
						:ls_t2type,
						:ls_t2shape,
						:li_reliq1,
						:ll_reliq2,
						:li_reliq3,
						:ls_chgtype,
						:ld_chgdate,
						:ld_launch,
						:ls_hullno,
						:ls_ex,
						:ld_speed,
						:ld_cons,
						:li_sbt);
					If SQLCA.SQLCode = -1Then
						MessageBox("SQL error, insert",SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If
				Elseif SQLCA.SQLCode = -1Then
					MessageBox("SQL error",SQLCA.SQLErrText,Information!)
				End If
			End If

		LOOP UNTIL li_result < 0

		If li_result = -1 Then MessageBox("Error", "There was an error during fileread")
		FileClose(li_handle)
	Else
		MessageBox("Error", "Error during opening of file. Tjek that: ~r~n &
					1 The file has been unziped if it's a zip file. ~r~n &
					2 The full path is included in 'Path' ")
	End if
End If

If rb_bulk.Checked = True Then
	ls_path = sle_path.Text
	li_handle = FileOpen(ls_path, LineMode!)
	If li_handle > 0 Then
		DO
			If Mod(ll_row, 20)=0 Then 
				Yield()
				st_nolines_read.text = String(ll_row)
				If ib_cancel Then
					ib_cancel = false
					If MessageBox("Cancel", "Do you want to stop ?", Question!, YesNo!, 2) = 1 Then
						Exit
					End if										
				End if		
			End if

			li_result = FileRead(li_Handle, ls_datastring) 
			ll_row ++

			If li_result > 0 Then // Der er noget data
				li_vsl1 = Integer(Trim(Mid(ls_datastring, 0, 1)))
				ls_vsl2 = Trim(Mid(ls_datastring, 2, 5))
				li_type = Integer(Trim(Mid(ls_datastring, 7, 3)))
				ls_name = Trim(Mid(ls_datastring, 10, 30))
				ll_dwt = Long(Trim(Mid(ls_datastring, 40, 6)))
				li_grain = Integer(Trim(Mid(ls_datastring,46,6)))
				li_year = Integer(Trim(Mid(ls_datastring, 52, 4)))
				li_month = Integer(Trim(Mid(ls_datastring, 56, 2)))
				ls_yard = Trim(Mid(ls_datastring, 58, 15))
				ls_flag = Trim(Mid(ls_datastring, 73, 4))
				li_status = Integer(Trim(Mid(ls_datastring, 77, 2)))

				ls_draft = Trim(Mid(ls_datastring,79, 5))
				ls_tmp1 = Mid(ls_draft,1,Pos(ls_draft,".") -1)
				ls_tmp2 = Mid(ls_draft,Pos(ls_draft,".") +1)
				ld_draft = double(ls_tmp1 +","+ls_tmp2)

				ls_loa = Trim(Mid(ls_datastring,84, 6))
				ls_tmp1 = Mid(ls_loa,1,Pos(ls_loa,".") -1)
				ls_tmp2 = Mid(ls_loa,Pos(ls_loa,".") +1)
				ld_loa = double(ls_tmp1 +","+ls_tmp2)

				ls_beam = Trim(Mid(ls_datastring,90,5))
				ls_tmp1 = Mid(ls_beam,1,Pos(ls_beam,".") -1)
				ls_tmp2 = Mid(ls_beam,Pos(ls_beam,".") +1)
				ld_beam = double(ls_tmp1 +","+ls_tmp2)

				ld_grt = Double(Trim(Mid(ls_datastring,95,6)))
				ls_society = Trim(Mid(ls_datastring,101,8))
				ls_prop = Trim(Mid(ls_datastring,109, 2))

				ls_speed  = Trim(Mid(ls_datastring,111, 5))
				ls_tmp1 = Mid(ls_speed,1,Pos(ls_speed,".") -1)
				ls_tmp2 = Mid(ls_speed,Pos(ls_speed,".") +1)
				ld_speed = double(ls_tmp1 +","+ls_tmp2)

				ls_cons  = Trim(Mid(ls_datastring,116,6))
				ls_tmp1 = Mid(ls_cons,1,Pos(ls_cons,".") -1)
				ls_tmp2 = Mid(ls_cons,Pos(ls_cons,".") +1)
				ld_cons = double(ls_tmp1 +","+ls_tmp2)

				li_ownercat = Integer(Trim(Mid(ls_datastring,122, 1)))
				ls_owner = Trim(Mid(ls_datastring, 123, 20))
				li_holds = Integer(Trim(Mid(ls_datastring, 143, 2)))
				li_hatches  = Integer(Trim(Mid(ls_datastring,145,2)))
				ls_hdim1  = Trim(Mid(ls_datastring,147,11))
				ls_hdim2  = Trim(Mid(ls_datastring,158,11))
				ls_hdim3  = Trim(Mid(ls_datastring,169,11))
				ls_gear  = Trim(Mid(ls_datastring,180,10))
				ls_chgtype = Trim(Mid(ls_datastring,190,4))

				ls_chgdate  = Trim(Mid(ls_datastring,194,8))
				If (IsNull(ls_chgdate) or (ls_chgdate = ""))Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)
				If (ld_chgdate = date("00-01-00")) Then ls_chgdate = "01-01-1901"
				ld_chgdate = date(ls_chgdate)

				ls_launch  = Trim(Mid(ls_datastring,202,8))
				If (IsNull(ls_launch) or (ls_launch = ""))Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)
				If (ld_launch = date("00-01-00")) Then ls_launch = "01-01-1901"
				ld_launch = date(ls_launch)

				ls_hullno  = Trim(Mid(ls_datastring,210,4))
				ls_lakes  = Trim(Mid(ls_datastring,214,1))
				ls_ex  = Trim(Mid(ls_datastring,215,30))
				/* Field sbt does not allow null value */
				li_sbt = 1

				// Insert into the Clarkson table
				SELECT CAL_CLAR.CAL_CLRK_VSL2
				INTO :ls_dummy
				FROM CAL_CLAR
				WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

				If SQLCA.SQLCode = 0 Then
					UPDATE CAL_CLAR
					SET  CAL_CLRK_VSL1 = :li_vsl1,
						CAL_CLRK_VSL2 = :ls_vsl2,
						CAL_CLRK_TYPE = :li_type,
						CAL_CLRK_NAME = :ls_name,
						CAL_CLRK_DWT = :ll_dwt,
						CAL_CLRK_GRAIN = :li_grain,
						CAL_CLRK_BUILD_YEAR = :li_year,
						CAL_CLRK_BUILD_MONTH = :li_month,
						CAL_CLRK_YARD = :ls_yard,
						CAL_CLRK_FLAG = :ls_flag,
						CAL_CLRK_STATUS = :li_status,
						CAL_DRAFT = :ld_draft,
						CAL_LOA = :ld_loa,
						CAL_BEAM = :ld_beam,
						CAL_GRT = :ld_grt,
						CAL_CLRK_SOCIETY = :ls_society,
						CAL_CLRK_PROP = :ls_prop,
						CAL_CLRK_OWN_CAT = :li_ownercat,
						CAL_CLRK_OWNER = :ls_owner,
						CAL_CLRK_HOLDS = :li_holds,
						CAL_HATCHES = :li_hatches,
						CAL_CLRK_HDIM1 = :ls_hdim1,
						CAL_CLRK_HDIM2 = :ls_hdim2,
						CAL_CLRK_HDIM3 = :ls_hdim3,
						CAL_CLRK_GEAR =  :ls_gear,
						CAL_CLRK_CHGTYPE = :ls_chgtype,
						CAL_CLRK_CHGDATE = :ld_chgdate,
						CAL_CLRK_LAUNCH = :ld_launch,
						CAL_CLRK_HULL_NR = :ls_hullno,
						CAL_CLRK_LAKES = :ls_lakes,
						CAL_CLRK_EX = :ls_ex,
						CAL_CLRK_SPEED = :ld_speed,
						CAL_CLRK_CONS = :ld_cons,
						CAL_CLRK_SBT = :li_sbt
					WHERE CAL_CLAR.CAL_CLRK_VSL2 = :ls_vsl2 ;

					If SQLCA.SQLCode = -1Then
						MessageBox("SQL error, update",SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If

				Elseif SQLCA.SQLCode = 100 Then

					INSERT INTO CAL_CLAR
						(CAL_CLAR.CAL_CLRK_VSL1,
						CAL_CLAR.CAL_CLRK_VSL2,
						CAL_CLAR.CAL_CLRK_TYPE,
						CAL_CLAR.CAL_CLRK_NAME,
						CAL_CLAR.CAL_CLRK_DWT,
						CAL_CLAR.CAL_CLRK_GRAIN,
						CAL_CLAR.CAL_CLRK_BUILD_YEAR,
						CAL_CLAR.CAL_CLRK_BUILD_MONTH,
						CAL_CLAR.CAL_CLRK_YARD,
						CAL_CLAR.CAL_CLRK_FLAG,
						CAL_CLAR.CAL_CLRK_STATUS,
						CAL_CLAR.CAL_DRAFT,
						CAL_CLAR.CAL_LOA,
						CAL_CLAR.CAL_BEAM,
						CAL_CLAR.CAL_GRT,
						CAL_CLAR.CAL_CLRK_SOCIETY,
						CAL_CLAR.CAL_CLRK_PROP,
						CAL_CLAR.CAL_CLRK_OWN_CAT,
						CAL_CLAR.CAL_CLRK_OWNER,
						CAL_CLAR.CAL_CLRK_HOLDS,
						CAL_CLAR.CAL_HATCHES,
						CAL_CLAR.CAL_CLRK_HDIM1,
						CAL_CLAR.CAL_CLRK_HDIM2,
						CAL_CLAR.CAL_CLRK_HDIM3,
						CAL_CLAR.CAL_CLRK_GEAR,
						CAL_CLAR.CAL_CLRK_CHGTYPE,
						CAL_CLAR.CAL_CLRK_CHGDATE,
						CAL_CLAR.CAL_CLRK_LAUNCH,
						CAL_CLAR.CAL_CLRK_HULL_NR,
						CAL_CLAR.CAL_CLRK_LAKES,
						CAL_CLAR.CAL_CLRK_EX,
						CAL_CLAR.CAL_CLRK_SPEED,
						CAL_CLAR.CAL_CLRK_CONS,
						CAL_CLAR.CAL_CLRK_SBT)
					VALUES
						(:li_vsl1,
						:ls_vsl2,
						:li_type,
						:ls_name,
						:ll_dwt,
						:li_grain,
						:li_year,
						:li_month,
						:ls_yard,
						:ls_flag,
						:li_status,
						:ld_draft,
						:ld_loa,
						:ld_beam,
						:ld_grt,
						:ls_society,
						:ls_prop,
						:li_ownercat,
						:ls_owner,
						:li_holds,
						:li_hatches,
						:ls_hdim1,
						:ls_hdim2,
						:ls_hdim3,
						:ls_gear,
						:ls_chgtype,
						:ld_chgdate,
						:ld_launch,
						:ls_hullno,
						:ls_lakes,
						:ls_ex,
						:ld_speed,
						:ld_cons,
						:li_sbt);
					If SQLCA.SQLCode = -1Then
						MessageBox("SQL error, insert",SQLCA.SQLErrText,Information!)
					Else
						COMMIT ;
					End If

				Elseif SQLCA.SQLCode = -1Then
					MessageBox("SQL error",SQLCA.SQLErrText,Information!)
				End If
			End If			
		LOOP UNTIL li_result < 0

		If li_result = -1 Then MessageBox("Error", "There was an error during fileread")
		FileClose(li_handle)
	Else
		MessageBox("Error", "Error during opening of file. Tjek that: ~r~n &
1 The file has been unziped if it's a zip file. ~r~n &
2 The full path is included in 'Path' ")
	End if
End if 

st_nolines_read.text = String(ll_row) + " Updating the database"

SetPointer(Arrow!)

cb_close.text = "&Close"
ib_working = false

end event

type cb_close from commandbutton within w_convert_clarkson
integer x = 878
integer y = 752
integer width = 247
integer height = 108
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Stop"
end type

on clicked;If ib_working then ib_cancel = true else Close(Parent)
end on

type st_1 from statictext within w_convert_clarkson
integer x = 110
integer y = 624
integer width = 622
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Number of rows converted:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_nolines_read from statictext within w_convert_clarkson
integer x = 786
integer y = 624
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type rb_bulk from uo_rb_base within w_convert_clarkson
integer x = 91
integer y = 112
integer taborder = 30
long backcolor = 81324524
string text = "Bulk"
boolean checked = true
end type

type rb_tank from uo_rb_base within w_convert_clarkson
integer x = 786
integer y = 112
integer taborder = 50
long backcolor = 81324524
string text = "Tank"
end type

type rb_gas from uo_rb_base within w_convert_clarkson
integer x = 421
integer y = 112
integer taborder = 40
long backcolor = 81324524
string text = "Gas"
end type

type gb_1 from uo_gb_base within w_convert_clarkson
integer x = 55
integer y = 48
integer width = 1061
integer height = 192
integer taborder = 20
long backcolor = 81324524
string text = "Department"
end type

type st_2 from uo_st_base within w_convert_clarkson
integer x = 73
integer y = 496
long backcolor = 81324524
string text = "Path:"
end type

type sle_path from uo_sle_base within w_convert_clarkson
integer x = 366
integer y = 480
integer width = 750
integer height = 80
integer taborder = 60
boolean autohscroll = true
end type

type dw_convert_clarkson from u_datawindow_sqlca within w_convert_clarkson
boolean visible = false
integer x = 969
integer y = 16
integer width = 146
integer height = 112
integer taborder = 10
string dataobject = "d_calc_clarkson_bulk"
end type

type st_3 from uo_st_base within w_convert_clarkson
integer x = 73
integer y = 272
integer width = 1042
integer height = 176
long backcolor = 81324524
string text = "Insert the full path to the file. Zip~'ed files has to be unziped before updating the Clarkson Table."
alignment alignment = left!
end type

type cb_1 from commandbutton within w_convert_clarkson
integer x = 1152
integer y = 488
integer width = 101
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
boolean default = true
end type

on clicked;string docname, named

integer value

value = GetFileOpenName("Choose Clarkson Import File",  &
	docname, named, "TXT",  &
	"TXT Files (*.TXT),*.TXT")

IF value = 1 THEN sle_path.text = docname


end on

