$PBExportHeader$uo_dwdraw.sru
forward
global type uo_dwdraw from nonvisualobject
end type
end forward

global type uo_dwdraw from nonvisualobject
end type
global uo_dwdraw uo_dwdraw

type variables

Public String DW_FontName = "Arial Narrow", DW_Band = "Detail"
Public Integer DW_FontSize = 8
Public Boolean DW_FontBold = False
end variables

forward prototypes
public function string drawondw (ref datawindow adw_target, long al_x, long al_y, long al_xlen, long al_ylen, integer ai_style, integer ai_size, long al_color)
public function string drawondw (ref datawindowchild adwc_target, long al_x, long al_y, long al_xlen, long al_ylen, integer ai_style, integer ai_size, long al_color)
public function string writeondw (datawindowchild adwc_target, long al_x, long al_y, long al_width, long al_height, string as_text, long al_color, integer ai_align)
public function string writeondw (datawindow adw_target, long al_x, long al_y, long al_width, long al_height, string as_text, long al_color, integer ai_align)
public function string boxondw (datawindow adw_target, long al_x, long al_y, long al_width, long al_height, long al_color)
end prototypes

public function string drawondw (ref datawindow adw_target, long al_x, long al_y, long al_xlen, long al_ylen, integer ai_style, integer ai_size, long al_color);// This function draws a line on a datawindow in specified color and size.
// To draw a single pixel, set al_xlen and al_ylen to zero

Return adw_Target.Modify("create line(band=" + DW_Band + " x1='"+String(al_x)+"' y1='"+String(al_y)+"' x2='"+string(al_x+al_xlen)+"' y2='"+String(al_y+al_ylen)+"' pen.style='" + String(ai_Style) + "' pen.width='"+String(ai_Size)+"' pen.color='"+String(al_Color)+"' background.color='16777215')")

end function

public function string drawondw (ref datawindowchild adwc_target, long al_x, long al_y, long al_xlen, long al_ylen, integer ai_style, integer ai_size, long al_color);// This function draws a line on a datawindow in specified color and size.
// To draw a single pixel, set al_xlen and al_ylen to zero

Return adwc_Target.Modify("create line(band=" + DW_Band + " x1='"+String(al_x)+"' y1='"+String(al_y)+"' x2='"+string(al_x+al_xlen)+"' y2='"+String(al_y+al_ylen)+"' pen.style='" + String(ai_Style) + "' pen.width='"+String(ai_Size)+"' pen.color='"+String(al_Color)+"' background.color='16777215')")

end function

public function string writeondw (datawindowchild adwc_target, long al_x, long al_y, long al_width, long al_height, string as_text, long al_color, integer ai_align);// This function writes text on a datawindow in specified font at the specified location and size

String ls_Temp, ls_Weight

If DW_FontBold then ls_Weight = "700" else ls_Weight = "400"

ls_Temp = "create text(band=" + DW_Band + " color='" + String(al_Color) + "' alignment='" + String(ai_align) + "' border='0'"&
		+ " height.autosize=No pointer='Arrow!' visible='1' moveable=0 resizeable=0 x='" + String(al_X) + "'"&
		+ " y='" + String(al_Y) + "' height='" + String(al_Height) + "' width='" + String(al_width) + "' text='" + as_Text + "'"&
		+ " font.face='" + DW_FontName + "' font.height= '-" + String(dw_FontSize) + "' font.weight='" + ls_Weight + "' font.family='0' font.pitch='0' font.charset='0' font.italic='0'"&
		+ " font.strikethrough='0' font.underline='0' background.mode='1' background.color='0')"
		
Return adwc_Target.Modify(ls_Temp)


end function

public function string writeondw (datawindow adw_target, long al_x, long al_y, long al_width, long al_height, string as_text, long al_color, integer ai_align);// This function writes text on a datawindow in specified font at the specified location and size

String ls_Temp, ls_Weight

If DW_FontBold then ls_Weight = "700" else ls_Weight = "400"

ls_Temp = "create text(band=" + DW_Band + " color='" + String(al_Color) + "' alignment='" + String(ai_align) + "' border='0'"&
		+ " height.autosize=No pointer='Arrow!' visible='1' moveable=0 resizeable=0 x='" + String(al_X) + "'"&
		+ " y='" + String(al_Y) + "' height='" + String(al_Height) + "' width='" + String(al_width) + "' text='" + as_Text + "'"&
		+ " font.face='" + DW_FontName + "' font.height= '-" + String(dw_FontSize) + "' font.weight='" + ls_Weight + "' font.family='0' font.pitch='0' font.charset='0' font.italic='0'"&
		+ " font.strikethrough='0' font.underline='0' background.mode='1' background.color='0')"
		
Return adw_Target.Modify(ls_Temp)

end function

public function string boxondw (datawindow adw_target, long al_x, long al_y, long al_width, long al_height, long al_color);
// This function draws a box on the datawindow

Return adw_Target.Modify("create rectangle(band=Detail pointer='Arrow!' moveable=0 resizeable=0 x='" + String(al_X) + "' y='" + String(al_Y) + "' height='" + String(al_Height) + "' width='" + String(al_Width) + "' brush.hatch='8' brush.color='0' pen.style='5' pen.width='0' pen.color='0' background.mode='1' background.color='" + String(al_Color) + "')")
end function

on uo_dwdraw.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_dwdraw.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

