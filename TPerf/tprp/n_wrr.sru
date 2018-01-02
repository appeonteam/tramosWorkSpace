HA$PBExportHeader$n_wrr.sru
forward
global type n_wrr from nonvisualobject
end type
end forward

global type n_wrr from nonvisualobject
end type
global n_wrr n_wrr

type variables
n_datastore ids_Wrr

integer ii_CurVslID

struct_spdcontable istr_Loaded[], istr_Ballast[]

integer ii_NumLd, ii_NumBl, ii_CalcType

Constant Decimal Adm_Power = 3.5
end variables

forward prototypes
private subroutine retrievevesseltable ()
public function boolean wrrtableexists (integer ai_vslid, byte ab_voytype)
public function real getwrrspd (integer ai_vslid, byte ab_voytype, decimal ad_cons)
public function decimal getwrrcons (integer ai_vslid, byte ab_voytype, decimal ad_speed)
private function decimal getadmspd (decimal ad_cons, boolean abool_ldd)
private function decimal getadmcons (decimal ad_spd, boolean abool_ldd)
end prototypes

private subroutine retrievevesseltable ();integer li_rows, li_loop, li_Inter

ids_wrr.dataobject = "d_sq_tb_wrrtable"
ids_wrr.settransobject(SQLCA)

li_rows = ids_wrr.Retrieve(ii_CurVslID, 0)   //  Get Loaded types first
commit;

ii_NumLd = li_rows

for li_loop = 1 to li_rows
   istr_Loaded[li_loop].Speed = ids_wrr.getitemnumber( li_loop, "Spd")
	istr_Loaded[li_loop].Consumption = ids_wrr.getitemnumber( li_loop, "Con")
Next

li_rows = ids_wrr.Retrieve(ii_CurVslID, 1)   //  Get Ballast types
commit;

ii_NumBl = li_rows

for li_loop = 1 to li_rows
   istr_Ballast[li_loop].Speed = ids_wrr.getitemnumber( li_loop, "Spd")
	istr_Ballast[li_loop].Consumption = ids_wrr.getitemnumber( li_loop, "Con")
Next

// Determine type of interpolation to use
Select TPERF_INTERPOLATION into :ii_CalcType from VESSELS Where VESSEL_ID = :ii_CurVslID;

If SQLCA.SQLCode<0 then 
	Rollback;
	ii_CalcType = 1
Else
	Commit;
End If


end subroutine

public function boolean wrrtableexists (integer ai_vslid, byte ab_voytype);
// Function to check if a vessel has any warranted setting for selected voyage type

if ai_vslid <> ii_Curvslid then 
	ii_Curvslid = ai_vslid
	RetrieveVesselTable( )
end if

If ab_voytype = 0 then
	If ii_numLd = 0 then Return False else Return True
Else
	If ii_numBl = 0 then Return False else Return True
End If

end function

public function real getwrrspd (integer ai_vslid, byte ab_voytype, decimal ad_cons);
Integer li_Idx = 1

If ai_vslid <> ii_Curvslid then 
	ii_Curvslid = ai_vslid
	RetrieveVesselTable( )
End if

If ab_VoyType = 0 then  // Loaded voyage
	
	If ii_numLd = 0 then Return 0   //  Return 0 if no table
	If ii_CalcType = 2 then Return istr_Loaded[ii_numLd].Speed  // Return max speed from table
		
	// If only 1 entry	
	If ii_numLd = 1 then 
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[1].Speed / istr_Loaded[1].Consumption * ad_cons, 1)
		Else
			Return Round(GetAdmSpd(ad_Cons, True), 1)
		End If
	End If
	
	If ad_cons < istr_loaded[1].consumption then  // If cons is below range
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[1].speed - (( istr_Loaded[2].speed - istr_Loaded[1].speed) * (istr_Loaded[1].consumption - ad_cons) / (istr_Loaded[2].consumption - istr_Loaded[1].consumption)), 1)
		Else
			Return Round(GetAdmSpd(ad_Cons, True), 1)
		End If
	End If		

	If ad_cons > istr_loaded[ii_numLd].consumption then  // If cons is above range
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[ii_numLd].speed + (( istr_Loaded[ii_numLd].speed - istr_Loaded[ii_numLd - 1].speed) * (ad_cons - istr_Loaded[ii_numLd].consumption ) / (istr_Loaded[ii_numLd].consumption - istr_Loaded[ii_numLd - 1].consumption)), 1)
		Else
			Return Round(GetAdmSpd(ad_Cons, True), 1)			
		End If		
	End If		

	// Check if last entry matches
	If istr_loaded[ii_numLd].consumption = ad_cons then Return istr_loaded[ii_numLd].speed
	
	Do While istr_loaded[li_Idx].consumption <= ad_cons
		li_Idx ++
	Loop
	li_Idx --
	
	Return Round(istr_loaded[li_idx].speed + ((ad_cons - istr_loaded[li_Idx].consumption) * (istr_loaded[li_Idx + 1].speed - istr_loaded[li_Idx].speed) / (istr_loaded[li_Idx + 1].consumption - istr_loaded[li_Idx].consumption)), 1)
	
