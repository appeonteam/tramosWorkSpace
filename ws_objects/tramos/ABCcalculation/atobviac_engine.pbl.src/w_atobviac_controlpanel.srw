$PBExportHeader$w_atobviac_controlpanel.srw
forward
global type w_atobviac_controlpanel from mt_w_main
end type
type cb_findremoved from commandbutton within w_atobviac_controlpanel
end type
type st_calc_port_used from statictext within w_atobviac_controlpanel
end type
type st_17 from statictext within w_atobviac_controlpanel
end type
type cb_ports_in_calc_no_abccode from commandbutton within w_atobviac_controlpanel
end type
type cb_close from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_rp_not_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_not_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_rp_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_rp from commandbutton within w_atobviac_controlpanel
end type
type cb_show_tramos_ports from commandbutton within w_atobviac_controlpanel
end type
type cb_show_abc_rp_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_abc_rp_not_linked from commandbutton within w_atobviac_controlpanel
end type
type st_abc_rp_not_linked from statictext within w_atobviac_controlpanel
end type
type st_16 from statictext within w_atobviac_controlpanel
end type
type st_abc_rp_linked from statictext within w_atobviac_controlpanel
end type
type st_15 from statictext within w_atobviac_controlpanel
end type
type cb_show_abc_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_abc_not_linked from commandbutton within w_atobviac_controlpanel
end type
type cb_show_abc_rp from commandbutton within w_atobviac_controlpanel
end type
type cb_show_abc_ports from commandbutton within w_atobviac_controlpanel
end type
type st_feed_status from statictext within w_atobviac_controlpanel
end type
type cb_find_portcode from commandbutton within w_atobviac_controlpanel
end type
type st_tramos_rp_not_linked from statictext within w_atobviac_controlpanel
end type
type st_tramos_not_linked from statictext within w_atobviac_controlpanel
end type
type st_14 from statictext within w_atobviac_controlpanel
end type
type st_13 from statictext within w_atobviac_controlpanel
end type
type st_12 from statictext within w_atobviac_controlpanel
end type
type st_tramos_rp_linked from statictext within w_atobviac_controlpanel
end type
type st_tramos_linked from statictext within w_atobviac_controlpanel
end type
type st_abc_not_linked from statictext within w_atobviac_controlpanel
end type
type st_abc_linked from statictext within w_atobviac_controlpanel
end type
type st_tramos_rp from statictext within w_atobviac_controlpanel
end type
type st_tramos_ports from statictext within w_atobviac_controlpanel
end type
type st_11 from statictext within w_atobviac_controlpanel
end type
type st_10 from statictext within w_atobviac_controlpanel
end type
type st_9 from statictext within w_atobviac_controlpanel
end type
type st_8 from statictext within w_atobviac_controlpanel
end type
type st_7 from statictext within w_atobviac_controlpanel
end type
type st_abc_rp from statictext within w_atobviac_controlpanel
end type
type st_abc_ports from statictext within w_atobviac_controlpanel
end type
type st_date from statictext within w_atobviac_controlpanel
end type
type st_version from statictext within w_atobviac_controlpanel
end type
type st_6 from statictext within w_atobviac_controlpanel
end type
type st_5 from statictext within w_atobviac_controlpanel
end type
type st_4 from statictext within w_atobviac_controlpanel
end type
type st_3 from statictext within w_atobviac_controlpanel
end type
type st_2 from statictext within w_atobviac_controlpanel
end type
type st_1 from statictext within w_atobviac_controlpanel
end type
type hpb_1 from hprogressbar within w_atobviac_controlpanel
end type
type cb_feed from commandbutton within w_atobviac_controlpanel
end type
type gb_1 from groupbox within w_atobviac_controlpanel
end type
type gb_2 from groupbox within w_atobviac_controlpanel
end type
type gb_3 from groupbox within w_atobviac_controlpanel
end type

end forward

