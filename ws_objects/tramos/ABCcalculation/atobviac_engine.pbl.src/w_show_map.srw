$PBExportHeader$w_show_map.srw
$PBExportComments$NOT USED !!!! is connected to the COM engine
forward
global type w_show_map from mt_w_response
end type
type dw_map from datawindow within w_show_map
end type
end forward

global type w_show_map from mt_w_response
integer width = 3854
integer height = 2192
string title = "Route Map"
dw_map dw_map
end type
global w_show_map w_show_map

type prototypes
// GDI functions
Function ulong DeleteObject(ulong hObject) LIBRARY "gdi32.dll" 
Function ulong DeleteDC(ulong hdc) LIBRARY "gdi32.dll" 
Function ulong CreateCompatibleDC(ulong hdc) LIBRARY "gdi32.dll" 
Function ulong BitBlt(ulong hDestDC,ulong xx,ulong yy,ulong nWidth,ulong nHeight,ulong hSrcDC,ulong xSrc,ulong ySrc,ulong dwRop) LIBRARY "gdi32.dll" 
Function ulong GetDC(ulong hwnd) LIBRARY "user32.dll" 
Function ulong ReleaseDC(ulong hwnd,ulong hdc) LIBRARY "user32.dll" 
Function ulong SelectObject(ulong hdc,ulong hObject) LIBRARY "gdi32.dll" 

end prototypes

type variables
ulong hBitmap
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_show_map
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

event open;//gnv_atobviac.of_setMapSize(3)

//gnv_atobviac.of_newMap()   // if newroute is ignored then you can plot several routes
//gnv_atobviac.of_plotRouteToMap()
//hBitmap = gnv_atobviac.of_getMap()
//dw_map.triggerevent("ue_paint")





end event

on w_show_map.create
int iCurrent
call super::create
this.dw_map=create dw_map
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_map
end on

on w_show_map.destroy
call super::destroy
destroy(this.dw_map)
end on

type dw_map from datawindow within w_show_map
event ue_paint pbm_paint
integer x = 18
integer y = 12
integer width = 3666
integer height = 2040
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_paint;Long nWidth,nHeight,ThisDC,NewDC
Long SRCCOPY = 13369376

//if hBitmap <> 0 then
//	ThisDC = getdc(handle(this))
//	NewDC = CreateCompatibleDC(ThisDC) 
////	nWidth = UnitsToPixels( width, XUnitsToPixels!)
////	nHeight = UnitsToPixels( height, YUnitsToPixels!)
//	nWidth = gnv_atobviac.of_getMapWidth()
//	nHeight = gnv_atobviac.of_getMapHeight()
//	SelectObject(NewDC, hBitmap)
//	BitBlt(ThisDC, 0, 0, nWidth, nHeight, NewDC, 0, 0, SRCCOPY )
//	DeleteObject(NewDC)
//	ReleaseDC(handle(this),ThisDC)
//end if

end event

