;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F886. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F886.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list	p=16f886	; list directive to define processor
	#include	<p16f886.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG	_CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG	_CONFIG2, _WRT_OFF & _BOR21V

	cblock	0x020
  		COUNTERL
  		COUNTERH
		INDEX
		TEMP_BANK
		REG1
		
		R_DEVICEID_H
		R_DEVICEID_L
		R_CHIPID_H
		R_CHIPID_L
		R_POWERCFG_H
		R_POWERCFG_L
		R_CHANNEL_H
		R_CHANNEL_L
		R_SYSCONFIG1_H
		R_SYSCONFIG1_L
		R_SYSCONFIG2_H
		R_SYSCONFIG2_L
		R_SYSCONFIG3_H
		R_SYSCONFIG3_L
		R_TEST1_H
		R_TEST1_L
		R_TEST2_H
		R_TEST2_L
		R_BOOTCONFIG_H
		R_BOOTCONFIG_L
		R_STATUSRSSI_H
		R_STATUSRSSI_L
		R_READCHAN_H
		R_READCHAN_L
		R_RDSA_H
		R_RDSA_L
		R_RDSB_H
		R_RDSB_L
		R_RDSC_H
		R_RDSC_L
		R_RDSD_H
		R_RDSD_L
		
		READCHAN_COPY
		READCHAN_HUNDREDS
		READCHAN_TENS
		READCHAN_ONES
		READCHAN_TENTHS
		
		d1
		d2
		d3
		
		counter_128ms
		counter_5ms
		counter_200us
		counter_bf
		counter_keyPress
		LCD_COMMAND
		LCD_DATA
		LCD_ADDRESS_COUNTER
		LCD_LINE_COUNTER
		LCD_PRINT_COUNTER
		
		performPreset_CHANNEL
		performPreset_NUMBER
		
		w_temp	; variable used for context saving
		status_temp	; variable used for context saving
		pclath_temp	; variable used for context saving
	endc


;***** VARIABLE DEFINITIONS
;w_temp	EQU	0x7D	
;status_temp	EQU	0x7E	; variable used for context saving
;pclath_temp	EQU	0x7F	; variable used for context saving

; LCD
LCD_DATA_PORT	EQU	PORTB
LCD_DATA_TRIS	EQU	TRISB
LCD_DATA_ANSEL	EQU	ANSELH
LCD_RS	EQU	0x05
LCD_RW	EQU	0x04
LCD_BF	EQU	0x03
LCD_D7	EQU	0x03
LCD_D6	EQU	0x02
LCD_D5	EQU	0x01
LCD_D4	EQU	0x00
LCD_EN_PORT	EQU	PORTC
LCD_EN_TRIS	EQU	TRISC
LCD_EN	EQU	0x07

;KEYPAD
KEYPAD	EQU	PORTA
KEYPAD_TRIS	EQU	TRISA
KEYPAD_ANSEL	EQU	ANSEL
KEYPAD_COLCFG	EQU	b'11110000' ; Columns then rows

; RADIO
RADIO	EQU	PORTC
SDIO	EQU	0x04
SCLK	EQU	0x03
RST	EQU	0x02
GPIO1	EQU	0x01
GPIO2	EQU	0x06

