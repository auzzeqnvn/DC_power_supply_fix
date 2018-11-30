
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny24
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny24
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

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
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uc_Negative_5_over_count=R3
	.DEF _Uc_Negative_5_under_count=R2
	.DEF _Uc_Positive_5_over_count=R5
	.DEF _Uc_Positive_5_under_count=R4
	.DEF _Uc_Positive_12_over_count=R7
	.DEF _Uc_Positive_12_under_count=R6
	.DEF _Uc_Negative_12_over_count=R9
	.DEF _Uc_Negative_12_under_count=R8
	.DEF _Uc_Positive_24_over_count=R11
	.DEF _Uc_Positive_24_under_count=R10
	.DEF _Uint_Warning_timer=R12
	.DEF _Uint_Warning_timer_msb=R13

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x90,0x1


__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DC_Power_Supply_Protect
;Version : 1.0
;Date    : 11/28/2018
;Author  :
;Company :
;Comments:
;Bao ve duong nguon DC +24V +12V -12V +5V -5V
;
;
;Chip type               : ATtiny24
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*******************************************************/
;
;#include <tiny24.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define ADC_Negative_5  1
;#define ADC_Negative_12 4
;#define ADC_Positive_5  5
;#define ADC_Positive_12 3
;#define ADC_Positive_24 2
;
;#define ADC_Negative_5_Set_OVER 450
;#define ADC_Positive_5_Set_OVER 450
;#define ADC_Negative_12_Set_OVER    450
;#define ADC_Positive_12_Set_OVER    450
;#define ADC_Positive_24_Set_OVER    460
;
;
;#define CONTROL_UNDER_24    PORTA.7
;#define CONTROL_24  PORTA.6
;#define BUZZER  PORTB.2
;
;#define CONTROL_UNDER_24_ON CONTROL_UNDER_24=0
;#define CONTROL_UNDER_24_OFF CONTROL_UNDER_24=1
;
;#define CONTROL_24_ON   CONTROL_24=1
;#define CONTROL_24_OFF  CONTROL_24=0
;
;#define BUZZER_ON   BUZZER = 1
;#define BUZZER_OFF  BUZZER = 0
;
;#define TIME_BUZZER 40
;#define TIME_WARNING    500
;
;
;unsigned char  Uc_Negative_5_over_count;
;unsigned char  Uc_Negative_5_under_count;
;
;unsigned char  Uc_Positive_5_over_count;
;unsigned char  Uc_Positive_5_under_count;
;
;unsigned char  Uc_Positive_12_over_count;
;unsigned char  Uc_Positive_12_under_count;
;
;unsigned char  Uc_Negative_12_over_count;
;unsigned char  Uc_Negative_12_under_count;
;
;unsigned char  Uc_Positive_24_over_count;
;unsigned char  Uc_Positive_24_under_count;
;
;unsigned int    Uint_Warning_timer = 400;
;
;
;bit  Uc_Negative_5_warning;
;bit  Uc_Positive_5_warning;
;bit  Uc_Positive_12_warning;
;bit  Uc_Negative_12_warning;
;bit  Uc_Positive_24_warning;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0057 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0058 ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x3F)
	OUT  0x7,R30
; 0000 0059 // Delay needed for the stabilization of the ADC input voltage
; 0000 005A delay_us(10);
	__DELAY_USB 27
; 0000 005B // Start the AD conversion
; 0000 005C ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 005D // Wait for the AD conversion to complete
; 0000 005E while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 005F ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0060 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0061 }
; .FEND
;
;void    Init(void)
; 0000 0064 {
_Init:
; .FSTART _Init
; 0000 0065     Uc_Negative_5_warning = 0;
	CBI  0x13,0
; 0000 0066     Uc_Positive_5_warning = 0;
	CBI  0x13,1
; 0000 0067     Uc_Positive_12_warning = 0;
	CBI  0x13,2
; 0000 0068     Uc_Negative_12_warning = 0;
	CBI  0x13,3
; 0000 0069     Uc_Positive_24_warning = 0;
	CBI  0x13,4
; 0000 006A 
; 0000 006B     Uc_Negative_5_over_count = 0;
	CLR  R3
; 0000 006C     Uc_Negative_5_under_count = 0;
	CLR  R2
; 0000 006D     Uc_Positive_5_over_count = 0;
	CLR  R5
; 0000 006E     Uc_Positive_5_under_count = 0;
	CLR  R4
; 0000 006F     Uc_Positive_12_over_count = 0;
	CLR  R7
; 0000 0070     Uc_Positive_12_under_count = 0;
	CLR  R6
; 0000 0071     Uc_Negative_12_over_count = 0;
	CLR  R9
; 0000 0072     Uc_Negative_12_under_count = 0;
	CLR  R8
; 0000 0073     Uc_Positive_24_over_count = 0;
	CLR  R11
; 0000 0074     Uc_Positive_24_under_count = 0;
	CLR  R10
; 0000 0075 
; 0000 0076     CONTROL_24_ON;
	SBI  0x1B,6
; 0000 0077     CONTROL_UNDER_24_ON;
	CBI  0x1B,7
; 0000 0078 
; 0000 0079     BUZZER_ON;
	SBI  0x18,2
; 0000 007A     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 007B     BUZZER_OFF;
	CBI  0x18,2
; 0000 007C }
	RET
