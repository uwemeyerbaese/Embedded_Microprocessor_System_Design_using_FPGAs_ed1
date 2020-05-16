/* FLEX Lexical Analyzer 3ac.l for three address code */
/* Author-EMAIL: Uwe.Meyer-Baese@ieee.org */
%{
#include <stdio.h>
#include "y3ac.h"
int yylval;
int symcount =0;
int nlines=0;
char sym_tbl[32][20];
%}

letter [A-Za-z]
digit  [0-9]
ident {letter}({letter}|{digit})*
number {digit}*
op    "+"|"-"|"*"|"/"|"("|")"|";"
ws     [ \t\n]+

%% /* Token and Actions */
\n        { nlines++;}
{ws}      ;         
{ident}   { yylval = install(yytext); return ID; }
{number}  { yylval = install(yytext); return NUM; }
{op}      return yytext[0];
=         return ASSIGN;
.         {printf( "Unrecognized character: %s\n", yytext );}

%% /* User program section */

int yywrap(void) { return 1; } /** Needed by FLEX ***/

int install(char *ident)
  { int i;i=0;
    while (i <= symcount && strcmp(ident, sym_tbl[i]))
      i++;
    if (i<= symcount) return(i);
    else { 
    symcount++;
    strcpy(sym_tbl[symcount], ident);
    return symcount;
    }
}
