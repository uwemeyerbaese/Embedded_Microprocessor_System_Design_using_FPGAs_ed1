/* Scanner for PicoBlaze psm assembler to HEX file converter */ 

%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#define DEBUG 0
int   state=0; /* end of line prints out IW */
int   icount=0; /* number of instructions */
int   lcount=0; /* number of labels */
int   pp=1; /** preprocessor flag **/
int   vimm, imm=0; /* 2. op is kk flag */
int   offset=0; /* offset opc for jump code */
char  opis[6],lblis[4],immis[4];
FILE  *fid;
struct inst {int adr; int opc; int x; int y; int kk; char *txt;} iw;
struct init  {char *name; int code;} op_table[20] =
{
"LOAD"   , 0x00,
"STAR"   , 0x16,
"FETCH"  , 0x0A,
"STORE"  , 0x2E,
"INPUT"  , 0x08,
"OUTPUT" , 0x2C,
"XOR"    , 0x06,
"ADD"    , 0x10,
"ADDCY"  , 0x12,
"SUB"    , 0x18,
"SUBCY"  , 0x1A,
"JUMP"   , 0x22,
"CALL"   , 0x20,
"RETURN" , 0x25,
0,0
};
FILE      *fid;
int add_symbol(int value, char *symbol);
int lookup_symbol(char *symbol);
void list_symbols();
int h2i(char c);   
int  lookup_opc(char *opc);
%}
HEX             [a-fA-F0-9]{1,2} 
REG             [s|S][a-fA-F0-9] 
NZ              [n|N][z|Z]
DELIMITER       [,]
COMMENT         ";"[^\n]*
LABEL           [a-zA-Z][a-zA-Z0-9]*[:]
GOTO            [a-zA-Z][a-zA-Z0-9]*
%%
\r               /* avoid trouble with FTP files */
\n               {if (pp) printf( "end of line \n");
                  else { if ((state==3) && (pp==0)) /* print out an instruction at end of line */
                  { 
                    printf("%02X",iw.opc+imm+offset); /* First two digits have op code */ 
                    fprintf(fid, "%02X",iw.opc+imm+offset); /* First two digits have op code */ 
                    if (iw.opc==0x25) {
                        printf("%03X",0); /* Next comes 000 */
                        fprintf(fid, "%03X\n",0); /* Next comes 000 */
                      } else { 
                    if ((iw.opc==0x22)||(iw.opc==0x20)) {
                      printf("%03X",iw.kk); /* Here comes aaa */
                      fprintf(fid,"%03X\n",iw.kk); /* Here comes aaa */
                    } else {
                    printf("%1X",iw.x); /* Next comes the desitination register */
                    fprintf(fid, "%1X",iw.x); /* Next comes the desitination register */
                    if (imm) {
                      printf("%02X",iw.kk); /* Last two have kk or y0 */
                      fprintf(fid, "%02X\n",iw.kk); /* Last two have kk or y0 */
                    } else {
                      printf("%02X",iw.y); /* Last two have kk or y0 */
                      fprintf(fid, "%02X\n",iw.y); /* Last two have kk or y0 */
                    }
                    } } }} 
                    printf("\n"); /* 5 digits = line complete */
                    /*fprintf(fid, "\n"); 5 digits = line complete */
                  state=0; imm=0; offset=0;
                 }
{HEX}           { strcpy(immis, yytext); vimm=h2i(immis[1])+16*h2i(immis[0]);
                  if (pp) printf( "An hex: %s (%d)\n", yytext, vimm ); 
                  else   { iw.kk=vimm; state=3; imm=1; }}
XOR|LOAD|STAR|INPUT|OUTPUT|ADD|ADDCY|SUB|SUBCY { 
                if (pp)  printf( "%d) 2 op ALU Instruction: %s opc=%2X\n", icount++, yytext, lookup_opc(yytext)); 
                else  {  state=1; iw.adr=icount++; iw.opc=lookup_opc(yytext); }
                   } 
CALL|JUMP { 
                if (pp)  printf( "%d) 1 op  Flow Instruction: %s\n", icount++, yytext ); 
                else  {  state=2; iw.adr=icount++; iw.opc=lookup_opc(yytext); }
                   } 
