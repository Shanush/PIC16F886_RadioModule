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


	; --- VARIABLE DEFINITIONS ---
	; CBLOCKS allow variables to be allocated to each GPR
	; starting at the given address (in this case 0x020)
	; Each variable in the cblock is given the next space
	; For example, COUNTER1 will be 0x020, COUNTER2 will be 0x021, R_DEVICEID_H will be 0x022 etc.
	; Saves the need for EQUing everything
	cblock	0x020
  		COUNTER1	; USED As A TEMP COUNTER
  		COUNTER2	; USED AS A SECOND TEMP COUNTER
		;INDEX
		;TEMP_BANK
		;REG1
		
		; RADIO SHADOW REGISTERS
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
		
		; RADIO PRESETS
		R_PRESET1
		R_PRESET2
		R_PRESET3
		R_PRESET4
		R_PRESET5
		R_PRESET6
		
		; VARIABLES USED FOR CALCULATING READCHAN AND PRINTING
		; THE CURRENT FREQUENCY BEING PLAYED
		READCHAN_COPY
		READCHAN_HUNDREDS
		READCHAN_TENS
		READCHAN_ONES
		READCHAN_TENTHS
		
		; USED AS PASSING IN ARGUMENTS TO FUNCTION: performPreset
		performPreset_CHANNEL
		performPreset_NUMBER
		
		; DELAY VARIABLES
		d1
		d2
		d3
		counter_128ms
		counter_5ms
		counter_200us
		counter_bf
		counter_keyPress
		
		; LCD VARIABLES
		LCD_COMMAND	; For temporary storing the original command
		LCD_DATA	; For temporary storing the original data
		LCD_ADDRESS_COUNTER ;For storing the current cell of the line, (counting down)
		LCD_LINE_COUNTER	; Storing current line, (0 for first line, 1 for second line)
		
		
		;w_temp	; variable used for context saving
		;status_temp	; variable used for context saving
		;pclath_temp	; variable used for context saving
	endc


; --- LCD PORTS AND PINS ---
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
LCD_backLight	EQU	0x06

; --- KEYPAD PORTS AND PINS
KEYPAD	EQU	PORTA
KEYPAD_TRIS	EQU	TRISA
KEYPAD_ANSEL	EQU	ANSEL
KEYPAD_COLCFG	EQU	b'11110000' ; Columns then rows

; --- RADIO PORTS AND PINS
RADIO	EQU	PORTC
SDIO	EQU	0x04
SCLK	EQU	0x03
RST	EQU	0x02
GPIO1	EQU	0x01
GPIO2	EQU	0x06

