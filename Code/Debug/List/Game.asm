
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _not=R4
	.DEF _not_msb=R5
	.DEF _dir=R6
	.DEF _dir_msb=R7
	.DEF _lastdir=R8
	.DEF _lastdir_msb=R9
	.DEF _ttt=R10
	.DEF _ttt_msb=R11
	.DEF _tt=R12
	.DEF _tt_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x67
_0x4:
	.DB  0xFE,0xFD,0xFB,0xF7,0xEF,0xDF,0xBF,0x7F

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x0A
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  __7SEGPTRN
	.DW  _0x3*2

	.DW  0x08
	.DW  _ptrn
	.DW  _0x4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define COL 8
;#define ROW 16
;
;#define DOT_PIXELS 8
;
;#define DMC PORTD.0
;
;#define _7SEG PORTB
;
;#define TRUE 1
;#define FALSE 0
;
;#define D1 PORTA
;#define D2 PORTC
;
;#define STOP PIND.3
;#define UP PIND.4
;#define RIGHT PIND.5
;#define DOWN PIND.6
;#define LEFT PIND.7
;
;#define S 0
;#define U 1
;#define R 2
;#define D 3
;#define L 4
;#define EMP 0
;#define SNK 1
;#define FOD 2
;
;char _7SEGPTRN[10] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67};

	.DSEG
