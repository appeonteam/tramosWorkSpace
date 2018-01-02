$PBExportHeader$u_atobviac_map.sru
forward
global type u_atobviac_map from mt_u_visualobject
end type
type cbx_portname from mt_u_checkbox within u_atobviac_map
end type
type cbx_piracy from mt_u_checkbox within u_atobviac_map
end type
type cbx_seca from mt_u_checkbox within u_atobviac_map
end type
type uo_bitmap from mt_u_visualobject within u_atobviac_map
end type
type cb_up from mt_u_commandbutton within u_atobviac_map
end type
type cb_down from mt_u_commandbutton within u_atobviac_map
end type
end forward

global type u_atobviac_map from mt_u_visualobject
integer width = 4498
integer height = 2100
long backcolor = 32304364
cbx_portname cbx_portname
cbx_piracy cbx_piracy
cbx_seca cbx_seca
uo_bitmap uo_bitmap
cb_up cb_up
cb_down cb_down
end type
global u_atobviac_map u_atobviac_map

type prototypes
// GDI functions
Function ulong DeleteObject(ulong hObject) LIBRARY "gdi32.dll" 
Function ulong DeleteDC(ulong hdc) LIBRARY "gdi32.dll" 
Function ulong CreateCompatibleDC(ulong hdc) LIBRARY "gdi32.dll" 
Function ulong BitBlt(ulong hDestDC,ulong xx,ulong yy,ulong nWidth,ulong nHeight,ulong hSrcDC,ulong xSrc,ulong ySrc,ulong dwRop) LIBRARY "gdi32.dll" 
Function ulong GetDC(ulong hwnd) LIBRARY "user32.dll" 
Function ulong ReleaseDC(ulong hwnd, ulong hdc) LIBRARY "user32.dll" 
Function ulong SelectObject(ulong hdc, ulong hObject) LIBRARY "gdi32.dll" 
Function boolean Rectangle(ulong hdc, ulong X1, ulong Y1, ulong X2, ulong Y2) LIBRARY "gdi32.dll"
Function ulong CreatePen  (ulong nPenStyle, ulong nWidth, ulong crColor) LIBRARY "Gdi32.dll"
Function Ulong CreateSolidBrush (Long crColor) Library "gdi32.dll"
Function ulong SetCapture(ulong hWnd) LIBRARY "user32.dll" 
Function ulong ReleaseCapture() LIBRARY "user32.dll" 
Function ulong CopyImage (ulong hImage, uint uType, int cxDesired, int cyDesired, uint fuFlags) LIBRARY "user32.dll" 
end prototypes

type variables
ulong iul_hbitmap
long il_orgx, il_orgy, il_bitmapx, il_bitmapy, il_bitmapw, il_bitmaph, il_leftmapx, il_rightmapx
long il_maxbgw, il_maxbgh
boolean ib_move, ib_resetposition, ib_zoom
string is_portsequence[]
integer il_maplevel, il_defaultlevel = 4
decimal{4} id_xrate, id_yrate

constant integer il_maxlevel = 5, il_minlevel = 0
end variables

forward prototypes
public subroutine of_createmap ()
public subroutine of_setportsequence (string as_portsequence[])
public subroutine of_setmaxbackgroudheight (long al_height)
public subroutine of_setmaxbackgroudwidth (long al_width)
public subroutine of_setdefaultlevel (integer ai_level)
public subroutine of_clearmap ()
public subroutine documentation ()
public subroutine of_drawmap (boolean ab_first, boolean ab_show, string as_fromport, string as_toport)
public subroutine of_deleteobject ()
public subroutine of_resetposition ()
public subroutine of_setresetposition (boolean ab_rest)
public subroutine of_prezoom ()
public subroutine of_setzoomposition ()
public subroutine of_setheight ()
public function unsignedlong of_copymap (ref long al_bitmapx, ref long al_bitmapy, ref long al_leftmapx, ref long al_rightmapx, ref long al_bitmapw, ref long al_bitmaph, ref boolean ab_showportname, ref boolean ab_showecazone, ref boolean ab_showpiracyareas, ref integer ai_maplevel)
public subroutine of_drawmapfromcopy (unsignedlong aul_bitmap, long al_bitmapx, long al_bitmapy, long al_leftmapx, long al_rightmapx, long al_bitmapw, long al_bitmaph, boolean ab_showportname, boolean ab_showecazone, boolean ab_showpiracyareas, integer ai_maplevel)
end prototypes