;{
; RADIO REGISTERS - Shared by James Slacksmith
;00H
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




; ---------------------------------------------------------------------------------------

	ORG	0x000	; processor reset vector

	nop
  	goto	initialise	; go to beginning of program

;----------------------------------------------------------------------------------------;
;    _____ _  _ ___   ___ _   _ _  _   ___ _____ _   ___ _____ ___   _  _ ___ ___ ___    ;
;   |_   _| || | __| | __| | | | \| | / __|_   _/_\ | _ \_   _/ __| | || | __| _ \ __|   ;
;     | | | __ | _|  | _|| |_| | .` | \__ \ | |/ _ \|   / | | \__ \ | __ | _||   / _|    ;
;     |_| |_||_|___| |_|  \___/|_|\_| |___/ |_/_/ \_\_|_\ |_| |___/ |_||_|___|_|_\___|   ;
;                                                                                        ;
;----------------------------------------------------------------------------------------;                                                                                   
initialise
	; ---- INITIAL PORT SETUP ----
		
	; Set ANSELs
	BANKSEL	ANSELH
	clrf	ANSELH	;Set all ports to digital
	clrf	ANSEL
	
	; Set TRISC
	BANKSEL	TRISB
	clrf	TRISB	; Set all ports to (initally) outputs
	clrf 	TRISC
	
	movlw	KEYPAD_COLCFG 	; Set the columns inputs and rows as outputs
	movwf	TRISA
	
	; Set Ports
	BANKSEL	PORTB	
	clrf	PORTB	; Set all output pins to zero
	clrf	PORTC
	
	; Set Keypad's port to all 1.
	; Each row is cleared, and column is checked
	; to see which key it is
	movlw	b'11111111'
	movwf	PORTA
	
	
	; ---- LOADING DEFAULT PRESETS ----
	movlw	D'27'	;  92.9 MHz
	movwf	R_PRESET1
	
	movlw	D'39'	;  95.3 MHz
	movwf	R_PRESET2
	
	movlw	D'47'	;  96.9 MHz
	movwf	R_PRESET3
	
	movlw	D'71'	; 101.7 MHz
	movwf	R_PRESET4
	
	movlw	D'83'	; 104.1 MHz
	movwf	R_PRESET5
	
	movlw	D'91'	; 105.7 MHz
	movwf	R_PRESET6
	
;---------------------------------------------------------------------------
	
startUp	
	; ---- INITIALISE RADIO, I2C COMMUNICATION AND LCD ----
	call	radio_init	

	; Tuned to 96.9 Nova FM	
	movlw	D'47'
	call	radio_tune_noPrint
	
	
	; --- // EXTRA FEATURE \\ ---
	; The following displays my name "SHANUSH" in specially generated 
	; characters and after a pause displays "Radio!!!". 
	; It increases volume while displaying the strings
	; described above.
	
	call	LCD_clearDisplay
	
	
	call	printShanush
	
	movlw	D'8'	; Increase volume from zero till the limit of VOLEXT
	call	increaseVolume
	
	call	delay_LCD	; Enough delay so that a person can see the message
	
	
	call	printRadio	
	
	movlw	D'7'
	call	increaseVolume
	
	call	delay_LCD
	
	
	call	printCurrentChannel	; Print the current channel being played
	
	call	registerHeartCharacter	; Register the heart symbol, override the S letter since it will never be used again
	
;---------------------------------------------------------------------------

main
	; For each row cleared, check if any column has been pressed
	; I.e bit clear a row, and check if any column pins have been cleared (active low)
	BANKSEL	KEYPAD
keyPad
	; First Row
	bsf	KEYPAD,0	; Set the previous row scanned
	bcf	KEYPAD,3	; Clear the row to be scanned
	btfss	KEYPAD,7
	call	preset1	; Key1
	btfss	KEYPAD,6
	call	preset2	; Key2
	btfss	KEYPAD,5
	call	preset3	; Key3
	btfss	KEYPAD,4
	goto	powerDown	; KeyF
	
	; Second Row
	bsf	KEYPAD,3
	bcf	KEYPAD,2
	btfss	KEYPAD,7
	call	preset4	; Key4
	btfss	KEYPAD,6
	call	preset5	; Key5
	btfss	KEYPAD,5	
	call	preset6	; Key6
	btfss	KEYPAD,4
	call	seekUp	; KeyE
	
	; Third Row
	bsf	KEYPAD,2
	bcf	KEYPAD,1
	btfss	KEYPAD,7
	call	volumeMute	; Key7
	btfss	KEYPAD,6
	call	volumeDown	; Key8
	btfss	KEYPAD,5
	call	volumeUp	; Key9
	btfss	KEYPAD,4
	call	seekDown	; KeyD
	
	; Fourth Row
	bsf	KEYPAD,1
	bcf	KEYPAD,0
	btfss	KEYPAD,7
	call	extraKey	; KeyA
	btfss	KEYPAD,6
	call	setPreset	; Key0
	btfss	KEYPAD,5
	call	extraKey	; KeyB
	btfss	KEYPAD,4
	call	extraKey	; KeyC
	
	goto 	keyPad

;---------------------------------------------------------------------------

; Special function - must be called as a go to since it will turn off radio, i2c etc
; and must start from the beginning
powerDown	
	call	printPoweringDown

	call	delay_500ms

	; Turning off Radio
	BANKSEL	R_POWERCFG_L
	bsf	R_POWERCFG_L, ENABLE
	bsf	R_POWERCFG_L, DISABLE
	
	call	shadow_push
	
	; Turn of i2c
	BANKSEL	SSPCON
	bcf	SSPCON, SSPEN
	
	call	printBye
	
	call	delay_500ms
	call	delay_500ms
	
	; Turn of LCD
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay
	movlw	b'00001000'
	call	LCD_sendCommand
	
	BANKSEL	LCD_EN_PORT
	bcf	LCD_EN_PORT, LCD_backLight
	
	BANKSEL	RADIO
	bcf	RADIO, RST

wait_for_power_on	
	BANKSEL	PORTA
	movlw	b'11110111'
	movwf	PORTA
	
	movlw	b'11100111'
	xorwf	PORTA,W
	btfss	STATUS,Z
	goto	wait_for_power_on
	
	; Bascially restart pic, since i2c and radio was turned off
	goto	startUp
	
	return   
	
; The program ends here. The rest are functions



;--------------------------------------------------------------------------;
;      _  __         ___         _   ___             _   _                 ;
;     | |/ /___ _  _| _ \__ _ __| | | __|  _ _ _  __| |_(_)___ _ _  ___    ;
;     | ' </ -_) || |  _/ _` / _` | | _| || | ' \/ _|  _| / _ \ ' \(_-<    ;
;     |_|\_\___|\_, |_| \__,_\__,_| |_| \_,_|_||_\__|\__|_\___/_||_/__/    ;
;               |__/                                                       ;
;--------------------------------------------------------------------------;
;{
preset1	;{
	BANKSEL	performPreset_CHANNEL
	movf	R_PRESET1,W		; Move the channel required to performPreset's variable
	movwf	performPreset_CHANNEL
	
	movlw	'1'		; Move the preset number to perforPreset's variable
	movwf	performPreset_NUMBER
	
	goto	performPreset		; Call the function to start the tuning
				; A goto is used instead of a call, to reduce stack level
				; performPreset returns to caller of preset1
;}
;---------------------------------------------------------------------------

preset2	;{
	BANKSEL	performPreset_CHANNEL	; Same logic as preset1
	movf	R_PRESET2,W
	movwf	performPreset_CHANNEL
	
	movlw	'2'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset	
;}
	
;---------------------------------------------------------------------------

preset3	;{
	BANKSEL	performPreset_CHANNEL	; Same logic as preset1
	movf	R_PRESET3,W
	movwf	performPreset_CHANNEL
	
	movlw	'3'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
;}
	
;---------------------------------------------------------------------------	

preset4	;{
	BANKSEL	performPreset_CHANNEL	; Same logic as preset1
	movf	R_PRESET4,W
	movwf	performPreset_CHANNEL
	
	movlw	'4'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
;}

;---------------------------------------------------------------------------
	
preset5	;{ 
	BANKSEL	performPreset_CHANNEL	; Same logic as preset1
	movf	R_PRESET5,W
	movwf	performPreset_CHANNEL
	
	movlw	'5'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
;}
	
;---------------------------------------------------------------------------
	
preset6	;{ 
	BANKSEL	performPreset_CHANNEL	; Same logic as preset1
	
	movf	R_PRESET6,W
	movwf	performPreset_CHANNEL
	
	movlw	'6'
	movwf	performPreset_NUMBER
	
	; preformPreset will return back to keypad
	goto	performPreset
;}
	
;---------------------------------------------------------------------------

seekUp	;{
	; This function seeks up and wraps around
	call	LCD_clearDisplay
	call	printSeek
	
	BANKSEL	LCD_DATA
	movlw	' '		; Print a space after seek
	call	LCD_sendData
	
	; --- // EXTRA FEATURE \\ ---
	movlw	0x5		; Print the up arrow (custom character)
	call	LCD_sendData		; Allows for less works required
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SKMODE	; clear SKMODE to wrap around
	bsf	R_POWERCFG_H, SEEKUP	; Set to Seek up

seekUp_seek	
	call	radio_seek		; Start the seeking
	
	call	delay_keyPress		; Wait before checking if its being pressed again
				; Otherwise it will continually seek with no breaks
				; The user needs to be given enough time to recognise 
				; that a seek was over
	BANKSEL	PORTA
	movlw	b'11111011'		; Check if the same button was pressed again
	movwf	PORTA
	
	movlw	b'11101011'		
	xorwf	PORTA,W		; XOR the pattern for this key press with the keyPad Port
	btfsc	STATUS,Z		; Check if they are the same
	goto	seekUp_seek		; If the same, then seek again
	
	call	delay_LCD		
	
	goto	printCurrentChannel	; Print Current (possibly new) channel
				; It returns to the caller of seekUp (saves a stack level)
;}
	
;---------------------------------------------------------------------------
	
seekDown	;{
	call	LCD_clearDisplay
	call	printSeek		; Similar logic to Seekup
	
	BANKSEL	LCD_DATA
	movlw	' '
	call	LCD_sendData
	movlw	0x6		; Down arrow (custom character)
	call	LCD_sendData
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SKMODE	 
	bcf	R_POWERCFG_H, SEEKUP	; Clear to seek down

seekDown_seek	
	call	radio_seek
	
	call	delay_keyPress
	
	BANKSEL	PORTA
	movlw	b'11111101'
	movwf	PORTA
	
	movlw	b'11101101'
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	seekDown_seek
	
	call	delay_LCD
	
	call	printCurrentChannel
	
	return	 ;}	

;---------------------------------------------------------------------------
	
volumeMute	;{
	; An if-else statement with the DMUTE bit in POWERCFG register
	BANKSEL	R_POWERCFG_H
	btfsc	R_POWERCFG_H, DMUTE	
	goto	mute		; If unmute, mute and push
	
	bsf	R_POWERCFG_H, DMUTE	; else set for unmute and push
	goto	volumeMute_Part1		
	
mute
	bcf	R_POWERCFG_H, DMUTE	; Clear for mute

volumeMute_Part1	
	call	shadow_push		; Send changes to radio
	
	BANKSEL	LCD_DATA		; Change Bank 0 to "LCD/Printing bank"
	call	LCD_clearDisplay
	
	; If it is unmuted, print "un" and then the "mute"
	; This method saves program memory
	btfss	R_POWERCFG_H, DMUTE	
	goto	volumeMute_Part2
	movlw	'U'
	call	LCD_sendData
	movlw	'N'
	call	LCD_sendData
	
	; Print mute (which could be by itself or printed after "un" to make "unmute"
volumeMute_Part2	
	call	printMute
	
	call	delay_LCD
	
	btfss	R_POWERCFG_H, DMUTE
	goto	volumeMute_finish	
	
	; If unmuted, print volume, and delays
	call	printVolume	
	call	delay_LCD

volumeMute_finish		
	call	printCurrentChannel
	return ;}

;---------------------------------------------------------------------------

; FOR BOTH VOLUME UP AND VOLUME DOWN
; Volume works by having a range between 0000 and 1111 (i.e from 0-15)
; But it also has a volume extender (VOLEXT). Which means it has a possibility from (0-31)
; Hence, if VOLEXT is 0, and Volume is 1110, then volume output is -32dBFS
;    and if VOLEXT is 1, and Volume is 1110, then volume output is -2dBFS
; However for both VOLEXT 0 or 1, Volume 0000 is mute - hence there is actually a range from (0-30)

	
volumeUp	;{
	BANKSEL	R_POWERCFG_H
	bsf	R_POWERCFG_H, DMUTE
	
	BANKSEL	R_SYSCONFIG2_L
	movlw	0x0F
	xorwf	R_SYSCONFIG2_L,W	
	btfsc	STATUS,Z		; If volume is at possible max, goto this case
	goto	volumeUp_volLimit_case
	
	BANKSEL	R_SYSCONFIG2_L	
	incf	R_SYSCONFIG2_L,F		; Increase volume
		
	goto	volumeUp_end

	
volumeUp_volLimit_case
	BANKSEL	R_SYSCONFIG3_H
	btfss	R_SYSCONFIG3_H, VOLEXT	
	goto	volumeUp_end		; If VOLEXT is cleared, that means volume is at its limit
	
	movlw	D'1'		; Only works because BAND and SPACE is 0
	movwf	R_SYSCONFIG2_L		; Reason BAND and SPACE wasn't extracted was because any change wouldn't 
				; have worked in Sydney. To keep changes, AND R_SYSCONFIG2 with 11110000
				; where BAND is <7:6> and SPACE is <5:4>.
				; Then set the last bit to 1
	
	bcf	R_SYSCONFIG3_H, VOLEXT	; Clear VOLEXT to "not extend" volume.

volumeUp_end
	call	shadow_push
	call	printVolume
	
	call	delay_keyPress
	
	; For about 65025 times, wait for either volume up or down to be pressed again

	BANKSEL	COUNTER2
	movlw	D'255'
	movlw	COUNTER2
	
volumeUp_checkButtons_outerLoop
	BANKSEL	COUNTER1
	movlw	D'255'
	movwf	COUNTER1

volumeUp_checkButtons	
	BANKSEL	PORTA
	movlw	b'11111101'	
	movwf	PORTA
	
	movlw	b'11011101'	; Volume up pattern
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	volumeUp	
		
	movlw	b'10111101'	; Volume down pattern
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	volumeDown
	
	decfsz	COUNTER1,F
	goto	volumeUp_checkButtons
	
	decfsz	COUNTER2,F
	goto	volumeUp_checkButtons_outerLoop
	
	; Delay to allow the volume level to be seen
	call	delay_128ms	; Shorter delay because a bit of the time was used to wait a key
	
	call	printCurrentChannel
	
	return	;}

;---------------------------------------------------------------------------
	
volumeDown	;{
	BANKSEL	R_POWERCFG_H
	bsf	R_POWERCFG_H, DMUTE
	
	BANKSEL	R_SYSCONFIG2_L
	movlw	0x01		; Case 1:	
	xorwf	R_SYSCONFIG2_L,W		; When Volume is 0001
	btfsc	STATUS,Z		; and it might be either middle of the range
	goto	volumeDown_volLimit_case1	; or the end of the range of volumes
	
	movlw	0x00
	xorwf	R_SYSCONFIG2_L,W		; Case 2:
	btfsc	STATUS,Z		; Because 0000 could be both in the middle and mute
	goto	volumeDown_volLimit_case2	; We need to check this case as well
	
	goto	volumeDown_decrementAndFinish	; Else do normal decrementing
	
volumeDown_volLimit_case1
	
	btfsc	R_SYSCONFIG3_H, VOLEXT	; If VOLEXT is set, this means that its near the end (next has to be mute)
	goto	volumeDown_decrementAndFinish	; So decrement as usual and push changes
	
	movlw	0x0F		; Otherwise, the next volume is 1111, and VOLEXT is set for this
	movwf	R_SYSCONFIG2_L		; Next volume is 1111 and not 0000 because 0000 is mute for any VOLEXT
	
	bsf	R_SYSCONFIG3_H, VOLEXT
	
	goto	volumeDown_finish
	
	
volumeDown_volLimit_case2
	btfsc	R_SYSCONFIG3_H, VOLEXT
	goto	volumeDown_finish
	
	
volumeDown_decrementAndFinish
	BANKSEL	R_SYSCONFIG2_L
	decf	R_SYSCONFIG2_L,F		; Decrement volume

volumeDown_finish
	call	shadow_push
	call	printVolume
	
	call	delay_keyPress
	
	; For about 65025 times, wait for either volume up or down to be pressed again
	BANKSEL	COUNTER2
	movlw	D'255'
	movlw	COUNTER2
	
volumeDn_chkButns_outLoop
	BANKSEL	COUNTER1
	movlw	D'255'
	movwf	COUNTER1

volumeDown_checkButtons	
	; check if pressed agan
	BANKSEL	PORTA
	movlw	b'11111101'
	movwf	PORTA
	
	movlw	b'11011101'
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	volumeUp
	
	movlw	b'10111101'
	xorwf	PORTA,W
	btfsc	STATUS,Z
	goto	volumeDown
	
	decfsz	COUNTER1,F
	goto	volumeDown_checkButtons
	
	decfsz	COUNTER2,F
	goto	volumeDn_chkButns_outLoop
	
	; Delay to allow the volume level to be seen
	call	delay_128ms	; Shorter delay because a bit of the time was used to wait a key
	
	call	printCurrentChannel
	
	return	;}

;---------------------------------------------------------------------------
	
setPreset 	;{
	
	call	printSetPreset	; Ask user which preset they want to change
	
	call	delay_keyPress
	
	
	; Scan for any button pressed
	; If a button is a number between 1 and 6 (inclusive) save at that preset
	; otherwise cancel the save operation
	BANKSEL	KEYPAD
setPreset_Key
	bsf	KEYPAD,0
	bcf	KEYPAD,3
	btfss	KEYPAD,7
	goto	setPreset_1	;Key1
	btfss	KEYPAD,6
	goto	setPreset_2	;Key2
	btfss	KEYPAD,5
	goto	setPreset_3	;Key3
	btfss	KEYPAD,4
	goto	setPreset_Cancel	;KeyF
	
	bsf	KEYPAD,3
	bcf	KEYPAD,2
	btfss	KEYPAD,7
	goto	setPreset_4	;Key4
	btfss	KEYPAD,6
	goto	setPreset_5	;Key5
	btfss	KEYPAD,5	
	goto	setPreset_6	;Key6
	btfss	KEYPAD,4
	goto	setPreset_Cancel	;KeyE
	
	bsf	KEYPAD,2
	bcf	KEYPAD,1
	btfss	KEYPAD,7
	goto	setPreset_Cancel	;Key7
	btfss	KEYPAD,6
	goto	setPreset_Cancel	;Key8
	btfss	KEYPAD,5
	goto	setPreset_Cancel	;Key9
	btfss	KEYPAD,4
	goto	setPreset_Cancel	;KeyD
	
	bsf	KEYPAD,1
	bcf	KEYPAD,0
	btfss	KEYPAD,7
	goto	setPreset_Cancel	;KeyA
	btfss	KEYPAD,6
	goto	setPreset_Cancel	;KeyB
	btfss	KEYPAD,5
	goto	setPreset_Cancel	;Key0
	btfss	KEYPAD,4
	goto	setPreset_Cancel	;KeyC
	
	goto 	setPreset_Key
	
	
setPreset_1
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET1	; Take currently playing radio station and store it in the given preset
	
	goto	preset1	; Load preset (gives the effect of showing "PRESET1 [CHANNEL]")
			; GOTO instead of call to save stack space. Hence preset1 will return to the caller
			; of setPreset, and therefore this return doesn't actually occur.
	
setPreset_2
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET2
	
	goto	preset2
	
setPreset_3
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET3
	
	goto	preset3
	
setPreset_4
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET4
	
	goto	preset4
	
setPreset_5
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET5
	
	goto	preset5
	
setPreset_6
	BANKSEL	R_READCHAN_L
	movf	R_READCHAN_L,W
	movwf	R_PRESET6
	
	goto	preset6
	
setPreset_Cancel
	call	printPresetCancelled	; Tell the user that preset has been cancelled
	
	call	delay_LCD	
	
	goto	printCurrentChannel	; Show currently playing channel
	return ;}

;---------------------------------------------------------------------------
		
extraKey	;{
	; For any key that doesn't have a use
	; Show a "manual"
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay
	
	; "1-6 for Presets"
	movlw	'1'
	call	LCD_sendData
	
	movlw	'-'
	call	LCD_sendData
	
	movlw	'6'
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	call	printFor
	
	movlw	' '
	call	LCD_sendData
	
	call	printPreset
	
	movlw	'S'
	call	LCD_sendData
	
	
	call	delay_LCD
	call	LCD_clearDisplay
	
	
	; "Arrows for Seek"
	movlw	'A'
	call	LCD_sendData
	
	movlw	'r'
	call	LCD_sendData
	
	movlw	'r'
	call	LCD_sendData
	
	movlw	'o'
	call	LCD_sendData
	
	movlw	'w'
	call	LCD_sendData
	
	movlw	's'
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	call	printFor
	
	movlw	' '
	call	LCD_sendData
	
	call	printSeek
	
	
	call	delay_LCD
	call	LCD_clearDisplay
	
	
	; "[HEART] to save new"
	; Delay
	; "CHANNEL"
	movlw	0x00
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	call	printFor
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'S'
	call	LCD_sendData
	
	movlw	'a'
	call	LCD_sendData
	
	movlw	'v'
	call	LCD_sendData
	
	movlw	'i'
	call	LCD_sendData
	
	movlw	'n'
	call	LCD_sendData
	
	movlw	'g'
	call	LCD_sendData
	
	call	delay_LCD
	call	LCD_clearDisplay
	
	call	printChannel
	
	call	delay_LCD
	call	LCD_clearDisplay
	
	; "Enjoy"
	call	printEnjoy
	
	call	delay_LCD
	goto	printCurrentChannel	; printCurrentChannel will return 
;}

;}

;-----------------------------------------------------------------------;
;      _  _     _                 ___             _   _                 ;
;     | || |___| |_ __  ___ _ _  | __|  _ _ _  __| |_(_)___ _ _  ___    ;
;     | __ / -_) | '_ \/ -_) '_| | _| || | ' \/ _|  _| / _ \ ' \(_-<    ;
;     |_||_\___|_| .__/\___|_|   |_| \_,_|_||_\__|\__|_\___/_||_/__/    ;
;                |_|                                                    ;
;-----------------------------------------------------------------------;
;{
; Set PerformPreset_NUMBER for Preset number to be printed
; Set PerformPreset_CHANNEL for channel to be tuned to
; Before calling this function
performPreset ;{
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay
	
	; Print "PRESET" and then the number, to make "PRESET#"
	call	printPreset	

	movf	performPreset_NUMBER,W	
	call	LCD_sendData
	
	; Tune uses the number from W reg as the channel
	movf	performPreset_CHANNEL,W	; So move required channel to W
	call	radio_tune		; And tune

	call	delay_LCD		
	
	goto	printCurrentChannel
;}

;---------------------------------------------------------------------------
	
printCurrentChannel ;{
	; Prints either "CHANNEL [channel]" or "Mute [Channel]" depending on mute setting
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay
	
	btfsc	R_POWERCFG_H, DMUTE	
	call	printChannel		; If unmuted, print CHANNEL

	btfss	R_POWERCFG_H, DMUTE
	call	printMute		; If muted, print Mute (instead of channel)
	
	call	printREADCHAN		; Print channel
	return 
;}
	
;---------------------------------------------------------------------------
	
printREADCHAN ;{

	;calculate READCHAN into printing
	movlw	'0'		; Set to lowest possible frequency
	movwf	READCHAN_HUNDREDS		; i.e 087.5
	
	movlw	'8'
	movwf	READCHAN_TENS
	
	movlw	'7'
	movwf	READCHAN_ONES
	
	movlw	'5'
	movwf	READCHAN_TENTHS
	
	movf	R_READCHAN_L,W		
	movwf	READCHAN_COPY		; Make a copy of the current READCHAN
	
calREADCHANLoop:
	movf	READCHAN_COPY,W
	btfsc	STATUS,Z
	goto	printREADCHANPrinting	; If READCHAN_COPY is zero, variables are ready to print
	
	; TENTHS
	decf	READCHAN_COPY,F		; While (READCHAN > 0)
	incf	READCHAN_TENTHS,F		; Increase TENTHS by 2
	incf	READCHAN_TENTHS,F		
	
	movlw	D'59'		; Its ASCII '9' + 2
	xorwf	READCHAN_TENTHS,W
	btfss	STATUS,Z		; If not overflowed (i.e TENTH is not 9 + 2 = 11)
	goto	calREADCHANLoop		; Continue to decrement by 2
	
	; ONES			; If tenths overflowed
	movlw	'1'		; Make tenths to '1'
	movwf	READCHAN_TENTHS
	incf	READCHAN_ONES,F		; Increase ones
	
	movlw	D'58'		
	xorwf	READCHAN_ONES,W
	btfss	STATUS,Z		; Ensure ones hasn't overflowed
	goto	calREADCHANLoop		; if not overflowed, back to decrementing tenth by 2
	
	; TENTHS
	movlw	'0'		
	movwf	READCHAN_ONES		; Make the ones to '0'
	incf	READCHAN_TENS,F		; Increments tenths
	
	movlw	D'58'
	xorwf	READCHAN_TENS,W
	btfss	STATUS,Z
	goto	calREADCHANLoop		; if not overflowed, back to decrementing tenth by 2
	
	; HUNDREDS
	movlw	'0'		
	movwf	READCHAN_TENS
	incf	READCHAN_HUNDREDS,F	; We don't check if Hundreds will overflow, because it will
				; never overflow (no Channels over (255 * 0.2) + 87.5 = 138.5MHz)
	goto	calREADCHANLoop		; Where its 255 since that the maximum number for 8 bits
				

printREADCHANPrinting	
	movlw	'0'		; If its 0, print a space instead of 0
	xorwf	READCHAN_HUNDREDS,W
	btfsc	STATUS,Z
	goto	printREADCHANspace
	
	movlw	'1'		; Else print 1, printing READCHAN_HUNDREDS would be exactly equivalent
	call	LCD_sendData
	goto 	printREADCHANspaceEnd
	
printREADCHANspace
	movlw	' '		
	call	LCD_sendData
	
printREADCHANspaceEnd
	movf	READCHAN_TENS,W		; Print the tens
	call	LCD_sendData
	
	movf	READCHAN_ONES,W		; Print the ones
	call	LCD_sendData
	
	movlw	'.'		; Print decimal point
	call	LCD_sendData
	
	movf	READCHAN_TENTHS,W		; Print Tenths
	call	LCD_sendData
	
	movlw	'M'		; Print "MHz"
	call	LCD_sendData
	
	movlw	'H'
	call	LCD_sendData
	
	movlw	'z'
	call	LCD_sendData
	
	
	return ;}

;---------------------------------------------------------------------------
	
printVolume ;{
	; ---- // EXTRA FEATURE \\ ----
	; The ability to print 30 blocks to show full volume range
	; By printing a special character (half block)
	call	LCD_clearDisplay
	
	movlw	'V'		; Print V for volume
	call	LCD_sendData
	
	movf	R_SYSCONFIG2_L,W		; Store a copy of volume
	movwf	COUNTER1		; This works because BAND and SPACE is 00
	
	incf	COUNTER1,F		; Increment counter since for Volume 5, loop needs to happen 6 times
	
	movlw	b'00001111'		
	btfss	R_SYSCONFIG3_H, VOLEXT
	addwf	COUNTER1,F		; If in LOUD mode, need to add 15 extra volume blocks
	
	; Return if zero (i.e don't print anything)
	movf	COUNTER1,W
	btfsc	STATUS,Z
	return
	
printVolume_loop
	decfsz	COUNTER1,F		; For each decrementing of volume
	call	printHalf		; Print half block
	
	; Check if its now zero, if so, return
	movf	COUNTER1,W		; Stop printing if volume is now zero
	btfsc	STATUS,Z
	return
	
	decfsz	COUNTER1,F		; Then print full block
	call	printFull
	
	movf	COUNTER1,W
	btfss	STATUS,Z		
	goto	printVolume_loop		; Coutinue if still need to print
	
	
	return ;}

;---------------------------------------------------------------------------
		
printHalf	;{
	; ---- // EXTRA FEATURE \\ ----
	; Custom character, half a block
	; To allow for "30" characters to be printed
	movlw	0x0F
	call	LCD_sendData
	return ;}

;---------------------------------------------------------------------------
		
printFull	;{
	; Shift DDRAM because full will always replace a half
	call	LCD_shiftCursorLeft
	movlw	0xFF
	call	LCD_sendData
	return ;}

;---------------------------------------------------------------------------
				
registerHeartCharacter	;{
	movlw	0x40		; Store in first location of CGRAM
	call	LCD_sendCommand
	
	; Heart symbol 	;{
	movlw	0x00
	call	LCD_sendData
	
	movlw	0xA
	call	LCD_sendData
	
	movlw	0x1B
	call	LCD_sendData
	
	movlw	0x1F
	call	LCD_sendData
	
	movlw	0x1F
	call	LCD_sendData
	
	movlw	0xE
	call	LCD_sendData
	
	movlw	0x04
	call	LCD_sendData
	
	movlw	0x00
	call	LCD_sendData
	
	call	delay_mate ;}
	
	; Reset to DDRAM
	movlw	b'10000000'
	call	LCD_sendCommand

	call	delay_5ms
	
	goto	printCurrentChannel
	
	return	;}

;---------------------------------------------------------------------------
		
increaseVolume	;{
	BANKSEL	COUNTER1	
	movwf	COUNTER1
increaseVolume_loop	
	BANKSEL	R_SYSCONFIG2_L
	incf	R_SYSCONFIG2_L,F		; Increment Volume. This works because BAND and SPACE are 0
	call	shadow_push		; Send these changes to the radio registers
	
	BANKSEL	COUNTER1		; BANKSEL to ensure we are back at BANK 0	
	call	delay_60ms		; Wait a bit to ensure change in sound is audible, but short enough for it to smooth	
	decfsz	COUNTER1,F
	goto	increaseVolume_loop	; Continue to increase volume to COUNTER1 times

	return	;}
;}

;---------------------------------------------------------------------------

; PRINTING FUNCTIONS>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;{
printShanush ;{
	; ---- // EXTRA FEATURE \\ ---- 
	; Use of custom characters
	; "[][][][]SHANUSH[][][][][]" INVERTED COLORS
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay

	movlw	0xFF
	call	LCD_sendData
	
	movlw	0xFF
	call	LCD_sendData

	movlw	0xFF
	call	LCD_sendData
		
	movlw	0xFF
	call	LCD_sendData

	movlw	0x0
	call	LCD_sendData

	movlw	0x1
	call	LCD_sendData

	movlw	0x2
	call	LCD_sendData

	movlw	0x3
	call	LCD_sendData

	movlw	0x4
	call	LCD_sendData
	
	movlw	0x0
	call	LCD_sendData
	
	movlw	0x1
	call	LCD_sendData
	
	movlw	0xFF
	call	LCD_sendData
	
	movlw	0xFF
	call	LCD_sendData

	movlw	0xFF
	call	LCD_sendData
		
	movlw	0xFF
	call	LCD_sendData
	
	movlw	0xFF
	call	LCD_sendData
	
	;call	LCD_resetCursor
	return	;}

;---------------------------------------------------------------------------
	
printRadio	;{
	; "     RADIO!" (including spaces)  
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
	
	
	return	;}

;---------------------------------------------------------------------------
	
printSeek ;{
	; "SEEK"
	BANKSEL	LCD_DATA
	movlw	'S'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'K'
	call	LCD_sendData
	
	return	;}

;---------------------------------------------------------------------------

printMute ;{
	; "MUTE    " (including spaces)
	BANKSEL	LCD_DATA
	movlw	'M'
	call	LCD_sendData
	movlw	'U'
	call	LCD_sendData
	movlw	'T'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	return	;}
	
;---------------------------------------------------------------------------
	
printEnjoy ;{
	; "Enjoy :)"
	BANKSEL	LCD_DATA
	movlw	'E'
	call	LCD_sendData
	movlw	'n'
	call	LCD_sendData
	movlw	'j'
	call	LCD_sendData
	movlw	'o'
	call	LCD_sendData
	movlw	'y'
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	movlw	':'
	call	LCD_sendData
	movlw	')'
	call	LCD_sendData
	return	;}

;---------------------------------------------------------------------------
	
printPreset	;{
	; "PRESET"
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
	return ;}

;---------------------------------------------------------------------------
	
printChannel	;{
	; "CHANNEL " (including spaces)
	BANKSEL	LCD_COMMAND
	call	LCD_clearDisplay
	movlw	'C'
	call	LCD_sendData
	movlw	'H'
	call	LCD_sendData
	movlw	'A'
	call	LCD_sendData
	movlw	'N'
	call	LCD_sendData
	movlw	'N'
	call	LCD_sendData
	movlw	'E'
	call	LCD_sendData
	movlw	'L'
	call	LCD_sendData
	movlw	' '
	call	LCD_sendData
	
	return 	;}

;---------------------------------------------------------------------------

printSetPreset	;{
	; ---- // EXTRA FEATURE  ---- 
	; Use of custom characters
	; "[Heart] Preset (1-6)?"
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay

	movlw	0x00
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'P'
	call	LCD_sendData
	
	movlw	'r'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	movlw	's'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	movlw	't'
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'('
	call	LCD_sendData
	
	movlw	'1'
	call	LCD_sendData
	
	movlw	'-'
	call	LCD_sendData
	
	movlw	'6'
	call	LCD_sendData
	
	movlw	')'
	call	LCD_sendData
	
	movlw	'?'
	call	LCD_sendData
	return	;}

;---------------------------------------------------------------------------
		
printPresetCancelled 	;{
	; ---- // EXTRA FEATURE \\ ---- 
	; Use of custom characters
	; "[Heart] Cancelled"
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay

	movlw	0x00
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'C'
	call	LCD_sendData
	
	movlw	'a'
	call	LCD_sendData
	
	movlw	'n'
	call	LCD_sendData
	
	movlw	'c'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	movlw	'l'
	call	LCD_sendData
	
	movlw	'l'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	movlw	'd'
	call	LCD_sendData
	
	return 	;}

;---------------------------------------------------------------------------

printFor	;{
	; "for"
	movlw	'f'
	call	LCD_sendData
	
	movlw	'o'
	call	LCD_sendData
	
	movlw	'r'
	call	LCD_sendData
	
	return	;}

;---------------------------------------------------------------------------

printPoweringDown 	;{
	; " Powering  Down"
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'P'
	call	LCD_sendData
	
	movlw	'o'
	call	LCD_sendData
	
	movlw	'w'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	movlw	'r'
	call	LCD_sendData
	
	movlw	'i'
	call	LCD_sendData
	
	movlw	'n'
	call	LCD_sendData
	
	movlw	'g'
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'D'
	call	LCD_sendData
	
	movlw	'o'
	call	LCD_sendData
	
	movlw	'w'
	call	LCD_sendData
	
	movlw	'n'
	call	LCD_sendData
	
	return 	;}

;---------------------------------------------------------------------------
		
printBye	;{
	; "      Bye" (include space)
	BANKSEL	LCD_DATA
	call	LCD_clearDisplay

	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	' '
	call	LCD_sendData
	
	movlw	'B'
	call	LCD_sendData
	
	movlw	'y'
	call	LCD_sendData
	
	movlw	'e'
	call	LCD_sendData
	
	return 	;}

;---------------------------------------------------------------------------
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
	clrf	TRISC
	
	BANKSEL	RADIO	; i.e PORTC
	
	; Configure Two-bus mode (i2c)
	; SDIO must be low && SEN must be hight
	clrf	RADIO	
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

radio_turnOn_loop
	call	shadow_push	
	BANKSEL	R_POWERCFG_L
	; Ensure ENABLE is zero (properly turned off before attempting 
	; to turn on radio)
	btfsc	R_POWERCFG_L, ENABLE
	goto	radio_turnOn_loop
	
	bcf	R_POWERCFG_L, DISABLE
	bsf	R_POWERCFG_L, ENABLE
	
	bsf	R_POWERCFG_H, DMUTE	; Set for Disable mute
	bcf	R_POWERCFG_H, DSMUTE
	
	bsf	R_SYSCONFIG1_H, DEMPHASIS	; For australia
	
	bcf	R_SYSCONFIG1_H, RDSIEN	; Disable Interrupts
	bcf	R_SYSCONFIG1_H, STCIEN	; Because we are not using them
	
	; Set volume 0000 (mute)
	bcf	R_SYSCONFIG2_L, VOLUME_0
	bcf	R_SYSCONFIG2_L, VOLUME_1
	bcf	R_SYSCONFIG2_L, VOLUME_2
	bcf	R_SYSCONFIG2_L, VOLUME_3
	
	bsf	R_SYSCONFIG3_H, VOLEXT 	;Set for low volume (clear for high volume)
	
	; Seek Threshold for RSSI (Recieved Signal Strength Indicator)
	movlw	0xC		
	movwf	R_SYSCONFIG2_H		; SEEKTH to 0xC
	
	; Noise ratios and impulse detection thresholds
	movlw	0x7F		; SKSNR to 0x7	(0001 for minimum stops, 0111 for max stops)
	movwf	R_SYSCONFIG3_L		; SKCNT to 0xF	(0001 for max stops, 1111 for fewer stops)
	
	; GPIO 1 to High for Power On status
	bsf	R_SYSCONFIG1_L, GPIO1_1
	bsf	R_SYSCONFIG1_L, GPIO1_0
	
	; Default Seek Modes
	bcf	R_POWERCFG_H, SKMODE	; Wrap around when seeking
	bsf	R_POWERCFG_H, SEEKUP	; Seek up when seeking
	
	goto	shadow_push

	return
;}
;---------------------------------------------------------------------------
; Tuning function 
; Make sure to have your "channel" on W reg
; Channel = (Frequency - Lower Band Limit) / Spacing
; Channel(#) = (Desired Frequency(MHz) - 87.5MHz) / 200KHz
radio_tune ;{
	BANKSEL	R_CHANNEL_H		; Move Channel from W register to Channel register
	bsf	R_CHANNEL_H, TUNE		; This works because the maximum possible channel number 
	movwf	R_CHANNEL_L		; is only 8 bits
				 
	
	call	shadow_push
	
radioTuneLoop
	call 	shadow_fill		; Update local radio
	
	BANKSEL	LCD_DATA
	call	LCD_secondLine		; print READCHAN on the second line
	call	printREADCHAN		; Printing used as a delay
	
	BANKSEL	R_STATUSRSSI_H		; Wait till STC bit is set
	btfss	R_STATUSRSSI_H, STC	
	goto	radioTuneLoop
	
	BANKSEL	R_CHANNEL_H	
	bcf	R_CHANNEL_H, TUNE		; Clear tune bit to say tuning is done
	
	call	shadow_push		; Push that change		 
	
	return
	
	
	
radio_tune_noPrint
	BANKSEL	R_CHANNEL_H
	bsf	R_CHANNEL_H, TUNE
	movwf	R_CHANNEL_L
	
	call	shadow_push
	
radioTune_noPrint_Loop
	call 	shadow_fill
	call	delay_60ms		; Exactly the same as radio_tune but delay instead of print
	
	BANKSEL	R_STATUSRSSI_H
	btfss	R_STATUSRSSI_H, STC
	goto	radioTune_noPrint_Loop
	
	BANKSEL	R_CHANNEL_H
	bcf	R_CHANNEL_H, TUNE
	
	call	shadow_push
	
	return	
;}	
;---------------------------------------------------------------------------

; Call this function to seek to the nearest station
; Make sure to set Seek Control before calling this function
; SKMODE - High for stopping at upper limit
;          Low for wrapping around (default)
; SEEKUP - High for seeking up to upper band limit
;          Low for seeking down to lower band limit (default)
radio_seek ;{	
	BANKSEL	R_POWERCFG_H		; SKMODE and SEEKUP bits are set by caller
	bsf	R_POWERCFG_H, SEEK	; Start seeking
	call	shadow_push
	
radioSeekLoop
	call 	shadow_fill
	
	BANKSEL	LCD_DATA		; Print current channel
	call	LCD_secondLine		; Print READCHAN on second line
	call	printREADCHAN		; Used as delay as well
	
	BANKSEL	R_STATUSRSSI_H		; Wait till STC is set
	btfss	R_STATUSRSSI_H, STC
	goto	radioSeekLoop
	
	BANKSEL	R_POWERCFG_H
	bcf	R_POWERCFG_H, SEEK	; Clear bit to say seeking is done
		
	call	shadow_push
	
	return
	
;}
;---------------------------------------------------------------------------


; Updates the local copy of the radio registers	
; Warning: Make sure to set up i2c before using this function
shadow_fill ;{
	; Initiate start condition
	call	i2c_start
	
	; Move device id from 
	BANKSEL	SSPBUF
	movlw	b'00100001' 		; DeviceID + Read
	movwf	SSPBUF
	
	call	i2c_checkAcknowledge	; Check if Radio acknowledged the call
	
	call	i2c_checkIdle		; Ensure i2c is not being used
	
	movlw	R_STATUSRSSI_H		
	movwf	FSR		; Using FSR as a pointer

shadowFillLoop				
	call	i2c_read		; Read data from the Radio
	call	i2c_checkIdle
	
	nop
	
	call	i2c_acknowledge		; Acknowledge the just recieved message
	
	
	call	i2c_checkIdle		; Ensure PIC's i2c has completed all events
	
	
	
	BANKSEL	SSPBUF
	movf	SSPBUF,W		; Move the newly read byte to the register
	movwf	INDF		; INDF points to the correct register

	
	movlw	R_RDSD_L		; Case 1: Check if its at the end of the radio registers
	xorwf	FSR,W		; XOR the end with 
	btfss	STATUS,Z 		
	goto	noWrapAround		; Wrap around if FSR is the same
	
wrapAround
	movlw	R_DEVICEID_H
	movwf	FSR
	goto 	wAD
	
noWrapAround
	incf	FSR,f		; Increments pointer in radio registers

wAD
	BANKSEL	R_STATUSRSSI_H		; Case 2: Checks if its at the start of read
	movlw	R_STATUSRSSI_H
	xorwf	FSR,W
	btfss	STATUS,Z
	goto	shadowFillLoop
	
	
	call	i2c_read		; The last read MUST be nacked
	call	i2c_checkIdle		; So make another unused read and nack it
	
	nop
	
	call	i2c_nAcknowledge
	
	movf	SSPBUF,W		; Ensure SSPBUF is used to avoid overflowing
	

	call 	i2c_stop		; Stop reading + and hence shadow filling
	
	call	delay_mate		; Delay to ensure i2c module doesn't get over used
	return


; shadowFill Helper function	


;}
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
shadow_push ;{
	call	i2c_start
	
	; Move device id from 
	BANKSEL	SSPBUF
	movlw	b'00100000' 		; DeviceID + Write
	movwf	SSPBUF
	call	i2c_checkTransmit
	
	nop
	
	call	i2c_checkAcknowledge	; Check if radio to address
	call	i2c_checkIdle
	
	movlw	R_POWERCFG_H		; Change INDF pointer to PowerCFG(02h)	
	movwf	FSR
	
shadowPushLoop
	
	movf	INDF,W		; Move the data to SSPBUF	
	BANKSEL	SSPBUF
	movwf	SSPBUF
	
	; The pic will now send data over i2C
	
	call	i2c_checkTransmit		; Wait til transmission is done
	
	call	i2c_checkAcknowledge	; Check if radio has recieved
	
	call	i2c_checkIdle		; Ensure i2c has completed all events
	
	movlw	R_RDSD_L		; Case 1: Check if its just wrote to the last one
	xorwf	FSR,W
	btfsc	STATUS,Z
	goto	shadowPushLoopEnd 	; If so, end the loop
	
	incf	FSR,F		; Else, increment and loop
	goto	shadowPushLoop		
	
shadowPushLoopEnd
	call	i2c_stop
	
	call	delay_mate		; Delay to ensure i2c module doesn't get over used
	
	; Once reading, ensures shadow registers
	; are up to date
	; shadow_fill will return to the function that called 
	; shadowPush (one less hardware stack (Y) )
	goto	shadow_fill
	
	return	;}
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
	BANKSEL	SSPCON2
	bsf	SSPCON2,SEN	; Send start condition
	
	btfsc	SSPCON2,SEN	; Wait till start condition has been successfully sent
	goto	$-1
	
	return	
	
;---------------------------------------------------------------------------

i2c_read
	BANKSEL	SSPCON2
	bsf	SSPCON2,RCEN	; Send read (start) condition
	
	btfsc 	SSPCON2,RCEN	; Wait till read condition has been successfully sent
	goto	$-1
	
	return
	
;---------------------------------------------------------------------------

i2c_stop
	BANKSEL	SSPCON2
	bsf	SSPCON2,PEN	; Send stop condition
	
	btfsc	SSPCON2,PEN	; Wait till stop condition has been successfully sent
	goto	$-1
	
	return

;---------------------------------------------------------------------------

i2c_checkTransmit

	BANKSEL	SSPSTAT	
	btfsc	SSPSTAT,R_W	; Check if transmittion in progress
	goto	$-1
	
	return

;---------------------------------------------------------------------------

i2c_checkIdle
	BANKSEL	SSPSTAT
	btfsc	SSPSTAT,R_W	; Check if transmittion in progress
	goto	$-1
	
	BANKSEL	SSPCON2
checkEN	
	movf	SSPCON2,W	; Extracting Bits to check
	andlw	0x1F	; Bits <4:0> - From ACKEN to SEn
	
	btfss	STATUS,Z	; Check if the anding resulted in zero
	goto	checkEN	; If not, then something is still being sent, so continue looping 
	
	return
	
;---------------------------------------------------------------------------

i2c_checkAcknowledge
	BANKSEL	SSPCON2
	btfsc	SSPCON2,ACKSTAT	; Check if ACKSTAT <5> is 0 - recieved from slave
	goto	$-1
	return

;---------------------------------------------------------------------------

i2c_acknowledge
	BANKSEL	SSPCON2
	bcf	SSPCON2,ACKDT	; To send an acknowledge, clear ACKDT <4> to 0
	bsf	SSPCON2,ACKEN	; and start the ack
	return
	
;---------------------------------------------------------------------------
	
i2c_nAcknowledge
	BANKSEL	SSPCON2
	bsf	SSPCON2,ACKDT	; To send an not acknowledge, set ACKDT <4> to 1
	bsf	SSPCON2,ACKEN	; and start the nack
	return
;}	

;------------------------------------------------------------------------;
;      _    ___ ___    ___ _   _ _  _  ___ _____ ___ ___  _  _ ___       ;
;     | |  / __|   \  | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|      ;    
;     | |_| (__| |) | | _|| |_| | .` | (__  | |  | | (_) | .` \__ \      ;
;     |____\___|___/  |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/      ;
;                                                                        ;
;------------------------------------------------------------------------;
; Two variables are used to aid the sending of LCD commands and data, LCD_COMMAND and LCD_DATA respectively
; --- // SOFTWARE DESIGN: ABSTRACTION \\ ----
; Also two counters are used to keep track of the cursor, in order to automatically move to the next line
; NOTE: LCD_ADDRESS_COUNTER counts down, 8 for the start of the line, 0 for the end of the line
;       also, LCD_LINE_COUNTER, 0 for first line and 1 for end line
;{
LCD_initialise ;{
	BANKSEL	LCD_EN_PORT
	bsf	LCD_EN_PORT, LCD_backLight
	
	
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
	
	; Place some special characters in CGRAM :)
	movlw	0x40
	call	LCD_sendCommand
	
	; Black S 	;{
	movlw	0x1f
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x17
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x1D
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x1f
	call	LCD_sendData
	
	call	delay_mate ;}
	
	; Black H	;{
	movlw	0x48
	call	LCD_sendCommand
	
	movlw	0x1f
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x1F
	call	LCD_sendData
	
	call	delay_mate ;}
	
	; Black A	;{
	movlw	0x50
	call	LCD_sendCommand
	
	movlw	0x1f
	call	LCD_sendData
	
	movlw	0x1b
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x15
	call	LCD_sendData
	
	movlw	0x1f
	call	LCD_sendData
	
	call	delay_mate ;}
	
	; Black N	;{
	movlw	0x58 
	call	LCD_sendCommand
	
	movlw	0x1f
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x12
	call	LCD_sendData
	
	movlw	0x14
	call	LCD_sendData
	
	movlw	0x14
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x1f
	call	LCD_sendData
	
	call	delay_mate	;}
	
	; Black U	;{
	movlw	0x60
	call	LCD_sendCommand
	movlw	0x1f
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x16
	call	LCD_sendData
	
	movlw	0x19
	call	LCD_sendData
	
	movlw	0x1f
	call	LCD_sendData
	
	call	delay_mate	;}
	
	; Up arrow	;{
	movlw	0x68
	call	LCD_sendCommand
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0xe
	call	LCD_sendData
	
	movlw	0x1b
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	call	delay_mate	;}
	
	; Down arrow	;{
	movlw	0x70
	call	LCD_sendCommand
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	movlw	0x11
	call	LCD_sendData
	
	movlw	0x1b
	call	LCD_sendData
	
	movlw	0xe
	call	LCD_sendData
	
	movlw	0x4
	call	LCD_sendData
	
	call	delay_mate	;}
	
	; Half black	;{
	movlw	0x78
	call	LCD_sendCommand
	
	movlw	D'8'
	movwf	COUNTER1
LCD_initalise_halfBlock	
	movlw	0x1c
	call	LCD_sendData
	
	decfsz	COUNTER1,F
	goto	LCD_initalise_halfBlock
	
	call	delay_mate	;}
	
	; Reset to DDRAM
	movlw	b'10000000'
	call	LCD_sendCommand
	
	call	LCD_clearDisplay

	; Initalises counters for new line
	BANKSEL	LCD_ADDRESS_COUNTER
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	clrf	LCD_LINE_COUNTER

	call	delay_5ms
	return ;}

;---------------------------------------------------------------------------

LCD_clearDisplay ;{
	movlw	b'00000001'
	call	LCD_sendCommand		
	
	BANKSEL	LCD_ADDRESS_COUNTER	; Reset LCD counters to start
	movlw	D'8'		; ADDRESS to 8 (as ADDRESS counts down)
	movwf	LCD_ADDRESS_COUNTER
	clrf	LCD_LINE_COUNTER	
	
	return ;}

;---------------------------------------------------------------------------
	
;LCD_resetCursor ;{
;	movlw	b'00000010'
;	call	LCD_sendCommand
;	
;	BANKSEL	LCD_ADDRESS_COUNTER	; Reset LCD counters to start
;	movlw	D'8'
;	movwf	LCD_ADDRESS_COUNTER
;	clrf	LCD_LINE_COUNTER
;	
;	return ;}

;---------------------------------------------------------------------------

LCD_nextLine ;{
	BANKSEL	LCD_LINE_COUNTER		; Move to the next line
	btfsc	LCD_LINE_COUNTER,0	; First check which line it is currently one
	goto	leftLine
	goto	rightLine
	
leftLine
	movlw	b'10000000'		; Set DDRAM to 0
	call	LCD_sendCommand
	clrf	LCD_LINE_COUNTER		; Set new value for next line counter
	goto 	lcd_nextLine_end
	
rightLine
	movlw	b'11000000'		; Set DDRAM to 40H
	call	LCD_sendCommand
	incf	LCD_LINE_COUNTER,F	; Set new value for next line counter
	
lcd_nextLine_end
	movlw	D'8'		; Reset LCD_ADDRESS counter
	movwf	LCD_ADDRESS_COUNTER
	
	return 	;}

;---------------------------------------------------------------------------

LCD_secondLine ;{		
	movlw	b'11000000'		; Move to the second line
	call	LCD_sendCommand		; i.e set DDRAM to 40H
	
	BANKSEL	LCD_LINE_COUNTER		; Reset counters appropriately
	bsf	LCD_LINE_COUNTER,0
	movlw	D'8'
	movwf	LCD_ADDRESS_COUNTER
	
	return	;}

LCD_shiftCursorLeft ;{
	
	movlw	D'8'		; Check for line edge cases
	xorwf	LCD_ADDRESS_COUNTER,W	; i.e whether the cursor at the start
	btfsc	STATUS,Z		; or on the middle of the screen
	goto	LCD_shiftCursorLeft_edgeCase	
	
	movlw	b'00010000' 		;Shift to the left, cursor movement
	call	LCD_sendCommand
	
	incf	LCD_ADDRESS_COUNTER,F

	return
	
LCD_shiftCursorLeft_edgeCase
	btfsc	LCD_LINE_COUNTER,0
	goto	LCD_shiftCursorLeft_middleCase
	goto	LCD_shiftCursorLeft_startCase
	
LCD_shiftCursorLeft_middleCase
	movlw	0x87		; If at the middle, set DDRAM to 8H
	call	LCD_sendCommand
	bcf	LCD_LINE_COUNTER,0	; Set line counter to start
	goto	LCD_shiftCursorLeft_caseEnd

LCD_shiftCursorLeft_startCase
	movlw	0xC7		; If at the start, set DDRAM to end of screen
	call	LCD_sendCommand		; i.e DDRAM to 47H
	bsf	LCD_LINE_COUNTER,0	; Set line counter to second line (because it just got wrapped around)
	
LCD_shiftCursorLeft_caseEnd
	movlw	D'1'		; Fix counter for end case
	movwf	LCD_ADDRESS_COUNTER
	
	return
;}

;---------------------------------------------------------------------------

LCD_sendCommand ;{
	BANKSEL	LCD_COMMAND
	movwf	LCD_COMMAND
	swapf	LCD_COMMAND,w	; First half of instruction
	andlw	b'00001111'	; Set RS and RW to zero
	movwf	LCD_DATA_PORT	; Move to data port
	call	LCD_pulseEnable
	call	LCD_checkBf

	movf	LCD_COMMAND,w	; Send the second half
	andlw	b'00001111'	
	movwf	LCD_DATA_PORT	; Move to data port
	call	LCD_pulseEnable
	call	LCD_checkBf

	return	;}

;---------------------------------------------------------------------------

LCD_sendData ;{
	BANKSEL	LCD_DATA
	movwf	LCD_DATA
	swapf	LCD_DATA,w		; Send first half of the instruction
	movwf	LCD_DATA_PORT
	bsf	LCD_DATA_PORT,LCD_RS	; Set RS and RW bits for writing to DDRAM/CGRAM
	bcf	LCD_DATA_PORT,LCD_RW
	call	LCD_pulseEnable
	call	LCD_checkBf

	movf	LCD_DATA,w
	movwf	LCD_DATA_PORT		; Send second half 
	bsf	LCD_DATA_PORT,LCD_RS
	bcf	LCD_DATA_PORT,LCD_RW
	call	LCD_pulseEnable
	call	LCD_checkBf

	bcf	LCD_DATA_PORT,LCD_RS
	bcf	LCD_DATA_PORT,LCD_RW
	
	decfsz	LCD_ADDRESS_COUNTER,f	; Reduce Address counter (counting down)
	return			
				; If zero, i.e at the end of the line now
	call	LCD_nextLine		; goto the next line
	return ;}

;---------------------------------------------------------------------------
LCD_pulseEnable ;{
	bsf	LCD_EN_PORT,LCD_EN
	nop
	nop
	nop
	bcf	LCD_EN_PORT,LCD_EN
	return	;}

;---------------------------------------------------------------------------
	
LCD_checkBf ;{
	; Checks Busy Flag
	BANKSEL	LCD_DATA_TRIS
	bsf	LCD_DATA_TRIS,LCD_D7	; Set D7 (Busy flag pin) to be an input
	
	BANKSEL	LCD_DATA_PORT
	bsf	LCD_DATA_PORT, LCD_RW	; Set LCD to be reading Busy flag
	bcf	LCD_DATA_PORT, LCD_RS
	
	bsf	LCD_EN_PORT, LCD_EN

; --- // SOFTWARE DESIGN \\ ---
; Is both a delay and a check, so if bf fails, delay will override.
wait_bf
	movlw	D'200'
	movwf	counter_bf
	
wait_bf_loop
	btfss	LCD_DATA_PORT, LCD_BF	
	goto 	wait_bf_end		; End if not bf (when BF flag is cleared)
	call	delay_200us
	decfsz	counter_bf,F		
	goto	wait_bf_loop		; If time is up, then forget about checking BF, LCD probably stuffed up :(
				; Occurs very rarely though
	
wait_bf_end
	bcf	LCD_EN_PORT, LCD_EN	; Stop reading
	
	BANKSEL	LCD_DATA_TRIS		; Revert TRIS and PORT to usual
	clrf	LCD_DATA_TRIS
	
	BANKSEL	LCD_DATA_PORT
	bcf	LCD_DATA_PORT, LCD_RW
	
	return ;}
;}


;------------------------------------------------------------------------;
;    ___  ___ _      ___   __  ___  ___  _   _ _____ ___ _  _ ___ ___    ;
;   |   \| __| |    /_\ \ / / | _ \/ _ \| | | |_   _|_ _| \| | __/ __|   ;
;   | |) | _|| |__ / _ \ V /  |   / (_) | |_| | | |  | || .` | _|\__ \   ;
;   |___/|___|____/_/ \_\_|   |_|_\\___/ \___/  |_| |___|_|\_|___|___/   ;
;                                                                        ;
;------------------------------------------------------------------------;
; Some of these delays were generated from the following website: http://www.piclist.com/techref/piclist/codegen/delay.htm
; They work by using a cascading loop. In effect, it counts in base 255.
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

delay_LCD			;999990 cycles - 1 second
	movlw	0x07
	movwf	d1
	movlw	0x2F
	movwf	d2
	movlw	0x03
	movwf	d3
delay_LCD_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	delay_LCD_0

			;6 cycles
	goto	$+1
	goto	$+1
	goto	$+1

			;4 cycles (including call)
	return


	
;---------------------------------------------------------------------------
			
delay_60ms			;59993 cycles
	BANKSEL	d1	
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
; The following loops we created from scratch by me.
; Work simply by calculating number of instruction cycles as shown in the lecture
; and instead using variables and trial and error till we get exact or really close to
; required delay
delay_128ms
	movlw	D'26'
	movwf	counter_128ms
	
loop_128ms
	call	delay_5ms
	decfsz	counter_128ms,F
	goto	loop_128ms
	
	return
	
;---------------------------------------------------------------------------

delay_keyPress
	movlw	D'20'
	movwf	counter_keyPress
	
loop_keyPress
	call	delay_5ms
	decfsz	counter_keyPress,F
	goto	loop_keyPress
	
	return

;---------------------------------------------------------------------------

delay_5ms
	movlw	D'100'
	movwf	counter_5ms
	
loop_5ms
	call	delay_200us
	decfsz	counter_5ms,F
	goto	loop_5ms
	
	return

;---------------------------------------------------------------------------
	
delay_200us
	movlw	D'66'
	movwf	counter_200us
	
loop_200us
	decfsz	counter_200us,F
	goto	loop_200us

	return
;}
	
	END	; directive 'end of program'