;{
PN_3	EQU 	D'07'
PN_2	EQU 	D'06'
PN_1	EQU 	D'05'
PN_0	EQU 	D'04'
MFGID_11	EQU 	D'03'	
MFGID_10	EQU 	D'02'
MFGID_9	EQU 	D'01'
MFGID_8	EQU 	D'00'
MFGID_7	EQU 	D'07'
MFGID_6	EQU 	D'06'
MFGID_5	EQU 	D'05'
MFGID_4	EQU 	D'04'
MFGID_3	EQU 	D'03'
MFGID_2	EQU 	D'02'
MFGID_1	EQU 	D'01'
MFGID_0	EQU 	D'00'
	
;01H	
REV_5	EQU 	D'07'
REV_4	EQU 	D'06'
REV_3	EQU 	D'05'
REV_2	EQU 	D'04'
REV_1	EQU 	D'03'
REV_0	EQU 	D'02'
DEV_3	EQU 	D'01'
DEV_2	EQU 	D'00'
DEV_1	EQU 	D'07'
DEV_0	EQU 	D'06'
FIRMWARE_5	EQU 	D'05'
FIRMWARE_4	EQU 	D'04'
FIRMWARE_3	EQU 	D'03'
FIRMWARE_2	EQU 	D'02'
FIRMWARE_1	EQU 	D'01'
FIRMWARE_0	EQU 	D'00'
	
;02H	
DSMUTE	EQU 	D'07'
DMUTE	EQU 	D'06'
MONO	EQU 	D'05'
RDSM	EQU 	D'03'
SKMODE	EQU 	D'02'
SEEKUP	EQU 	D'01'
SEEK	EQU 	D'00'
DISABLE	EQU 	D'06'
ENABLE	EQU 	D'00'
	
;03H	
TUNE	EQU 	D'07'
CHAN_9	EQU 	D'01'
CHAN_8	EQU 	D'00'
CHAN_7	EQU 	D'07'
CHAN_6	EQU 	D'06'
CHAN_5	EQU 	D'05'
CHAN_4	EQU 	D'04'
CHAN_3	EQU 	D'03'
CHAN_2	EQU 	D'02'
CHAN_1	EQU 	D'01'
CHAN_0	EQU 	D'00'
	
;04H	
RDSIEN	EQU 	D'07'
STCIEN	EQU 	D'06'
RDS	EQU 	D'04'
DEMPHASIS	EQU 	D'03'
AGCD	EQU 	D'02'
BLNDADJ_1	EQU 	D'07'
BLNDADJ_0	EQU 	D'06'
GPIO3_1	EQU 	D'05'
GPIO3_0	EQU 	D'04'
GPIO2_1	EQU 	D'03'
GPIO2_0	EQU 	D'02'
GPIO1_1	EQU 	D'01'
GPIO1_0	EQU 	D'00'
	
;05H	
SEEKTH_7	EQU 	D'07'
SEEKTH_6	EQU 	D'06'
SEEKTH_5	EQU 	D'05'
SEEKTH_4	EQU 	D'04'
SEEKTH_3	EQU 	D'03'
SEEKTH_2	EQU 	D'02'
SEEKTH_1	EQU 	D'01'
SEEKTH_0	EQU 	D'00'
BAND_1	EQU 	D'07'
BAND_0	EQU 	D'06'
SPACE_1	EQU 	D'05'
SPACE_0	EQU 	D'04'
VOLUME_3	EQU 	D'03'
VOLUME_2	EQU 	D'02'
VOLUME_1	EQU 	D'01'
VOLUME_0	EQU 	D'00'

;06H	
SMUTER_1	EQU 	D'07'
SMUTER_0	EQU 	D'06'
SMUTEA_1	EQU 	D'05'
SMUTEA_0	EQU 	D'04'
VOLEXT	EQU 	D'00'
SKSNR_3	EQU 	D'07'
SKSNR_2	EQU 	D'06'
SKSNR_1	EQU 	D'05'
SKSNR_0	EQU 	D'04'
SKCNT_3	EQU 	D'03'
SKCNT_2	EQU 	D'02'
SKCNT_1	EQU 	D'01'
SKCNT_0	EQU 	D'00'
	
;07H	
XOSCEN	EQU 	D'07'
AHIZEN	EQU 	D'06'
	
;0AH	
RDSR	EQU 	D'07'
STC	EQU 	D'06'
SF_BL	EQU 	D'05'
AFCRL	EQU 	D'04'
RDSS	EQU 	D'03'
BLERA_1	EQU 	D'02'
BLERA_0	EQU 	D'01'
ST	EQU 	D'00'
RSSI_7	EQU 	D'07'
RSSI_6	EQU 	D'06'
RSSI_5	EQU 	D'05'
RSSI_4	EQU 	D'04'
RSSI_3	EQU 	D'03'
RSSI_2	EQU 	D'02'
RSSI_1	EQU 	D'01'
RSSI_0	EQU 	D'00'
	
;0BH	
BLERB_1	EQU 	D'07'
BLERB_0	EQU 	D'06'
BLERC_1	EQU 	D'05'
BLERC_0	EQU 	D'04'
BLERD_1	EQU 	D'03'
BLERD_0	EQU 	D'02'
READCHAN_9	EQU 	D'01'
READCHAN_8	EQU 	D'00'
READCHAN_7	EQU 	D'07'
READCHAN_6	EQU 	D'06'
READCHAN_5	EQU 	D'05'
READCHAN_4	EQU 	D'04'
READCHAN_3	EQU 	D'03'
READCHAN_2	EQU 	D'02'
READCHAN_1	EQU 	D'01'
READCHAN_0	EQU 	D'00'
	
;0CH	
RDSA_15	EQU 	D'07'
RDSA_14	EQU 	D'06'
RDSA_13	EQU 	D'05'
RDSA_12	EQU 	D'04'
RDSA_11	EQU 	D'03'
RDSA_10	EQU 	D'02'
RDSA_9	EQU 	D'01'
RDSA_8	EQU 	D'00'
RDSA_7	EQU 	D'07'
RDSA_6	EQU 	D'06'
RDSA_5	EQU 	D'05'
RDSA_4	EQU 	D'04'
RDSA_3	EQU 	D'03'
RDSA_2	EQU 	D'02'
RDSA_1	EQU 	D'01'
RDSA_0	EQU 	D'00'
	
;0DH	
RDSB_15	EQU 	D'07'
RDSB_14	EQU 	D'06'
RDSB_13	EQU 	D'05'
RDSB_12	EQU 	D'04'
RDSB_11	EQU 	D'03'
RDSB_10	EQU 	D'02'
RDSB_9	EQU 	D'01'
RDSB_8	EQU 	D'00'
RDSB_7	EQU 	D'07'
RDSB_6	EQU 	D'06'
RDSB_5	EQU 	D'05'
RDSB_4	EQU 	D'04'
RDSB_3	EQU 	D'03'
RDSB_2	EQU 	D'02'
RDSB_1	EQU 	D'01'
RDSB_0	EQU 	D'00'

;0EH
RDSC_15	EQU 	D'07'
RDSC_14	EQU 	D'06'
RDSC_13	EQU 	D'05'
RDSC_12	EQU 	D'04'
RDSC_11	EQU 	D'03'
RDSC_10	EQU 	D'02'
RDSC_9	EQU 	D'01'
RDSC_8	EQU 	D'00'
RDSC_7	EQU 	D'07'
RDSC_6	EQU 	D'06'
RDSC_5	EQU 	D'05'
RDSC_4	EQU 	D'04'
RDSC_3	EQU 	D'03'
RDSC_2	EQU 	D'02'
RDSC_1	EQU 	D'01'
RDSC_0	EQU 	D'00'

;0FH
RDSD_15	EQU 	D'07'
RDSD_14	EQU 	D'06'
RDSD_13	EQU 	D'05'
RDSD_12	EQU 	D'04'
RDSD_11	EQU 	D'03'
RDSD_10	EQU 	D'02'
RDSD_9	EQU 	D'01'
RDSD_8	EQU 	D'00'
RDSD_7	EQU 	D'07'
RDSD_6	EQU 	D'06'
RDSD_5	EQU 	D'05'
RDSD_4	EQU 	D'04'
RDSD_3	EQU 	D'03'
RDSD_2	EQU 	D'02'
RDSD_1	EQU 	D'01'
RDSD_0	EQU 	D'00'
;}
;
;RADIO_SDIO      EQU     	0x04    ;
;RADIO_SCLK      EQU     	0x03    ;
;RADIO_RST       EQU     	0x02    ; Active low
;RADIO_GPIO1     EQU     	0x01    ; Configured as 3.3V output to power an LED on power up
;RADIO_GPIO2     EQU     	0x06    ;

