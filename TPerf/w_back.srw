HA$PBExportHeader$w_back.srw
forward
global type w_back from window
end type
type st_built from statictext within w_back
end type
type p_1 from picture within w_back
end type
type rr_1 from roundrectangle within w_back
end type
type rr_2 from roundrectangle within w_back
end type
type st_active from statictext within w_back
end type
type st_total from statictext within w_back
end type
type st_pc from statictext within w_back
end type
type st_4 from statictext within w_back
end type
type st_3 from statictext within w_back
end type
type st_2 from statictext within w_back
end type
type st_8 from statictext within w_back
end type
type st_user from statictext within w_back
end type
type st_6 from statictext within w_back
end type
type st_ver from statictext within w_back
end type
type st_db from statictext within w_back
end type
end forward

global type w_back from window
integer width = 1975
integer height = 932
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 12639424
string icon = "AppIcon!"
boolean toolbarvisible = false
st_built st_built
p_1 p_1
rr_1 rr_1
rr_2 rr_2
st_active st_active
st_total st_total
st_pc st_pc
st_4 st_4
st_3 st_3
st_2 st_2
st_8 st_8
st_user st_user
st_6 st_6
st_ver st_ver
st_db st_db
end type
global w_back w_back

on w_back.create
this.st_built=create st_built
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.st_active=create st_active
this.st_total=create st_total
this.st_pc=create st_pc
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_8=create st_8
this.st_user=create st_user
this.st_6=create st_6
this.st_ver=create st_ver
this.st_db=create st_db
this.Control[]={this.st_built,&
this.p_1,&
this.rr_1,&
this.rr_2,&
this.st_active,&
this.st_total,&
this.st_pc,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_8,&
this.st_user,&
this.st_6,&
this.st_ver,&
this.st_db}
end on

on w_back.destroy
destroy(this.st_built)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.st_active)
destroy(this.st_total)
destroy(this.st_pc)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_8)
destroy(this.st_user)
destroy(this.st_6)
destroy(this.st_ver)
destroy(this.st_db)
end on

event open;Integer li_Total, li_Active

// Set version and build date  (remove leading zeros from version number)
st_Ver.Text = 'Version: ' + String(Integer(Mid(g_Parameters.AppVersion, 1, 2))) + '.' + String(Integer(Mid(g_Parameters.AppVersion, 4, 2))) + '.' + String(Integer(Mid(g_Parameters.AppVersion, 7, 2)))
st_Built.Text = 'Built: ' + g_Parameters.AppBuilt

st_DB.text = SQLCA.Database
st_user.text=g_userinfo.firstname + " " + g_userinfo.lastname
st_PC.text=g_userinfo.pc_name

this.event timer( )

timer(1200, w_back)
end event

event timer;Long ll_Active, ll_Total

SELECT COUNT(ALERT_ID), Sum(Convert(INT,ACK)) INTO :ll_Total, :ll_Active
    FROM TPERF_ALERTS,   
         VESSELS,   
         TPERF_VOY  
   WHERE VESSELS.PC_NR in (Select PC_NR from USERS_PROFITCENTER Where USERID = :g_userinfo.userid)
			AND VESSELS.VESSEL_ID = TPERF_VOY.VESSEL_ID
			AND TPERF_VOY.VOY_ID = TPERF_ALERTS.VOY_ID;
			
If sqlca.sqlcode=0 then 
	Commit;
Else
	Rollback;
End if

ll_active = ll_total - ll_active
if IsNull(ll_active) then ll_active=0

st_total.text = string(ll_total)
st_active.text = string(ll_active)

If ll_active>0 then
	timer(1, w_main)
	st_active.textcolor = 255
	st_active.weight = 700
Else
   timer(0, w_main)
	 m_tperf.m_tramperperformance.m_alerts.toolbaritemname = "H:\Tramos.Dev\Resource\TPerf\Exclm.gif"
	 st_active.weight = 400
   st_active.textcolor = st_total.textcolor
End if
end event

type st_built from statictext within w_back
integer x = 1426
integer y = 832
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Built: XX"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_1 from picture within w_back
integer x = 110
integer y = 48
integer width = 1769
integer height = 60
boolean originalsize = true
string picturename = "H:\Tramos.Dev\Resource\TPerf\Title.gif"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_back
long linecolor = 8421504
integer linethickness = 4
long fillcolor = 33538240
integer x = 18
integer y = 16
integer width = 1938
integer height = 896
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_back
long linecolor = 8421504
integer linethickness = 4
long fillcolor = 12639424
integer x = 37
integer y = 32
integer width = 1902
integer height = 864
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_active from statictext within w_back
integer x = 823
integer y = 736
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12639424
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_total from statictext within w_back
integer x = 823
integer y = 592
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421376
long backcolor = 12639424
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_pc from statictext within w_back
integer x = 201
integer y = 432
integer width = 1573
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421376
long backcolor = 12639424
string text = "LR2"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_back
integer x = 741
integer y = 368
integer width = 475
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Profit Center"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_back
integer x = 731
integer y = 672
integer width = 475
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Active Alerts"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_back
integer x = 741
integer y = 528
integer width = 475
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Total Alerts"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within w_back
integer x = 512
integer y = 832
integer width = 933
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "M a e r s k   T a n k e r s"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_user from statictext within w_back
integer x = 201
integer y = 288
integer width = 1573
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421376
long backcolor = 12639424
string text = "LR2"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_back
integer x = 750
integer y = 224
integer width = 475
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "User Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ver from statictext within w_back
integer x = 55
integer y = 832
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 12639424
string text = "Ver: X.X.X"
boolean focusrectangle = false
end type

type st_db from statictext within w_back
integer x = 91
integer y = 112
integer width = 1792
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