global type w_atobviac_controlpanel from mt_w_main
integer x = 215
integer y = 220
integer width = 2167
integer height = 1928
string title = "AtoBviaC Control Panel"
boolean maxbox = false
boolean resizable = false
cb_findremoved cb_findremoved
st_calc_port_used st_calc_port_used
st_17 st_17
cb_ports_in_calc_no_abccode cb_ports_in_calc_no_abccode
cb_close cb_close
cb_show_tramos_rp_not_linked cb_show_tramos_rp_not_linked
cb_show_tramos_not_linked cb_show_tramos_not_linked
cb_show_tramos_rp_linked cb_show_tramos_rp_linked
cb_show_tramos_linked cb_show_tramos_linked
cb_show_tramos_rp cb_show_tramos_rp
cb_show_tramos_ports cb_show_tramos_ports
cb_show_abc_rp_linked cb_show_abc_rp_linked
cb_show_abc_rp_not_linked cb_show_abc_rp_not_linked
st_abc_rp_not_linked st_abc_rp_not_linked
st_16 st_16
st_abc_rp_linked st_abc_rp_linked
st_15 st_15
cb_show_abc_linked cb_show_abc_linked
cb_show_abc_not_linked cb_show_abc_not_linked
cb_show_abc_rp cb_show_abc_rp
cb_show_abc_ports cb_show_abc_ports
st_feed_status st_feed_status
cb_find_portcode cb_find_portcode
st_tramos_rp_not_linked st_tramos_rp_not_linked
st_tramos_not_linked st_tramos_not_linked
st_14 st_14
st_13 st_13
st_12 st_12
st_tramos_rp_linked st_tramos_rp_linked
st_tramos_linked st_tramos_linked
st_abc_not_linked st_abc_not_linked
st_abc_linked st_abc_linked
st_tramos_rp st_tramos_rp
st_tramos_ports st_tramos_ports
st_11 st_11
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_abc_rp st_abc_rp
st_abc_ports st_abc_ports
st_date st_date
st_version st_version
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
hpb_1 hpb_1
cb_feed cb_feed
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
event ue_postopen()
end type
global w_atobviac_controlpanel w_atobviac_controlpanel

type variables
n_atobviac inv_AtoBviaC


end variables

forward prototypes
public subroutine documentation ()

end prototypes

event ue_postopen;long ll_count

setPointer(HourGlass!)
this.setRedraw( false )

/* If not already active create instance */
if NOT isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac

/* If not open open tables - can take several seconds */
if NOT gnv_atobviac.of_getTableOpen( ) then
	open(w_startup_screen)
	gnv_AtoBviaC.of_OpenTable()
	close(w_startup_screen)
end if 

/* Only Administrators do have access to FEED */
IF uo_global.ii_access_level > 1 THEN
	cb_feed.Enabled = true
	cb_findremoved.Enabled = true
end if

st_version.text 		= gnv_atobviac.of_getTableVersion( )
st_date.text 		= gnv_atobviac.of_getTableDate( )

/* AtoBviaC Ports and ABC Ports excluding alias ports in () */
SELECT count(*)  
	INTO :ll_count  
	FROM ATOBVIAC_PORT  
   	WHERE ATOBVIAC_PORT.ABC_ADVANCED_RP = 0 
	AND ATOBVIAC_PORT.ABC_PORTCOUNTRY NOT LIKE "%Routing point%" ;
commit;
st_abc_ports.text 	= string(ll_count,"#,##0")+" ("+string(gnv_atobviac.of_getNumberOfPorts( ),"#,##0")+")"

/* AtoBviaC Routing Points and RP excluding alias in () */
SELECT count(*)  
	INTO :ll_count  
	FROM ATOBVIAC_PORT  
   	WHERE ATOBVIAC_PORT.ABC_ADVANCED_RP = 1   
	OR ATOBVIAC_PORT.ABC_PORTCOUNTRY LIKE "%Routing point%" ;
commit;
st_abc_rp.text 	= string(ll_count,"#,##0")+" ("+string(gnv_atobviac.of_getNumberOfRoutingPoints( ),"#,##0")+")"

/* AtoBviaC Ports linked to TRAMOS */
SELECT COUNT(DISTINCT ABC_PORTID) 
	INTO :ll_count
	FROM PORTS
	WHERE ABC_PORTID IS NOT NULL
	AND CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT = 0 ;
commit;
st_abc_linked.text = string(ll_count,"#,##0")

/* AtoBviaC RP linked to TRAMOS */
SELECT COUNT(DISTINCT ABC_PORTID) 
	INTO :ll_count
	FROM PORTS
	WHERE ABC_PORTID IS NOT NULL  
	AND CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT > 0 ;
