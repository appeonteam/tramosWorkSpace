$PBExportHeader$uo_find_layt_ports.sru
$PBExportComments$Used in Laytime Statements for updateing Settled Bit for DEM_DES_CLAIMS
forward
global type uo_find_layt_ports from UserObject
end type
end forward

global type uo_find_layt_ports from UserObject
int Width=1582
int Height=993
boolean Border=true
end type
global uo_find_layt_ports uo_find_layt_ports

type variables

end variables

forward prototypes
public subroutine uf_layt_ports (integer vessel, string voyage, integer charter, ref s_port_array ports_array)
end prototypes

public subroutine uf_layt_ports (integer vessel, string voyage, integer charter, ref s_port_array ports_array);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : 
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : 
   
 Date       : 

 Description : Get ports where exists laytime. Will be used for setting settled bit to TRUE in 
		      DEM_DES_CLAIM, or dw_dem_des_claim. This bit(Int) will then include calculation in claim amount if TRUE(1)
		      and include in print. Claim amount will then always be updated according to actual visited ports.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  23/7-96                                   LN            INITIAL
************************************************************************************/
String ls_port
Integer li_counter = 0,li_pcn

 DECLARE port_cur CURSOR FOR  
  SELECT LAYTIME_STATEMENTS.PORT_CODE,  LAYTIME_STATEMENTS.PCN
  FROM LAYTIME_STATEMENTS  
  WHERE LAYTIME_STATEMENTS.VESSEL_NR = :vessel AND   LAYTIME_STATEMENTS.VOYAGE_NR = :voyage AND
               LAYTIME_STATEMENTS.CHART_NR = :charter ;

OPEN port_cur;

FETCH port_cur INTO :ls_port,:li_pcn;
 
DO WHILE SQLCA.SQLCode = 0
	li_counter++
	ports_array.ports[li_counter] = ls_port
	ports_array.pcn[li_counter] = li_pcn
FETCH port_cur INTO :ls_port,:li_pcn;
LOOP
CLOSE port_cur;

COMMIT USING SQLCA;

end subroutine

on uo_find_layt_ports.create
end on

on uo_find_layt_ports.destroy
end on

