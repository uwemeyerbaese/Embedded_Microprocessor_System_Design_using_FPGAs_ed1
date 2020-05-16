/* SOLUTION MANUAL 3/e file: 3ac.y  */
/* Author-EMAIL: Uwe.Meyer-Baese@ieee.org */
/* YACC specification for three address code (3AC) */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylval;
int symcount;
char sym_tbl[32][20];
#ifndef YYSTYPE
#define YYSTYPE int
#endif
int  taccount =0, tcount =1595, Tmax;
#define MAXTACS 32
struct { char op; int a1, a2, a3;} tac[MAXTACS];
YYSTYPE make_tac(char op, YYSTYPE op1, YYSTYPE op2);
void yyerror (char *s);
%}

%left '+' '-'
%left '*' '/'

%token ID NUM
%token ASSIGN

%% /* Grammar rules and actions follows */
input:  
      | input stmt
      ;
stmt  :  '\n'
      |ID ASSIGN exp ';' { $$ = make_tac('=',$1,$3); Tmax=tcount; }
      ;
exp   : exp '+' exp    { $$ = make_tac('+',$1,$3); }
      | exp '-' exp    { $$ = make_tac('-',$1,$3); }
      | exp '*' exp    { $$ = make_tac('*',$1,$3); }
      | exp '/' exp    { $$ = make_tac('/',$1,$3); }
      | '(' exp ')'    { $$ = $2;}
      | ID             { $$ = yylval;}
      | NUM            { $$ = yylval;}
      ;

%% /* Additional C-code goes here */

YYSTYPE gettemp(void);
void list_tacs(void);
void list_table(void);

YYSTYPE gettemp(void)
{ char str1[10]; int i,found;
  tcount++;
  sprintf(str1,"D.%d",tcount);
  found=-1;
  for (i=0;i<symcount;i++)
    if (strcmp(str1,sym_tbl[i]) == 0)
      found=i;
  if (found!=-1)  {
    return (found);
  } else {
    symcount++; 
    strcpy(sym_tbl[symcount],str1);
    return (symcount);
 }
}

YYSTYPE make_tac(char op, YYSTYPE op1, YYSTYPE op2)
{ YYSTYPE new_a ;
  if (op == '=') { new_a=op1;op1=0;
  } else new_a = gettemp();
  tac[taccount].op = op;
  tac[taccount].a1 = op1;
  tac[taccount].a2 = op2;
  tac[taccount].a3 = new_a;
  taccount++;
  return(new_a);
}


void list_tacs(void)
{ int i;
  printf("\n Intermediate code:\n");
  printf(" Quadruples          3AC\n");
  printf(" Op Dst Op1 Op2\n");
       /*(+,  3,  4,  5)    T1 <= x + b*/
  for (i=0; i < taccount; i++) {
    if (tac[i].op == '=') {
      printf("(%c, %2d, %2d, --)      ",tac[i].op,tac[i].a3,tac[i].a2);
      printf("%s  = %s\n", sym_tbl[tac[i].a3],sym_tbl[tac[i].a2]);
    } else {
      printf("(%c, %2d, %2d, %2d)      ",tac[i].op,tac[i].a3,tac[i].a1,tac[i].a2);
      printf("%s = %s %c %s\n",sym_tbl[tac[i].a3],sym_tbl[tac[i].a1], tac[i].op,sym_tbl[tac[i].a2]);  
    }
  }
}

void list_table(void)
{  int i;
   printf("\n Symbol table:\n");
   for(i=1; i <= symcount; i++) 
     printf("%2d : %s\n", i, sym_tbl[i]);
   printf("\n");   
}

void yyerror (char *s) 
{ printf("%s\n", s); }

/** Main program **/
main() {
   do {
    yyparse();
   } while (!feof(stdin));
    list_table();
    list_tacs();
    return 0;
}