commit;
st_abc_rp_linked.text = string(ll_count,"#,##0")

/* AtoBviaC Ports NOT linked to TRAMOS */
// CR3547 Speed up
SELECT COUNT(*) 
	INTO :ll_count
	FROM ATOBVIAC_PORT
	WHERE ABC_PORTCOUNTRY NOT LIKE '%Routing point%' 
   AND NOT EXISTS(SELECT * FROM PORTS
                  WHERE ABC_PORTID IS NOT NULL
                  AND ATOBVIAC_PORT.ABC_PORTID = PORTS.ABC_PORTID );
commit;
st_abc_not_linked.text = string(ll_count,"#,##0")

/* AtoBviaC RP NOT linked to TRAMOS */
// CR3547 Speed up
SELECT COUNT(*) 
	INTO :ll_count
	FROM ATOBVIAC_PORT
	WHERE ABC_PORTCOUNTRY LIKE '%Routing point%' 
	AND NOT EXISTS(SELECT * FROM PORTS
                  WHERE ABC_PORTID IS NOT NULL
                  AND ATOBVIAC_PORT.ABC_PORTID = PORTS.ABC_PORTID );
commit;
st_abc_rp_not_linked.text = string(ll_count,"#,##0")

/* TRAMOS ports */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT = 0 ;
commit;
st_tramos_ports.text = string(ll_count,"#,##0")

/* TRAMOS Via-points and Canals */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT > 0 ;
commit;
st_tramos_rp.text = string(ll_count,"#,##0")

/* TRAMOS Ports linked */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT = 0 
	AND ABC_PORTID IS NOT NULL;
commit;
st_tramos_linked.text = string(ll_count,"#,##0")

/* TRAMOS RP linked */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT > 0 
	AND ABC_PORTID IS NOT NULL;
commit;
st_tramos_rp_linked.text = string(ll_count,"#,##0")

/* TRAMOS Ports NOT linked */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT = 0 
	AND ABC_PORTID IS NULL;
commit;
st_tramos_not_linked.text = string(ll_count,"#,##0")

/* TRAMOS RP NOT linked */
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS
	WHERE CHAR_LENGTH(RTRIM(PORT_CODE)) = 3
	AND VIA_POINT > 0 
	AND ABC_PORTID IS NULL;
commit;
st_tramos_rp_not_linked.text = string(ll_count,"#,##0")

// CR3547 Speed up
SELECT COUNT(*) 
	INTO :ll_count
	FROM PORTS P 
	WHERE (EXISTS(SELECT * FROM CAL_CAIO WHERE P.PORT_CODE = CAL_CAIO.PORT_CODE)
        OR EXISTS(SELECT * FROM CAL_CALC WHERE P.PORT_CODE = CAL_CALC.CAL_CALC_BALLAST_FROM)
        OR EXISTS(SELECT * FROM CAL_CALC WHERE P.PORT_CODE = CAL_CALC.CAL_CALC_BALLAST_TO))
	AND P.ABC_PORTID = NULL 
	AND P.PORT_CODE <> '          ';
st_calc_port_used.text = string(ll_count,"#,##0")


this.setRedraw( true )
setPointer(Arrow!)

end event

public subroutine documentation ();/********************************************************************
	w_atobviac_controlpanel
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - moved into MT framework. 
		  												Also updated opensheet() call to find atobviac port.
	</HISTORY>
********************************************************************/
end subroutine