; .FEND
;
;void    Protect(void)
; 0000 007F {
_Protect:
; .FSTART _Protect
; 0000 0080     unsigned int    Uint_adc_value;
; 0000 0081 
; 0000 0082     /* Kiem tra nguon -5vdc */
; 0000 0083     Uint_adc_value = read_adc(ADC_Negative_5);
	RCALL __SAVELOCR2
;	Uint_adc_value -> R16,R17
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x0
; 0000 0084     if(Uint_adc_value > ADC_Negative_5_Set_OVER)
	BRLO _0x18
; 0000 0085     {
; 0000 0086         Uc_Negative_5_over_count++;
	INC  R3
; 0000 0087         if(Uc_Negative_5_over_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R3
	BRSH _0x19
; 0000 0088         {
; 0000 0089             Uc_Negative_5_over_count = 11;
	LDI  R30,LOW(11)
	MOV  R3,R30
; 0000 008A             Uc_Negative_5_under_count = 0;
	CLR  R2
; 0000 008B             /* Set warning */
; 0000 008C             Uc_Negative_5_warning = 1;
	SBI  0x13,0
; 0000 008D         }
; 0000 008E     }
_0x19:
; 0000 008F     else
	RJMP _0x1C
_0x18:
; 0000 0090     {
; 0000 0091         Uc_Negative_5_under_count++;
	INC  R2
; 0000 0092         if(Uc_Negative_5_under_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R2
	BRSH _0x1D
; 0000 0093         {
; 0000 0094             Uc_Negative_5_over_count = 0;
	CLR  R3
; 0000 0095             Uc_Negative_5_under_count = 11;
	LDI  R30,LOW(11)
	MOV  R2,R30
; 0000 0096             /* clear warning */
; 0000 0097             Uc_Negative_5_warning = 0;
	CBI  0x13,0
; 0000 0098         }
; 0000 0099     }
_0x1D:
_0x1C:
; 0000 009A 
; 0000 009B     /* Kiem tra nguon +5VDC */
; 0000 009C     Uint_adc_value = read_adc(ADC_Positive_5);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x0
; 0000 009D     if(Uint_adc_value > ADC_Positive_5_Set_OVER)
	BRLO _0x20
; 0000 009E     {
; 0000 009F         Uc_Positive_5_over_count++;
	INC  R5
; 0000 00A0         if(Uc_Positive_5_over_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R5
	BRSH _0x21
; 0000 00A1         {
; 0000 00A2             Uc_Positive_5_over_count = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 00A3             Uc_Positive_5_under_count = 0;
	CLR  R4
; 0000 00A4             /* Set warning */
; 0000 00A5             Uc_Positive_5_warning = 1;
	SBI  0x13,1
; 0000 00A6         }
; 0000 00A7     }
_0x21:
; 0000 00A8     else
	RJMP _0x24
_0x20:
; 0000 00A9     {
; 0000 00AA         Uc_Positive_5_under_count++;
	INC  R4
; 0000 00AB         if(Uc_Positive_5_under_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R4
	BRSH _0x25
; 0000 00AC         {
; 0000 00AD             Uc_Positive_5_over_count = 0;
	CLR  R5
; 0000 00AE             Uc_Positive_5_under_count = 11;
	LDI  R30,LOW(11)
	MOV  R4,R30
; 0000 00AF             /* clear warning */
; 0000 00B0             Uc_Positive_5_warning = 0;
	CBI  0x13,1
; 0000 00B1         }
; 0000 00B2     }
_0x25:
_0x24:
; 0000 00B3 
; 0000 00B4     /* Kiem tra nguon -12VDC */
; 0000 00B5     Uint_adc_value = read_adc(ADC_Negative_12);
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x0
; 0000 00B6     if(Uint_adc_value > ADC_Negative_12_Set_OVER)
	BRLO _0x28
; 0000 00B7     {
; 0000 00B8         Uc_Negative_12_over_count++;
	INC  R9
; 0000 00B9         if(Uc_Negative_12_over_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R9
	BRSH _0x29
; 0000 00BA         {
; 0000 00BB             Uc_Negative_12_over_count = 11;
	LDI  R30,LOW(11)
	MOV  R9,R30
; 0000 00BC             Uc_Negative_12_under_count = 0;
	CLR  R8
; 0000 00BD             /* Set warning */
; 0000 00BE             Uc_Negative_12_warning = 1;
	SBI  0x13,3
; 0000 00BF         }
; 0000 00C0     }
_0x29:
; 0000 00C1     else
	RJMP _0x2C
_0x28:
; 0000 00C2     {
; 0000 00C3         Uc_Negative_12_under_count++;
	INC  R8
; 0000 00C4         if(Uc_Negative_12_under_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R8
	BRSH _0x2D
; 0000 00C5         {
; 0000 00C6             Uc_Negative_12_over_count = 0;
	CLR  R9
; 0000 00C7             Uc_Negative_12_under_count = 11;
	LDI  R30,LOW(11)
	MOV  R8,R30
; 0000 00C8             /* clear warning */
; 0000 00C9             Uc_Negative_12_warning = 0;
	CBI  0x13,3
; 0000 00CA         }
; 0000 00CB     }
_0x2D:
_0x2C:
; 0000 00CC 
; 0000 00CD     /* Kiem tra nguon +12VDC */
; 0000 00CE     Uint_adc_value = read_adc(ADC_Positive_12);
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x0
; 0000 00CF     if(Uint_adc_value > ADC_Positive_12_Set_OVER)
	BRLO _0x30
; 0000 00D0     {
; 0000 00D1         Uc_Positive_12_over_count++;
	INC  R7
; 0000 00D2         if(Uc_Positive_12_over_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x31
; 0000 00D3         {
; 0000 00D4             Uc_Positive_12_over_count = 11;
	LDI  R30,LOW(11)
	MOV  R7,R30
; 0000 00D5             Uc_Positive_12_under_count = 0;
	CLR  R6
; 0000 00D6             /* Set warning */
; 0000 00D7             Uc_Positive_12_warning = 1;
	SBI  0x13,2
; 0000 00D8         }
; 0000 00D9     }
_0x31:
; 0000 00DA     else
	RJMP _0x34
_0x30:
; 0000 00DB     {
; 0000 00DC         Uc_Positive_12_under_count++;
	INC  R6
; 0000 00DD         if(Uc_Positive_12_under_count > 10)
	LDI  R30,LOW(10)
	CP   R30,R6
	BRSH _0x35
; 0000 00DE         {
; 0000 00DF             Uc_Positive_12_over_count = 0;
	CLR  R7
; 0000 00E0             Uc_Positive_12_under_count = 11;
	LDI  R30,LOW(11)
	MOV  R6,R30
; 0000 00E1             /* clear warning */
; 0000 00E2             Uc_Positive_12_warning = 0;
	CBI  0x13,2
; 0000 00E3         }
; 0000 00E4     }
_0x35:
_0x34:
; 0000 00E5 
; 0000 00E6     /* Kiem tra nguon +24VDC */
; 0000 00E7     Uint_adc_value = read_adc(ADC_Positive_24);
	LDI  R26,LOW(2)
	RCALL _read_adc
	MOVW R16,R30
; 0000 00E8     //Uint_adc_value = 150;
; 0000 00E9     if(Uint_adc_value > ADC_Positive_24_Set_OVER)
	__CPWRN 16,17,461
	BRLO _0x38
; 0000 00EA     {
; 0000 00EB         Uc_Positive_24_over_count++;
	INC  R11
; 0000 00EC         if(Uc_Positive_24_over_count > 5)
	LDI  R30,LOW(5)
	CP   R30,R11
	BRSH _0x39
; 0000 00ED         {
; 0000 00EE             Uc_Positive_24_over_count = 11;
	LDI  R30,LOW(11)
	MOV  R11,R30
; 0000 00EF             Uc_Positive_24_under_count = 0;
	CLR  R10
; 0000 00F0             /* Set warning */
; 0000 00F1             Uc_Positive_24_warning = 1;
	SBI  0x13,4
; 0000 00F2         }
; 0000 00F3     }
_0x39:
; 0000 00F4     else
	RJMP _0x3C
_0x38:
; 0000 00F5     {
; 0000 00F6         Uc_Positive_24_under_count++;
	INC  R10
; 0000 00F7         if(Uc_Positive_24_under_count > 5)
	LDI  R30,LOW(5)
	CP   R30,R10
	BRSH _0x3D
; 0000 00F8         {
; 0000 00F9             Uc_Positive_24_over_count = 0;
	CLR  R11
; 0000 00FA             Uc_Positive_24_under_count = 11;
	LDI  R30,LOW(11)
	MOV  R10,R30
; 0000 00FB             /* clear warning */
; 0000 00FC             Uc_Positive_24_warning = 0;
	CBI  0x13,4
; 0000 00FD         }
; 0000 00FE     }
_0x3D:
_0x3C:
; 0000 00FF 
; 0000 0100     if(Uc_Negative_5_warning || Uc_Negative_12_warning || Uc_Positive_5_warning || Uc_Positive_12_warning)
	SBIC 0x13,0
	RJMP _0x41
	SBIC 0x13,3
	RJMP _0x41
	SBIC 0x13,1
	RJMP _0x41
	SBIS 0x13,2
	RJMP _0x40
_0x41:
; 0000 0101     {
; 0000 0102         CONTROL_UNDER_24_OFF;
	SBI  0x1B,7
; 0000 0103         Uint_Warning_timer = 0;
	CLR  R12
	CLR  R13
; 0000 0104         // BUZZER_ON;
; 0000 0105     }
; 0000 0106     else  if(Uint_Warning_timer == TIME_WARNING)
	RJMP _0x45
_0x40:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x46
; 0000 0107     {
; 0000 0108         CONTROL_UNDER_24_ON;
	CBI  0x1B,7
; 0000 0109         BUZZER_OFF;
	CBI  0x18,2
; 0000 010A     }
; 0000 010B 
; 0000 010C     if(Uc_Positive_24_warning)
_0x46:
_0x45:
	SBIS 0x13,4
	RJMP _0x4B
; 0000 010D     {
; 0000 010E         CONTROL_24_OFF;
	CBI  0x1B,6
; 0000 010F         Uint_Warning_timer = 0;
	CLR  R12
	CLR  R13
; 0000 0110     }
; 0000 0111     else if(Uint_Warning_timer >= TIME_WARNING)
	RJMP _0x4E
_0x4B:
	RCALL SUBOPT_0x1
	BRLO _0x4F
; 0000 0112     {
; 0000 0113         CONTROL_24_ON;
	SBI  0x1B,6
; 0000 0114     }
; 0000 0115 
; 0000 0116 
; 0000 0117     if(Uint_Warning_timer < TIME_WARNING)
_0x4F:
_0x4E:
	RCALL SUBOPT_0x1
	BRSH _0x52
; 0000 0118     {
; 0000 0119         Uint_Warning_timer++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 011A         if(Uint_Warning_timer%TIME_BUZZER == 0)
	MOVW R26,R12
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL __MODW21U
	SBIW R30,0
	BRNE _0x53
; 0000 011B         {
; 0000 011C             BUZZER = !BUZZER;
	SBIS 0x18,2
	RJMP _0x54
	CBI  0x18,2
	RJMP _0x55
_0x54:
	SBI  0x18,2
_0x55:
; 0000 011D         }
; 0000 011E     }
_0x53:
; 0000 011F     else
	RJMP _0x56
_0x52:
; 0000 0120     {
; 0000 0121         BUZZER_OFF;
	CBI  0x18,2
; 0000 0122     }
_0x56:
; 0000 0123     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0124 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0127 {
_main:
; .FSTART _main
; 0000 0128     // Declare your local variables here
; 0000 0129 
; 0000 012A     // Crystal Oscillator division factor: 1
; 0000 012B     #pragma optsize-
; 0000 012C     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 012D     CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 012E     #ifdef _OPTIMIZE_SIZE_
; 0000 012F     #pragma optsize+
; 0000 0130     #endif
; 0000 0131 
; 0000 0132     // Input/Output Ports initialization
; 0000 0133     // Port A initialization
; 0000 0134     // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0135     DDRA=(1<<DDA7) | (1<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(192)
	OUT  0x1A,R30
; 0000 0136     // State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0137     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0138 
; 0000 0139     // Port B initialization
; 0000 013A     // Function: Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 013B     DDRB=(0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(4)
	OUT  0x17,R30
; 0000 013C     // State: Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 013D     PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 013E 
; 0000 013F     // Timer/Counter 0 initialization
; 0000 0140     // Clock source: System Clock
; 0000 0141     // Clock value: Timer 0 Stopped
; 0000 0142     // Mode: Normal top=0xFF
; 0000 0143     // OC0A output: Disconnected
; 0000 0144     // OC0B output: Disconnected
; 0000 0145     TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x30,R30
; 0000 0146     TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0147     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0148     OCR0A=0x00;
	OUT  0x36,R30
; 0000 0149     OCR0B=0x00;
	OUT  0x3C,R30
; 0000 014A 
; 0000 014B     // Timer/Counter 1 initialization
; 0000 014C     // Clock source: System Clock
; 0000 014D     // Clock value: Timer1 Stopped
; 0000 014E     // Mode: Normal top=0xFFFF
; 0000 014F     // OC1A output: Disconnected
; 0000 0150     // OC1B output: Disconnected
; 0000 0151     // Noise Canceler: Off
; 0000 0152     // Input Capture on Falling Edge
; 0000 0153     // Timer1 Overflow Interrupt: Off
; 0000 0154     // Input Capture Interrupt: Off
; 0000 0155     // Compare A Match Interrupt: Off
; 0000 0156     // Compare B Match Interrupt: Off
; 0000 0157     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0158     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0159     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 015A     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 015B     ICR1H=0x00;
	OUT  0x25,R30
; 0000 015C     ICR1L=0x00;
	OUT  0x24,R30
; 0000 015D     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 015E     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 015F     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0160     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0161 
; 0000 0162     // Timer/Counter 0 Interrupt(s) initialization
; 0000 0163     TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0164 
; 0000 0165     // Timer/Counter 1 Interrupt(s) initialization
; 0000 0166     TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	OUT  0xC,R30
; 0000 0167 
; 0000 0168     // External Interrupt(s) initialization
; 0000 0169     // INT0: Off
; 0000 016A     // Interrupt on any change on pins PCINT0-7: Off
; 0000 016B     // Interrupt on any change on pins PCINT8-11: Off
; 0000 016C     MCUCR=(0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 016D     GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);
	OUT  0x3B,R30
; 0000 016E 
; 0000 016F     // USI initialization
; 0000 0170     // Mode: Disabled
; 0000 0171     // Clock source: Register & Counter=no clk.
; 0000 0172     // USI Counter Overflow Interrupt: Off
; 0000 0173     USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);
	OUT  0xD,R30
; 0000 0174 
; 0000 0175     // Analog Comparator initialization
; 0000 0176     // Analog Comparator: Off
; 0000 0177     // The Analog Comparator's positive input is
; 0000 0178     // connected to the AIN0 pin
; 0000 0179     // The Analog Comparator's negative input is
; 0000 017A     // connected to the AIN1 pin
; 0000 017B     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017C     // Digital input buffer on AIN0: On
; 0000 017D     // Digital input buffer on AIN1: On
; 0000 017E     DIDR0=(0<<ADC1D) | (0<<ADC2D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 017F 
; 0000 0180     // ADC initialization
; 0000 0181     // ADC Clock frequency: 1000.000 kHz
; 0000 0182     // ADC Voltage Reference: AVCC pin
; 0000 0183     // ADC Bipolar Input Mode: Off
; 0000 0184     // ADC Auto Trigger Source: ADC Stopped
; 0000 0185     // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0186     // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 0187     DIDR0=(0<<ADC7D) | (0<<ADC6D) | (0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	OUT  0x1,R30
; 0000 0188     ADMUX=ADC_VREF_TYPE;
	OUT  0x7,R30
; 0000 0189     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 018A     ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 018B 
; 0000 018C     Init();
	RCALL _Init
; 0000 018D     while (1)
_0x59:
; 0000 018E     {
; 0000 018F     // Place your code here
; 0000 0190         Protect();
	RCALL _Protect
; 0000 0191     }
	RJMP _0x59
; 0000 0192 }
_0x5C:
	RJMP _0x5C
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	RCALL _read_adc
	MOVW R16,R30
	__CPWRN 16,17,451
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R12,R30
	CPC  R13,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