RETURN { 
                if (pp)  printf( "%d) 0 op Instruction: %s\n", icount++, yytext ); 
                else  {  state=3; iw.adr=icount++; iw.opc=lookup_opc(yytext);}
                   } 
{REG}            { if (pp)  {printf( "An register: %s\n", yytext ); }
                  else { state+=1; if (state==2) iw.x=h2i( yytext[1] ); if (state==3) iw.y=h2i( yytext[1] );}
                }
{NZ}             {if (pp) printf( "JUMP condition: %s\n", yytext );offset=0x14;}
{LABEL}         { if (pp) {printf( "A label: %s length=%d icount=%d\n", yytext , yyleng, icount);
                   add_symbol(icount, yytext);}
                }
{GOTO}		{ if (pp) printf( "A goto label: %s\n", yytext ); 
                    else {state=3;sprintf(lblis,"%s:",yytext);iw.kk=lookup_symbol(lblis);}
                }
{COMMENT}        {if (pp) printf( "A comment: %s\n", yytext );}
{DELIMITER}      {if (pp) printf( "A delimiter: %s\n", yytext );}
[ \t]+ 		/* eat up whitespace */ 
. 		printf( "Unrecognized character: %s\n", yytext ); 

%% 

int yywrap(void) { return 1; }

int main(int  argc, char *argv[] ) 
{ int k;
  
  yyin = fopen( argv[1], "r" ); 
  if (yyin == NULL ) { printf("Attempt to open file %s failed\n", argv[1]); exit(1); }
  printf("Open file %s now...\n", argv[1]);
  printf("--- First path though file ---\n");
  yylex(); 
  fclose(yyin);
  pp=0;
  printf("-- This is the psm2hex program with %d lines and %d labels\n",icount,lcount);
  icount=0;
  printf("-- Copyright (c) Uwe Meyer-Baese\n");
  list_symbols();
  if (DEBUG) printf("--- Second path through file ---\n");
  yyin = fopen( argv[1], "r" ); 
  fid   = fopen("psm.hex","w");
  yylex(); 
  for (k=icount;k<4096;k++)
    fprintf(fid, "00000\n");
  fclose (fid);
} 

/* define a linked list of symbols */
struct symbol {
	char *symbol_name;
	int symbol_value;
	struct symbol *next;
};

struct symbol *symbol_list; /* first element in symbol list */

extern void *malloc();

int
add_symbol(int value, char *symbol)
{
	struct symbol *wp;	

	if(lookup_symbol(symbol) >= 0 ) {
		printf("--- Warning: symbol %s already defined \n", symbol);
		return 0;
	}
	wp = (struct symbol *) malloc(sizeof(struct symbol));
	wp->next = symbol_list;
	wp->symbol_name = (char *) malloc(strlen(symbol)+1);
	strcpy(wp->symbol_name, symbol);
        lcount++;
	wp->symbol_value = value;
	symbol_list = wp;
	return 1;	/* it worked */
}

int lookup_symbol(char *symbol)
{     int found = -1;
	struct symbol *wp = symbol_list;
	for(; wp; wp = wp->next) {
		if(strcmp(wp->symbol_name, symbol) == 0)
        {if (DEBUG) printf("-- Found symbol %s value is: %d\n",symbol, wp->symbol_value);
			return wp->symbol_value;}
	}
        if (DEBUG) printf("-- Symbol %s not found!!\n",symbol);
	return -1;	/* not found */
}

int lookup_opc(char *opc)
{ int k;  
  strcpy(opis, opc);
  for (k=0; op_table[k].name !=0; k++)
    if (strcmp(opc,op_table[k].name)==0) return (op_table[k].code);

  printf("******* Ups, no opcode : %s --> exit \n",opc);exit(1);
}

void list_symbols()
{
  struct symbol *wp = symbol_list;
  printf("--- Print the Symbol list: ---\n");
  for(; wp; wp = wp->next) 
    printf("-- Label: %s  line = %d\n",wp->symbol_name, wp->symbol_value);
  printf("--- Print the Symbol done  ---\n");

}

/************* conversion hex to integer value ***********/
int h2i(char c) {   
  switch (c) {
    case '1': return 1; break;
    case '2': return 2; break;
    case '3': return 3; break;
    case '4': return 4; break;
    case '5': return 5; break;
    case '6': return 6; break;
    case '7': return 7; break;
    case '8': return 8; break;
    case '9': return 9; break;
    case 'A': case 'a': return 10; break;
    case 'B': case 'b': return 11; break;
    case 'C': case 'c': return 12; break;
    case 'D': case 'd': return 13; break;
    case 'E': case 'e': return 14; break;
    case 'F': case 'f': return 15; break;
    default : return 0; break;
  }
}