public subroutine of_createmap ();/********************************************************************
   of_createmap
   <DESC>Create new map</DESC>
   <RETURN></RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

long ll_numberofports, ll_portpointer, ll_distance
integer li_first
boolean lb_first

ll_numberofports = upperBound(is_portsequence)
if ll_numberofports < 2 then return

ll_portpointer = 2
li_first = 0

do while ll_portpointer <= ll_numberofports
	gnv_AtoBviaC.of_fromport(is_portsequence[ll_portpointer - 1])
	gnv_AtoBviaC.toport(is_portsequence[ll_portpointer])
	ll_distance = gnv_AtoBviaC.of_calculate()	
	
	if ll_distance > 0 then 
		li_first ++
		
		if li_first = 1 then
			lb_first = true
		else
			lb_first = false
		end if
		
		of_drawmap(lb_first, false, is_portsequence[ll_portpointer - 1], is_portsequence[ll_portpointer])
	end if
	
	ll_portpointer ++
loop

if li_first > 0 then 
	of_drawmap(false, true, '', '')
else
	of_clearmap()
end if
end subroutine

public subroutine of_setportsequence (string as_portsequence[]);/********************************************************************
   of_setportsequence
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
		as_portsequence[]
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

is_portsequence = as_portsequence
end subroutine

public subroutine of_setmaxbackgroudheight (long al_height);/********************************************************************
   of_setmaxbackgroudheight
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
		al_height
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

il_maxbgh = al_height
end subroutine

public subroutine of_setmaxbackgroudwidth (long al_width);/********************************************************************
   of_setmaxbackgroudwidth
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
		al_width
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

il_maxbgw = al_width
end subroutine

public subroutine of_setdefaultlevel (integer ai_level);/********************************************************************
   of_setdefaultlevel
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_level
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

il_maplevel = ai_level
end subroutine

public subroutine of_clearmap ();/********************************************************************
   of_clearmap
   <DESC>Clear map</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

of_setdefaultlevel(il_defaultlevel)
of_setresetposition(true)
of_deleteobject( )
uo_bitmap.setredraw( true)

end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
	14/06/16		CR4411		CCY018		Add functions of_copymap and of_drawmapfromcopy
   </HISTORY>
********************************************************************/
end subroutine

public subroutine of_drawmap (boolean ab_first, boolean ab_show, string as_fromport, string as_toport);/********************************************************************
   of_drawmap
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		ab_first
		ab_show
		as_fromport
		as_toport
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31/03/16		CR3787		CCY018		First Version.
   </HISTORY>
********************************************************************/

boolean lb_showeca, lb_showPiracy, lb_showportname
long ll_width, ll_height
ulong lul_sourcehandle
string ls_fromname, ls_toname
decimal{17} ld_fromlatitude, ld_fromlongitude, ld_tolatitude, ld_tolongitude
uint IMAGE_BITMAP = 0, LR_COPYRETURNORG = 4

lb_showeca = cbx_seca.checked
lb_showPiracy = cbx_piracy.checked 
lb_showportname = cbx_portname.checked

if ab_first then 	
	gnv_AtoBviaC.of_setmaplevel(il_maplevel)
	
	gnv_AtoBviaC.of_setshowsecazonesonmap(lb_showeca)
	gnv_AtoBviaC.of_setshowpiracyareasonmap(lb_showPiracy)	
	
	gnv_AtoBviaC.of_newmap()	
end if

if not ab_show then
	gnv_AtoBviaC.of_plotroutetomap()
	
	if lb_showportname then
		select ABC_PORTNAME, ABC_LATITUDE, ABC_LONGITUDE 
		into :as_fromport, :ld_fromlatitude, :ld_fromlongitude from ATOBVIAC_PORT
		where ABC_PORTCODE = :as_fromport;
		
		select ABC_PORTNAME, ABC_LATITUDE, ABC_LONGITUDE 
		into :as_toport, :ld_tolatitude, :ld_tolongitude from ATOBVIAC_PORT
		where ABC_PORTCODE = :as_toport;
		
		gnv_AtoBviaC.of_plotposition(ld_fromlatitude, ld_fromlongitude, as_fromport)
		gnv_AtoBviaC.of_plotposition(ld_tolatitude, ld_tolongitude, as_toport)
	end if
end if