on w_atobviac_controlpanel.create
int iCurrent
call super::create
this.cb_findremoved=create cb_findremoved
this.st_calc_port_used=create st_calc_port_used
this.st_17=create st_17
this.cb_ports_in_calc_no_abccode=create cb_ports_in_calc_no_abccode
this.cb_close=create cb_close
this.cb_show_tramos_rp_not_linked=create cb_show_tramos_rp_not_linked
this.cb_show_tramos_not_linked=create cb_show_tramos_not_linked
this.cb_show_tramos_rp_linked=create cb_show_tramos_rp_linked
this.cb_show_tramos_linked=create cb_show_tramos_linked
this.cb_show_tramos_rp=create cb_show_tramos_rp
this.cb_show_tramos_ports=create cb_show_tramos_ports
this.cb_show_abc_rp_linked=create cb_show_abc_rp_linked
this.cb_show_abc_rp_not_linked=create cb_show_abc_rp_not_linked
this.st_abc_rp_not_linked=create st_abc_rp_not_linked
this.st_16=create st_16
this.st_abc_rp_linked=create st_abc_rp_linked
this.st_15=create st_15
this.cb_show_abc_linked=create cb_show_abc_linked
this.cb_show_abc_not_linked=create cb_show_abc_not_linked
this.cb_show_abc_rp=create cb_show_abc_rp
this.cb_show_abc_ports=create cb_show_abc_ports
this.st_feed_status=create st_feed_status
this.cb_find_portcode=create cb_find_portcode
this.st_tramos_rp_not_linked=create st_tramos_rp_not_linked
this.st_tramos_not_linked=create st_tramos_not_linked
this.st_14=create st_14
this.st_13=create st_13
this.st_12=create st_12
this.st_tramos_rp_linked=create st_tramos_rp_linked
this.st_tramos_linked=create st_tramos_linked
this.st_abc_not_linked=create st_abc_not_linked
this.st_abc_linked=create st_abc_linked
this.st_tramos_rp=create st_tramos_rp
this.st_tramos_ports=create st_tramos_ports
this.st_11=create st_11
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_abc_rp=create st_abc_rp
this.st_abc_ports=create st_abc_ports
this.st_date=create st_date
this.st_version=create st_version
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.hpb_1=create hpb_1
this.cb_feed=create cb_feed
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_findremoved
this.Control[iCurrent+2]=this.st_calc_port_used
this.Control[iCurrent+3]=this.st_17
this.Control[iCurrent+4]=this.cb_ports_in_calc_no_abccode
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.cb_show_tramos_rp_not_linked
this.Control[iCurrent+7]=this.cb_show_tramos_not_linked
this.Control[iCurrent+8]=this.cb_show_tramos_rp_linked
this.Control[iCurrent+9]=this.cb_show_tramos_linked
this.Control[iCurrent+10]=this.cb_show_tramos_rp
this.Control[iCurrent+11]=this.cb_show_tramos_ports
this.Control[iCurrent+12]=this.cb_show_abc_rp_linked
this.Control[iCurrent+13]=this.cb_show_abc_rp_not_linked
this.Control[iCurrent+14]=this.st_abc_rp_not_linked
this.Control[iCurrent+15]=this.st_16
this.Control[iCurrent+16]=this.st_abc_rp_linked
this.Control[iCurrent+17]=this.st_15
this.Control[iCurrent+18]=this.cb_show_abc_linked
this.Control[iCurrent+19]=this.cb_show_abc_not_linked
this.Control[iCurrent+20]=this.cb_show_abc_rp
this.Control[iCurrent+21]=this.cb_show_abc_ports
this.Control[iCurrent+22]=this.st_feed_status
this.Control[iCurrent+23]=this.cb_find_portcode
this.Control[iCurrent+24]=this.st_tramos_rp_not_linked
this.Control[iCurrent+25]=this.st_tramos_not_linked
this.Control[iCurrent+26]=this.st_14
this.Control[iCurrent+27]=this.st_13
this.Control[iCurrent+28]=this.st_12
this.Control[iCurrent+29]=this.st_tramos_rp_linked
this.Control[iCurrent+30]=this.st_tramos_linked
this.Control[iCurrent+31]=this.st_abc_not_linked
this.Control[iCurrent+32]=this.st_abc_linked
this.Control[iCurrent+33]=this.st_tramos_rp
this.Control[iCurrent+34]=this.st_tramos_ports
this.Control[iCurrent+35]=this.st_11
this.Control[iCurrent+36]=this.st_10
this.Control[iCurrent+37]=this.st_9
this.Control[iCurrent+38]=this.st_8
this.Control[iCurrent+39]=this.st_7
this.Control[iCurrent+40]=this.st_abc_rp
this.Control[iCurrent+41]=this.st_abc_ports
this.Control[iCurrent+42]=this.st_date
this.Control[iCurrent+43]=this.st_version
this.Control[iCurrent+44]=this.st_6
this.Control[iCurrent+45]=this.st_5
this.Control[iCurrent+46]=this.st_4
this.Control[iCurrent+47]=this.st_3
this.Control[iCurrent+48]=this.st_2
this.Control[iCurrent+49]=this.st_1
this.Control[iCurrent+50]=this.hpb_1
this.Control[iCurrent+51]=this.cb_feed
this.Control[iCurrent+52]=this.gb_1
this.Control[iCurrent+53]=this.gb_2
this.Control[iCurrent+54]=this.gb_3
end on

