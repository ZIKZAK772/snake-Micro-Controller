#include <mega16.h>

#define COL 8
#define ROW 16

#define DOT_PIXELS 8 // Dotmatrix ROW/COL

#define DMC PORTD.0 // DMC = DOT MATRIX CONTROLLER

#define _7SEG PORTB // 7_SEG is OUTPUT to Control 7 Segment
//boolean exp
#define FALSE 0
#define TRUE 1
#define D1 PORTA // DotMatrix row
#define D2 PORTC // DotMatrix col


// Buttons PIN
#define STOP PIND.3
#define UP PIND.4
#define RIGHT PIND.5
#define DOWN PIND.6
#define LEFT PIND.7

// Directions as an int
#define S 0
#define U 1
#define R 2
#define D 3
#define L 4

// For Working whit Game map
#define EMP 0
#define SNK 1
#define FOD 2

// 7 segment Patterns for numbers
char _7SEGPTRN[10] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67};

// Dot Matrix Pattern to control one columnt at a time
char ptrn[8] = {~0x01,~0x02,~0x04,~0x08,~0x10,~0x20,~0x40,~0x80};

// Game Data
struct point {
    char x,y;
}food,last,head[ROW * COL];

// GAME MAP
int map [ROW][COL];

int not; // Num Of Tail
int dir; // Direction
int lastdir;  // LastDirection

bit win;  // Is Winner ?
bit gameover; // is Game Over ?

void Initial();
void Logic();
void UPD(); // Update Map
void Show(); // SHOW DATA
void Show_On_LED(); // GetData in DotMatrix
void CHFOD();     // Check Food Colision Whit Head
void INC();   // Increase Tail
void SET(int ,int ,int ); // SET DATA in Map

int ttt = 0; // 7SEGMENT OUTPUT
int tt = 0;  // LOGIC CONTOLLER
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    //LOGIC
    tt++;
    if(tt==20){
    if(!gameover)
        Logic();
    tt=0;
    }
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// 7SEG
    if(not<10){
        if(ttt<=5)
        _7SEG = (1<<7) | _7SEGPTRN[not];
        if(ttt>5)
        _7SEG = (0<<7) | _7SEGPTRN[0];
    }
    else
    {
         if(ttt<=5)
        _7SEG = (1<<7) | _7SEGPTRN[not%10];
        if(ttt>5)
        _7SEG = (0<<7) | _7SEGPTRN[not/10];
    }
if(ttt == 10) 
ttt=0;
ttt++;
}                           

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Set Direction Of Snake
if(STOP){
  dir = S;
}
else if(UP)
{
    if(lastdir!=D)
        dir = U;
}
else if(RIGHT)
{   if(lastdir!=L)
        dir = R;

}
else if(DOWN)
{
    if(lastdir!=U)
        dir = D;
}
else if(LEFT)
{
    if(lastdir!=R)
        dir = L;
}

}

void main(void)
{
// Declare your local variables here

DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 0.032 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 0.032 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

// Global enable interrupts
#asm("sei")

// Game LOOP
while (1)
      {
            Initial();

            while(!gameover) {
                Show();
            }

      }
}

void Initial(){

   int r,c;

   for(r=0;r<ROW;r++)
    for(c=0;c<COL;c++)
        map[r][c] = 0;

    gameover = FALSE;
    win = FALSE;

    dir = S;
    lastdir = S;

    not = 0;

    food.x = 1;
    food.y = 5;

    head[0].x = 1;
    head[0].y = 1;

    last.x = head[0].x;
    last.y = head[0].y;

    for(r=1;r<ROW*COL;r++){
        head[r].x = -1;
        head[r].y = -1;
    }
}

void Logic(){
    int i;

    if(dir == S)
            return;

        // Gameover || Win Chexk
        if(not == ROW*COL-1)
        {
            gameover = TRUE;
            win = TRUE;
        }

        // Update Tail
        last.x = head[not].x;
        last.y = head[not].y;
        for(i=not;i>0;i--)
        {
            head[i].x = head[i-1].x;
            head[i].y = head[i-1].y;

        }

        // Move
        switch (dir) {
        case U:
            lastdir = U;
            head[0].x++;
            break;
        case R:
            lastdir = R;
            head[0].y++;
            break;
        case D:
            lastdir = D;
            head[0].x--;
            break;
        case L:
            lastdir = L;
            head[0].y--;
            break;
        }

        // Food Match
        CHFOD();

        // Hit Tail
        for(i=1;i<=not;i++)
            if(head[0].x == head[i].x && head[0].y == head[i].y)
            {
                gameover = TRUE;
                return;
            }

        // Hit wall
        if(head[0].x < 0 || head[0].x >= ROW || head[0].y < 0 || head[0].y >= COL)
        {
            gameover=TRUE;
            return;
        }
}

void CHFOD() {


        if(head[0].x == food.x && head[0].y == food.y) {
            // Replace Food
            SET(head[0].x, head[0].y, SNK);

            // Increase Tail
            INC();
            do{
            food.x = ((int)TCNT0*tt) % 8;
            food.y = ((int)TCNT0) % 8;
            }while(map[food.x][food.y]>0);
        }
    }

void INC() {
    not++;
    head[not].x = last.x;
    head[not].y = last.y;
    last.x = -1;
    last.y = -1;
}

void Show() {
    UPD();
    Show_On_LED();
}

void UPD() {
    SET(last.x, last.y, EMP);
    SET(food.x, food.y, FOD);
    SET(head[0].x, head[0].y, SNK);
}

void SET(int X,int Y,int TYPE) {
    if(X >= 0 && X < ROW && Y >= 0 && Y < COL)
        map[X][Y] = TYPE;
}

void Show_On_LED(){
    char Temp_Data;
    int r,c;
    int temp;

    for(c=0;c<COL;c++){

    for(r=0,Temp_Data = 0x00;r<DOT_PIXELS;r++){
        temp = (map[r][c] > 0)? 1 : 0;
        Temp_Data = Temp_Data | (temp << r);
    }

    DMC = 0;
    D2 = ptrn[c];
    D1 = Temp_Data;


    for(r=0,Temp_Data = 0x00;r<DOT_PIXELS;r++){
        temp = (map[r+DOT_PIXELS][c] > 0)? 1 : 0;
        Temp_Data = Temp_Data | (temp << r);
    }

    DMC = 1;
    D2 = ptrn[c];
    D1 = Temp_Data;

    }
}
