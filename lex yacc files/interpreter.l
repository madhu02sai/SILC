%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <stdlib.h>

	int number=0;
	char str[50];
	char *ch;
%}

%%

[0-9]+	{ch=malloc(sizeof(char));strcpy(ch,"!");yylval=makeLeafNode(ch,atoi(yytext));return NUM;}
"+"	{return *yytext;}
"*"	{return *yytext;}
"-"	{return *yytext;}
"/"	{return *yytext;}
"%"	{return *yytext;}
"="	{return *yytext;}
" "	{}
"!"	{return *yytext;}
"<"	{return *yytext;}
">"	{return *yytext;}
","	{return *yytext;}
"["	{return *yytext;}
"]"	{return *yytext;}
"("	{return *yytext;}
")"	{return *yytext;}
"{"	{localbind=0;printf("args bind completed {\n");return *yytext;}
"}"	{retflag=1;localbind=-2;printf("args bind completed }\n");return *yytext;}
"."	{return *yytext;}
[\n]	{return END;}
";"	{return SC;}
"free"	{return FREE;}
"null"	{return NULLTOK;}
"alloc"	{return ALLOC;}
"initialize" {return INIT;}
"type"	{return TY;}
"endtype" {return ENDTY;}
"AND" 	{return AND;}
"OR"	{return OR;}
"TRUE"	{return TR;}
"FALSE"	{return FA;}
"begin" {return OPEN;}
"end"	{return CLOSE;}
"read"	{return READ;}
"write"	{return WRITE;}
"if"	{return IF;}
"else"	{return ELSE;}
"then"	{return THEN;}
"endif"	{return ENDIF;}
"while"	{return WHILE;}
"do"	{return DO;}
"endwhile" {return ENDWHILE;}
"integer" {if(retflag==1){strcpy(retstr,yytext);retflag=0;}return INT;}
"decl"	{return DECL;}
"enddecl" {/*if(globaldecflag==0)retflag=1;*/return ENDDECL;}
"boolean" {if(retflag==1){strcpy(retstr,yytext);retflag=0;}return BOOL;}
"main"	{return MAIN;}
"return" {return RET;}
[a-z]+	{if(retflag==1){strcpy(retstr,yytext);retflag=0;}yylval=makeLeafNode(yytext,-1);printf("id------%s\n",yytext);return ID;}
[\t] 	{}
.	{yyerror("unknown character\n");exit(1);}

%%

int yywrap(void) {
	return 1;
}