Else
	If ii_numBl = 0 then Return 0	
	If ii_CalcType = 2 then Return istr_Ballast[ii_numBl].Speed  // Return max speed from table
	
	If ii_numBl = 1 then    // If only 1 entry
		If ii_CalcType = 1 then
			Return Round(istr_Ballast[1].Speed / istr_Ballast[1].Consumption * ad_cons, 1)
		Else
			Return Round(GetAdmSpd(ad_Cons, False), 1)
		End If
	End if
	
	If ad_cons < istr_Ballast[1].consumption then  // If cons is below range
		If ii_CalcType = 1 then
			Return Round(istr_Ballast[1].speed - (( istr_Ballast[2].speed - istr_Ballast[1].speed) * (istr_Ballast[1].consumption - ad_cons) / (istr_Ballast[2].consumption - istr_Ballast[1].consumption)), 1)
		Else
			Return Round(GetAdmSpd(ad_Cons, False), 1)
		End If
	End If		

	If ad_cons > istr_Ballast[ii_numBl].consumption then  // If cons is above range
		If ii_CalcType = 1 then
			Return istr_Ballast[ii_numBl].speed + (( istr_Ballast[ii_numBl].speed - istr_Ballast[ii_numBl - 1].speed) * (ad_cons - istr_Ballast[ii_numBl].consumption ) / (istr_Ballast[ii_numBl].consumption - istr_Ballast[ii_numBl - 1].consumption))
		Else
			Return Round(GetAdmSpd(ad_Cons, False), 1)			
		End If
	End If		
	
	// Check if last entry matches
	If istr_Ballast[ii_numBl].consumption = ad_cons then Return istr_Ballast[ii_numBl].speed		
	
	Do While istr_Ballast[li_Idx].consumption <= ad_cons
		li_Idx ++
	Loop
	li_Idx --
	
	Return Round(istr_Ballast[li_idx].speed + ((ad_cons - istr_Ballast[li_Idx].consumption) * (istr_Ballast[li_Idx + 1].speed - istr_Ballast[li_Idx].speed) / (istr_Ballast[li_Idx + 1].consumption - istr_Ballast[li_Idx].consumption)), 1)
	
End if

Return 0

end function

public function decimal getwrrcons (integer ai_vslid, byte ab_voytype, decimal ad_speed);
Integer li_Idx = 1

If ai_vslid <> ii_Curvslid then 
	ii_Curvslid = ai_vslid
	RetrieveVesselTable( )
End if

If ab_VoyType = 0 then  // If loaded voyage

	If ii_numLd = 0 then Return 0   //  Return 0 if no table
	If ii_CalcType = 2 then Return Round(istr_Loaded[ii_numLd].Consumption, 1)  // Return max consumption from table
	
	If ii_numLd = 1 then    // If only 1 entry
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[1].Consumption / istr_Loaded[1].Speed * ad_Speed, 1)
		Else
			Return Round(GetAdmCons(ad_Speed, True),1)
		End If
	End If
	
	If ad_Speed < istr_loaded[1].Speed then  // If speed is below range
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[1].Consumption - (( istr_Loaded[2].Consumption - istr_Loaded[1].Consumption) * (istr_Loaded[1].Speed - ad_Speed) / (istr_Loaded[2].Speed - istr_Loaded[1].Speed)), 1)
		Else
			Return Round(GetAdmCons(ad_Speed, True), 1)
		End If
	End If
	
	If ad_Speed > istr_loaded[ii_numLd].Speed then  // If speed is above range
		If ii_CalcType = 1 then
			Return Round(istr_Loaded[ii_numLd].Consumption + (( istr_Loaded[ii_numLd].Consumption - istr_Loaded[ii_numLd - 1].Consumption) * (ad_Speed - istr_Loaded[ii_numLd].Speed ) / (istr_Loaded[ii_numLd].Speed - istr_Loaded[ii_numLd - 1].Speed)), 1)
		Else
			Return Round(GetAdmCons(ad_Speed, True), 1)
		End If
	End If
	
	// If last entry matches
	If istr_loaded[ii_numLd].Speed = ad_speed then Return Round(istr_loaded[ii_numLd].Consumption, 1)

	// Find first speed higher than req speed
	Do While istr_loaded[li_Idx].Speed <= ad_speed
		li_Idx ++
	Loop
	li_Idx --
	
	// Interpolate and return
	Return Round(istr_loaded[li_idx].Consumption + ((ad_speed - istr_loaded[li_Idx].Speed) * (istr_loaded[li_Idx + 1].Consumption - istr_loaded[li_Idx].Consumption) / (istr_loaded[li_Idx + 1].Speed - istr_loaded[li_Idx].Speed)), 1)

