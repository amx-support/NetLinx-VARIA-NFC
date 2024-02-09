PROGRAM_NAME='Varia_NFC_sample'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvTP		= 10001:1:0
vdvNFC		= 33001:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

NFC_MODE_ID	= 0
NFC_MODE_MD5	= 1
NFC_MODE_SHA256	= 2

NFC_DATA_LENGTH	= 64
NFC_DATA_NUM	= 20

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

integer	nMode
char	strNFC_Read[NFC_DATA_LENGTH]
char	strNFC_Data[NFC_DATA_NUM][NFC_DATA_LENGTH]

long	lTL_DP[] = {300}

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([dvTP,1]..[dvTP,3])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

DEFINE_FUNCTION checkData()
{
    STACK_VAR integer i
    
    FOR(i=1;i<=NFC_DATA_NUM;i++)
    {
	IF (strNFC_Data[i] == strNFC_Read)
	{
	    SEND_COMMAND dvTP,"'^TXT-2,0,HIT:',ITOA(i)"
	    RETURN
	}
    }
    
    SEND_COMMAND dvTP,'^TXT-2,0,N/A'
}


DEFINE_MODULE 'mdl_Varia_NFC_1_0' mdlVariaNFC(dvTP,vdvNFC,nMode)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

TIMELINE_CREATE(99,lTL_DP,1,TIMELINE_ABSOLUTE,TIMELINE_REPEAT)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT [99]
{
    ON[dvTP,nMode+1]
}

DATA_EVENT [vdvNFC]
{
    STRING:
    {
	strNFC_Read = DATA.TEXT
	SEND_COMMAND dvTP,"'^TXT-1,0,',DATA.TEXT"
	
	checkData()
	SEND_COMMAND dvTP,'^PPN-ppREAD'
    }
}

DATA_EVENT [dvTP]
{
    ONLINE:
    {
	STACK_VAR integer i
	
	SEND_COMMAND dvTP,"'^TXT-1,0,',strNFC_Read"
	FOR(i=11;i<=30;i++) SEND_COMMAND dvTP,"'^TXT-',ITOA(i),',0,',strNFC_Data[i-10]"
    }
}

BUTTON_EVENT [dvTP,1]
BUTTON_EVENT [dvTP,2]
BUTTON_EVENT [dvTP,3]
{
    PUSH:
    {
	nMode = BUTTON.INPUT.CHANNEL-1
    }
}

BUTTON_EVENT [dvTP,11]
BUTTON_EVENT [dvTP,12]
BUTTON_EVENT [dvTP,13]
BUTTON_EVENT [dvTP,14]
BUTTON_EVENT [dvTP,15]
BUTTON_EVENT [dvTP,16]
BUTTON_EVENT [dvTP,17]
BUTTON_EVENT [dvTP,18]
BUTTON_EVENT [dvTP,19]
BUTTON_EVENT [dvTP,20]
BUTTON_EVENT [dvTP,21]
BUTTON_EVENT [dvTP,22]
BUTTON_EVENT [dvTP,23]
BUTTON_EVENT [dvTP,24]
BUTTON_EVENT [dvTP,25]
BUTTON_EVENT [dvTP,26]
BUTTON_EVENT [dvTP,27]
BUTTON_EVENT [dvTP,28]
BUTTON_EVENT [dvTP,29]
BUTTON_EVENT [dvTP,30]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	strNFC_Data[BUTTON.INPUT.CHANNEL-10] = strNFC_Read
	SEND_COMMAND dvTP,"'^TXT-',ITOA(BUTTON.INPUT.CHANNEL),',0,',strNFC_Read"
    }
    HOLD[10]:
    {
	strNFC_Data[BUTTON.INPUT.CHANNEL-10] = ''
	SEND_COMMAND dvTP,"'^TXT-',ITOA(BUTTON.INPUT.CHANNEL),',0,'"
    }
}

BUTTON_EVENT [dvTP,100]
{
    PUSH:
    {
	SEND_COMMAND dvTP,'^PPF-ppREAD'
    }
}


(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