;char ptrn[8] = {~0x01,~0x02,~0x04,~0x08,~0x10,~0x20,~0x40,~0x80};
;
;// Game Data
;
;struct point {
;    char x,y;
;}food,last,head[ROW * COL];
;
;int map [ROW][COL];
;
;int not;
;int dir;
;int lastdir;
;
;bit win;
;bit gameover;
;
;void Initial();
;void Logic();
;void UPD();
;void Show();
;void Show_On_LED();
;void CHFOD();
;void INC();
;void SET(int ,int ,int );
;
;int ttt = 0;
;int tt = 0;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0040 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041     //LOGIC
; 0000 0042     tt++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0043     if(tt==20){
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x5
; 0000 0044     if(!gameover)
	SBRS R2,1
; 0000 0045         Logic();
	RCALL _Logic
; 0000 0046     tt=0;
	CLR  R12
	CLR  R13
; 0000 0047     }
; 0000 0048 }
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 004B {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004C  bit P;
; 0000 004D // 7SEG
; 0000 004E     if(not<10){
;	P -> R15.0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x7
; 0000 004F         if(ttt<=5)
	RCALL SUBOPT_0x0
	BRLT _0x8
; 0000 0050         _7SEG = (1<<7) | _7SEGPTRN[not];
	LDI  R26,LOW(__7SEGPTRN)
	LDI  R27,HIGH(__7SEGPTRN)
	ADD  R26,R4
	ADC  R27,R5
	LD   R30,X
	ORI  R30,0x80
	OUT  0x18,R30
; 0000 0051         if(ttt>5)
_0x8:
	RCALL SUBOPT_0x0
	BRGE _0x9
; 0000 0052         _7SEG = (0<<7) | _7SEGPTRN[0];
	LDS  R30,__7SEGPTRN
	OUT  0x18,R30
; 0000 0053     }
_0x9:
; 0000 0054     else
	RJMP _0xA
_0x7:
; 0000 0055     {
; 0000 0056          if(ttt<=5)
	RCALL SUBOPT_0x0
	BRLT _0xB
; 0000 0057         _7SEG = (1<<7) | _7SEGPTRN[not%10];
	MOVW R26,R4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,LOW(-__7SEGPTRN)
	SBCI R31,HIGH(-__7SEGPTRN)
	LD   R30,Z
	ORI  R30,0x80
	OUT  0x18,R30
; 0000 0058         if(ttt>5)
_0xB:
	RCALL SUBOPT_0x0
	BRGE _0xC
; 0000 0059         _7SEG = (0<<7) | _7SEGPTRN[not/10];
	MOVW R26,R4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,LOW(-__7SEGPTRN)
	SBCI R31,HIGH(-__7SEGPTRN)
	LD   R30,Z
	OUT  0x18,R30
; 0000 005A     }
_0xC:
_0xA:
; 0000 005B if(ttt == 10)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xD
; 0000 005C ttt=0;
	CLR  R10
	CLR  R11
; 0000 005D ttt++;
_0xD:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 005E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0064 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0065 // Place your code here
; 0000 0066 if(STOP){
	SBIS 0x10,3
	RJMP _0xE
; 0000 0067   dir = S;
	CLR  R6
	CLR  R7
; 0000 0068 }
; 0000 0069 else if(UP)
	RJMP _0xF
_0xE:
	SBIS 0x10,4
	RJMP _0x10
; 0000 006A {
; 0000 006B     if(lastdir!=D)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x11
; 0000 006C         dir = U;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 006D }
_0x11:
; 0000 006E else if(RIGHT)
	RJMP _0x12
_0x10:
	SBIS 0x10,5
	RJMP _0x13
; 0000 006F {   if(lastdir!=L)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x14
; 0000 0070         dir = R;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R6,R30
; 0000 0071 
; 0000 0072 }
_0x14:
; 0000 0073 else if(DOWN)
	RJMP _0x15
_0x13:
	SBIS 0x10,6
	RJMP _0x16
; 0000 0074 {
; 0000 0075     if(lastdir!=U)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x17
; 0000 0076         dir = D;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R6,R30
; 0000 0077 }
_0x17:
; 0000 0078 else if(LEFT)
	RJMP _0x18
_0x16:
	SBIS 0x10,7
	RJMP _0x19
; 0000 0079 {
; 0000 007A     if(lastdir!=R)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1A
; 0000 007B         dir = L;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R6,R30
; 0000 007C }
_0x1A:
; 0000 007D 
; 0000 007E }
_0x19:
_0x18:
_0x15:
_0x12:
_0xF:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0081 {
_main:
; .FSTART _main
; 0000 0082 // Declare your local variables here
; 0000 0083 
; 0000 0084 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0085 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0086 
; 0000 0087 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0088 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0089 
; 0000 008A DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 008B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 008C 
; 0000 008D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(1)
	OUT  0x11,R30
; 0000 008E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 008F 
; 0000 0090 // Timer/Counter 0 initialization
; 0000 0091 // Clock source: System Clock
; 0000 0092 // Clock value: 8000.000 kHz
; 0000 0093 // Mode: Normal top=0xFF
; 0000 0094 // OC0 output: Disconnected
; 0000 0095 // Timer Period: 0.032 ms
; 0000 0096 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0097 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0098 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0099 
; 0000 009A // Timer/Counter 2 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: 8000.000 kHz
; 0000 009D // Mode: Normal top=0xFF
; 0000 009E // OC2 output: Disconnected
; 0000 009F // Timer Period: 0.032 ms
; 0000 00A0 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00A1 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00A2 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00A3 OCR2=0x00;
	OUT  0x23,R30
; 0000 00A4 
; 0000 00A5 
; 0000 00A6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A7 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 00A8 
; 0000 00A9 // External Interrupt(s) initialization
; 0000 00AA // INT0: On
; 0000 00AB // INT0 Mode: Rising Edge
; 0000 00AC // INT1: Off
; 0000 00AD // INT2: Off
; 0000 00AE GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00AF MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 00B0 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00B1 GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00B2 
; 0000 00B3 // Global enable interrupts
; 0000 00B4 #asm("sei")
	sei
; 0000 00B5 
; 0000 00B6 while (1)
_0x1B:
; 0000 00B7       {
; 0000 00B8 
; 0000 00B9             Initial();
	RCALL _Initial
; 0000 00BA 
; 0000 00BB             while(!gameover) {
_0x1E:
	SBRC R2,1
	RJMP _0x20
; 0000 00BC                 Show();
	RCALL _Show
; 0000 00BD             }
	RJMP _0x1E
_0x20:
; 0000 00BE 
; 0000 00BF       }
	RJMP _0x1B
; 0000 00C0 }
_0x21:
	RJMP _0x21