if ab_show then
	lul_sourcehandle = gnv_AtoBviaC.of_getmap()
	il_bitmapw = gnv_AtoBviaC.of_getmapwidth()
	il_bitmaph = gnv_AtoBviaC.of_getmapheight()
	
	of_deleteobject( )
	
	iul_hbitmap = CopyImage(lul_sourcehandle, IMAGE_BITMAP, il_bitmapw, il_bitmaph, LR_COPYRETURNORG) 
	
	ll_width = PixelsToUnits(il_bitmapw, XPixelsToUnits!)
	ll_height = PixelsToUnits(il_bitmaph, YPixelsToUnits!)
	
	if ll_width > il_maxbgw then ll_width = il_maxbgw
	if ll_height > il_maxbgh then ll_height = il_maxbgh
	
	uo_bitmap.resize(ll_width, ll_height)
	uo_bitmap.move((il_maxbgw - ll_width)/2, (il_maxbgh - ll_height)/2)	
	
	if ib_resetposition then of_resetposition( )
	if ib_zoom then of_setzoomposition()
	uo_bitmap.triggerevent("ue_paint")
	if ib_resetposition then ib_resetposition = false
end if
end subroutine

public subroutine of_deleteobject ();/********************************************************************
   of_deleteobject
   <DESC>Delete the bitmap object</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3787		CCY018        First Version
   </HISTORY>
********************************************************************/

if iul_hbitmap <> 0 then 
	DeleteObject(iul_hbitmap)
	iul_hbitmap = 0
end if
end subroutine

public subroutine of_resetposition ();/********************************************************************
   of_resetposition
   <DESC>reset the map positon	</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3787		CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_width, ll_height

ll_width = unitstopixels(uo_bitmap.width, XUnitsToPixels!)
ll_height = unitstopixels(uo_bitmap.height, YUnitsToPixels!)

il_bitmapx = (ll_width - il_bitmapw) /2
il_bitmapy = (ll_height - il_bitmaph)/2
il_leftmapx = -99999
il_rightmapx = 99999
end subroutine

public subroutine of_setresetposition (boolean ab_rest);ib_resetposition = ab_rest
end subroutine

public subroutine of_prezoom ();
long ll_width, ll_height

ll_width = unitstopixels(uo_bitmap.width, XUnitsToPixels!)
ll_height = unitstopixels(uo_bitmap.height, YUnitsToPixels!)

id_yrate = (abs(il_bitmapy) + ll_height/2)/il_bitmaph

if il_bitmapx <= ll_width/2 and il_bitmapx + il_bitmapw >= ll_width/2 then
	id_xrate = (ll_width/2 - il_bitmapx)/il_bitmapw
elseif il_bitmapx > ll_width/2 then
	id_xrate = (ll_width/2 - il_leftmapx)/il_bitmapw
elseif il_bitmapx + il_bitmapw < ll_width/2 then
	id_xrate = (ll_width/2 - il_rightmapx)/il_bitmapw
end if
end subroutine

public subroutine of_setzoomposition ();
long ll_width, ll_height, ll_midx, ll_midy

ll_width = unitstopixels(uo_bitmap.width, XUnitsToPixels!)
ll_height = unitstopixels(uo_bitmap.height, YUnitsToPixels!)

ll_midx = il_bitmapw * id_xrate
ll_midy = il_bitmaph * id_yrate

il_bitmapx = ll_width/2 - ll_midx
il_rightmapx = il_bitmapx + il_bitmapw
il_leftmapx = il_bitmapx - il_bitmapw

il_bitmapy = ll_height/2 - ll_midy
if il_bitmapy > 0 then il_bitmapy = 0
if il_bitmaph + il_bitmapy < ll_height then il_bitmapy = ll_height - il_bitmaph

end subroutine

public subroutine of_setheight ();
cbx_portname.y = this.height - cbx_portname.height - 32
cbx_seca.y = cbx_portname.y
cbx_piracy.y = cbx_portname.y
uo_bitmap.height = cbx_portname.y - 32
of_setmaxbackgroudheight( uo_bitmap.height)
cb_down.y = uo_bitmap.height - 32 - cb_down.height
cb_up.y = cb_down.y - 4 - cb_up.height
end subroutine

public function unsignedlong of_copymap (ref long al_bitmapx, ref long al_bitmapy, ref long al_leftmapx, ref long al_rightmapx, ref long al_bitmapw, ref long al_bitmaph, ref boolean ab_showportname, ref boolean ab_showecazone, ref boolean ab_showpiracyareas, ref integer ai_maplevel);/********************************************************************
   of_copymap
   <DESC>Copy the current map</DESC>
   <RETURN>	unsignedlong: the new map
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/06/16		CR4411            CCY018        First Version
   </HISTORY>
********************************************************************/

ulong lul_copyhandle
uint IMAGE_BITMAP = 0, LR_COPYRETURNORG = 4

