$PBExportHeader$n_distance.sru
forward
global type n_distance from nonvisualobject
end type
end forward

global type n_distance from nonvisualobject
end type
global n_distance n_distance

type variables


Constant Double idb_Mult = 3437.74677082932
Constant Double idb_SubCorr = 23.01336332

end variables

forward prototypes
public subroutine documentation ()
public function decimal of_getdistance (decimal ad_lata, decimal ad_longa, decimal ad_latb, decimal ad_longb)
private function double _dmp (double adb_lat1, double adb_lat2)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_distance
	
   <OBJECT>
		This object simply calculates the rhumb-line distance between two positions.
		Positions must be supplied in Lat/Lng. It calculates accurate distances 
		taking the correct shape of the earth.
	</OBJECT>
	
   <USAGE>
	
		Use function of_GetDistance() and pass lat/long for positions A and B.
		
		Function _DMP() is private and used internally only
		
	</USAGE>

<HISTORY> 
   Date	     CR-Ref	 Author	Comments
   20/06/10	    1517  CONASW	First Version
</HISTORY>    
********************************************************************/

end subroutine

public function decimal of_getdistance (decimal ad_lata, decimal ad_longa, decimal ad_latb, decimal ad_longb);
// Calculates rhumbline distance between two points

Double ldb_DLong, ldb_Dep, ldb_MLat, ldb_DMPVal, ldb_Dist

ldb_DLong = ad_LongA - ad_LongB
If ldb_DLong > 180 Then ldb_DLong = ldb_DLong - 360
If ldb_DLong < -180 Then ldb_DLong = 360 + ldb_DLong

ldb_DMPVal = Abs(_DMP(ad_LatA, ad_LatB))

ldb_Dist = Sqrt((ldb_DMPVal * ldb_DMPVal) + (ldb_DLong * ldb_DLong * 3600))

If ldb_DMPVal = Double(0) Then
	ldb_Dist = Abs(ldb_DLong * Cos(ad_LatA * Pi(1/180)))
Else
	ldb_Dist = Round(Abs(ad_LatA - ad_LatB)* 60 * ldb_Dist / ldb_DMPVal, 2)
End If

Return ldb_Dist

end function

private function double _dmp (double adb_lat1, double adb_lat2);// Calculates the difference in meridonial parts of latitudes (DMP)

Double ldb_MP1, ldb_MP2, ldb_LRad

ldb_LRad = (Abs(adb_Lat1) / 2 + 45) * Pi(1/180)
ldb_MP1 = idb_Mult * Log(Tan(ldb_LRad)) - (idb_SubCorr * Sin(Abs(adb_Lat1) * Pi(1/180)))
ldb_LRad = (Abs(adb_Lat2) / 2 + 45) * Pi(1/180)
ldb_MP2 = idb_Mult * Log(Tan(ldb_LRad)) - (idb_SubCorr * Sin(Abs(adb_Lat2) * Pi(1/180)))

Return (Sign(adb_Lat2) * ldb_MP2) - (Sign(adb_Lat1) * ldb_MP1)


end function

on n_distance.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_distance.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

