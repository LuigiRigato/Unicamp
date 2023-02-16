#include <fcntl.h>
#include <unistd.h>

int readInt(unsigned char hexdump[], int i)
{
    unsigned char aux[] = {hexdump[i], hexdump[i+1], hexdump[i+2], hexdump[i+3]};
    return *((int*)aux);
}

short readShort(unsigned char hexdump[], int i)
{
    unsigned char aux[] = {hexdump[i], hexdump[i+1]};
    return *((short*)aux);
}

void intTo4Bytes(int n, unsigned char str[])
{
    unsigned char restos[8];
    int preenchido = 0;

    for(int i = 0; n != 0; i++)
    {
        int resto = n % 16;
        if(resto < 10)
        {
            restos[i] = resto + '0';
        }
        else
        {
            restos[i] = resto + 'a' - 10;
        }
        
        n /= 16;
        preenchido++;
    }

    for(int i = 0; i < preenchido; i++)
    {
        str[7 - i] = restos[i];
    }
}

void print4Bytes(unsigned char hexdump[], int position)
{
    int n = readInt(hexdump, position);
    unsigned char str[8] = {'0','0','0','0','0','0','0', '0'};
    intTo4Bytes(n, str);
    write(1, str, 8);
}

void printName(unsigned char hexdump[], int position)
{
    while(hexdump[position] != '\000')
    {
        unsigned char sectionAscii[1] = {hexdump[position]};
        write(1, sectionAscii, 1);
        position++;
    }
}

void sort(unsigned char hexdump[], int array[], int start, int end)
{
     
    int i = start;
    int j = end;
    int pivot = readInt(hexdump, array[(start + end) / 2] + 4);
     
    while(i <= j)
    {
        while(readInt(hexdump, array[i] + 4) < pivot && i < end)
        {
            i++;
        }
        while(readInt(hexdump, array[j] + 4) > pivot && j > start)
        {
            j--;
        }
        if(i <= j)
        {
            int aux = array[i];
            array[i] = array[j];
            array[j] = aux;
            i++;
            j--;
        }
    }
     
    if(j > start)
    {
        sort(hexdump, array, start, j);
    }
    if(i < end)
    {
        sort(hexdump, array, i, end);
    }
}

unsigned char intToChar(int n)
{
    unsigned char ch;

    if (n >= 0 && n <= 9) // intervalo dos int de 0 a 9 para o intervalo dos char de 0 a 9
    {
        ch = n + '0';
    }
    else if(n >= 10 && n <= 15) // intervalo dos inteiros de 10 a 15 para o intervalo dos char de "a" a "f", em hexadecimal
    {
        ch = n + 'a' - 10;
    }

    return ch;
}

int intToAntiDecStr(int n, unsigned char str[])
{
    int size = 0;

    for(int i = 0; n != 0; i++)
    {
        str[i] = intToChar(n % 10);
        n /= 10;
        size++;
    }

    return size;
}

int intToStr(int n, unsigned char str[], int divider)
{
    int size = 0;
    int restos[10];

    for(int i = 0; n != 0; i++)
    {
        restos[i] = intToChar(n % divider);
        n /= divider;
        size++;
    }

    for(int i = 0; i < size; i++)
    {
        str[i] = restos[size - i - 1];
    }

    return size;
}

