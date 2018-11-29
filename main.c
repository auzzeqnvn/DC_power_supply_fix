/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DC_Power_Supply_Protect
Version : 1.0
Date    : 11/28/2018
Author  : 
Company : 
Comments: 
Bao ve duong nguon DC +24V +12V -12V +5V -5V


Chip type               : ATtiny24
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*******************************************************/

#include <tiny24.h>
#include <delay.h>

#define ADC_Negative_5  1
#define ADC_Negative_12 4
#define ADC_Positive_5  5
#define ADC_Positive_12 3
#define ADC_Positive_24 2


#define ADC_Negative_5_ratio    1
#define ADC_Positive_5_ratio    1

#define ADC_Negative_12_ratio   1
#define ADC_Positive_12_ratio   1

#define ADC_Positive_24_ratio   1

#define ADC_Negative_5_Set_OVER 10
#define ADC_Positive_5_Set_OVER 10

#define ADC_Negative_12_Set_OVER    10
#define ADC_Positive_12_Set_OVER    10

#define ADC_Positive_24_Set_OVER    10

#define CONTROL_UNDER_24    PORTA.7
#define CONTROL_24  PORTA.6
#define BUZZER  PORTB.2

#define CONTROL_UNDER_24_ON CONTROL_UNDER_24=0
#define CONTROL_UNDER_24_OFF CONTROL_UNDER_24=1

#define CONTROL_24_ON   CONTROL_24=0
#define CONTROL_24_OFF  CONTROL_24=1

#define BUZZER_ON   BUZZER = 1
#define BUZZER_OFF  BUZZER = 0


unsigned char  Uc_Negative_5_over_count;
unsigned char  Uc_Negative_5_under_count;

unsigned char  Uc_Positive_5_over_count;
unsigned char  Uc_Positive_5_under_count;

unsigned char  Uc_Positive_12_over_count;
unsigned char  Uc_Positive_12_under_count;

unsigned char  Uc_Negative_12_over_count;
unsigned char  Uc_Negative_12_under_count;

unsigned char  Uc_Positive_24_over_count;
unsigned char  Uc_Positive_24_under_count;


bit  Uc_Negative_5_warning;
bit  Uc_Positive_5_warning;
bit  Uc_Positive_12_warning;
bit  Uc_Negative_12_warning;
bit  Uc_Positive_24_warning;
// Declare your global variables here

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void    Init(void)
{
    Uc_Negative_5_warning = 0;
    Uc_Positive_5_warning = 0;
    Uc_Positive_12_warning = 0;
    Uc_Negative_12_warning = 0;
    Uc_Positive_24_warning = 0;

    Uc_Negative_5_over_count = 0;
    Uc_Negative_5_under_count = 0;
    Uc_Positive_5_over_count = 0;
    Uc_Positive_5_under_count = 0;
    Uc_Positive_12_over_count = 0;
    Uc_Positive_12_under_count = 0;
    Uc_Negative_12_over_count = 0;
    Uc_Negative_12_under_count = 0;
    Uc_Positive_24_over_count = 0;
    Uc_Positive_24_under_count = 0;

    CONTROL_24_ON;
    CONTROL_UNDER_24_ON;

    BUZZER_ON;
    delay_ms(200);
    BUZZER_OFF;
}

