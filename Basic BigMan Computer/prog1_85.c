#include <stdio.h>
#include <assert.h>

/*
    Program:
        1c801ec00690000020b0167002e01c8000401c90006000004142430018000080ff00

        - BBC's instructions are, X[12-15] + Y[0-11] -
        
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 
       PC-   LE  =  BE  = op + val -->  cmd meaning
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 
        0-  1c80 = 801c =  8 + 1c  -->  A = RAM[01c]
        2-  1ec0 = c01e =  c + 1e  -->  A = A | RAM[01e]
        4-  0690 = 9006 =  9 + 6   -->  RAM[6]= A
        6-  0000                        Data - "4-"
        8-  20b0 = b020 =  b + 20  -->  A = A & RAM[20]
        10- 1670 = 7016 =  7 + 16  -->  if (A == 0) PC = 16          ! THIS SKIPS PRINTF !
        12- 02e0 = e002 =  e + 2   -->  write(A, mode=2)
        14- 1c80 = 801c =  8 + 1c  -->  A = RAM[1c]
        16- 0040 = 4000 =  4 + 0   -->  A++                          ! THIS IS PC 16 !
        18- 1c90 = 901c =  9 + 1c  -->  RAM[1c]= A
        20- 0060 = 6000 =  6 + 0   -->  PC = 0
        22- 0000                        HALT
        24- 4142 = 4241 =  4 + 241 -->  Data - A++
        26- 4300 = 0043 =  0 + 43  -->  Data - HALT
        28- 1800 = 0018 =  0 + 18  -->  Data - HALT
        30- 0080 = 8000 =  8 + 00  -->  Data - A = RAM[0]
        32- ff00 = 00ff =  0 + ff  -->  Data - HALT     
*/

typedef unsigned short word; // - 16 bits
typedef unsigned char byte;  // - 8 bits

byte RAM[4096] = {0}; //        The DB for both the running cmd prog. and stored values.
word A = 0;           //        The local memory variable from cmd to cmd.
int PC = 0;           //        The var which remembers what RAM[...] you will read on the next while loop.
int EX_CNT = 0;       //        For debugging. Count number of opcodes executed.

//

int main()
{
    char *program = "1c801ec00690000020b0167002e01c8000401c90006000004142430018000080ff00";

    run(program);
    return 0;
}

//
//

//  Run program until step() returns 0
int run(char *program)
{
    // Get LE program and store its bytes as LE in RAM
    for (int i = 0; i < strlen(program); i += 2)
        RAM[i / 2] = asciiToHex(program[i]) << 4 | asciiToHex(program[i + 1]);

    int RUN = 1;
    while (RUN && EX_CNT < 38)
        RUN = step();

    return 0;
}

//
//

int step()
{
    word ram_cmd = load(PC);

    byte opcode = ram_cmd >> 12 & 0x0F;

    word Y = ram_cmd & 0xFFF;

    if (opcode)
    {
        PC += 2;
        ++EX_CNT;
    }

    return cmd(opcode, Y);
}

//
//

int store(unsigned Y)
{
    // BE -> LE ....xxxx
    byte A_lil = A;
    RAM[Y] = A_lil;

    // BE -> LE xxxx....
    byte A_big = A >> 8 & 0x00FF;
    RAM[Y + 1] = A_big;

    return 0;
}

//
//

int load(unsigned Y)
{
    // LE -> BE
    word value = (RAM[Y + 1] << 8) | RAM[Y];
    return value;
}

//
//

int asciiToHex(char ascii)
{
    if ('0' <= ascii && ascii <= '9')
        return ascii - '0';
    if ('A' <= ascii && ascii <= 'F')
        return ascii - 'A' + 10;
    if ('a' <= ascii && ascii <= 'f')
        return ascii - 'a' + 10;

    return 0;
}

//
//

int cmd(byte opcode, word Y)
{
    switch (opcode)
    {
    case 0: //              HALT
        return 0;

    case 1: //              ~
        A = ~A;
        break;

    case 2: //              <<
        A = A << Y;
        break;

    case 3: //              >>
        A = A >> Y;
        break;

    case 4: //              ++
        ++A;
        break;

    case 5: //              --
        --A;
        break;

    case 6: //              Jump to
        PC = Y;
        break;

    case 7: //              Break
        if (A == 0)
            PC = Y;
        break;

    case 8: //              Assign A
        A = load(Y);
        break;

    case 9: //              Assign RAM
        store(Y);
        break;

    case 10: //             +
        A = A + load(Y);
        break;

    case 11: //             &
        A = A & load(Y);
        break;

    case 12: //             |
        A = A | load(Y);
        break;

    case 13: //             ^
        A = A ^ load(Y);
        break;

    case 14: //             Print
        switch (Y)
        {
        case 1:
            printf("%d", A);
            break;

        case 2:
            printf("%c", A);
            break;

        default:
            printf("%x", A);
        }
        break;

    case 15: //             Read
        printf("READ");
        switch (Y)
        {
        case 1:
            break;

        case 2:
            break;

        default:
            break;
        }
        break;

    default:;
    }

    return 1;
}