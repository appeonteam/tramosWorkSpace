$PBExportHeader$u_atobviac_find_portcode.sru
$PBExportComments$visual user object
forward
global type u_atobviac_find_portcode from mt_u_visualobject
end type
type dw_port_list from mt_u_datawindow within u_atobviac_find_portcode
end type
type dw_calc_longlat_search from mt_u_datawindow within u_atobviac_find_portcode
end type
type dw_calc_unctad_search_name from mt_u_datawindow within u_atobviac_find_portcode
end type
type cb_search_longlat from commandbutton within u_atobviac_find_portcode
end type
type cb_search_name from commandbutton within u_atobviac_find_portcode
end type
type cb_refresh from commandbutton within u_atobviac_find_portcode
end type
type gb_2 from groupbox within u_atobviac_find_portcode
end type
type gb_3 from uo_gb_base within u_atobviac_find_portcode
end type
type gb_1 from uo_gb_base within u_atobviac_find_portcode
end type
type st_norows from statictext within u_atobviac_find_portcode
end type
end forward

global type u_atobviac_find_portcode from mt_u_visualobject
integer width = 3259
integer height = 2008
long backcolor = 32238571
dw_port_list dw_port_list
dw_calc_longlat_search dw_calc_longlat_search
dw_calc_unctad_search_name dw_calc_unctad_search_name
cb_search_longlat cb_search_longlat
cb_search_name cb_search_name
cb_refresh cb_refresh
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
st_norows st_norows
end type
global u_atobviac_find_portcode u_atobviac_find_portcode

on u_atobviac_find_portcode.create
int iCurrent
call super::create
this.dw_port_list=create dw_port_list
this.dw_calc_longlat_search=create dw_calc_longlat_search
this.dw_calc_unctad_search_name=create dw_calc_unctad_search_name
this.cb_search_longlat=create cb_search_longlat
this.cb_search_name=create cb_search_name
this.cb_refresh=create cb_refresh
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.st_norows=create st_norows
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_port_list
this.Control[iCurrent+2]=this.dw_calc_longlat_search
this.Control[iCurrent+3]=this.dw_calc_unctad_search_name
this.Control[iCurrent+4]=this.cb_search_longlat
this.Control[iCurrent+5]=this.cb_search_name
this.Control[iCurrent+6]=this.cb_refresh
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.st_norows
end on

on u_atobviac_find_portcode.destroy
call super::destroy
destroy(this.dw_port_list)
destroy(this.dw_calc_longlat_search)
destroy(this.dw_calc_unctad_search_name)
destroy(this.cb_search_longlat)
destroy(this.cb_search_name)
destroy(this.cb_refresh)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.st_norows)
end on

type dw_port_list from mt_u_datawindow within u_atobviac_find_portcode
integer x = 27
integer y = 28
integer width = 3168
integer height = 1542
integer taborder = 10
string dataobject = "d_sq_tb_atobviac_find_portcode"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event constructor;call super::constructor;this.SetTransObject(sqlca)
this.setrowfocusindicator( focusrect!)
/* Activate sort and set sort by click on header */
//if isValid(inv_sort) then inv_sort.of_setColumnheader( true )
this.Retrieve()
end event

event clicked;call super::clicked;if row>0 then
	this.SelectRow(0, false)
	this.SelectRow(row, true)
end if
end event

type dw_calc_longlat_search from mt_u_datawindow within u_atobviac_find_portcode
integer x = 50
integer y = 1648
integer width = 1669
integer height = 80
integer taborder = 20
string dataobject = "d_calc_unctad_search"
boolean border = false
end type

event constructor;call super::constructor;//of_setUpdateable(false)
end event

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the search name button to be the default

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_search_longlat.Default = true
end event

type dw_calc_unctad_search_name from mt_u_datawindow within u_atobviac_find_portcode
integer x = 50
integer y = 1872
integer width = 1499
integer height = 84
integer taborder = 30
string dataobject = "d_calc_unctad_search_name"
boolean border = false
end type

event constructor;call super::constructor;//of_setUpdateable(false)
end event

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set the search name button to be the default

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

cb_search_name.Default = true
end event

type cb_search_longlat from commandbutton within u_atobviac_find_portcode
integer x = 1742
integer y = 1640
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search"
end type

