/* Scanner for Verilog (key)word, lines and character count */
/* Author-EMAIL: Uwe.Meyer-Baese@ieee.org */ 
%{ 
  int nchars, nwords,  nlines, kwords = 0; 
%} 
DELIMITER       [.;,)(:\"+-/*@]
KW  module|input|output|reg|begin|end|posedge|always|endmodule
WORDS           [a-zA-Z][a-zA-Z0-9$_]*
%% 
\n          	{ nlines++; nchars++; } 
{DELIMITER}     { nchars++; }
{KW}            { kwords++, nchars += yyleng; } 
{WORDS}         { nwords++, nchars += yyleng; } 
[ \t]+ 		/* eat up whitespace */
. 		{ nchars++; } 
%% 
int yywrap(void) { return 1; }

int main(void) { 
	yylex(); 
        printf("*** Results from Verilog scanner:\n");
	printf("Verilog keywords=%d  lines=%d  words=%d  chars=%d\n", kwords, nlines, nwords+kwords, nchars); 
	return 0; 
}