;**********************************************************************
	ORG	0x000	; processor reset vector

	nop
  	goto	initialise	; go to beginning of program


	ORG	0x004	; interrupt vector location

	movwf	w_temp	; save off current W register contents
	movf	STATUS,w	; move status register into W register
	movwf	status_temp	; save off contents of STATUS register
	movf	PCLATH,w	; move pclath register into w register
	movwf	pclath_temp	; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere

	movf	pclath_temp,w	; retrieve copy of PCLATH register
	movwf	PCLATH	; restore pre-isr PCLATH register contents
	movf	status_temp,w	; retrieve copy of STATUS register
	movwf	STATUS	; restore pre-isr STATUS register contents
	swapf	w_temp,f
	swapf	w_temp,w	; restore pre-isr W register contents
	retfie		; return from interrupt


;----------------------------------------------------------------------------------------;
;    _____ _  _ ___   ___ _   _ _  _   ___ _____ _   ___ _____ ___   _  _ ___ ___ ___    ;
;   |_   _| || | __| | __| | | | \| | / __|_   _/_\ | _ \_   _/ __| | || | __| _ \ __|   ;
;     | | | __ | _|  | _|| |_| | .` | \__ \ | |/ _ \|   / | | \__ \ | __ | _||   / _|    ;
;     |_| |_||_|___| |_|  \___/|_|\_| |___/ |_/_/ \_\_|_\ |_| |___/ |_||_|___|_|_\___|   ;
;                                                                                        ;
;----------------------------------------------------------------------------------------;                                                                                   
initialise
	; Set ANSELs
	BANKSEL	ANSELH
	clrf	ANSELH
	clrf	ANSEL
	
	; Set TRISC
	BANKSEL	TRISB
	clrf	TRISB
	clrf 	TRISC
	
	movlw	KEYPAD_COLCFG 
	movwf	TRISA
	
	; Set Ports
	BANKSEL	PORTB
	clrf	PORTB
	clrf	PORTC
	
	movlw	b'11111111'
	movwf	PORTA
	
	
	call	radio_init
	; Tune to 96.9 Nova FM	
	movlw	D'47'
	call	radio_tune
	
	call	LCD_clearDisplay
	call	printShanush
	call	delay_500ms
	call	delay_500ms
	call	delay_500ms
	call	printRadio
	call	delay_500ms
	call	delay_500ms
	call	delay_500ms
	
	call	printCurrentChannel

main
	BANKSEL	KEYPAD
keyPad
	
	bsf	KEYPAD,0
	bcf	KEYPAD,3
	btfss	KEYPAD,7
	call	preset1	;Key1
	btfss	KEYPAD,6
	call	preset2	;Key2
	btfss	KEYPAD,5
	call	preset3	;Key3
	btfss	KEYPAD,4
	call	seekUp	;KeyF
	
	bsf	KEYPAD,3
	bcf	KEYPAD,2
	btfss	KEYPAD,7
	call	preset4	;Key4
	btfss	KEYPAD,6
	call	preset5	;Key5
	btfss	KEYPAD,5	
	call	f6	;Key6
	btfss	KEYPAD,4
	call	seekDown	;KeyE
	
	bsf	KEYPAD,2
	bcf	KEYPAD,1
	btfss	KEYPAD,7
	call	f7	;Key7
	btfss	KEYPAD,6
	call	f8	;Key8
	btfss	KEYPAD,5
	call	f9	;Key9
	btfss	KEYPAD,4
	call	fD	;KeyD
	
	bsf	KEYPAD,1
	bcf	KEYPAD,0
	btfss	KEYPAD,7
	call	fA	;KeyA
	btfss	KEYPAD,6
	call	f0	;KeyB
	btfss	KEYPAD,5
	call	fB	;Key0
	btfss	KEYPAD,4
	call	fC	;KeyC
	
	goto 	keyPad

	
endProgram	
	goto	endProgram	

; MAKE THIS KEYPAD FUNCTIONS
;-----------------------------------------------------;
;     ___ _   _ _  _  ___ _____ ___ ___  _  _ ___     ;
;    | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|    ;
;    | _|| |_| | .` | (__  | |  | | (_) | .` \__ \    ;
;    |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/    ;
;                                                     ;
;-----------------------------------------------------;
;{
preset1
	; Print "PRESET 1: [CHANNEL]MHz"
	; Print "Tuning:   PRESET 1"
	;       "Playing: [Chan]MHz"
	
	BANKSEL	performPreset_CHANNEL
	
	movlw	D'27'
	movwf	performPreset_CHANNEL
	
	movlw	'1'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
	
	return

preset2
	; Print "PRESET 1: [CHANNEL]MHz"
	; Print "Tuning:   PRESET 1"
	;       "Playing: [Chan]MHz"
	
	BANKSEL	performPreset_CHANNEL
	
	movlw	D'39'
	movwf	performPreset_CHANNEL
	
	movlw	'2'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
	
	return


preset3
	; Print "PRESET 1: [CHANNEL]MHz"
	; Print "Tuning:   PRESET 1"
	;       "Playing: [Chan]MHz"
	
	BANKSEL	performPreset_CHANNEL
	
	movlw	D'47'
	movwf	performPreset_CHANNEL
	
	movlw	'3'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
	
	return
	
preset4
	; Print "PRESET 1: [CHANNEL]MHz"
	; Print "Tuning:   PRESET 1"
	;       "Playing: [Chan]MHz"	

	BANKSEL	performPreset_CHANNEL
	
	movlw	D'71'
	movwf	performPreset_CHANNEL
	
	movlw	'4'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset

	return
	
preset5
	; Print "PRESET 1: [CHANNEL]MHz"
	; Print "Tuning:   PRESET 1"
	;       "Playing: [Chan]MHz"
	
	BANKSEL	performPreset_CHANNEL
	
	movlw	D'83'
	movwf	performPreset_CHANNEL
	
	movlw	'5'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
	
	return
	
seekUp
	call	LCD_clearDisplay
	call	printSeek
	
	BANKSEL	LCD_DATA
	movlw	0xC5
	call	LCD_sendData
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SKMODE
	bsf	R_POWERCFG_H, SEEKUP

seekUp_seek	
	call	radio_seek
	
	call	delay_128ms
	
	BANKSEL	PORTA
	movlw	b'11110111'
	movwf	PORTA
	
	movlw	b'11100111'
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	seekUp_seek
	
	call	delay_500ms
	
	call	printCurrentChannel
	
	return
	
	
seekDown
	call	LCD_clearDisplay
	call	printSeek
	
	BANKSEL	LCD_DATA
	movlw	0xC6
	call	LCD_sendData
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SKMODE
	bcf	R_POWERCFG_H, SEEKUP

seekDown_seek	
	call	radio_seek
	
	call	delay_128ms
	
	BANKSEL	PORTA
	movlw	b'11111011'
	movwf	PORTA
	
	movlw	b'11101011'
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	seekDown_seek
	
	call	delay_500ms
	
	call	printCurrentChannel
	
	return
	
;fFunctions
;{
f0
	call	'0'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f1
	call	'1'
	call	LCD_sendData
	call	delay_keyPress
	return

f2	
	movlw	'2'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f3
	movlw	'3'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f4
	movlw	'4'
	call	LCD_sendData
	call	delay_keyPress
	return

f5
	movlw	'5'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f6
	movlw	'6'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f7
	movlw	'7'
	call	LCD_sendData
	call	delay_keyPress
	return

f8
	movlw	'8'
	call	LCD_sendData
	call	delay_keyPress
	return
	
f9
	movlw	'9'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fA
	movlw	'A'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fB	

	movlw	'B'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fC
	movlw	'C'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fD
	movlw	'D'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fE
	movlw	'E'
	call	LCD_sendData
	call	delay_keyPress
	return
	
fF	
	movlw	'F'
	call	LCD_sendData
	call	delay_keyPress
	return
;}
;}

; HELPER FUNCTIONS
;{
performPreset
	BANKSEL	LCD_DATA
	call	printPreset
;	movlw	' '
;	call	LCD_sendData
	movf	performPreset_NUMBER,W
	call	LCD_sendData
	
	movf	performPreset_CHANNEL,W
	call	radio_tune

	call	delay_500ms
	
	call	printCurrentChannel

	return

printSeek
	BANKSEL	LCD_DATA
	movlw	'S'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'K'
	call	LCD_sendData
	
	return

printPreset
	BANKSEL	LCD_DATA
	movlw	'P'
	call	LCD_sendData
	movlw	'R'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'S'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'T'
	call	LCD_sendData
	return

;printTuning
;	BANKSEL	LCD_DATA
;	call	LCD_clearDisplay
;	movlw	'T'
;	call	LCD_sendData
;	movlw	'u'
;	call	LCD_sendData
;	movlw	'n'
;	call	LCD_sendData
;	movlw	'i'
;	call	LCD_sendData
;	movlw	'n'
;	call	LCD_sendData
;	movlw	'g'
;	call	LCD_sendData
;	movlw	' '
;	call	LCD_sendData
;	call	printREADCHAN
;	
;	return

printCurrentChannel
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay
	call	printPlaying
	call	printREADCHAN
	return

printREADCHAN

	;calculate READCHAN into printing
	movlw	'0'
	movwf	READCHAN_HUNDREDS
	
	movlw	'8'
	movwf	READCHAN_TENS
	
	movlw	'7'
	movwf	READCHAN_ONES
	
	movlw	'5'
	movwf	READCHAN_TENTHS
	
	
	movf	R_READCHAN_L,W
	movwf	READCHAN_COPY
	
calREADCHANLoop:
	movf	READCHAN_COPY,W
	btfsc	STATUS,Z
	goto	printREADCHANPrinting
	
	; TENTHS
	decf	READCHAN_COPY,F
	incf	READCHAN_TENTHS,F
	incf	READCHAN_TENTHS,F
	
	movlw	D'59'
	xorwf	READCHAN_TENTHS,W
	btfss	STATUS,Z
	goto	calREADCHANLoop
	
	; ONES
	movlw	'1'
	movwf	READCHAN_TENTHS
	incf	READCHAN_ONES,F
	
	movlw	D'58'
	xorwf	READCHAN_ONES,W
	btfss	STATUS,Z
	goto	calREADCHANLoop
	
	; TENTHS
	movlw	'0'
	movwf	READCHAN_ONES
	incf	READCHAN_TENS,F
	
	movlw	D'58'
	xorwf	READCHAN_TENS,W
	btfss	STATUS,Z
	goto	calREADCHANLoop
	
	; HUNDREDS
	movlw	'0'
	movwf	READCHAN_TENS
	incf	READCHAN_HUNDREDS
	
	goto	calREADCHANLoop

printREADCHANPrinting	
	movlw	'0'
	xorwf	READCHAN_HUNDREDS,W
	btfsc	STATUS,Z
	goto	printREADCHANspace
	
	movlw	'1'
	call	LCD_sendData
	goto 	printREADCHANspaceEnd
	
printREADCHANspace
	movlw	' '
	call	LCD_sendData
	
printREADCHANspaceEnd
	movf	READCHAN_TENS,W
	call	LCD_sendData
	
	movf	READCHAN_ONES,W
	call	LCD_sendData
	
	movlw	'.'
	call	LCD_sendData

	movf	READCHAN_TENTHS,W
	call	LCD_sendData
	
	movlw	'M'
	call	LCD_sendData
	
	movlw	'h'
	call	LCD_sendData
	
	movlw	'z'
	call	LCD_sendData
	
	
	return


printPlaying
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay
	movlw	'P'
	call	LCD_sendData
	movlw	'L'
	call	LCD_sendData
	movlw	'A'
	call	LCD_sendData
	movlw	'Y'
	call	LCD_sendData
	movlw	'I'
	call	LCD_sendData
	movlw	'N'
	call	LCD_sendData
	movlw	'G'
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	return
	
printShanush
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay

	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData

	movlw	' '
	call	LCD_sendData
		
	movlw	' '
	call	LCD_sendData

	movlw	'S'
	call	LCD_sendData

	movlw	'H'
	call	LCD_sendData

	movlw	'A'
	call	LCD_sendData

	movlw	'N'
	call	LCD_sendData

	movlw	'U'
	call	LCD_sendData
	
	movlw	'S'
	call	LCD_sendData
	
	movlw	'H'
	call	LCD_sendData
	
	movlw	'P'
	call	LCD_sendData
	
	call	LCD_resetCursor
	return


printRadio
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData

	movlw	' '
	call	LCD_sendData
		
	movlw	' '
	call	LCD_sendData

	movlw	'R'
	call	LCD_sendData

	movlw	'A'
	call	LCD_sendData

	movlw	'D'
	call	LCD_sendData

	movlw	'I'
	call	LCD_sendData

	movlw	'O'
	call	LCD_sendData
	
	movlw	'!'
	call	LCD_sendData
	
	movlw	'!'
	call	LCD_sendData
	
	movlw	'!'
	call	LCD_sendData
	
	
	return
;}
;-----------------------------------------------------------------------------;
;    ___    _   ___ ___ ___    ___ _   _ _  _  ___ _____ ___ ___  _  _ ___    ;
;   | _ \  /_\ |   \_ _/ _ \  | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|   ;
;   |   / / _ \| |) | | (_) | | _|| |_| | .` | (__  | |  | | (_) | .` \__ \   ;
;   |_|_\/_/ \_\___/___\___/  |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/   ;
;                                                                             ;
;-----------------------------------------------------------------------------;
;{
radio_init;{
	BANKSEL	TRISC
; WARNING NEED TO SET GPIO PINS TO INPUTS
;	  SET LCD ENABLE PIN
	clrf	TRISC
	
	BANKSEL	RADIO	; i.e PORTC
	
	; Configure Two-bus mode (i2c)
	; SDIO must be low && SEN must be hight
	clrf	RADIO
	;bcf	RADIO,SDIO 	
	nop		; Give time before setting reset high
	
	; Start Radio
	bsf	RADIO,RST
	nop		; Give time to register two bus mode option
	nop
	
	call	i2c_setup
	call	shadow_fill
	
	; Set XOSCEN - we are using the internal crystal oscillator
	BANKSEL	R_TEST1_H
	bsf	R_TEST1_H, XOSCEN
	
	; Set RDSD to 0x0000 as an errand solution for our chip
	clrf	R_RDSD_H
	clrf	R_RDSD_L
	
	call	shadow_push
	
	; Wait for 500ms for crystal to oscillate
	call	LCD_initialise
	;call	delay_500ms
	
	
	BANKSEL	R_POWERCFG_L
	bcf	R_POWERCFG_L, DISABLE
	bsf	R_POWERCFG_L, ENABLE
	
	bsf	R_POWERCFG_H, DMUTE
	bcf	R_POWERCFG_H, DSMUTE
	
	; For australia
	bsf	R_SYSCONFIG1_H, DEMPHASIS
	
	; Disable Interrupts
	; WARNING CHANGE IF YOU WANT TO USE INTERRUPTS
	bcf	R_SYSCONFIG1_H, RDSIEN
	bcf	R_SYSCONFIG1_H, STCIEN
	
	; Set volume
	bcf	R_SYSCONFIG2_L, VOLUME_0
	bsf	R_SYSCONFIG2_L, VOLUME_1
	bsf	R_SYSCONFIG2_L, VOLUME_2
	bsf	R_SYSCONFIG2_L, VOLUME_3	
	bsf	R_SYSCONFIG3_H, VOLEXT 	;Set for low volume, clear for high volume
	
	; Noise ratios and stuff for good quality
	bsf	R_SYSCONFIG3_L, SKSNR_0	; SKSNR - 0001: minimum signal to noise
	bsf	R_SYSCONFIG3_L, SKCNT_0	; SKCNT - 0001: FM impulse detection, max stops
	
	
	call	shadow_push
	
	call	radio_setDefaultSeekSettings

	return
;}
;---------------------------------------------------------------------------
; Tuning function 
; Make sure to have your "channel" on W reg
; Channel = (Frequency - Lower Band Limit) / Spacing
; Channel(Mhz) = (Desired Frequency(MHz) - 87.5MHz) / 200KHz
; WARNING - MAYBE ENSURE "BAND" AND "SPACING" ARE CORRECT
radio_tune ;{
	BANKSEL	R_CHANNEL_H
	bsf	R_CHANNEL_H, TUNE
	movwf	R_CHANNEL_L
	
	call	shadow_push
	
radioTuneLoop
	call 	shadow_fill
	;call	delay_60ms
	
	call	LCD_secondLine
	call	printREADCHAN
	
	BANKSEL	R_STATUSRSSI_H
	btfss	R_STATUSRSSI_H, STC
	goto	radioTuneLoop
	
	BANKSEL	R_CHANNEL_H
	bcf	R_CHANNEL_H, TUNE
	
	call	shadow_push
	call	delay_500ms
	
	return
;}	
;---------------------------------------------------------------------------

radio_setDefaultSeekSettings ;{
	BANKSEL	R_CHANNEL_H
	bcf	R_CHANNEL_H, CHAN_9
	bcf	R_CHANNEL_H, CHAN_8
	clrf	R_CHANNEL_L
	
	bcf	R_POWERCFG_H, SKMODE
	bcf	R_POWERCFG_H, SEEKUP
	
	; shadow push will return to function
	; that called this function
	goto	shadow_push
	
	return ;}

;---------------------------------------------------------------------------
; Call this function to seek to the nearest station
; Make sure to set Seek Control before calling this function
; SKMODE - High for stopping at upper limit
;          Low for wrapping around (default)
; SEEKUP - High for seeking up to upper band limit
;          Low for seeking down to lower band limit (default)
radio_seek ;{	
	BANKSEL	R_POWERCFG_H
	bsf	R_POWERCFG_H, SEEK
	call	shadow_push
	
radioSeekLoop
	call 	shadow_fill
	;call	delay_60ms
	
	BANKSEL	LCD_DATA
	call	LCD_secondLine
	call	printREADCHAN
	
	BANKSEL	R_STATUSRSSI_H
	btfss	R_STATUSRSSI_H, STC
	goto	radioSeekLoop
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SEEK	
	
	call	shadow_push
	
	return
	
;}
;---------------------------------------------------------------------------


; Updates the local copy of the radio registers	
; Warning: Make sure to set up i2c before using this function
shadow_fill
	; Initiate start condition
	call	i2c_start
	
	; Move device id from 
	BANKSEL	SSPBUF
	movlw	b'00100001' ; DeviceID + Read
	movwf	SSPBUF
	
	call	i2c_checkAcknowledge
	
	call	i2c_checkIdle
	
	movlw	R_STATUSRSSI_H
	movwf	FSR

shadowFillLoop
	call	i2c_read
	call	i2c_checkIdle
	
	nop
	
	call	i2c_acknowledge
	
	; Ensure PIC's i2c has completed all events
	call	i2c_checkIdle
	
	; Move the newly read byte to the register
	; INDF points to the correct register
	BANKSEL	SSPBUF
	movf	SSPBUF,W
	
	movwf	INDF

	; Check if its at the end of the radio registers
	movlw	R_RDSD_L
	xorwf	FSR,W	; XOR the end with 
	btfsc	STATUS,Z 	; Skips if its the same
	goto	wrapAround
	
	; Increments pointer in radio registers
	incf	FSR,f

wAD
	; Checks if its at the start of read
	BANKSEL	R_STATUSRSSI_H
	movlw	R_STATUSRSSI_H
	xorwf	FSR,W
	btfss	STATUS,Z
	goto	shadowFillLoop
	
	; Make another read and nack it
	call	i2c_read
	call	i2c_checkIdle
	
	nop
	
	call	i2c_nAcknowledge
	
	movf	SSPBUF,W
	
	; Stop reading + and hence shadow filling
	call 	i2c_stop
	; Delay to ensure i2c module doesn't get over used
	call	delay_mate
	return


; shadowFill Helper function	
wrapAround
	movlw	R_DEVICEID_H
	movwf	FSR
	goto 	wAD


;---------------------------------------------------------------------------

; Pushes all changes to the server ... oh wait this is not git
; Updates the radio with the new value(s) based on the values
; of the local registers
; To use this function. Make sure change the local copy and then 
; call this function to update the radio's registers. Make sure to 
; pull all changes first before editing your local copy and then 
; sending your changes
; Warning: Make sure to set up i2c before using this function
; Note: Automatically fills after pushing.
shadow_push
	call	i2c_start
	
	; Move device id from 
	BANKSEL	SSPBUF
	movlw	b'00100000' ; DeviceID + Write
	movwf	SSPBUF
	call	i2c_checkTransmit
	nop
	
	call	i2c_checkAcknowledge
	call	i2c_checkIdle
	
	; Change INDF pointer to PowerCFG(02h)
	movlw	R_POWERCFG_H
	movwf	FSR
	
shadowPushLoop
	movf	INDF,W
	
	; Move the data to SSPBUF
	BANKSEL	SSPBUF
	movwf	SSPBUF
	; The pic will now send data over i2C
	; Wait til transmission is done
	; Ensure i2c has completed all events
	
	call	i2c_checkTransmit
	
	; Check if radio has recieved
	call	i2c_checkAcknowledge
	
	call	i2c_checkIdle
	
	; Check if its just wrote to the last one
	movlw	R_RDSD_L
	xorwf	FSR,W
	btfsc	STATUS,Z
	goto	shadowPushLoopEnd ; If so, end the loop
	
	incf	FSR
	goto	shadowPushLoop
	
shadowPushLoopEnd
	call	i2c_stop
	
	;nop
	
	; Delay to ensure i2c module doesn't get over used
	call	delay_mate
	;call	delay_500ms
	;call	delay_500ms
	; Once reading, ensures shadow registers
	; are uptodate
	; shadow_fill will return to the function that called 
	; shadowPush (one less hardware stack (Y) )
	goto	shadow_fill
	
	return
;}

;--------------------------------------------------------------;
;    _ ___      ___ _   _ _  _  ___ _____ ___ ___  _  _ ___    ;
;   (_)_  )__  | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|   ;
;   | |/ // _| | _|| |_| | .` | (__  | |  | | (_) | .` \__ \   ;
;   |_/___\__| |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/   ;                                                      
;                                                              ;
;--------------------------------------------------------------; 
;{ 
; This funciton sets up the i2c. Needs to be done before any 
; communciation can occur through i2c.   
i2c_setup
	; I^2C configuration + enabling
	BANKSEL	SSPCON
	; Set WCOL <7> to 0 (no collision has occured)
	; Set SSPV <6> to 0 (no recieve overflow)
	; Set SSPEN <5> to 1 - enable I^2C
	; Set SSPM <3:0> to 1000 - I^2C master mode
	movlw	b'00101000'
	movwf	SSPCON
	
	; I^2C Bit rate setup
	BANKSEL	SSPADD
	; SSPADD = ((Fosc)/BitRate)/4 - 1
	; BitRate must be 100kHz, Fosc is 4Mhz (default)
	; Therefore SSPADD is 9
	movlw	d'9'
	movwf	SSPADD
	
	; I^2C STATUS setup
	BANKSEL	SSPSTAT
	; Set Slew rate to disabled <7> - 1 for standard speed mode
	; Set R/W <2> to 0 - no tramission in progress
	movlw	b'10000000'
	movwf	SSPSTAT
	
	; SCL / SDA setup
	; Set them to inputs
	BANKSEL	TRISC
	movlw	b'00011000'
	iorwf	TRISC,f
	
	BANKSEL	SSPBUF
	clrf	SSPBUF
	
	; ATTEMPTING TO START TO COMMUNICATE WITH RADIO
	; READING FROM RADIO
	
	call	i2c_checkIdle

	return

;---------------------------------------------------------------------------

i2c_start
;WARNING NEED TO STORE BANK THAT IT WAS AT, AND CHANGE BACK AFTER FINISHED
	BANKSEL	SSPCON2
	bsf	SSPCON2,SEN
	
	btfsc	SSPCON2,SEN
	goto	$-1
	
	return	
	
;---------------------------------------------------------------------------

i2c_read
	BANKSEL	SSPCON2
	bsf	SSPCON2,RCEN
	
	btfsc 	SSPCON2,RCEN
	goto	$-1
	
	return
	
;---------------------------------------------------------------------------

i2c_stop
;WARNING NEED TO STORE BANK THAT IT WAS AT, AND CHANGE BACK AFTER FINISHED
	BANKSEL	SSPCON2
	bsf	SSPCON2,PEN
	
	btfsc	SSPCON2,PEN
	goto	$-1
	
	return

;---------------------------------------------------------------------------

i2c_checkTransmit

	BANKSEL	SSPSTAT
	; Check if transmittion in progress
	btfsc	SSPSTAT,R_W
	goto	$-1
	
	return

;---------------------------------------------------------------------------

i2c_checkIdle
	BANKSEL	SSPSTAT
	; Check if transmittion in progress
	btfsc	SSPSTAT,R_W
	goto	$-1
	
	BANKSEL	SSPCON2
	; Extracting Bits to check
	; Bits <4:0> - From ACKEN to SEn
checkEN	movf	SSPCON2,W
	andlw	0x1F
	; Ensure w is zero
	btfss	STATUS,Z
	goto	checkEN
	
	return
	
;---------------------------------------------------------------------------

i2c_checkAcknowledge
	BANKSEL	SSPCON2
	; Check if ACKSTAT <5> is 0 - recieved from slave
	btfsc	SSPCON2,ACKSTAT
	goto	$-1
	return

;---------------------------------------------------------------------------

i2c_acknowledge
	BANKSEL	SSPCON2
	; send an acknowledge
	; clear ACKDT <4> to 0
	bcf	SSPCON2,ACKDT
	; start the ack
	bsf	SSPCON2,ACKEN
	return
	
;---------------------------------------------------------------------------
	
i2c_nAcknowledge
	BANKSEL	SSPCON2
	; send an acknowledge
	; set ACKDT <4> to 1
	bsf	SSPCON2,ACKDT
	; start the ack
	bsf	SSPCON2,ACKEN
	return
;}	

;------------------------------------------------------------------------;
;      _    ___ ___    ___ _   _ _  _  ___ _____ ___ ___  _  _ ___       ;
;     | |  / __|   \  | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|      ;    
;     | |_| (__| |) | | _|| |_| | .` | (__  | |  | | (_) | .` \__ \      ;
;     |____\___|___/  |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/      ;
;                                                                        ;
;------------------------------------------------------------------------;
;{
; **************************************
; ******* LCD Commands *****************
; Improvements
; * Initalisation uses a "LCD COMMAND" subroutine
; * subroutine to toggle enable, used in both pulse and bf
LCD_initialise
	BANKSEL	LCD_DATA_PORT
	call	delay_128ms
	
	;       0 0 RS RW D7 D6 D5 D4
	
	movlw	b'00000011'	; Initialisation sequence 1
	movwf	LCD_DATA_PORT
	call	LCD_pulseEnable
	call	delay_5ms
	
	movlw	b'00000011'	; Initialisation sequence 2
	movwf	LCD_DATA_PORT
	call	LCD_pulseEnable
	call	delay_5ms
	
	movlw	b'00000011'	; Initialisation sequence 3
	movwf	LCD_DATA_PORT
	call	LCD_pulseEnable
	call	delay_5ms
	
	movlw	b'00000010'	; 4-bit mode
	movwf	LCD_DATA_PORT
	call	LCD_pulseEnable
	call	delay_200us
	
	movlw	b'00101000'
	call	LCD_sendCommand

	movlw	b'00001000' 	; Display Setup, Display, Cursor and Blink on
	call	LCD_sendCommand

	movlw	b'00001100' 	; Display Setup, Display on, Cursor and Blink off
	call	LCD_sendCommand
	
	movlw	b'00000110'
	call	LCD_sendCommand
	
	call	LCD_clearDisplay

	; Initalises counters for new line
	BANKSEL	LCD_ADDRESS_COUNTER
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	clrf	LCD_LINE_COUNTER

	call	delay_5ms
	return

;---------------------------------------------------------------------------

LCD_clearDisplay
	movlw	b'00000001'
	call	LCD_sendCommand
	
	BANKSEL	LCD_ADDRESS_COUNTER
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	clrf	LCD_LINE_COUNTER
	
	return

;---------------------------------------------------------------------------
	
LCD_resetCursor
	movlw	b'00000010'
	call	LCD_sendCommand
	
	BANKSEL	LCD_ADDRESS_COUNTER
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	clrf	LCD_LINE_COUNTER
	
	return

;---------------------------------------------------------------------------

LCD_nextLine
	BANKSEL	LCD_LINE_COUNTER
	btfsc	LCD_LINE_COUNTER,0
	goto	leftLine
	goto	rightLine
	
leftLine
	movlw	b'10000000'
	call	LCD_sendCommand
	clrf	LCD_LINE_COUNTER
	goto 	lcd_nextLine_end
	
rightLine
	movlw	b'11000000'
	call	LCD_sendCommand
	incf	LCD_LINE_COUNTER
	
lcd_nextLine_end
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	
	return

;---------------------------------------------------------------------------

LCD_secondLine
	movlw	b'11000000'
	call	LCD_sendCommand
	
	BANKSEL	LCD_LINE_COUNTER
	bsf	LCD_LINE_COUNTER,1
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	
	return

;---------------------------------------------------------------------------

LCD_sendCommand
	BANKSEL	LCD_COMMAND
	movwf	LCD_COMMAND
	swapf	LCD_COMMAND,w	; First half of instruction
	andlw	b'00001111'	; Set RS and RW to zero
	movwf	LCD_DATA_PORT	; Move to data port
	call	LCD_pulseEnable
	call	LCD_checkBf

	movf	LCD_COMMAND,w
	andlw	b'00001111'
	movwf	LCD_DATA_PORT	; Move to data port
	call	LCD_pulseEnable
	call	LCD_checkBf

	return

;---------------------------------------------------------------------------

LCD_sendData
	BANKSEL	LCD_DATA
	movwf	LCD_DATA
	swapf	LCD_DATA,w
	movwf	LCD_DATA_PORT
	bsf	LCD_DATA_PORT,LCD_RS
	bcf	LCD_DATA_PORT,LCD_RW
	call	LCD_pulseEnable
	call	LCD_checkBf

	movf	LCD_DATA,w
	movwf	LCD_DATA_PORT
	bsf	LCD_DATA_PORT,LCD_RS
	bcf	LCD_DATA_PORT,LCD_RW
	call	LCD_pulseEnable
	call	LCD_checkBf

	bcf	LCD_DATA_PORT,LCD_RS
	bcf	LCD_DATA_PORT,LCD_RW
	
; Feature auto increments new line
	decfsz	LCD_ADDRESS_COUNTER,f
	return
	
	call	LCD_nextLine
	return

;---------------------------------------------------------------------------
; ASSUMING ONLY LCD functions use this
LCD_pulseEnable
	bsf	LCD_EN_PORT,LCD_EN
	nop
	nop
	nop
	bcf	LCD_EN_PORT,LCD_EN
	return

;---------------------------------------------------------------------------
	
LCD_checkBf
	BANKSEL	LCD_DATA_TRIS
	bsf	LCD_DATA_TRIS,LCD_D7
	
	BANKSEL	LCD_DATA_PORT
	bsf	LCD_DATA_PORT, LCD_RW
	bcf	LCD_DATA_PORT, LCD_RS
	
	bsf	LCD_EN_PORT, LCD_EN

; FEATURE - both a delay and a check, so if one fails other will override.
wait_bf
	movlw	D'200'
	movwf	counter_bf
	
wait_bf_loop
	btfss	LCD_DATA_PORT, LCD_BF
	goto 	wait_bf_end
	call	delay_200us
	decfsz	counter_bf
	goto	wait_bf_loop
	
wait_bf_end
	bcf	LCD_EN_PORT, LCD_EN
	
	BANKSEL	LCD_DATA_TRIS
	clrf	LCD_DATA_TRIS
	
	BANKSEL	LCD_DATA_PORT
	bcf	LCD_DATA_PORT, LCD_RW
	
	return
;}


;------------------------------------------------------------------------;
;    ___  ___ _      ___   __  ___  ___  _   _ _____ ___ _  _ ___ ___    ;
;   |   \| __| |    /_\ \ / / | _ \/ _ \| | | |_   _|_ _| \| | __/ __|   ;
;   | |) | _|| |__ / _ \ V /  |   / (_) | |_| | | |  | || .` | _|\__ \   ;
;   |___/|___|____/_/ \_\_|   |_|_\\___/ \___/  |_| |___|_|\_|___|___/   ;
;                                                                        ;
;------------------------------------------------------------------------;
;{
delay_500ms
	BANKSEL	d1
			;499994 cycles
	movlw	0x03
	movwf	d1
	movlw	0x18
	movwf	d2
	movlw	0x02
	movwf	d3
delay_500ms_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	delay_500ms_0

			;2 cycles
	goto	$+1

			;4 cycles (including call)
	return
	
;---------------------------------------------------------------------------
	
delay_60ms
	BANKSEL	d1
	;59993 cycles
	movlw	0xDE
	movwf	d1
	movlw	0x2F
	movwf	d2
delay_60ms_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	delay_60ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return


;---------------------------------------------------------------------------

delay_mate
			;59993 cycles
	movlw	0xF6
	movwf	d1
	movlw	0x2B
	movwf	d2
delay_mate_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	delay_mate_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return

;---------------------------------------------------------------------------

delay_128ms
	movlw	D'26'
	movwf	counter_128ms
	
loop_128ms
	call	delay_5ms
	decfsz	counter_128ms
	goto	loop_128ms
	
	return
	
;---------------------------------------------------------------------------

delay_keyPress
	movlw	D'20'
	movwf	counter_keyPress
	
loop_keyPress
	call	delay_5ms
	decfsz	counter_keyPress
	goto	loop_keyPress
	
	return

;---------------------------------------------------------------------------

delay_5ms
	movlw	D'100'
	movwf	counter_5ms
	
loop_5ms
	call	delay_200us
	decfsz	counter_5ms
	goto	loop_5ms
	
	return

;---------------------------------------------------------------------------
	
delay_200us
	movlw	D'66'
	movwf	counter_200us
	
loop_200us
	decfsz	counter_200us
	goto	loop_200us

	return
;}
	
	END	; directive 'end of program'

