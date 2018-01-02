$PBExportHeader$nvo_img.sru
forward
global type nvo_img from nonvisualobject
end type
end forward

global type nvo_img from nonvisualobject
end type
global nvo_img nvo_img

type prototypes

//Private Subroutine FreeImage_Initialise(Long load_local_plugins_only) Library "FreeImage.dll" Alias For "_FreeImage_Initialise@4;ansi" 
//Private Subroutine FreeImage_DeInitialise() Library "FreeImage.dll" Alias For "_FreeImage_DeInitialise@0;ansi"

Private Function Long FreeImage_GetFileType(String Filename, Long Size) Library "FreeImage.dll" Alias For "_FreeImage_GetFileType@8;ansi"

Private Function Long FreeImage_Load(Long fif, String Filename, Long Flags) Library "FreeImage.dll" Alias For "_FreeImage_Load@12;ansi"
Private Function Long FreeImage_Save(Long fif, Long dib, String Filename, Long Flags) Library "FreeImage.dll" Alias For "_FreeImage_Save@16;ansi"
Private Subroutine FreeImage_Unload(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_Unload@4;ansi" 


Private Function Long FreeImage_GetWidth(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_GetWidth@4;ansi" 
Private Function Long FreeImage_GetHeight(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_GetHeight@4;ansi" 
Private Function Long FreeImage_GetBPP(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_GetBPP@4;ansi" 

Public Function Long GetDC(Long hWnd) Library "user32.dll"
Public Function Long ReleaseDC(Long hWnd, Long hDC) Library "user32.dll"
Private Function Long StretchDIBits(Long hDC, Long x, Long y, Long dx, Long dy, Long SrcX, Long SrcY, Long wSrcWidth, Long wSrcHeight, Long lpBits, Long lpBitsInfo, Long wUsage, Long dwRop) Library "gdi32.dll"

Private Function Long FreeImage_GetInfo(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_GetInfo@4;ansi"
Private Function Long FreeImage_GetBits(Long dib) Library "FreeImage.dll" Alias For "_FreeImage_GetBits@4;ansi"

Private Function Long FreeImage_RotateClassic(Long dib, Double Angle) Library "FreeImage.dll" Alias For "_FreeImage_RotateClassic@12;ansi" 
Private Function Long FreeImage_MakeThumbnail(Long dib, Long max_pixel_size, Boolean convert) Library "FreeImage.dll" Alias For "_FreeImage_MakeThumbnail@12;ansi" 

end prototypes

type variables

Private Long il_ImgHandle, il_Width, il_Height, il_BPP, il_FileType


// il_ImgHandle   -   This is the handle to the image contained in memory
// il_Width, il_Height, il_BPP   -   Width, Height, Bits per Pixel of the image in memory

// Above variables must remain private
end variables

forward prototypes
public subroutine unloadimage ()
public function boolean isimageloaded ()
public function long getwidth ()
public function long getheight ()
public function long getbpp ()
public function long drawimage (long al_dc, long al_x, long al_y)
public function long rotateimage (integer ai_angle)
public function integer scaledown (long al_maxedge)
public function integer saveimagetofile (string as_filename)
public function long loadimagefromfile (string as_filename)
public subroutine createphotoreport (long al_inspid, ref datawindowchild adwc_dw)
end prototypes

public subroutine unloadimage ();// This function unloads an image from memory. 
// This MUST be performed once finished with an image, otherwise memory leaks will occur


If il_ImgHandle > 0 then FreeImage_Unload(il_ImgHandle)    //  If image is loaded, unload image

il_ImgHandle = 0

Return 

end subroutine

public function boolean isimageloaded ();// This function returns if a image is currently loaded

If il_ImgHandle > 0 then Return True else Return False
end function

public function long getwidth ();// This function returns the Width of the loaded image

Return il_Width
end function

public function long getheight ();// This function returns the Height of the loaded image

Return il_Height
end function

public function long getbpp ();// This function returns the Bits per Pixel of the loaded image

Return il_BPP
end function

public function long drawimage (long al_dc, long al_x, long al_y);
// This function draws the image on a device context at specified position (in pixels) and no scaling

Long ll_DC

If il_ImgHandle = 0 then Return -1

Return StretchDIBits(al_DC, al_x, al_y, il_Width, il_Height, 0, 0, il_Width, il_Height, FreeImage_GetBits(il_ImgHandle), FreeImage_GetInfo(il_ImgHandle), 0, 13369376)





end function

public function long rotateimage (integer ai_angle);// This function rotates the image
// Any positive value is treated as 90° clockwise and any negative value is treated is 90° anti-clockwise

// Do not modify this function to rotate to any custom angle as it does not preserve the original image


Long ll_NewBitmap

If il_ImgHandle = 0 then Return -1    // If no image loaded

If ai_Angle > 0 then ai_Angle = -90     // Determine correct angle (positive values turn anti-clockwise)
If ai_Angle < 0 then ai_Angle = 90

ll_NewBitmap = FreeImage_RotateClassic(il_ImgHandle, ai_Angle)   // Perform rotation

If ll_NewBitmap>0 then   // If a new image was returned, discard old image
	FreeImage_Unload(il_ImgHandle)
   il_ImgHandle = ll_NewBitmap // Assign new image
	il_Width = FreeImage_GetWidth(il_ImgHandle)	  // Get new sizes
	il_Height = FreeImage_GetHeight(il_ImgHandle)	
Else
	Return -1     // otherwise return failure
End If
end function

public function integer scaledown (long al_maxedge);// This function scales down an image so that the largest side is not more than al_MaxEdge
// It uses the Bilinear filter to scale down

Long ll_NewBitmap

If il_ImgHandle = 0 then Return -1      // If no image loaded

ll_NewBitmap = FreeImage_MakeThumbnail(il_ImgHandle, al_MaxEdge, True)   // Scaledown

If ll_NewBitmap > 0 then      // New image created successfully
	FreeImage_Unload(il_ImgHandle)   // Discard old image
	il_ImgHandle = ll_NewBitmap    // Assign new image
	il_Width = FreeImage_GetWidth(il_ImgHandle)	  // Get new sizes & BPP
	il_Height = FreeImage_GetHeight(il_ImgHandle)
	il_BPP = FreeImage_GetBPP(il_ImgHandle)
	Return 0
Else
	Return -1   // Return error
End If
end function

public function integer saveimagetofile (string as_filename);// This function saves the image back. It does not unload the image!

If il_ImgHandle = 0 then Return -1   // Check if there is no image loaded

Return FreeImage_Save(il_FileType, il_ImgHandle, as_FileName, 0)
end function

public function long loadimagefromfile (string as_filename);// This function takes a filename, determines the file type and loads an image
// Returns zero if it succeeds

Try
	If il_ImgHandle > 0 then FreeImage_Unload(il_ImgHandle)   // If some image already loaded, then unload
	
	il_ImgHandle = 0
	
	il_FileType = FreeImage_GetFileType(as_FileName, 0)  // Get the file type first
	
	If il_FileType < 0 then Return il_FileType  // File type not recognized
	
	il_ImgHandle = FreeImage_Load( il_FileType, as_FileName, 0)   // Load file into memory and set handle
	
	If il_ImgHandle > 0 then  // If load successful, get image size & BPP
		il_Width = FreeImage_GetWidth(il_ImgHandle)	
		il_Height = FreeImage_GetHeight(il_ImgHandle)
		il_BPP = FreeImage_GetBPP(il_ImgHandle)
	Else
		il_Width = 0
		il_Height = 0
		il_BPP = 0
	End If
Catch (RuntimeError lrte_Error)
	Return -1
Finally

End Try

If il_Imghandle > 0 then Return 0 else Return -1  // Return success or failure
end function

public subroutine createphotoreport (long al_inspid, ref datawindowchild adwc_dw);// This function gets all photo attachments in an inspection, saves them and
// displays on the child datawindow
// Returns nothing

If g_Obj.TempFolder="" then Return

DataStore lds_Att
lds_Att = Create Datastore
n_vimsatt ln_att
n_inspio ln_io
ln_att = Create n_vimsatt
Integer li_Loop, li_Row = 0, li_MaxEdge = 480
String ls_Temp
blob lblob_Photo

// Step 1 - Retrieve all photos
lds_Att.DataObject = "d_sq_tb_photos"
lds_Att.SetTransObject(SQLCA)
If lds_Att.Retrieve(al_InspID) < 0 then Return
f_Write2Log("Images Retrieved: " + String(lds_Att.RowCount()))

// Pass temp folder to DW
adwc_dw.Modify("tempfolder.expression=" + CharA(34) + "'" + g_Obj.TempFolder + "'" + CharA(34))

// Step 2 - Loop thru all att, set correct filename and save it, set pic height/width
For li_Loop = 1 to lds_Att.RowCount()
	If Mod(li_Loop, 2) = 1 Then
		ls_Temp = "a.jpg"
		adwc_dw.InsertRow(0)
		li_Row ++
		adwc_dw.SetItem(li_Row, "file1", lds_Att.GetItemString(li_Loop, "FileName"))
	Else
		ls_Temp = "b.jpg"
		adwc_dw.SetItem(li_Row, "file2", lds_Att.GetItemString(li_Loop, "FileName"))
	End If
	ls_Temp = g_Obj.TempFolder + "img" + String(li_Row) + ls_Temp	
	ln_att.of_SaveAttachment(lds_Att.GetItemNumber(li_Loop, "Att_ID"), ls_Temp)
	
	// Load image from file, scaledown, rotate (if reqd), save again and set height/width
	If LoadImageFromFile(ls_Temp) = 0 Then
		
		Scaledown(li_MaxEdge)
		If il_Height > il_Width Then RotateImage(90)
		SaveImageToFile(ls_Temp)		
	
		If Mod(li_Loop, 2) = 1 Then
			adwc_dw.SetItem(li_Row, "wd1", il_Width)
			adwc_dw.SetItem(li_Row, "ht1", il_Height)
		Else
			adwc_dw.SetItem(li_Row, "wd2", il_Width)
			adwc_dw.SetItem(li_Row, "ht2", il_Height)
		End If
		UnloadImage( )
	End If
Next

Destroy lds_Att
Destroy ln_att
end subroutine

on nvo_img.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_img.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
il_ImgHandle = 0

end event

event destructor;
If il_ImgHandle > 0 then FreeImage_Unload(il_ImgHandle)  // Check and unload image if any loaded

end event