if iul_hbitmap <> 0 then
	lul_copyhandle = CopyImage(iul_hbitmap, IMAGE_BITMAP, il_bitmapw, il_bitmaph, LR_COPYRETURNORG) 
	al_bitmapx = il_bitmapx
	al_bitmapy = il_bitmapy
	al_leftmapx = il_leftmapx
	al_rightmapx = il_rightmapx
	al_bitmapw = il_bitmapw
	al_bitmaph = il_bitmaph
	ab_showportname = cbx_portname.checked
	ab_showecazone = cbx_seca.checked
	ab_showpiracyareas = cbx_piracy.checked
	ai_maplevel = il_maplevel
end if

return lul_copyhandle
end function

public subroutine of_drawmapfromcopy (unsignedlong aul_bitmap, long al_bitmapx, long al_bitmapy, long al_leftmapx, long al_rightmapx, long al_bitmapw, long al_bitmaph, boolean ab_showportname, boolean ab_showecazone, boolean ab_showpiracyareas, integer ai_maplevel);/********************************************************************
   of_drawmapfromcopy
   <DESC>  </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		aul_bitmap
		al_bitmapx
		al_bitmapy
		al_leftmapx
		al_rightmapx
		al_bitmapw
		al_bitmaph
		ab_showportname
		ab_showecazone
		ab_showpiracyareas
		ai_maplevel
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/06/16		CR4411            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_width, ll_height

if aul_bitmap = 0 then return

ll_width = PixelsToUnits(al_bitmapw, XPixelsToUnits!)
ll_height = PixelsToUnits(al_bitmaph, YPixelsToUnits!)

if ll_width > il_maxbgw then ll_width = il_maxbgw
if ll_height > il_maxbgh then ll_height = il_maxbgh
	
uo_bitmap.resize(ll_width, ll_height)
uo_bitmap.move((il_maxbgw - ll_width)/2, (il_maxbgh - ll_height)/2)	

if iul_hbitmap <> 0 then of_deleteobject( )
iul_hbitmap = aul_bitmap
il_bitmapx = al_bitmapx
il_bitmapy = al_bitmapy
il_leftmapx = al_leftmapx
il_rightmapx = al_rightmapx
il_bitmapw = al_bitmapw
il_bitmapy = al_bitmapy
il_maplevel = ai_maplevel
cbx_portname.checked = ab_showportname
cbx_seca.checked = ab_showecazone
cbx_piracy.checked = ab_showpiracyareas

uo_bitmap.triggerevent("ue_paint")

end subroutine

on u_atobviac_map.create
int iCurrent
call super::create
this.cbx_portname=create cbx_portname
this.cbx_piracy=create cbx_piracy
this.cbx_seca=create cbx_seca
this.uo_bitmap=create uo_bitmap
this.cb_up=create cb_up
this.cb_down=create cb_down
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_portname
this.Control[iCurrent+2]=this.cbx_piracy
this.Control[iCurrent+3]=this.cbx_seca
this.Control[iCurrent+4]=this.uo_bitmap
this.Control[iCurrent+5]=this.cb_up
this.Control[iCurrent+6]=this.cb_down
end on

on u_atobviac_map.destroy
call super::destroy
destroy(this.cbx_portname)
destroy(this.cbx_piracy)
destroy(this.cbx_seca)
destroy(this.uo_bitmap)
destroy(this.cb_up)
destroy(this.cb_down)
end on

event constructor;call super::constructor;of_setmaxbackgroudwidth( uo_bitmap.width)
of_setmaxbackgroudheight(uo_bitmap.height)
of_setdefaultlevel(il_defaultlevel)
of_setresetposition(true)
end event

event destructor;call super::destructor;of_deleteobject( )
end event

type cbx_portname from mt_u_checkbox within u_atobviac_map
integer x = 3401
integer y = 2004
integer width = 334
integer height = 64
integer taborder = 40
integer textsize = -8
long textcolor = 0
long backcolor = 32304364
string text = "Port Names"
boolean checked = true
end type

event clicked;call super::clicked;
of_createmap()



end event

type cbx_piracy from mt_u_checkbox within u_atobviac_map
integer x = 4114
integer y = 2004
integer width = 347
integer height = 64
integer taborder = 60
integer textsize = -8
long textcolor = 0
long backcolor = 32304364
string text = "Piracy Areas"
boolean checked = true
end type

event clicked;call super::clicked;
of_createmap()

end event

type cbx_seca from mt_u_checkbox within u_atobviac_map
integer x = 3767
integer y = 2004
integer width = 311
integer height = 64
integer taborder = 50
integer textsize = -8
long textcolor = 0
long backcolor = 32304364
string text = "ECA Zones"
boolean checked = true
end type

event clicked;call super::clicked;
of_createmap()


end event

type uo_bitmap from mt_u_visualobject within u_atobviac_map
event ue_paint pbm_paint
event ue_mousemove pbm_mousemove
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer width = 4462
integer height = 1972
integer taborder = 10
long backcolor = 32304364
end type

event ue_paint;long ll_thisdc, ll_newdc, ll_hpen, ll_hbrush
long SRCCOPY = 13369376
long ll_width, ll_height

if iul_hbitmap <> 0 then
	ll_width = unitstopixels(this.width, XUnitsToPixels!)
	ll_height = unitstopixels(this.height, YUnitsToPixels!)

	ll_thisdc = getdc(handle(this))
	ll_newdc = CreateCompatibleDC(ll_thisdc) 
	
	SelectObject(ll_newdc, iul_hbitmap)
	
	if il_bitmapx < ll_width and il_bitmapx + il_bitmapw > 0 then
		BitBlt(ll_thisdc, il_bitmapx, il_bitmapy, il_bitmapw, il_bitmaph, ll_newdc, 0, 0, SRCCOPY )
	end if
	
	if il_leftmapx + il_bitmapw > 0 then
		BitBlt(ll_thisdc, il_leftmapx, il_bitmapy, il_bitmapw, il_bitmaph, ll_newdc, 0, 0, SRCCOPY )
	end if
	
	if il_rightmapx < ll_width then
		BitBlt(ll_thisdc, il_rightmapx, il_bitmapy, il_bitmapw, il_bitmaph, ll_newdc, 0, 0, SRCCOPY )
	end if
	
	DeleteObject(ll_newdc)
	ReleaseDC(handle(this), ll_thisdc)	
end if

end event

event ue_mousemove;long ll_curx, ll_cury, ll_plusx, ll_plusy
long ll_bgwidth, ll_bgheight

if not ib_move then return

ll_curx = xpos
ll_cury = ypos

ll_plusx = ll_curx - il_orgx
ll_plusy = ll_cury - il_orgy

ll_plusx = unitstopixels( ll_plusx, XUnitsToPixels!)
ll_plusy = unitstopixels( ll_plusy, YUnitsToPixels!)

il_bitmapx = il_bitmapx + ll_plusx
il_bitmapy = il_bitmapy + ll_plusy

ll_bgwidth = UnitsToPixels(this.width, XUnitsToPixels!)
ll_bgheight = UnitsToPixels(this.height, YUnitsToPixels!)

if il_bitmapy > 0 then il_bitmapy = 0
if il_bitmaph + il_bitmapy < ll_bgheight then il_bitmapy = ll_bgheight - il_bitmaph

il_leftmapx = il_bitmapx - il_bitmapw
il_rightmapx = il_bitmapx + il_bitmapw

if il_leftmapx > 0 then 
	il_leftmapx = 0
	il_bitmapx = il_bitmapw
	il_rightmapx = il_bitmapx + il_bitmapw
end if

if il_rightmapx + il_bitmapw < ll_bgwidth then
	il_rightmapx = ll_bgwidth - il_bitmapw
	il_bitmapx = il_rightmapx - il_bitmapw
	il_leftmapx = il_bitmapx - il_bitmapw
end if

this.triggerevent("ue_paint")

if il_bitmapx >= il_bitmapw then
	il_bitmapx = il_leftmapx
end if

if il_bitmapx + il_bitmapw <= 0 then
	il_bitmapx = il_rightmapx
end if

il_orgx = ll_curx
il_orgy = ll_cury
end event

event ue_lbuttonup;ib_move = false
ReleaseCapture()
end event

event ue_lbuttondown;il_orgx = xpos
il_orgy = ypos

ib_move = true

SetCapture(handle(this))
end event

on uo_bitmap.destroy
call mt_u_visualobject::destroy
end on

type cb_up from mt_u_commandbutton within u_atobviac_map
integer x = 4293
integer y = 1736
integer width = 133
integer taborder = 20
boolean bringtotop = true
string text = "+"
end type

event clicked;call super::clicked;if iul_hbitmap <= 0 then return
if il_maplevel >= il_maxlevel then return

il_maplevel ++
ib_zoom = true
of_prezoom()
of_createmap( )
ib_zoom = false

end event

type cb_down from mt_u_commandbutton within u_atobviac_map
integer x = 4293
integer y = 1840
integer width = 133
integer taborder = 30
boolean bringtotop = true
string text = "-"
end type

event clicked;call super::clicked;if iul_hbitmap <= 0 then return
if il_maplevel <= il_minlevel then return

il_maplevel --
ib_zoom = true
of_prezoom()
of_createmap( )
ib_zoom = false

end event