on w_atobviac_controlpanel.destroy
call super::destroy
destroy(this.cb_findremoved)
destroy(this.st_calc_port_used)
destroy(this.st_17)
destroy(this.cb_ports_in_calc_no_abccode)
destroy(this.cb_close)
destroy(this.cb_show_tramos_rp_not_linked)
destroy(this.cb_show_tramos_not_linked)
destroy(this.cb_show_tramos_rp_linked)
destroy(this.cb_show_tramos_linked)
destroy(this.cb_show_tramos_rp)
destroy(this.cb_show_tramos_ports)
destroy(this.cb_show_abc_rp_linked)
destroy(this.cb_show_abc_rp_not_linked)
destroy(this.st_abc_rp_not_linked)
destroy(this.st_16)
destroy(this.st_abc_rp_linked)
destroy(this.st_15)
destroy(this.cb_show_abc_linked)
destroy(this.cb_show_abc_not_linked)
destroy(this.cb_show_abc_rp)
destroy(this.cb_show_abc_ports)
destroy(this.st_feed_status)
destroy(this.cb_find_portcode)
destroy(this.st_tramos_rp_not_linked)
destroy(this.st_tramos_not_linked)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_tramos_rp_linked)
destroy(this.st_tramos_linked)
destroy(this.st_abc_not_linked)
destroy(this.st_abc_linked)
destroy(this.st_tramos_rp)
destroy(this.st_tramos_ports)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_abc_rp)
destroy(this.st_abc_ports)
destroy(this.st_date)
destroy(this.st_version)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.hpb_1)
destroy(this.cb_feed)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;postevent("ue_postopen")
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_atobviac_controlpanel
end type

type cb_findremoved from commandbutton within w_atobviac_controlpanel
integer x = 87
integer y = 1560
integer width = 517
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Find Removed Ports"
end type

event clicked;hpb_1.visible = true
st_feed_status.visible = true
gnv_AtoBviaC.of_findRemovedPortCode( hpb_1)
 
end event

type st_calc_port_used from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 1156
integer width = 631
integer height = 64
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

type st_17 from statictext within w_atobviac_controlpanel
integer x = 73
integer y = 1156
integer width = 859
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Calculation ports not linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ports_in_calc_no_abccode from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 1156
integer width = 343
integer height = 64
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT P.PORT_CODE CODE, P.PORT_N AS NAME, C.COUNTRY_NAME AS COUNTRY FROM PORTS P, COUNTRY C "+&
	"WHERE P.COUNTRY_ID = C.COUNTRY_ID AND "+&
				"(P.PORT_CODE IN (select DISTINCT PORT_CODE FROM CAL_CAIO) OR "+&
				"P.PORT_CODE IN (select DISTINCT CAL_CALC_BALLAST_FROM FROM CAL_CALC) OR "+&
				"P.PORT_CODE IN (select DISTINCT CAL_CALC_BALLAST_TO FROM CAL_CALC)) "+&
	"AND P.ABC_PORTID = NULL "+&
	"AND P.PORT_CODE <> '          ' "+&
	"ORDER BY P.PORT_N" )
end event

type cb_close from commandbutton within w_atobviac_controlpanel
integer x = 1778
integer y = 1724
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_show_tramos_rp_not_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 1096
integer width = 343
integer height = 64
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT PORTS.PORT_CODE AS CODE, PORTS.PORT_N AS NAME, COUNTRY.COUNTRY_NAME AS COUNTRY "+&
		"FROM PORTS, COUNTRY "+&  
			"WHERE PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
			"AND CHAR_LENGTH(RTRIM(PORTS.PORT_CODE)) = 3 "+&
			"AND PORTS.VIA_POINT > 0 "+&
			"AND PORTS.ABC_PORTID IS NULL "+&
		"ORDER BY PORTS.PORT_N")	