; .FEND
;
;void Initial(){
; 0000 00C2 void Initial(){
_Initial:
; .FSTART _Initial
; 0000 00C3 
; 0000 00C4    int r,c;
; 0000 00C5 
; 0000 00C6    for(r=0;r<ROW;r++)
	CALL __SAVELOCR4
;	r -> R16,R17
;	c -> R18,R19
	__GETWRN 16,17,0
_0x23:
	__CPWRN 16,17,16
	BRGE _0x24
; 0000 00C7     for(c=0;c<COL;c++)
	__GETWRN 18,19,0
_0x26:
	__CPWRN 18,19,8
	BRGE _0x27
; 0000 00C8         map[r][c] = 0;
	MOVW R30,R16
	RCALL SUBOPT_0x1
	MOVW R26,R30
	MOVW R30,R18
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	__ADDWRN 18,19,1
	RJMP _0x26
_0x27:
; 0000 00CA gameover = 0;
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
	CLT
	BLD  R2,1
; 0000 00CB     win = FALSE;
	BLD  R2,0
; 0000 00CC 
; 0000 00CD     dir = S;
	CLR  R6
	CLR  R7
; 0000 00CE     lastdir = S;
	CLR  R8
	CLR  R9
; 0000 00CF 
; 0000 00D0     not = 0;
	CLR  R4
	CLR  R5
; 0000 00D1 
; 0000 00D2     food.x = 1;
	LDI  R30,LOW(1)
	STS  _food,R30
; 0000 00D3     food.y = 5;
	LDI  R30,LOW(5)
	__PUTB1MN _food,1
; 0000 00D4 
; 0000 00D5     head[0].x = 1;
	LDI  R30,LOW(1)
	STS  _head,R30
; 0000 00D6     head[0].y = 1;
	__PUTB1MN _head,1
; 0000 00D7 
; 0000 00D8     last.x = head[0].x;
	STS  _last,R30
; 0000 00D9     last.y = head[0].y;
	__GETB1MN _head,1
	__PUTB1MN _last,1
; 0000 00DA 
; 0000 00DB     for(r=1;r<ROW*COL;r++){
	__GETWRN 16,17,1
_0x29:
	__CPWRN 16,17,128
	BRGE _0x2A
; 0000 00DC         head[r].x = -1;
	MOVW R30,R16
	RCALL SUBOPT_0x3
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x4
; 0000 00DD         head[r].y = -1;
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(255)
	ST   X,R30
; 0000 00DE     }
	__ADDWRN 16,17,1
	RJMP _0x29
_0x2A:
; 0000 00DF }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void Logic(){
; 0000 00E1 void Logic(){
_Logic:
; .FSTART _Logic
; 0000 00E2     int i;
; 0000 00E3 
; 0000 00E4     if(dir == S)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x2B
; 0000 00E5             return;
	RJMP _0x2000002
; 0000 00E6 
; 0000 00E7         // Gameover || Win Chexk
; 0000 00E8         if(not == ROW*COL-1)
_0x2B:
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x2C
; 0000 00E9         {
; 0000 00EA             gameover = TRUE;
	SET
	BLD  R2,1
; 0000 00EB             win = TRUE;
	BLD  R2,0
; 0000 00EC         }
; 0000 00ED 
; 0000 00EE         // Update Tail
; 0000 00EF         last.x = head[not].x;
_0x2C:
	MOVW R30,R4
	RCALL SUBOPT_0x3
	LD   R30,X
	STS  _last,R30
; 0000 00F0         last.y = head[not].y;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	__PUTB1MN _last,1
; 0000 00F1         for(i=not;i>0;i--)
	MOVW R16,R4
_0x2E:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x2F
; 0000 00F2         {
; 0000 00F3             head[i].x = head[i-1].x;
	MOVW R30,R16
	RCALL SUBOPT_0x7
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R16
	SBIW R30,1
	RCALL SUBOPT_0x3
	LD   R30,X
	MOVW R26,R0
	RCALL SUBOPT_0x4
; 0000 00F4             head[i].y = head[i-1].y;
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	MOVW R0,R30
	MOVW R30,R16
	SBIW R30,1
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	MOVW R26,R0
	ST   X,R30
; 0000 00F5 
; 0000 00F6         }
	__SUBWRN 16,17,1
	RJMP _0x2E
_0x2F:
; 0000 00F7 
; 0000 00F8         // Move
; 0000 00F9         switch (dir) {
	MOVW R30,R6
; 0000 00FA         case U:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x33
; 0000 00FB             lastdir = U;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 00FC             head[0].x++;
	LDS  R30,_head
	SUBI R30,-LOW(1)
	STS  _head,R30
; 0000 00FD             break;
	RJMP _0x32
; 0000 00FE         case R:
_0x33:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
; 0000 00FF             lastdir = R;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 0100             head[0].y++;
	__GETB1MN _head,1
	SUBI R30,-LOW(1)
	__PUTB1MN _head,1
	SUBI R30,LOW(1)
; 0000 0101             break;
	RJMP _0x32
; 0000 0102         case D:
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x35
; 0000 0103             lastdir = D;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
; 0000 0104             head[0].x--;
	LDS  R30,_head
	SUBI R30,LOW(1)
	STS  _head,R30
; 0000 0105             break;
	RJMP _0x32
; 0000 0106         case L:
_0x35:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x32
; 0000 0107             lastdir = L;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R8,R30
; 0000 0108             head[0].y--;
	__GETB1MN _head,1
	SUBI R30,LOW(1)
	__PUTB1MN _head,1
	SUBI R30,-LOW(1)
; 0000 0109             break;
; 0000 010A         }
_0x32:
; 0000 010B 
; 0000 010C         // Food Match
; 0000 010D         CHFOD();
	RCALL _CHFOD
; 0000 010E 
; 0000 010F         // Hit Tail
; 0000 0110         for(i=1;i<=not;i++)
	__GETWRN 16,17,1
_0x38:
	__CPWRR 4,5,16,17
	BRLT _0x39
; 0000 0111             if(head[0].x == head[i].x && head[0].y == head[i].y)
	MOVW R30,R16
	RCALL SUBOPT_0x3
	LD   R30,X
	LDS  R26,_head
	CP   R30,R26
	BRNE _0x3B
	MOVW R30,R16
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	__GETB2MN _head,1
	CP   R30,R26
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 0112             {
; 0000 0113                 gameover = TRUE;
	SET
	BLD  R2,1
; 0000 0114                 return;
	RJMP _0x2000002
; 0000 0115             }
; 0000 0116 
; 0000 0117         // Hit wall
; 0000 0118         if(head[0].x < 0 || head[0].x >= ROW || head[0].y < 0 || head[0].y >= COL)
_0x3A:
	__ADDWRN 16,17,1
	RJMP _0x38
_0x39:
	LDS  R26,_head
	CPI  R26,0
	BRLO _0x3E
	CPI  R26,LOW(0x10)
	BRSH _0x3E
	__GETB2MN _head,1
	CPI  R26,0
	BRLO _0x3E
	__GETB2MN _head,1
	CPI  R26,LOW(0x8)
	BRLO _0x3D
_0x3E:
; 0000 0119         {
; 0000 011A             gameover=TRUE;
	SET
	BLD  R2,1
; 0000 011B             return;
; 0000 011C         }
; 0000 011D }
_0x3D:
_0x2000002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void CHFOD() {
; 0000 011F void CHFOD() {
_CHFOD:
; .FSTART _CHFOD
; 0000 0120 
; 0000 0121         int i;
; 0000 0122         int j;
; 0000 0123         int r;
; 0000 0124         int Counter = 0;
; 0000 0125 
; 0000 0126         struct point PossibleFoodLoc[(ROW*COL)-(not+1)];
; 0000 0127 
; 0000 0128         if(head[0].x == food.x && head[0].y == food.y) {
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	r -> R20,R21
;	Counter -> Y+6
;	PossibleFoodLoc -> Y+6
	LDS  R30,_food
	LDS  R26,_head
	CP   R30,R26
	BRNE _0x41
	__GETB2MN _head,1
	__GETB1MN _food,1
	CP   R30,R26
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 0129             // Replace Food
; 0000 012A             SET(head[0].x, head[0].y, SNK);
	RCALL SUBOPT_0x8
; 0000 012B 
; 0000 012C             // Increase Tail
; 0000 012D             INC();
	RCALL _INC
; 0000 012E         /*
; 0000 012F             // Change food loc
; 0000 0130             for(i=0;i<ROW;i++)
; 0000 0131                 for(j=0;j<COL;j++)
; 0000 0132                     if(map[i][j] == 0)
; 0000 0133                     {
; 0000 0134                         PossibleFoodLoc[Counter].x = i;
; 0000 0135                         PossibleFoodLoc[Counter].y = j;
; 0000 0136                         Counter++;
; 0000 0137                     }                    */
; 0000 0138      /*       r = (int)TCNT0 % ((ROW*COL)-(not+1));
; 0000 0139             food.x = PossibleFoodLoc[r].x;
; 0000 013A             food.y = PossibleFoodLoc[r].y; */
; 0000 013B             do{
_0x44:
; 0000 013C             food.x = ((int)TCNT0*tt) % 8;
	IN   R30,0x32
	LDI  R31,0
	MOVW R26,R30
	MOVW R30,R12
	CALL __MULW12
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	STS  _food,R30
; 0000 013D             food.y = ((int)TCNT0) % 8;
	IN   R30,0x32
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	__PUTB1MN _food,1
; 0000 013E             }while(map[food.x][food.y]>0);
	LDS  R30,_food
	LDI  R31,0
	RCALL SUBOPT_0x1
	MOVW R26,R30
	__GETB1MN _food,1
	LDI  R31,0
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x9
	BRLT _0x44
; 0000 013F         }
; 0000 0140     }
_0x40:
	RJMP _0x2000001
; .FEND
;
;void INC() {
; 0000 0142 void INC() {
_INC:
; .FSTART _INC
; 0000 0143     not++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0144     head[not].x = last.x;
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_last
	STD  Z+0,R26
; 0000 0145     head[not].y = last.y;
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	__GETB1MN _last,1
	ST   X,R30
; 0000 0146     last.x = -1;
	LDI  R30,LOW(255)
	STS  _last,R30
; 0000 0147     last.y = -1;
	__PUTB1MN _last,1
; 0000 0148 }
	RET
; .FEND
;
;void Show() {
; 0000 014A void Show() {
_Show:
; .FSTART _Show
; 0000 014B     UPD();
	RCALL _UPD
; 0000 014C     Show_On_LED();
	RCALL _Show_On_LED
; 0000 014D }
	RET
; .FEND
;
;void UPD() {
; 0000 014F void UPD() {
_UPD:
; .FSTART _UPD
; 0000 0150     SET(last.x, last.y, EMP);
	LDS  R30,_last
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _last,1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _SET
; 0000 0151     SET(food.x, food.y, FOD);
	LDS  R30,_food
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _food,1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _SET
; 0000 0152     SET(head[0].x, head[0].y, SNK);
	RCALL SUBOPT_0x8
; 0000 0153 }
	RET
; .FEND
;
;void SET(int X,int Y,int TYPE) {
; 0000 0155 void SET(int X,int Y,int TYPE) {
_SET:
; .FSTART _SET
; 0000 0156     if(X >= 0 && X < ROW && Y >= 0 && Y < COL)
	ST   -Y,R27
	ST   -Y,R26
;	X -> Y+4
;	Y -> Y+2
;	TYPE -> Y+0
	LDD  R26,Y+5
	TST  R26
	BRMI _0x47
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,16
	BRGE _0x47
	LDD  R26,Y+3
	TST  R26
	BRMI _0x47
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRLT _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 0157         map[X][Y] = TYPE;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x1
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0158 }
_0x46:
	ADIW R28,6
	RET
; .FEND
;
;void Show_On_LED(){
; 0000 015A void Show_On_LED(){
_Show_On_LED:
; .FSTART _Show_On_LED
; 0000 015B     char Temp_Data;
; 0000 015C     int r,c;
; 0000 015D     int temp;
; 0000 015E 
; 0000 015F     for(c=0;c<COL;c++){
	SBIW R28,2
	CALL __SAVELOCR6
;	Temp_Data -> R17
;	r -> R18,R19
;	c -> R20,R21
;	temp -> Y+6
	__GETWRN 20,21,0
_0x4A:
	__CPWRN 20,21,8
	BRGE _0x4B
; 0000 0160 
; 0000 0161     for(r=0,Temp_Data = 0x00;r<DOT_PIXELS;r++){
	__GETWRN 18,19,0
	LDI  R17,LOW(0)
_0x4D:
	__CPWRN 18,19,8
	BRGE _0x4E
; 0000 0162         temp = (map[r][c] > 0)? 1 : 0;
	MOVW R30,R18
	RCALL SUBOPT_0x1
	MOVW R26,R30
	MOVW R30,R20
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x9
	BRGE _0x4F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x50
_0x4F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x50:
	RCALL SUBOPT_0xA
; 0000 0163         Temp_Data = Temp_Data | (temp << r);
; 0000 0164     }
	__ADDWRN 18,19,1
	RJMP _0x4D
_0x4E:
; 0000 0165 
; 0000 0166     DMC = 0;
	CBI  0x12,0
; 0000 0167     D1 = 0x00;
	RCALL SUBOPT_0xB
; 0000 0168     D2 = ptrn[c];
; 0000 0169     D1 = Temp_Data;
; 0000 016A 
; 0000 016B 
; 0000 016C     for(r=0,Temp_Data = 0x00;r<DOT_PIXELS;r++){
	__GETWRN 18,19,0
	LDI  R17,LOW(0)
_0x55:
	__CPWRN 18,19,8
	BRGE _0x56
; 0000 016D         temp = (map[r+DOT_PIXELS][c] > 0)? 1 : 0;
	MOVW R30,R18
	ADIW R30,8
	RCALL SUBOPT_0x1
	MOVW R26,R30
	MOVW R30,R20
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x9
	BRGE _0x57
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x58
_0x57:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x58:
	RCALL SUBOPT_0xA
; 0000 016E         Temp_Data = Temp_Data | (temp << r);
; 0000 016F     }
	__ADDWRN 18,19,1
	RJMP _0x55
_0x56:
; 0000 0170 
; 0000 0171     DMC = 1;
	SBI  0x12,0
; 0000 0172     D1 = 0x00;
	RCALL SUBOPT_0xB
; 0000 0173     D2 = ptrn[c];
; 0000 0174     D1 = Temp_Data;
; 0000 0175 
; 0000 0176     }
	__ADDWRN 20,21,1
	RJMP _0x4A
_0x4B:
; 0000 0177 }
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND

	.DSEG
__7SEGPTRN:
	.BYTE 0xA
_ptrn:
	.BYTE 0x8
_food:
	.BYTE 0x2
_last:
	.BYTE 0x2
_head:
	.BYTE 0x100
_map:
	.BYTE 0x100

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	CALL __LSLW4
	SUBI R30,LOW(-_map)
	SBCI R31,HIGH(-_map)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_head)
	LDI  R27,HIGH(_head)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   X,R30
	MOVW R30,R16
	LDI  R26,LOW(_head)
	LDI  R27,HIGH(_head)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	MOVW R30,R4
	LDI  R26,LOW(_head)
	LDI  R27,HIGH(_head)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_head)
	LDI  R27,HIGH(_head)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDS  R30,_head
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _head,1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _SET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __GETW1P
	CALL __CPW01
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOV  R30,R18
	LDD  R26,Y+6
	CALL __LSLB12
	OR   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	LDI  R26,LOW(_ptrn)
	LDI  R27,HIGH(_ptrn)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	OUT  0x15,R30
	OUT  0x1B,R17
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
