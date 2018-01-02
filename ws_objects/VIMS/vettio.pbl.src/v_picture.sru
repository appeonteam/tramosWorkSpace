$PBExportHeader$v_picture.sru
forward
global type v_picture from picture
end type
end forward

global type v_picture from picture
integer width = 229
integer height = 200
string pointer = "HyperLink!"
boolean originalsize = true
boolean border = true
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type
global v_picture v_picture

type variables

Long AttID
Integer Index
String AttName
end variables

forward prototypes
public subroutine initialize (long al_attid, integer ai_index, string as_attname)
public subroutine resize (integer ai_maxsize)
end prototypes

public subroutine initialize (long al_attid, integer ai_index, string as_attname);
AttID = al_AttID
Index = ai_Index
AttName = as_AttName
end subroutine

public subroutine resize (integer ai_maxsize);// This function resizes the thumbnail to a max size edge

If Width > Height then  // Image is wider than taller
	Height = ai_MaxSize * Height / Width
	Width = ai_MaxSize
Else  // Image is taller than wider
	Width = ai_MaxSize * Width / Height
	Height = ai_MaxSize
End If


end subroutine

on v_picture.create
end on

on v_picture.destroy
end on

event clicked;
Parent.Dynamic event ue_PictureClick(Index)
end event

