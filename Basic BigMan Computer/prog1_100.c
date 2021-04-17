#include <stdio.h>
#include <assert.h>
/*
    TODO:
        1. confirm e index_col print
        2. set e range check
        3. read from file name   
*/

typedef unsigned short word;
typedef unsigned char byte;

byte RAM[4096] = {0};
word A = 0;
int PC = 0;

//
//

int main()
{
    char *program = "1c801ec00690000020b0167002e01c8000401c90006000004142430018000080ff00";

    // Get LE program and store its bytes as LE in RAM
    for (int i = 0; i < strlen(program); i += 2)
        RAM[i / 2] = asciiToHex(program[i]) << 4 | asciiToHex(program[i + 1]);

    printf("___________________________________________\n");
    printf("\n Welcome to the Sith-inator Dark Edition.");
    printf("\n    What is your bidding, my master.");
    printf("\n___________________________________________\n\n");

    // begin sith-input
    int RUN = 1;
    while (RUN)
    {
        RUN = scan(program);
    }

    return 0;
}

int scan()
{
    char cmd = 0;
    printf("\n? ");
    scanf(" %c", &cmd);

    switch (cmd)
    {
    case 'a':
        printf("A = %x\n", A);
        printf("PC = %x\n", PC);
        break;

    case 'd':
        int start, length = 0;
        scanf(" %x %x", &start, &length);
        sith_Dump(start, length);
        return 1;

    case 'e':
        int address, value = 0;
        scanf(" %d %d", &address, &value);

        if (0 <= value <= 255 && 0 <= address <= 4094)
        {
            sith_store(address, value);
        }
        else
        {
            printf("Bid something within range, master.\n");
        }
        return 1;

    case 'h':
        printf("Ok, master, these are your possible biddings:\n");
        printf("a, use the force of mind to pry the secrets from Acc and PC, in hexadecimal\n");
        printf("   (while remaining within galactic standards of mental torture and interegation).\n");
        printf("d, jump a sith-specified range of meters into the air\n");
        printf("e, edit a single double bite of JAM to re-contain a new price.\n");
        printf("h, make me repeat myself (not cool master).\n");
        printf("q, depose your darkship from being dark lord.\n");
        printf("r, run Luke over with a moped (very dark and nasty, master).\n");
        printf("s, step on a watermelon (a little too dark if you ask me).\n");
        break;

    case 'q':
        printf("Goodbye, master.\n");
        return 0;

    case 'r':
        run();
        return 1;

    case 's':
        printf("PC      = %d\n", PC);
        printf("A       = %x\n", A);
        step();
        return 1;

    default:
        printf("Invalid bidding, my master. Enter 'h' to get some help, my master.\n");
    }

    return 1;
}

int sith_Dump(int start, int length)
{
    if (start + length > 0xFFF)
    {
        printf("Print range exceeded the size of RAM.\n");
        return 1;
    }

    int index_length = 0;
    int index_col = start;

    for (int x = 0; x <= length / 15; ++x)
    {
        if (index_length < length)
        {
            if (index_col < 0)
            {
                return 0;
            }
            else if (index_col < 10)
            {
                printf("00%d     ", index_col);
            }
            else if (index_col < 100)
            {
                printf("0%d     ", index_col);
            }
            else if (index_col < 1000)
            {
                printf("%d     ", index_col);
            }

            for (int y = 0; y <= 15; ++y)
            {
                int text = RAM[start + index_length];

                if (text < 16)
                {
                    printf("0%x ", RAM[start + index_length]);
                }
                else
                {
                    printf("%2x ", RAM[start + index_length]);
                }

                ++index_length;
            }

            index_col += 10;
            printf("\n");
        }
    }

    return 0;
}

//
//

//  Run program until step() returns 0
int run()
{
    A = 0;
    PC = 0;
    int r_RUN = 1;
    while (r_RUN)
        r_RUN = step();

    A = 0;
    PC = 0;
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
        PC += 2;

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

int sith_store(unsigned Y, unsigned value)
{
    // BE -> LE ....xxxx
    byte value_lil = value;
    RAM[Y] = value_lil;

    // BE -> LE xxxx....
    byte value_big = value >> 8 & 0x00FF;
    RAM[Y + 1] = value_big;

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
        printf("HALT\n");
        return 0;

    case 1: //              ~
        printf("NOT");
        A = ~A;
        break;

    case 2: //              <<
        printf("SHT_L");
        A = A << Y;
        break;

    case 3: //              >>
        printf("SHT_R");
        A = A >> Y;
        break;

    case 4: //              ++
        printf("++");
        ++A;
        break;

    case 5: //              --
        printf("--");
        --A;
        break;

    case 6: //              Jump to
        printf("JMP to %d", Y);
        PC = Y;
        break;

    case 7: //              Break
        printf("BREAK to %d", Y);
        if (A == 0)
            PC = Y;
        break;

    case 8: //              Assign A
        printf("LOAD");
        A = load(Y);
        break;

    case 9: //              Assign RAM
        printf("STORE");
        store(Y);
        break;

    case 10: //             +
        printf("+");
        A = A + load(Y);
        break;

    case 11: //             &
        printf("AND", A, load(Y));
        A = A & load(Y);
        break;

    case 12: //             |
        printf("|");
        A = A | load(Y);
        break;

    case 13: //             ^
        printf("^");
        A = A ^ load(Y);
        break;

    case 14: //             Print
        printf("PRINT: ");
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
            unsigned int a1 = 0;
            scanf("%x", &a1);
            break;

        case 2:
            int a2 = 0;
            scanf("%d", &a2);
            break;

        default:
            char a3 = 0;
            scanf("%c", &a3);
            break;
        }
        break;

    default:;
    }

    printf("\n");
    return 1;
}