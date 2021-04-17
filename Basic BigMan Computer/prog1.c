#include <stdio.h>
#include <assert.h>
#include <string.h>

/* Useful code for later:
    "w+" , "w+b"
    fwrite(content, for 'strlen + 1' chars, unknown, using Object file_editor);
    fwrite(content, strlen(content) + 1, 1, file_editor);
    fseek back to beginning
    fseek(file_editor, 0, SEEK_SET); 
*/

typedef unsigned short word;
typedef unsigned char byte;

byte RAM[4096] = {0};
word A = 0;
int PC = 0;

//

int main(int argc, char *argv[])
{
    // user input syntax check
    if (argc != 2)
        return printf("Input a single file name when you beckon the program, master.\n");

    FILE *file_editor;
    char program[4096];

    if (file_editor = fopen(argv[1], "r"))
    {
        // read file program into RAM
        fread(program, 4096, 1, file_editor);
        printf("Loaded Program: %s\n", program);
        fclose(file_editor);

        // Get LE program and store its bytes as LE in RAM
        for (int i = 0; i < strlen(program); i += 2)
            RAM[i / 2] = asciiToHex(program[i]) << 4 | asciiToHex(program[i + 1]);

        printf("_________________________________________________\n");
        printf("\n Welcome to the Sith-inator Auction Edition.");
        printf("\n    What is your bidding, my master.");
        printf("\n_______________________________________________\n\n");

        // begin sith-user input
        int RUN = 1;
        while (RUN)
            RUN = scan(program);

        return 0;
    }
    else
    {
        printf("File was not found, my master. Use your sith powers to try again.\n");
        return 0;
    }
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

        if (0 <= value && value < 256 && 0 <= address && address < 4096)
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
        printf("   (while probably remaining within intergalactic legal conventions of mental torture and interegation).\n");
        printf("d, jump a sith-specified range of meters into the air\n");
        printf("e, edit a single double bite of JAM to re-contain a new auction value.\n");
        printf("h, make me repeat myself (not cool, master).\n");
        printf("q, depose your darkship from being bidding dark lord.\n");
        printf("r, run Luke over with a moped (very dark and nasty, master).\n");
        printf("s, step on an antique watermelon (a little too dark if you ask me, master).\n");
        break;

    case 'q':
        printf("Goodbye, master.\n");
        return 0;

    case 'r':
        run();
        return 1;

    case 's':
        printf("PC      = %d\n", PC);
        printf("Y       = %x\n", A);
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
        printf("Print range exceeded the size of RAM, master.\n");
        return 1;
    }
    if (start > length)
    {
        printf("Cannot dump bad JAM addresses, my master.\n");
        return 1;
    }

    int index_length = 0;
    int index_col = start;

    for (int x = 0; x <= length / 15; ++x)
    {
        if (index_length < length)
        {
            printf("%03x     ", index_col);

            for (int y = 0; y <= 15; ++y)
            {
                if (index_length < length)
                {
                    printf("%02x ", RAM[start + index_length]);
                    ++index_col;
                    ++index_length;
                }
            }
        }
        printf("\n");
    }

    return 0;
}

/*
    
    _______________________________ 
                                    
         REGULAR 85% VERSION       
    _______________________________ 
    
    
*/

//  Continuously step through program until step() returns 0
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

// Store sith-bid value, rather than BBC's Acc
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
    return (RAM[Y + 1] << 8) | RAM[Y];
}

//
//

int asciiToHex(char ascii)
{
    if ('0' <= ascii && ascii <= '9')
        return ascii - '0';
    else if ('A' <= ascii && ascii <= 'F')
        return ascii - 'A' + 10;
    else if ('a' <= ascii && ascii <= 'f')
        return ascii - 'a' + 10;
    else
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
        printf("-   -   -   -   PRINT: ");
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