end event

type cb_show_tramos_not_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 1036
integer width = 343
integer height = 64
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT PORTS.PORT_CODE AS CODE, PORTS.PORT_N AS NAME, COUNTRY.COUNTRY_NAME AS COUNTRY "+&
		"FROM PORTS, COUNTRY "+&  
			"WHERE PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
			"AND CHAR_LENGTH(RTRIM(PORTS.PORT_CODE)) = 3 "+&
			"AND PORTS.VIA_POINT = 0 "+&
			"AND PORTS.ABC_PORTID IS NULL "+&
		"ORDER BY PORTS.PORT_N")	

end event

type cb_show_tramos_rp_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 976
integer width = 343
integer height = 64
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_dualports, &
	"SELECT PORTS.PORT_CODE AS CODE1, "+&
		"PORTS.PORT_N AS NAME1, "+&
		"COUNTRY.COUNTRY_NAME AS COUNTRY1, "+&
		"ATOBVIAC_PORT.ABC_PORTCODE AS CODE2, "+&
		"ATOBVIAC_PORT.ABC_PORTNAME AS NAME2, "+&   
         "ATOBVIAC_PORT.ABC_PORTCOUNTRY AS COUNTRY2 "+&   
		"FROM PORTS, "+&  
			"ATOBVIAC_PORT, "+&  
			"COUNTRY "+&  
	   "WHERE PORTS.ABC_PORTID = ATOBVIAC_PORT.ABC_PORTID "+&   
		"AND PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
			"AND CHAR_LENGTH(RTRIM(PORTS.PORT_CODE)) = 3 "+&
			"AND PORTS.VIA_POINT > 0 "+&
			"AND ATOBVIAC_PORT.ABC_PORTID IS NOT NULL "+&
		"ORDER BY PORTS.PORT_N")	

end event

type cb_show_tramos_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 916
integer width = 343
integer height = 64
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_dualports, &
	"SELECT PORTS.PORT_CODE AS CODE1, "+&
		"PORTS.PORT_N AS NAME1, "+&
		"COUNTRY.COUNTRY_NAME AS COUNTRY1, "+&
		"ATOBVIAC_PORT.ABC_PORTCODE AS CODE2, "+&
		"ATOBVIAC_PORT.ABC_PORTNAME AS NAME2, "+&   
         "ATOBVIAC_PORT.ABC_PORTCOUNTRY AS COUNTRY2 "+&   
		"FROM PORTS, "+&  
			"ATOBVIAC_PORT, "+&  
			"COUNTRY "+&  
	   "WHERE PORTS.ABC_PORTID = ATOBVIAC_PORT.ABC_PORTID "+&   
		"AND PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
		"AND CHAR_LENGTH(RTRIM(PORTS.PORT_CODE)) = 3 "+&
		"AND PORTS.VIA_POINT = 0 "+&
		"AND ATOBVIAC_PORT.ABC_PORTID IS NOT NULL "+&
		"ORDER BY PORTS.PORT_N")	

end event

type cb_show_tramos_rp from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 856
integer width = 343
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT PORT_CODE AS CODE, PORT_N AS NAME, COUNTRY.COUNTRY_NAME AS COUNTRY "+&
		"FROM PORTS, "+&  
			"COUNTRY "+&  
		"WHERE PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
		"AND CHAR_LENGTH(RTRIM(PORT_CODE)) = 3 "+&
		"AND VIA_POINT > 0 "+&
		"ORDER BY PORT_N")	

end event

type cb_show_tramos_ports from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 796
integer width = 343
integer height = 64
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT PORT_CODE AS CODE, PORT_N AS NAME, COUNTRY.COUNTRY_NAME AS COUNTRY "+&
		"FROM PORTS, "+&  
			"COUNTRY "+&  
		"WHERE PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
		"AND CHAR_LENGTH(RTRIM(PORT_CODE)) = 3 "+&
		"AND VIA_POINT = 0 "+&
		"ORDER BY PORT_N")	

end event