void    Protect(void)
{
    unsigned int    Uint_adc_value;

    /* Kiem tra nguon -5vdc */
    Uint_adc_value = read_adc(ADC_Negative_5);
    if(Uint_adc_value*ADC_Negative_5_ratio > ADC_Negative_5_Set_OVER)
    {
        Uc_Negative_5_over_count++;
        if(Uc_Negative_5_over_count > 10)
        {
            Uc_Negative_5_over_count = 11;
            Uc_Negative_5_under_count = 0;
            /* Set warning */
            Uc_Negative_5_warning = 1;
        }
    }
    else
    {
        Uc_Negative_5_under_count++;
        if(Uc_Negative_5_under_count > 10)
        {
            Uc_Negative_5_over_count = 0;
            Uc_Negative_5_under_count = 11;
            /* clear warning */
            Uc_Negative_5_warning = 0;
        }
    }

    /* Kiem tra nguon +5VDC */
    Uint_adc_value = read_adc(ADC_Positive_5);
    if(Uint_adc_value*ADC_Positive_5_ratio > ADC_Positive_5_Set_OVER)
    {
        Uc_Positive_5_over_count++;
        if(Uc_Positive_5_over_count > 10)
        {
            Uc_Positive_5_over_count = 11;
            Uc_Positive_5_under_count = 0;
            /* Set warning */
            Uc_Positive_5_warning = 1;
        }
    }
    else
    {
        Uc_Positive_5_under_count++;
        if(Uc_Positive_5_under_count > 10)
        {
            Uc_Positive_5_over_count = 0;
            Uc_Positive_5_under_count = 11;
            /* clear warning */
            Uc_Positive_5_warning = 0;
        }
    }

    /* Kiem tra nguon -12VDC */
    Uint_adc_value = read_adc(ADC_Negative_12);
    if(Uint_adc_value*ADC_Negative_12_ratio > ADC_Negative_12_Set_OVER)
    {
        Uc_Negative_12_over_count++;
        if(Uc_Negative_12_over_count > 10)
        {
            Uc_Negative_12_over_count = 11;
            Uc_Negative_12_under_count = 0;
            /* Set warning */
            Uc_Negative_12_warning = 1;
        }
    }
    else
    {
        Uc_Negative_12_under_count++;
        if(Uc_Negative_12_under_count > 10)
        {
            Uc_Negative_12_over_count = 0;
            Uc_Negative_12_under_count = 11;
            /* clear warning */
            Uc_Negative_12_warning = 0;
        }
    }

    /* Kiem tra nguon +12VDC */
    Uint_adc_value = read_adc(ADC_Positive_12);
    if(Uint_adc_value*ADC_Positive_12_ratio > ADC_Positive_12_Set_OVER)
    {
        Uc_Positive_12_over_count++;
        if(Uc_Positive_12_over_count > 10)
        {
            Uc_Positive_12_over_count = 11;
            Uc_Positive_12_under_count = 0;
            /* Set warning */
            Uc_Positive_12_warning = 1;
        }
    }
    else
    {
        Uc_Positive_12_under_count++;
        if(Uc_Positive_12_under_count > 10)
        {
            Uc_Positive_12_over_count = 0;
            Uc_Positive_12_under_count = 11;
            /* clear warning */
            Uc_Positive_12_warning = 0;
        }
    }

    /* Kiem tra nguon +24VDC */
    Uint_adc_value = read_adc(ADC_Positive_24);
    if(Uint_adc_value*ADC_Positive_24_ratio > ADC_Positive_24_Set_OVER)
    {
        Uc_Positive_24_over_count++;
        if(Uc_Positive_24_over_count > 10)
        {
            Uc_Positive_24_over_count = 11;
            Uc_Positive_24_under_count = 0;
            /* Set warning */
            Uc_Positive_24_warning = 1;
        }
    }
    else
    {
        Uc_Positive_24_under_count++;
        if(Uc_Positive_24_under_count > 10)
        {
            Uc_Positive_24_over_count = 0;
            Uc_Positive_24_under_count = 11;
            /* clear warning */
            Uc_Positive_24_warning = 0;
        }
    }

    if(Uc_Negative_5_warning || Uc_Negative_12_warning || Uc_Positive_5_warning || Uc_Positive_12_warning)
    {
        CONTROL_UNDER_24_OFF;
    }
    else
    {
        CONTROL_UNDER_24_ON;
    }

    if(Uc_Positive_24_warning)
    {
        CONTROL_24_OFF;
    }
    else
    {
        CONTROL_24_ON;
    }
    delay_ms(10);
}

void main(void)
{
    // Declare your local variables here

    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=(1<<CLKPCE);
    CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRA=(1<<DDA7) | (1<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    // State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    // Port B initialization
    // Function: Bit3=In Bit2=Out Bit1=In Bit0=In 
    DDRB=(0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
    // State: Bit3=T Bit2=0 Bit1=T Bit0=T 
    PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0A output: Disconnected
    // OC0B output: Disconnected
    TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
    TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0A=0x00;
    OCR0B=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer1 Stopped
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 0 Interrupt(s) initialization
    TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

    // Timer/Counter 1 Interrupt(s) initialization
    TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

    // External Interrupt(s) initialization
    // INT0: Off
    // Interrupt on any change on pins PCINT0-7: Off
    // Interrupt on any change on pins PCINT8-11: Off
    MCUCR=(0<<ISC01) | (0<<ISC00);
    GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);

    // USI initialization
    // Mode: Disabled
    // Clock source: Register & Counter=no clk.
    // USI Counter Overflow Interrupt: Off
    USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);

    // Analog Comparator initialization
    // Analog Comparator: Off
    // The Analog Comparator's positive input is
    // connected to the AIN0 pin
    // The Analog Comparator's negative input is
    // connected to the AIN1 pin
    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
    // Digital input buffer on AIN0: On
    // Digital input buffer on AIN1: On
    DIDR0=(0<<ADC1D) | (0<<ADC2D);

    // ADC initialization
    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    // ADC Bipolar Input Mode: Off
    // ADC Auto Trigger Source: ADC Stopped
    // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
    // ADC4: On, ADC5: On, ADC6: On, ADC7: On
    DIDR0=(0<<ADC7D) | (0<<ADC6D) | (0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

    Init();
    while (1)
    {
    // Place your code here
        //Protect();
        CONTROL_UNDER_24_OFF;
        CONTROL_24_OFF;
        delay_ms(5000);
        CONTROL_UNDER_24_ON;
        CONTROL_24_ON;
        delay_ms(5000);

    }
}
