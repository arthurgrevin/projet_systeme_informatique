%{
#include "y.tab.h"
#include <stdlib.h>
%}
 
ID [A-Za-z][A-Za-z0-9_]*
DIGIT [0-9]
DECI {DIGIT}+[\.]?{DIGIT}*
%%
main\(\) return tMAIN ;
printf\( return tPRINTF;
int	return tINT; 
const return tCONST;
{DECI}e{DECI} return tEXP;
{DECI} {yylval.decimal=atoi(strdup(yytext));return tDECI;}
\{	 return tACC_OUVR;
\}	 return tACC_FERM;
\+	 return tADD;
\-	 return tSUB;
\*	 return tMUL;
\/	 return tDIV;
\=	 return tEQ;
\(	 return tPAR_OUVR;
\)	 return tPAR_FERM;
,	 return tVIRG;
[ ]+ printf("");
[\n] printf("");
[\t]+ printf(""); 
\; return tPOINT_VIRGULE;
if return tIF;
else return tELSE;
\< return tINF;
\> return tSUP;
&& return tAND;
\|\| return tOR;
\! return tNOT;
while return tWHILE;
return return tRETURN;

{ID} {yylval.chaine=strdup(yytext);return tID;}
%%
int main(){
	yyparse();
}