void printRegister(int reg)
{
    char *registers[32] = {"zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
    if (reg == 0)
    {
        write(1, registers[reg], 4);
    }

    else if (reg == 26 || reg == 27)
    {
        write(1, registers[reg], 3);
    }

    else
    {
        write(1, registers[reg], 2);
    }
}

void jump(int bin, unsigned char hexdump[], int addrStrtab, int namePositionTxtSymbls[], int addrNow, int qtSymbls, int binSize)
{
    int isNegative = 0;

    if (bin >> (binSize - 1) == 0b1)
    {
        isNegative = 1;
        bin = (0b11111111111111111111111111111111 >> (32 - binSize)) - bin;
        bin++;
    }

    int addr = addrNow;

    if (isNegative)
    {
        addr -= bin;
    }
    else
    {
        addr += bin;
    }


    for (int i = qtSymbls - 1; i >= 0; i--)
    {
        int labelAddr = readInt(hexdump, namePositionTxtSymbls[i] + 4);
        if (addr >= labelAddr)
        {
            unsigned char hexalabelAddr[8];
            int strSize = intToStr(labelAddr, hexalabelAddr, 16);
            write(1, "0x", 2);
            write(1, hexalabelAddr, strSize);
            write(1, "\t<", 2);
            printName(hexdump, addrStrtab + readInt(hexdump, namePositionTxtSymbls[i]));
            write(1, ">", 1);
            break;
        }
    }

}

void printUnsignImmediate(int bin, int sizeBin)
{

    unsigned char immediate[10];
    int sizeStr = intToStr(bin, immediate, 10);

    if (sizeStr == 0)
    {
        write(1, "0", 1);
    }
    
    write(1, immediate, sizeStr);
}

void printImmediate(int bin, int sizeBin)
{
    int isNegative = 0;

    if (bin >> (sizeBin - 1) == 0b1)
    {
        isNegative = 1;
        bin = (0b11111111111111111111111111111111 >> (32 - sizeBin)) - bin;
        bin++;
    }

    unsigned char immediate[10];
    int sizeStr = intToStr(bin, immediate, 10);

    if (isNegative)
    {
        write(1, "-", 1);
    }
    else if (sizeStr == 0)
    {
        write(1, "0", 1);
    }
    
    write(1, immediate, sizeStr);
}

void readInstr(int instr, unsigned char hexdump[], int addrStrtab, int namePositionTxtSymbls[], int addrIdx, int qtSymbls)
{
    int opA = instr & 0b1111111;
    int opB = (instr >> 12) & 0b111;
    int opC = (instr >> 20) & 0b111111111111;
    int opD = (instr >> 25) & 0b1111111;

    int rd = (instr >> 7) & 0b11111;
    int rs1 = (instr >> 15) & 0b11111;
    int rs2 = (instr >> 20) & 0b11111;

    int imA = (instr >> 12) & 0b11111111111111111111;
    int imB = (instr >> 20) & 0b111111111111;
    int imC = ((instr >> 7) & 0b11111) + (((instr >> 25) & 0b1111111) << 5);
    int succ = (instr >> 20) & 0b1111;
    int pred = (instr >> 24) & 0b1111;
    int shamt = (instr >> 20) & 0b11111;
    int csr = (instr >> 20) & 0b111111111111;
    int zimm = (instr >> 15) & 0b11111;
    int imD = ((((instr >> 31) & 0b1) << 19) + (((instr >> 12) & 0b11111111) << 11) + (((instr >> 20) & 0b1) << 10) + ((instr >> 21) & 0b1111111111)) << 1;
    int imE = ((((instr >> 31) & 0b1) << 11) + (((instr >> 7) & 0b1) << 10) + (((instr >> 25) & 0b111111) << 4) + ((instr >> 8) & 0b1111)) << 1;

    switch (opA)
    {
        case (0b0110111):
            write(1, "lui\t", 4);
            printRegister(rd);
            write(1, ",\t", 2);
            printImmediate(imA, 20);
            break;

        case (0b0010111):
            write(1, "auipc\t", 6);
            printRegister(rd);
            write(1, ",\t", 2);
            printImmediate(imA, 20);
            break;

        case (0b1101111):
            write(1, "jal\t", 4);
            printRegister(rd);
            write(1, ",\t", 2);
            jump(imD, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 21);
            break;

        case (0b1100111):
            write(1, "jalr\t", 5);
            printRegister(rd);
            write(1, ",\t", 2);
            printImmediate(imB, 12);
            write(1, "(", 1);
            printRegister(rs1);
            write(1, ")", 1);
            break;
            
        case (0b1100011):
            switch(opB)
            {
                case(0b000):
                    write(1, "beq\t", 4);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                case(0b001):
                    write(1, "bne\t", 4);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                case(0b100):
                    write(1, "blt\t", 4);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                case(0b101):
                    write(1, "bge\t", 4);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                case(0b110):
                    write(1, "bltu\t", 5);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                case(0b111):
                    write(1, "bgeu\t", 5);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    jump(imE, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls, 13);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case (0b0000011):
            switch (opB)
            {
                case (0b000):
                    write(1, "lb\t", 3);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b001):
                    write(1, "lh\t", 3);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b010):
                    write(1, "lw\t", 3);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b100):
                    write(1, "lbu\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b101):
                    write(1, "lhu\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case (0b0100011):
            switch (opB)
            {
                case (0b000):
                    write(1, "sb\t", 3);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    printImmediate(imC, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b001):
                    write(1, "sh\t", 3);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    printImmediate(imC, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                case (0b010):
                    write(1, "sw\t", 3);
                    printRegister(rs2);
                    write(1, ",\t", 2);
                    printImmediate(imC, 12);
                    write(1, "(", 1);
                    printRegister(rs1);
                    write(1, ")", 1);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case (0b0010011):
            switch (opB)
            {
                case (0b000):
                    write(1, "addi\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b010):
                    write(1, "slti\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b011):
                    write(1, "sltiu\t", 6);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b100):
                    write(1, "xori\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b110):
                    write(1, "ori\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b111):
                    write(1, "andi\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printImmediate(imB, 12);
                    break;

                case (0b001):
                    write(1, "slli\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printUnsignImmediate(shamt, 5);
                    break;

                case (0b101):
                    switch (opD)
                    {
                        case (0b0000000):
                            write(1, "srli\t", 5);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printUnsignImmediate(shamt, 5);
                            break;

                        case (0b0100000):
                            write(1, "srai\t", 5);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printUnsignImmediate(shamt, 5);
                            break;

                        default:
                            write(1, "<unknown>", 9);
                            break;
                    }
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case(0b0110011):
            switch (opB)
            {
                case (0b000):
                    switch (opD)
                    {
                        case (0b0000000):
                            write(1, "add\t", 4);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printRegister(rs2);
                            break;

                        case (0b0100000):
                            write(1, "sub\t", 4);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printRegister(rs2);
                            break;

                        default:
                            write(1, "<unknown>", 9);
                            break;
                    }
                    break;

                case (0b001):
                    write(1, "sll\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                case (0b010):
                    write(1, "slt\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                case (0b011):
                    write(1, "sltu\t", 5);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                case (0b100):
                    write(1, "xor\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                case (0b101):
                    switch (opD)
                    {
                        case (0b0000000):
                            write(1, "srl\t", 4);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printRegister(rs2);
                            break;

                        case (0b0100000):
                            write(1, "sra\t", 4);
                            printRegister(rd);
                            write(1, ",\t", 2);
                            printRegister(rs1);
                            write(1, ",\t", 2);
                            printRegister(rs2);
                            break;

                        default:
                            write(1, "<unknown>", 9);
                            break;
                    }
                    break;

                case (0b110):
                    write(1, "or\t", 3);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                case (0b111):
                    write(1, "and\t", 4);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    write(1, ",\t", 2);
                    printRegister(rs2);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case(0b0001111):
            switch (opB)
            {
                case (0b000):
                    write(1, "fence\t", 6);
                    if (((pred >> 3) & 0b1) == 1)
                    {
                        write(1, "i", 1);
                    }
                    if (((pred >> 2) & 0b1) == 1)
                    {
                        write(1, "o", 1);
                    }
                    if (((pred >> 1) & 0b1) == 1)
                    {
                        write(1, "r", 1);
                    }
                    if ((pred & 0b1) == 1)
                    {
                        write(1, "w", 1);
                    }
                    if (succ != 0 || pred != 0)
                    {
                        write(1, ",\t", 2);
                    }
                    if (((succ >> 3) & 0b1) == 1)
                    {
                        write(1, "i", 1);
                    }
                    if (((succ >> 2) & 0b1) == 1)
                    {
                        write(1, "o", 1);
                    }
                    if (((succ >> 1) & 0b1) == 1)
                    {
                        write(1, "r", 1);
                    }
                    if ((succ & 0b1) == 1)
                    {
                        write(1, "w", 1);
                    }
                    break;

                case (0b001):
                    write(1, "fence.i", 7);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        case(0b1110011):
            switch (opB)
            {
                case (0b000):
                    switch (opC)
                    {
                        case (0b000000000000):
                            write(1, "ecall", 5);
                            break;

                        case (0b000000000001):
                            write(1, "ebreak", 6);
                            break;

                        default:
                            write(1, "<unknown>", 9);
                            break;
                    }
                    break;

                case (0b001):
                    write(1, "csrrw\t", 6);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    break;

                case (0b010):
                    write(1, "csrrs\t", 6);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    break;

                case (0b011):
                    write(1, "csrrc\t", 6);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printRegister(rs1);
                    break;

                case (0b101):
                    write(1, "csrrwi\t", 7);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printUnsignImmediate(zimm, 5);
                    break;

                case (0b110):
                    write(1, "csrrsi\t", 7);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printUnsignImmediate(zimm, 5);
                    break;

                case (0b111):
                    write(1, "csrrci\t", 7);
                    printRegister(rd);
                    write(1, ",\t", 2);
                    printUnsignImmediate(csr, 12);
                    write(1, ",\t", 2);
                    printUnsignImmediate(zimm, 5);
                    break;

                default:
                    write(1, "<unknown>", 9);
                    break;
            }
            break;

        default:
            write(1, "<unknown>", 9);
            break;
    }
}


int main(int argc, char *argv[])
{
    int fd = open(argv[2], O_RDONLY);
    if (fd == -1) return -1;
    unsigned char hexdump[100000];
    read(fd, hexdump, 100000);

    write(1, "\n", 1);
    write(1, argv[2], 13);
    write(1, ": file format elf32-littleriscv\n\n",33);

    int eShoff = readInt(hexdump, 32); // e_shoff = começo dos section headers
    short eShnum = readShort(hexdump, 48); // e_shnum = total de section headers
    short eShstrndx = readShort(hexdump, 50); // e_shstrndx = qual section header está o endereço da shstrtab

    int headerShStrtab = eShoff + eShstrndx * 40; // headerStrtab = começo da section header indicada pelo e_shstrndx
    int offsetShStrtab = readInt(hexdump, headerShStrtab + 16); // addrStrtab = endereço da shstrtab

    if (argv[1][1] == 'h')
    {
        write(1, "Sections:\n",10);
        write(1, "Idx\tName\tSize\tVMA\n0",19);

        for(int idx = 0; idx < eShnum; idx++)
        {
            unsigned char idxAscii[3] = {'0', '0', '0'};
            int size = intToAntiDecStr(idx, idxAscii);
            for (int i = size - 1; i >= 0; i--)
            {
                unsigned char idxAux[1] = {idxAscii[i]};
                write(1, idxAux, 1);
            }
            
            write(1, "\t", 1);

            int namePosition = eShoff + idx * 40;
            int shName = readInt(hexdump, namePosition);
            printName(hexdump, offsetShStrtab + shName);
            write(1, "\t", 1);

            print4Bytes(hexdump, namePosition + 20);
            write(1, "\t", 1);

            print4Bytes(hexdump, namePosition + 12);        
            write(1, "\n", 1);
        }
        write(1, "\n", 1);
    }

    else if (argv[1][1] == 't')
    {
        write(1, "SYMBOL TABLE:\n",14);

        int addrSymtab;
        int sizeSymtab;
        int addrStrtab;
        int position;
        int namePosition;
        int shName;

        for(int idx = 0; idx < eShnum; idx++)
        {
            namePosition = eShoff + idx * 40;
            shName = readInt(hexdump, namePosition);
            
            unsigned char sectionWanted1[7] = ".symtab";
            unsigned char sectionWanted2[7] = ".strtab";
            int equal1 = 0;
            int equal2 = 0;
            position = offsetShStrtab + shName;

            for (int i = 0; i < 7 && hexdump[position] != '\000'; i++)          
            {
                if (hexdump[position] == sectionWanted1[i])
                {
                    equal1++;
                }
                if (hexdump[position] == sectionWanted2[i])
                {
                    equal2++;
                }
                position++;
            }

            if (equal1 == 7)
            {
                addrSymtab = readInt(hexdump, namePosition + 16);
                sizeSymtab = readInt(hexdump, namePosition + 20);

            }
            else if (equal2 == 7)
            {
                addrStrtab = readInt(hexdump, namePosition + 16);
            }
        }
            
        int linhas = sizeSymtab / 16;

        for(int i = 1; i < linhas; i++)
        {
            print4Bytes(hexdump, addrSymtab + 16 * i + 4);
            write(1, "\t", 1);

            position = addrSymtab + 16 * i + 12;
            if (hexdump[position] == '\000')
            {
                write(1, "l", 1);
            }
            else
            {
                write(1, "g", 1);
            }
            write(1, "\t", 1);
            
            int sectionIdx = readShort(hexdump, addrSymtab + 16 * i + 14);
            if (sectionIdx >= eShnum ||  sectionIdx < 0)
            {
                write(1, "*ABS*", 5);
            }
            else
            {
                namePosition = eShoff + sectionIdx * 40;
                shName = readInt(hexdump, namePosition);
                printName(hexdump, offsetShStrtab + shName);
            }               
            write(1, "\t", 1);

            print4Bytes(hexdump, addrSymtab + 16 * i + 8);
            write(1, "\t", 1);

            position = readInt(hexdump, addrSymtab + 16 * i);
            printName(hexdump, addrStrtab + position);
            write(1, "\n", 1);
        }
    }
    else if (argv[1][1] == 'd')
    {
        write(1, "\nDisassembly of section .text:\n",31);

        int addrSymtab;
        int sizeSymtab;
        int addrStrtab;
        int position;
        int namePosition;
        int shName;
        unsigned char sectionWanted1[7] = ".symtab";
        unsigned char sectionWanted2[7] = ".strtab";

        for(int idx = 0; idx < eShnum; idx++)
        {
            namePosition = eShoff + idx * 40;
            shName = readInt(hexdump, namePosition);
            
            int equal1 = 0;
            int equal2 = 0;
            position = offsetShStrtab + shName;

            for (int i = 0; i < 7 && hexdump[position] != '\000'; i++)          
            {
                if (hexdump[position] == sectionWanted1[i])
                {
                    equal1++;
                }
                if (hexdump[position] == sectionWanted2[i])
                {
                    equal2++;
                }
                position++;
            }

            if (equal1 == 7)
            {
                addrSymtab = readInt(hexdump, namePosition + 16);
                sizeSymtab = readInt(hexdump, namePosition + 20);

            }
            else if (equal2 == 7)
            {
                addrStrtab = readInt(hexdump, namePosition + 16);
            }
        }
            
        int linhas = sizeSymtab / 16;
        unsigned char sectionWanted3[5] = ".text";
        int namePositionTxtSymbls[100];
        int qtSymbls = 0;
        int qtTotal = 0;
        int sizeText = -1;
        int addrText;

        for(int i = 1; i < linhas; i++)
        {   
            int equal3 = 0;
            int sectionIdx = readShort(hexdump, addrSymtab + 16 * i + 14);
            if (sectionIdx < eShnum && sectionIdx > 0)
            {
                namePosition = eShoff + sectionIdx * 40;
                shName = readInt(hexdump, namePosition);
                position = offsetShStrtab + shName;
                for (int i = 0; i < 5 && hexdump[position] != '\000'; i++)          
                {
                    if (hexdump[position] == sectionWanted3[i])
                    {
                        equal3++;
                    }
                    position++;
                }

                if (equal3 == 5)
                {
                    if (sizeText == -1)
                    {
                        addrText = readInt(hexdump,  namePosition + 16);
                        sizeText = readInt(hexdump,  namePosition + 20);
                    }
                    
                    namePositionTxtSymbls[qtSymbls++] = addrSymtab + 16 * i;
                }
            }
        }

        sort(hexdump, namePositionTxtSymbls, 0, qtSymbls - 1);
        int addrIdx;

        for (int i = 0; i < qtSymbls; i++)
        {
            int qtInst;
            write(1, "\n", 1);
            print4Bytes(hexdump, namePositionTxtSymbls[i] + 4);
            write(1, "\t", 1);
            int symbolNamePosition = readInt(hexdump, namePositionTxtSymbls[i]);
            write(1, "<", 1);
            printName(hexdump, addrStrtab + symbolNamePosition);
            write(1, ">:", 2);
            write(1, "\n", 1);

            if (i != qtSymbls - 1)
            {
                int symblAddr = readInt(hexdump, namePositionTxtSymbls[i] + 4);
                int nextSymblAddr = readInt(hexdump, namePositionTxtSymbls[i + 1] + 4);
                qtInst = (nextSymblAddr - symblAddr) / 4;
                qtTotal += qtInst;
            }
            else
            {
                qtInst = sizeText / 4 - qtTotal;
            }
            
            if (i == 0)
            {
                addrIdx = readInt(hexdump, namePositionTxtSymbls[i] + 4);
            }
            
            for (int j = 0; j < qtInst; j++)
            {
                unsigned char addr[8] = {'0','0','0','0','0','0','0','0'};
                int sizeAddr = intToStr(addrIdx, addr, 16);
                write(1, addr, sizeAddr);
                write(1, ":\t", 2);

                unsigned char antiInstr[2];
                int instr = readInt(hexdump, addrText);
                for(int idx = 0; idx < 4; idx ++)
                {
                    antiInstr[0] = '0';
                    antiInstr[1] = '0';
                    int size = intToStr(hexdump[addrText++], antiInstr, 16);

                    if (size == 1)
                    {
                        antiInstr[1] = antiInstr[0];
                        antiInstr[0] = '0';
                    }
                    
                    write(1, antiInstr, 2);
                    write(1, "\t", 1);
                }

                readInstr(instr, hexdump, addrStrtab, namePositionTxtSymbls, addrIdx, qtSymbls);
                write(1, "\n", 1);
                addrIdx += 4;
            }
        }

    }

    return 0;
}
