%{
#include "y.tab.h"
#include <stdlib.h>
%}

NUMERO [0-9]+
%%
AFC return tAFC;
STORE return tSTORE;
LOAD return tLOAD;
ADD return tADD;
MUL return tMUL;
SUB return tSUB;
DIV return tDIV;
NEG return tNEG;
EQ return tEQ;
R1 return tR1;
R2 return tR2;
SUP return tSUP;
INF return tINF;
END return tEND;
JMF return tJMF;
JMP return tJMP;
START return tSTART;
JMPR return tJMPR;
PUSH return tPUSH;
POP return tPOP;
{NUMERO} {yylval.numero=atoi(strdup(yytext));return tNUMERO;}
[ ]+ printf("");
[\n] printf("");
[\t]+ printf("");
[:] printf(""); 

%%



int main(){
	yyparse();
}