Else  // Ballast voyage

	If ii_numBl = 0 then Return 0	  // Return 0 if no table
	If ii_CalcType = 2 then Return istr_Ballast[ii_numBl].Consumption  // Return max consumption from table
	
	If ii_numBl = 1 then    // If only 1 entry
		If ii_CalcType = 1 then
			Return Round(istr_Ballast[1].Consumption / istr_Ballast[1].Speed * ad_Speed, 1)
		Else
			Return Round(GetAdmCons(ad_Speed, False), 1)
		End If
	End If
	
	If ad_Speed < istr_Ballast[1].Speed then  // If speed is below range
 		If ii_CalcType = 1 then
			Return Round(istr_Ballast[1].Consumption - (( istr_Ballast[2].Consumption - istr_Ballast[1].Consumption) * (istr_Ballast[1].Speed - ad_Speed) / (istr_Ballast[2].Speed - istr_Ballast[1].Speed)), 1)
		Else
			Return Round(GetAdmCons(ad_Speed, False), 1)
		End If
	End If
	
	If ad_Speed > istr_Ballast[ii_numBl].Speed then  // If speed is above range
 		If ii_CalcType = 1 then		
			Return Round(istr_Ballast[ii_numBl].Consumption + (( istr_Ballast[ii_numBl].Consumption - istr_Ballast[ii_numBl - 1].Consumption) * (ad_Speed - istr_Ballast[ii_numBl].Speed ) / (istr_Ballast[ii_numBl].Speed - istr_Ballast[ii_numBl - 1].Speed)), 1)
		Else
			Return Round(GetAdmCons(ad_Speed, False), 1)
		End If
	End IF
	
	// Check if last entry matches
	If istr_Ballast[ii_numBl].Speed = ad_speed then  Return Round(istr_Ballast[ii_numBl].Consumption, 1)
	
	// Find first speed higher than req speed
	Do While istr_Ballast[li_Idx].Speed <= ad_speed
		li_Idx ++
	Loop
	li_Idx --

	// Interpolate and return
	Return Round(istr_Ballast[li_idx].Consumption + ((ad_speed - istr_Ballast[li_Idx].Speed) * (istr_Ballast[li_Idx + 1].Consumption - istr_Ballast[li_Idx].Consumption) / (istr_Ballast[li_Idx + 1].Speed - istr_Ballast[li_Idx].Speed)), 1)

End if


end function

private function decimal getadmspd (decimal ad_cons, boolean abool_ldd);// This function calculates and returns the Speed for a particular consumption using the Admirality curve

If abool_ldd then
	Return ((istr_Loaded[ii_numLD].Speed ^ Adm_Power) * ad_Cons / istr_Loaded[ii_numLD].Consumption) ^ (1 / Adm_Power)
Else
	Return ((istr_Ballast[ii_numBl].Speed ^ Adm_Power) * ad_Cons / istr_Ballast[ii_numBl].Consumption) ^ (1 / Adm_Power)	
End If
end function

private function decimal getadmcons (decimal ad_spd, boolean abool_ldd);// This function calculates and returns the consumption for a particular speed using the Admirality curve

If abool_ldd then
	Return (ad_spd ^ Adm_Power) * istr_loaded[ii_NumLd].Consumption / (istr_loaded[ii_NumLd].Speed ^ Adm_Power)
Else
	Return (ad_spd ^ Adm_Power) * istr_Ballast[ii_NumBl].Consumption / (istr_Ballast[ii_NumBl].Speed ^ Adm_Power)
End If
end function

event constructor;
ids_wrr = Create n_datastore


end event

on n_wrr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_wrr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
if isvalid(ids_wrr) then destroy ids_wrr
end event