event clicked;string				ls_latitude, ls_longitude
decimal {17} 	ld_latitude, ld_longitude
decimal {17}		ld_lat_min, ld_lat_max
decimal {17}		ld_long_min, ld_long_max
integer 			li_within
string				ls_filter
long 				ll_startPos=1

dw_calc_longlat_search.acceptText()
ls_latitude = dw_calc_longlat_search.getItemString(1, "latitude")
ls_longitude = dw_calc_longlat_search.getItemString(1, "longitude")
li_within = dw_calc_longlat_search.getItemNumber(1, "within")

ld_latitude = dec(mid(ls_latitude,1,3))+(dec(mid(ls_latitude,4,2))/60)
ld_longitude = dec(mid(ls_longitude,1,3))+(dec(mid(ls_longitude,4,2))/60)

/* latitude */
choose case mid(ls_latitude,6,1)
	case "N"
		ld_lat_min 	= ld_latitude - (li_within/60)
		ld_lat_max	= ld_latitude + (li_within/60)
	case "S"
		ld_lat_min 	= (ld_latitude + (li_within/60))*-1
		ld_lat_max	= (ld_latitude - (li_within/60))*-1
	case else
		MessageBox("Validation error", "Latitude not entered correct")
		return
end choose

/* longitude */
choose case mid(ls_longitude,6,1)
	case "E"
		ld_long_min 	= ld_longitude - (li_within/60)
		ld_long_max	= ld_longitude + (li_within/60)
	case "W"
		ld_long_min 	= (ld_longitude + (li_within/60))*-1
		ld_long_max	= (ld_longitude - (li_within/60))*-1
	case else
		MessageBox("Validation error", "Longitude not entered correct")
		return
end choose

ls_filter = "abc_latitude >=("+string(ld_lat_min)+") and abc_latitude<=("+string(ld_lat_max)+") and abc_longitude >=("+string(ld_long_min)+") and abc_longitude<=("+string(ld_long_max)+")" 
/* 	following is a workaround. PB has a bug when decimal symbol in regional settings is ',' (komma)
	must be changed to '.'(dot) */
ll_startPos = Pos(ls_filter, ",", ll_startPos) 
DO WHILE ll_startPos > 0
    ls_filter = Replace(ls_filter, ll_startPos, 1, ".")
    ll_startPos = Pos(ls_filter, ",", ll_startPos+1)
LOOP

dw_port_list.setFilter(ls_filter)
dw_port_list.filter()
end event

type cb_search_name from commandbutton within u_atobviac_find_portcode
integer x = 1742
integer y = 1864
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search"
end type

event clicked;string 	ls_port, ls_country
string		ls_filter

dw_calc_unctad_search_name.accepttext( )
ls_port = dw_calc_unctad_search_name.getItemString(1, "portname")
ls_country=dw_calc_unctad_search_name.getItemString(1, "country")

if not isNull(ls_port) and not isNull(ls_country) then
	ls_filter = "match( upper(abc_portname), upper('"+ls_port+"')) and match(upper(abc_portcountry), upper('"+ls_country+"'))"
elseif not isNull(ls_port) then
	ls_filter = "match( upper(abc_portname), upper('"+ls_port+"'))"
elseif not isNull(ls_country) then
	ls_filter = "match(upper(abc_portcountry), upper('"+ls_country+"'))"
else
	ls_filter = ""
end if

dw_port_list.setFilter( ls_filter )
dw_port_list.filter()

end event

type cb_refresh from commandbutton within u_atobviac_find_portcode
integer x = 2853
integer y = 1732
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;dw_port_list.setFilter("")
dw_port_list.filter()

end event

type gb_2 from groupbox within u_atobviac_find_portcode
boolean visible = false
integer x = 2286
integer y = 1640
integer width = 411
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32238571
string text = "none"
end type

type gb_3 from uo_gb_base within u_atobviac_find_portcode
integer x = 32
integer y = 1808
integer width = 2085
integer height = 188
integer taborder = 20
integer weight = 700
long backcolor = 32238571
string text = "Search Name/Country"
end type

type gb_1 from uo_gb_base within u_atobviac_find_portcode
integer x = 32
integer y = 1584
integer width = 2085
integer height = 208
integer taborder = 10
integer weight = 700
long backcolor = 32238571
string text = "Search Longitude/Latitude"
end type

type st_norows from statictext within u_atobviac_find_portcode
integer x = 2354
integer y = 840
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