type cb_show_abc_rp_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 456
integer width = 343
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_dualports, &
  "SELECT ATOBVIAC_PORT.ABC_PORTCODE AS CODE1, "+&   
         "ATOBVIAC_PORT.ABC_PORTNAME AS NAME1, "+&   
         "ATOBVIAC_PORT.ABC_PORTCOUNTRY AS COUNTRY1, "+&   
         "PORTS.PORT_CODE AS CODE2, "+&   
         "PORTS.PORT_N AS NAME2, "+&   
         "COUNTRY.COUNTRY_NAME AS COUNTRY2 "+&
    "FROM ATOBVIAC_PORT, "+&   
         "PORTS, "+&  
		"COUNTRY "+&
   "WHERE PORTS.ABC_PORTID = ATOBVIAC_PORT.ABC_PORTID "+&   
	"AND PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
	"AND ABC_PORTCOUNTRY LIKE '%Routing point%' "+&
"ORDER BY ATOBVIAC_PORT.ABC_PORTNAME ASC")   

end event

type cb_show_abc_rp_not_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 576
integer width = 343
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT ABC_PORTCODE AS CODE, ABC_PORTNAME AS NAME, ABC_PORTCOUNTRY AS COUNTRY "+&
		"FROM ATOBVIAC_PORT "+&  
		"WHERE ABC_PORTCOUNTRY LIKE '%Routing point%' "+&
		"AND ABC_PORTID NOT IN (SELECT ABC_PORTID "+&
														"FROM PORTS "+&
														"WHERE ABC_PORTID IS NOT NULL) "+&
		"ORDER BY ABC_PORTNAME")	

end event

type st_abc_rp_not_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 576
integer width = 631
integer height = 64
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

type st_16 from statictext within w_atobviac_controlpanel
integer x = 110
integer y = 576
integer width = 823
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Routing Points not linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_abc_rp_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 456
integer width = 631
integer height = 64
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

type st_15 from statictext within w_atobviac_controlpanel
integer x = 187
integer y = 456
integer width = 745
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Routing Points linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_show_abc_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 396
integer width = 343
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_dualports, &
  "SELECT ATOBVIAC_PORT.ABC_PORTCODE AS CODE1, "+&   
         "ATOBVIAC_PORT.ABC_PORTNAME AS NAME1, "+&   
         "ATOBVIAC_PORT.ABC_PORTCOUNTRY AS COUNTRY1, "+&   
         "PORTS.PORT_CODE AS CODE2, "+&   
         "PORTS.PORT_N AS NAME2, "+&   
         "COUNTRY.COUNTRY_NAME AS COUNTRY2 "+&
    "FROM ATOBVIAC_PORT, "+&   
         "PORTS, "+&
		"COUNTRY "+&
   "WHERE PORTS.ABC_PORTID = ATOBVIAC_PORT.ABC_PORTID "+&   
	"AND PORTS.COUNTRY_ID *= COUNTRY.COUNTRY_ID "+&
	"AND ABC_PORTCOUNTRY NOT LIKE '%Routing point%' "+&
"ORDER BY ATOBVIAC_PORT.ABC_PORTNAME ASC")   

end event

type cb_show_abc_not_linked from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 516
integer width = 343
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT ABC_PORTCODE AS CODE, ABC_PORTNAME AS NAME, ABC_PORTCOUNTRY AS COUNTRY "+&
		"FROM ATOBVIAC_PORT "+&  
		"WHERE ABC_PORTCOUNTRY NOT LIKE '%Routing point%' "+&
		"AND ABC_PORTID NOT IN (SELECT ABC_PORTID "+&
														"FROM PORTS "+&
														"WHERE ABC_PORTID IS NOT NULL) "+&
		"ORDER BY ABC_PORTNAME")	

end event

type cb_show_abc_rp from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 336
integer width = 343
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT ABC_PORTCODE AS CODE, ABC_PORTNAME AS NAME, ABC_PORTCOUNTRY AS COUNTRY "+&
		"FROM ATOBVIAC_PORT "+&  
			"WHERE ATOBVIAC_PORT.ABC_ADVANCED_RP = 1 "+&
			"OR ATOBVIAC_PORT.ABC_PORTCOUNTRY LIKE '%Routing point%' "+&
		"ORDER BY ABC_PORTNAME")	

end event

type cb_show_abc_ports from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 276
integer width = 343
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show"
end type

