/* Infix notation add two calculator */
%{ 
#define YYSTYPE double
#include <stdio.h>
#include <math.h>
void yyerror(char *);
%}

/* BISON declarations */
%token NUMBER
%left '+'

%% /* Grammar rules and actions follows */
program :   /* empty */
         | program exp '\n'     { printf("    %lf\n",$2); }
         ;

exp      : NUMBER                { $$ = $1;}                       
         | NUMBER '+' NUMBER     { $$ = $1 + $3; }
          ;

%% /* Additional C-code goes here */
 
#include <ctype.h>
int yylex(void)
{ int c;
  /* skip white space and tabs */
  while ((c = getchar()) == ' '|| c == '\t');
  /* process numbers */
  if (c == '.' || isdigit(c)) {
    ungetc(c,stdin);
    scanf("%lf", &yylval);
    return NUMBER;
  }
  /* Return end-of-file */
  if (c==EOF) return(0);
  /* Return single chars */
  return(c);
}


/* Called by yyparse on error */
void yyerror(char *s) { printf("%s\n", s); } 

int main(void)  { return yyparse(); }