event clicked;openwithparm(w_show_ports, &
	"SELECT ABC_PORTCODE AS CODE, ABC_PORTNAME AS NAME, ABC_PORTCOUNTRY AS COUNTRY "+&
		"FROM ATOBVIAC_PORT "+&  
			"WHERE ATOBVIAC_PORT.ABC_ADVANCED_RP = 0 "+&
			"AND ATOBVIAC_PORT.ABC_PORTCOUNTRY NOT LIKE '%Routing point%' "+&
		"ORDER BY ABC_PORTNAME")	

end event

type st_feed_status from statictext within w_atobviac_controlpanel
integer x = 87
integer y = 1472
integer width = 1993
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_find_portcode from commandbutton within w_atobviac_controlpanel
integer x = 46
integer y = 1724
integer width = 517
integer height = 100
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Find &AtoBviaC Code"
end type

event clicked;opensheet(w_atobviac_find_portcode, w_tramos_main,0, Original!)
end event

type st_tramos_rp_not_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 1096
integer width = 631
integer height = 64
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

type st_tramos_not_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 1036
integer width = 631
integer height = 64
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

type st_14 from statictext within w_atobviac_controlpanel
integer x = 73
integer y = 1096
integer width = 859
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Via-points / Canals not linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_13 from statictext within w_atobviac_controlpanel
integer x = 187
integer y = 1036
integer width = 745
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports not linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_12 from statictext within w_atobviac_controlpanel
integer x = 169
integer y = 976
integer width = 763
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Via-points / Canals linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_tramos_rp_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 976
integer width = 631
integer height = 64
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

type st_tramos_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 916
integer width = 631
integer height = 64
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

type st_abc_not_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 516
integer width = 631
integer height = 64
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

type st_abc_linked from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 396
integer width = 631
integer height = 64
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

type st_tramos_rp from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 856
integer width = 631
integer height = 64
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

type st_tramos_ports from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 796
integer width = 631
integer height = 64
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

type st_11 from statictext within w_atobviac_controlpanel
integer x = 187
integer y = 916
integer width = 745
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_10 from statictext within w_atobviac_controlpanel
integer x = 338
integer y = 856
integer width = 594
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Via-points / Canals:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within w_atobviac_controlpanel
integer x = 494
integer y = 796
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_atobviac_controlpanel
integer x = 165
integer y = 516
integer width = 768
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports not linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_atobviac_controlpanel
integer x = 187
integer y = 396
integer width = 745
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports linked:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_abc_rp from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 336
integer width = 631
integer height = 64
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

type st_abc_ports from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 276
integer width = 631
integer height = 64
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

type st_date from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 216
integer width = 631
integer height = 64
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

type st_version from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 156
integer width = 631
integer height = 64
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

type st_6 from statictext within w_atobviac_controlpanel
integer x = 402
integer y = 336
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Routing Points:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_atobviac_controlpanel
integer x = 494
integer y = 276
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of Ports:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_atobviac_controlpanel
integer x = 494
integer y = 216
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_atobviac_controlpanel
integer x = 494
integer y = 156
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_atobviac_controlpanel
integer x = 978
integer y = 88
integer width = 631
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "BPS Distance Tables"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_atobviac_controlpanel
integer x = 434
integer y = 88
integer width = 498
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "AtoBviaC uses:"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_atobviac_controlpanel
integer x = 87
integer y = 1372
integer width = 1993
integer height = 96
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_feed from commandbutton within w_atobviac_controlpanel
integer x = 1737
integer y = 1560
integer width = 343
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

event clicked;hpb_1.visible = true
st_feed_status.visible = true
gnv_AtoBviaC.of_feedDBTables(hpb_1)
 
end event

type gb_1 from groupbox within w_atobviac_controlpanel
integer x = 46
integer y = 8
integer width = 2075
integer height = 668
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Distance Table Information"
end type

type gb_2 from groupbox within w_atobviac_controlpanel
integer x = 46
integer y = 700
integer width = 2075
integer height = 564
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TRAMOS Information"
end type

type gb_3 from groupbox within w_atobviac_controlpanel
integer x = 46
integer y = 1292
integer width = 2075
integer height = 392
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update Distance Table"
end type

