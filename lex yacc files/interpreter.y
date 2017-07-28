%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYSTYPE tnode*
	#include "exptree.h"
	#include "exptree.c"

	extern FILE *yyin;
	char *po;//=malloc(sizeof(char));
	struct Gsymbol *temp,*temp1;
	struct Lsymbol *temp2,*temp3;
	struct Paramlist *n1,*n2;
	struct tnode* t1;
	struct Typetable *tt;
	struct Fieldlist *fl;
	int flag;
	FILE *fp;
	int globaldecflag=0;
	char *storing;
	int localbind=-2;
	int retflag=0;
	char *retstr;
	int fieldflag=0;
	
%}

%token NUM ID END READ WRITE SC IF THEN ENDIF WHILE DO ENDWHILE INT DECL ENDDECL BOOL TR FA OPEN CLOSE AND OR ELSE MAIN RET TY ENDTY ALLOC INIT NULLTOK FREE
%left '+' '-'
%left '*' '/' '%'

%%

Prog	: TypeDefBlock GdeclBlock FDefBlock MainBlock	{return 0;}
	| TypeDefBlock GdeclBlock MainBlock 			{return 0;}
	| TypeDefBlock MainBlock				{return 0;}
	;

TypeDefBlock  : TY END TypeDefList ENDTY END		{CombineFieldType($3);globaldecflag=0;localbind=-2;satheesh();printf("pppppppppppppppppppppppppppppppppppppppppppppppppppppppp\n");}
              |                                         {globaldecflag=0;localbind=-2;}
              ;

TypeDefList   : TypeDefList TypeDef			{$$=CombineTypeList($1,$2);satheesh();}
              | TypeDef					{$$=$1;/*$$=CombineTypeList($1,NULL);*/satheesh();}
              ;

TypeDef       : ID END '{' END FieldDeclList  '}' END  { $$=TInstall($1->op,0,$5);  printf("here2\n");fieldflag=0;}
              ;

FieldDeclList : FieldDeclList FieldDecl		{fieldflag++;
						if(fieldflag==8){printf("no.of fields in typedef should not exceed 7\n");exit(1);}
						$$=CombineFieldList($1,$2);}
              | FieldDecl			{fieldflag++;$$=CombineFieldList($1,NULL);}
              ;

FieldDecl    : TypeName  ID SC END		{printf("heeeere\n");$$=FInstall($2->op,$1->op);printf("here\n");}
	     ;

TypeName     : INT	{
			strcpy(storing,"integer");
			po=(char*)malloc(sizeof(char));strcpy(po,"integer");$$=makeLeafNode(po,0);free(po);$$->op=(char*)malloc(sizeof(char));strcpy($$->op,"integer");}
             | BOOL	{
			strcpy(storing,"boolean");
			po=(char*)malloc(sizeof(char));strcpy(po,"boolean");$$=makeLeafNode(po,0);free(po);$$->op=(char*)malloc(sizeof(char));strcpy($$->op,"boolean");}
             | ID       {
			strcpy(storing,$1->op);
			$$=$1;}//TypeName for user-defined types
	     ;

MainBlock: INT  MAIN '(' ')' END '{' END Ldeclblock Body '}' END  {
									
									printf("yo\n");
									maindec();
									int i=Codegen_util($9);
									printf("yo\n");
									//return 0;							
								     }
	;

FDefBlock : FDefBlock Fdef 
	| Fdef
	;
/*TypeName3: TypeName {$$=$1;}
	;*/
Fdef 	: 
	 INT  ID '(' Paramlist ')' END '{' END Ldeclblock Body '}' END//change	
						{
							
							temp=Glookup($2->op);
							//printf("la%sla\n",$3->op);
							if(temp==NULL)
							{
								printf("function not declared\n");
								exit(1);
							}
							if(strcmp(temp->type->name,"boolean")==0)//temp->TYPE==2)
							{
								printf("return type mismatch\n");
								exit(1);
							}
							n1=temp->para;
							n2=$4;
							while(n1!=NULL && n2!=NULL)
							{
								if(n1==NULL || n2==NULL)
								{
									printf("less or more parameters\n");
									exit(1);
								}
								printf("jai_satti\n");
								if((n1->type)!=(n2->type))
								{
									printf("type mismatch in function arguments\n");
									exit(1);
								}
								n1=n1->NEXT;
								printf("jai_satti\n");
								n2=n2->NEXT;
								printf("jai_satti\n");
								
								if((n1==NULL && n2!=NULL) || (n1!=NULL && n2==NULL))
								{
									printf("less or more parameters\n");
									exit(1);
								}
								if(n1==NULL)printf("jai_satti\n");
								if(n2==NULL)printf("jai_satti\n");
								if(n1==NULL && n2==NULL)
								break;
							}
							funcdec($2->op);printf("jai_satti321\n");
							int i=Codegen_util($10);printf("jai_satti123\n");
							ltable=NULL;
							localbind=-2;
						}
	|	BOOL  ID '(' Paramlist ')' END '{' END Ldeclblock Body '}' END	
						{
							
							if(temp==NULL)
							{
								printf("function not declared\n");
								exit(1);
							}
							if(strcmp(temp->type->name,"integer")==0)//temp->TYPE==1)
							{
								printf("return type mismatch\n");
								exit(1);
							}
							n1=temp->para;
							n2=$5;
							while(n1!=NULL && n2!=NULL)
							{
								if(n1==NULL || n2==NULL)
								{
									printf("less or more parameters\n");
									exit(1);
								}
								printf("jai_satti\n");
								if((n1->type)!=(n2->type))
								{
									printf("type mismatch in function arguments\n");
									exit(1);
								}
								n1=n1->NEXT;
								n2=n2->NEXT;
								//if(n1==NULL){printf("olaola\n");}
								//if(n2==NULL){printf("olaola\n");}
								if((n1==NULL && n2!=NULL) || (n1!=NULL && n2==NULL))
								{
									printf("less or more parameters\n");
									exit(1);
								}
							}
							funcdec($3->op);
							int i=Codegen_util($10);
							ltable=NULL;
							localbind=-2;
						}
	| ID  ID '(' Paramlist ')' END '{' END Ldeclblock Body '}' END	{
							temp=Glookup($2->op);
							//printf("la%sla\n",$3->op);
							if(temp==NULL)
							{
								printf("function not declared\n");
								exit(1);
							}
							if(strcmp(temp->type->name,"boolean")==0)//temp->TYPE==2)
							{
								printf("return type mismatch\n");
								exit(1);
							}
							if(strcmp(temp->type->name,"integer")==0)//temp->TYPE==2)
							{
								printf("return type mismatch\n");
								exit(1);
							}
							n1=temp->para;
							n2=$4;
							while(n1!=NULL && n2!=NULL)
							{
								if(n1==NULL || n2==NULL)
								{
									printf("less or more parameters\n");
									exit(1);
								}
								if((n1->type)!=(n2->type))
								{
									printf("type mismatch in function arguments123\n");
									exit(1);
								}
								n1=n1->NEXT;
								n2=n2->NEXT;
								
								if((n1==NULL && n2!=NULL) || (n1!=NULL && n2==NULL))
								{
									printf("less or more parameters\n");
									exit(1);
								}
								if(n1==NULL)printf("jai_satti\n");
								if(n2==NULL)printf("jai_satti\n");
								if(n1==NULL && n2==NULL)
								break;
							}
							funcdec($2->op);printf("jai_satti321\n");
							int i=Codegen_util($10);printf("jai_satti123\n");
							ltable=NULL;
							localbind=-2;
							printf("bst done\n");//exit(1);
								}//return type user defined type
	;

Paramlist : TypeName  ID ',' Paramlist	{$$=makeParamlist($1->op,$2,$4);if(globaldecflag==1)makenewsymboltable2($1->op,$2->op);}
	| TypeName  ID			{$$=makeParamlist($1->op,$2,NULL);if(globaldecflag==1)
						{makenewsymboltable2($1->op,$2->op);}}
	;



/*Type 	: INT 
	| BOOL
	;*/

Ldeclblock: DECL END LDecllist ENDDECL END 	{printf("local declarations\n");struct Lsymbol* ltable2=ltable;
						printf("local table\n");
						while(ltable2!=NULL)
						{
							printf("%s\n%d\n",ltable2->NAME,ltable2->BINDING);
							ltable2=ltable2->NEXT;
						}
						printf("end\n");
						}		
	| DECL END ENDDECL END			{}
	;

//program : GdeclBlock Body 			{printf("evaluated\n");i=Codegen_util($2);return 0;}
//	;
GdeclBlock: DECL END GDecllist ENDDECL END 	{
							globaldec();
							
							printf("global declarations\n");
							globaldecflag=1;
							retflag=1;
						}		
	| DECL END ENDDECL END			{
							globaldec();//printf("lalalalala\n");
						        
						}
	;
GDecllist:
	  TypeName  Decl SC END		{}
	| TypeName  Decl SC END GDecllist	{}
	;
LDecllist: TypeName  LDecl SC END			{}
	| TypeName  LDecl SC END LDecllist		{}
	;

Decl  :	ID					{makenewsymboltable(storing,($1->op),-1,NULL);}
	|  ID '[' NUM ']'			{makenewsymboltable(storing,($1->op),$3->val,NULL);}
	| ID ',' Decl				{makenewsymboltable(storing,($1->op),-1,NULL);}
	|  ID '[' NUM ']' ',' Decl		{makenewsymboltable(storing,($1->op),$3->val,NULL);}
	| ID '('  Paramlist ')' 		{makenewsymboltable(storing,($1->op),-1,$3);}
	| ID '(' Paramlist ')' ',' Decl		{printf("inserting %s in %s\n",storing,$1->op);makenewsymboltable(storing,($1->op),-1,$3);}
	;
/*LDecl2  :	ID				{makenewsymboltable2(2,($1->op));$$=NULL;}
	| ID ',' LDecl2				{makenewsymboltable2(2,($1->op));$$=NULL;}
	;*/
LDecl  :	ID				{makenewsymboltable2(storing,($1->op));$$=NULL;}
	| ID ',' LDecl				{makenewsymboltable2(storing,($1->op));$$=NULL;}
	;
Body: OPEN END Slist CLOSE END			{printf("body\n");$$=$3; }
	| OPEN END CLOSE END			{$$=NULL;}
	;
Slist : Slist Stmt				{$$=makeOperatorNode(1,$1,$2);}
	| Stmt					{$$=$1;}
	;
Stmt  : ID '=' E SC END				{
						//printf("yo mama\n");
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared111111111\n");exit(1);}
						printf("goddddddddddddddddddddd\n");
							printf("%s\n",temp->type->name);
						printf("goddddddddddddddddddddd\n");
							tt=temp->type; 
							if(tt==NULL){printf("dassssssss\n");}
							if(strcmp(tt->name,"boolean")==0)//temp->TYPE==2)
								{printf("type mismatch44\n");exit(1);}
							//if($3->NODETYPE==24)//field
							{
						printf("goddddddddddddddddddddd\n");
								if($3->type==NULL){printf("la1");}
								if(temp->type==NULL){printf("la2");}
						printf("goddddddddddddddddddddd\n");
								printf("comparing %s and %s\n",temp->type->name,$3->type->name);
						printf("goddddddddddddddddddddd\n");
								if(temp->type!=$3->type)
								{printf("type mismatch for id=field\n");exit(1);}
							}
							
						}
						else
						{
							if(strcmp(temp2->type->name,"boolean")==0)
								{printf("type mismatch45\n");exit(1);}
							//if($3->NODETYPE==24)//field
							{
								if(temp2->type!=$3->type)
								{printf("type mismatch for id=field\n");exit(1);}
							}
							
						}
						$$=makeOperatorNode(9,$1,$3);
						}
	| FIELD '=' E SC END			{
						if($1->type!=$3->type)
						{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(25,$1,$3);
						}
	| ID '=' ALLOC '(' ')' SC END		{
						//if() integer a;boolean b;a=alloc();b=alloc(); error
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL){printf("id=alloc() var not declared\n");exit(1);}
							tt=temp->type;
							if(strcmp(tt->name,"integer")==0)
							{printf("in id=alloc() id cannot be of type integer\n");exit(1);}
							if(strcmp(tt->name,"boolean")==0)
							{printf("in id=alloc() id cannot be of type boolean\n");exit(1);}
						}
						else
						{
							tt=temp2->type;
							if(strcmp(tt->name,"integer")==0)
							{printf("in id=alloc() id cannot be of type integer\n");exit(1);}
							if(strcmp(tt->name,"boolean")==0)
							{printf("in id=alloc() id cannot be of type boolean\n");exit(1);}
						}
						$$=makeOperatorNode(26,$1,NULL);
						}
	| FIELD '=' ALLOC '(' ')' SC END	{//field type should not be integer or boolean
						tt=$1->type;
						if(strcmp(tt->name,"integer")==0)
						{printf("in id=alloc() id cannot be of type integer\n");exit(1);}
						if(strcmp(tt->name,"boolean")==0)
						{printf("in id=alloc() id cannot be of type boolean\n");exit(1);}
						$$=makeOperatorNode(27,$1,NULL);}
	|  INIT '(' ')' SC END			{$$=makeOperatorNode(28,NULL,NULL);}
	| READ '(' FIELD ')' SC END		{
						if(strcmp($3->type->name,"integer")!=0)
							{printf("read type should be only integer\n");exit(1);}
						$$=makeOperatorNode(29,$3,NULL);
						}
	| ID '=' NULLTOK SC END			{//id should be user type
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL){printf("id=null var not declared\n");exit(1);}
							tt=temp->type;
							if(strcmp(tt->name,"integer")==0)
							{printf("in id=null id cannot be of type integer\n");exit(1);}
							if(strcmp(tt->name,"boolean")==0)
							{printf("in id=null id cannot be of type boolean\n");exit(1);}
						}
						else
						{
							tt=temp2->type;
							if(strcmp(tt->name,"integer")==0)
							{printf("in id=null id cannot be of type integer\n");exit(1);}
							if(strcmp(tt->name,"boolean")==0)
							{printf("in id=null id cannot be of type boolean\n");exit(1);}
						}
						$$=makeOperatorNode(30,$1,NULL);}
	| FIELD '=' NULLTOK SC END		{
						tt=$1->type;
						if(strcmp(tt->name,"integer")==0)
						{printf("in field=null id cannot be of type integer\n");exit(1);}
						if(strcmp(tt->name,"boolean")==0)
						{printf("in field=null id cannot be of type boolean\n");exit(1);}
						$$=makeOperatorNode(31,$1,NULL);}
	| ID '=' FREE '(' ID ')' SC END		{
							printf("uppppppppppp\n");
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(strcmp(temp->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
						}
						temp2=Llookup($5->op);
						if(temp2==NULL)
						{
							temp=Glookup($5->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(strcmp(temp->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp(temp->type->name,"boolean")==0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp(temp2->type->name,"boolean")==0)
								{printf("type mismatch\n");exit(1);}
						}
							/*if(strcmp($1->type->name,"integer")!=0)
								{printf("return value of free call should be integer only\n");exit(1);}
							if(strcmp($5->type->name,"integer")==0)
								{printf("free() arg should not be integer\n");exit(1);}
							if(strcmp($5->type->name,"boolean")==0)
								{printf("free() arg should not be boolean\n");exit(1);}*/
							printf("downnnnnnnnnn\n");
							$$=makeOperatorNode(32,$1,$5);
						}
	| ID '=' FREE '(' FIELD ')' SC END	{
							temp2=Llookup($1->op);
							if(temp2==NULL)
							{
								temp=Glookup($1->op);
								if(temp==NULL)
									{printf("variable undeclared\n");exit(1);}
								if(strcmp(temp->type->name,"integer")!=0)
									{printf("type mismatch\n");exit(1);}
							}
							else
							{
								if(strcmp(temp2->type->name,"integer")!=0)
									{printf("type mismatch\n");exit(1);}
							}
							if(strcmp($5->type->name,"integer")==0)
								{printf("free() arg should not be integer\n");exit(1);}
							if(strcmp($5->type->name,"boolean")==0)
								{printf("free() arg should not be boolean\n");exit(1);}
							$$=makeOperatorNode(33,$1,$5);
						}
	| ID '=' '(' F ')' SC END		{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(strcmp(temp->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						po=malloc(sizeof(char));
						strcpy(po,"#");
						//$$=makeOperatorNode(9,$1,makeLeafNode(po,evaluate($4)));
						free(po);
						}
	| ID '[' E ']' '=' '(' F ')' SC END	{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE==-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"boolean")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($3->type->name,"integer")!=0)
							{
								printf("type mismatch\n");
								exit(1);
							}
							
						}
						
						po=malloc(sizeof(char));
						strcpy(po,"#");
						//$$=makeOperatorNode(9,makeLeafNode_ARR(($1->op),$3),makeLeafNode(po,evaluate($7)));
						free(po);
						}
	| ID '[' E ']' '=' E SC	END		{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE==-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($6->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($3->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							
						}
						
						$$=makeOperatorNode(9,makeLeafNode_ARR(($1->op),$3),$6);
						}
	| ID '=' TR SC	END			{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE!=-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeOperatorNode(9,$1,makeLeafNode(po,1));
						free(po);
						}
	| ID '=' FA SC	END			{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE!=-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"integer")==0)
								{printf("type mismatch\n");exit(1);}
						}
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeOperatorNode(9,$1,makeLeafNode(po,0));
						free(po);
						}
	| ID '[' E ']' '=' TR SC END		{		
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE==-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"boolean")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($3->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							
						}
						
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeOperatorNode(9,makeLeafNode_ARR($1->op,$3),makeLeafNode(po,1));
						free(po);
						}
	| ID '[' E ']' '=' FA SC END		{
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							temp=Glookup($1->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE==-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"boolean")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($3->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							
						}
						
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeOperatorNode(9,makeLeafNode_ARR($1->op,$3),makeLeafNode(po,0));
						free(po);
						}
	| READ '(' ID ')' SC END		{		
						temp2=Llookup($3->op);
						if(temp2==NULL)
						{
							temp=Glookup($3->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE!=-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"boolean")==0)
								{printf("type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp(temp2->type->name,"boolean")==0)
								{printf("type mismatch\n");exit(1);}
						}
						$$=makeOperatorNode(2,$3,NULL);
						}
	| READ '(' ID '[' E ']' ')' SC END	{
						temp2=Llookup($3->op);
						if(temp2==NULL)
						{
							temp=Glookup($3->op);
							if(temp==NULL)
								{printf("variable undeclared\n");exit(1);}
							if(temp->SIZE==-1)
								{printf("variable wrong use\n");exit(1);}
							if(strcmp(temp->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							if(strcmp($5->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							
						}
						
						$$=makeOperatorNode(2,makeLeafNode_ARR(($3->op),$5),NULL);
						}
	| WRITE '(' E ')' SC END		{
						

						/*if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}*/
						$$=makeOperatorNode(8,$3,NULL);printf("write identified\n");
						}
	| IF '(' F ')' THEN END Slist ENDIF SC END	{$$=makeOperatorNode(4,$3,$7);}
	| IF '(' F ')' THEN END Slist ELSE END Slist ENDIF SC END	{$$=makeOperatorNode_ITE(15,$3,$7,$10);}
	| WHILE '(' F ')' DO END Slist ENDWHILE SC END	{$$=makeOperatorNode(3,$3,$7);printf("whilee\n");}
	| RET  E SC END			{
						if(strcmp(retstr,"main")!=0)
						{
						struct Typetable *gt=Typelookup(retstr);
						printf("hhhhhhhh %s %s\n",retstr,$2->type->name);
						if(strcmp(retstr,$2->type->name)!=0)//$2->type!=gt->type)
						{printf("return type mismatch\n");exit(1);}
						}
						else
						{
							if(strcmp($2->type->name,"integer")!=0)
								{printf("type mismatch\n");exit(1);}
							
						}
						$$=makeOperatorNode(21,$2,NULL);printf("return completed\n");}
	| RET  F SC END			{
						if(strcmp(retstr,"main")==0)
						{
						{printf("return type mismatch in main\n");exit(1);}
						}
						else
						{
							temp2=Llookup($2->op);
							if(temp2==NULL)
							{
								temp=Glookup($2->op);
								if(temp!=NULL)
								{
									if(strcmp(temp->type->name,"boolean")!=0)
									{
										printf("return type mismatch\n");
										exit(1);
									}
								}
							}
							else
							{
								if(strcmp(temp2->type->name,"boolean")!=0)
									{
										printf("return type mismatch\n");
										exit(1);
									}
							}
						}
						$$=makeOperatorNode(21,$2,NULL);}
	;

FIELD : FIELD '.' ID				{
						$$=makeOperatorNode(24,$1,$3);
						//tt=$1->type;
						fl=$1->type->fields;
						if(fl==NULL)
						{
							printf("id does not contain fieldlist\n");
							exit(1);
						}
						flag=0;
						while(fl!=NULL)
						{
							if(strcmp(fl->name,$3->op)==0)
							{
								flag=1;
								break;
							}
							fl=fl->next;
						}
						if(flag==0)
							{
								printf("%s is not a field \n",$3->op);
								exit(1);
							}
						$$->type=fl->type;
						//$$=makeOperatorNode(24,$1,$3);
						}
      | ID '.' ID				{
						$$=makeOperatorNode(24,$1,$3);
						temp2=Llookup($1->op);
						if(temp2==NULL)
						{
							//check in global
							temp=Glookup($1->op);
							if(temp==NULL)
							{
								printf("field var is not defined\n");
								exit(1);
							}
							fl=temp->type->fields;
							if(fl==NULL)
							{
								printf("id does not contain fieldlist\n");
								exit(1);
							}
							flag=0;
							while(fl!=NULL)
							{
								if(strcmp(fl->name,$3->op)==0)
								{
									flag=1;
									break;
								}
								fl=fl->next;
							}
							if(flag==0)
							{
								printf("%s is not a field in %s\n",$3->op,$1->op);
								exit(1);
							}
							$$->type=fl->type;
						}
						else
						{
							fl=temp2->type->fields;//(does $3->name exists)
							if(fl==NULL)
							{
								printf("id does not contain fieldlist\n");
								exit(1);
							}
							flag=0;
							while(fl!=NULL)
							{
								if(strcmp(fl->name,$3->op)==0)
								{
									flag=1;
									break;
								}
								fl=fl->next;
							}
							if(flag==0)
							{
								printf("%s is not a field in %s\n",$3->op,$1->op);
								exit(1);
							}
							$$->type=fl->type;
						}
						//$$=makeOperatorNode(24,$1,$3);
						}
      ;

F     :  E '<' E  				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(6,$1,$3);
						$$->type=Typelookup("boolean");
						}
	|  E '>' E  				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(7,$1,$3);
						$$->type=Typelookup("boolean");
						}
	|  E '<' '=' E  			{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($4->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(19,$1,$3);
						$$->type=Typelookup("boolean");
						}
	|  E '>' '=' E  			{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($4->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(20,$1,$3);
						$$->type=Typelookup("boolean");
						}
	| E '=' '=' E				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($4->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(5,$1,$4);
						$$->type=Typelookup("boolean");
						}
	| E '!' '=' E				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($4->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(35,$1,$4);
						$$->type=Typelookup("boolean");
						}
	| E '=' '=' NULLTOK			{
						if(strcmp($1->type->name,"integer")==0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($1->type->name,"boolean")==0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(34,$1,NULL);
						$$->type=Typelookup("boolean");
						}
	| E '!' '=' NULLTOK			{
						if(strcmp($1->type->name,"integer")==0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($1->type->name,"boolean")==0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(36,$1,NULL);
						$$->type=Typelookup("boolean");
						}
	/*| E AND E				{
						temp=Glookup($1->op);
						temp1=Glookup($3->op);
						if(temp!=NULL && temp1!=NULL)
						{
							if(temp->TYPE==1 || temp1->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						if(temp==NULL && temp1!=NULL)
						{
							if(temp1->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						if(temp!=NULL && temp1==NULL)
						{
							if(temp->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						$$=makeOperatorNode(13,$1,$3);
						}
	| E OR E				{
						temp=Glookup($1->op);
						temp1=Glookup($3->op);
						if(temp!=NULL && temp1!=NULL)
						{
							if(temp->TYPE==1 || temp1->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						if(temp==NULL && temp1!=NULL)
						{
							if(temp1->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						if(temp!=NULL && temp1==NULL)
						{
							if(temp->TYPE==1)
							{printf("type mismatch\n");exit(1);}
						}
						$$=makeOperatorNode(14,$1,$3);
						}*/
	| TR					{
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeLeafNode(po,1);
						$$->type=Typelookup("boolean");
						}
	| FA					{
						po=malloc(sizeof(char));
						strcpy(po,"#");
						$$=makeLeafNode(po,0);
						$$->type=Typelookup("boolean");
						}
	;
E     : E '+' E 				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(10,$1,$3);
						$$->type=$1->type;
						}
	| E '*' E 				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(11,$1,$3);
						$$->type=$1->type;
						}
	| E '-' E 				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(16,$1,$3);
						$$->type=$1->type;
						}
	| E '/' E 				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(17,$1,$3);
						$$->type=$1->type;
						}
	| E '%' E 				{
						
						if(strcmp($1->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						if(strcmp($3->type->name,"integer")!=0)
							{printf("type mismatch\n");exit(1);}
						$$=makeOperatorNode(18,$1,$3);
						$$->type=$1->type;
						}
	| '(' E ')' 				{$$=$2;}
	| NUM 					{$$=$1;}
	| ID					{$$=$1;if(Llookup($1->op)!=NULL){$$->type=Llookup($1->op)->type;if($$->type==NULL){printf("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu\n");exit(1);}}
						 else if(Glookup($1->op)!=NULL){$$->type=Glookup($1->op)->type;if($$->type==NULL){printf("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu\n");exit(1);}}
						printf("uuuuuuuuuuuuuuuu %s\n",$$->type->name);
						}
	| ID '[' E ']'				{
						$$=makeLeafNode_ARR(($1->op),$3);
						temp=Glookup($1->op);
						if(temp==NULL)
						{
							printf("variable %s not declared\n",$1->op);
							exit(1);
						}
						$$->type=temp->type;
						}
						//$$=makeLeafNode_ARR(($1->op),$3);
						
	| FIELD					{$$=$1;}
	| ID '(' Passlist ')'			{
						temp=Glookup($1->op);//NULL?
						if(temp==NULL)
						{
							printf("calling a function that is not declared\n");
							exit(1);
						}
						n1=temp->para;
						$$=makeOperatorNode(23,$3,NULL);
						$$->type=temp->type;
						$$->op=(char*)malloc(sizeof(char));
						strcpy($$->op,$1->op);
						t1=$3;
						while(t1!=NULL)
						{
							temp2=Llookup(t1->left->op);
							if(temp2!=NULL)
							{
								//printf("pppp%s %d %s %d\n",temp2->NAME,temp2->TYPE,n1->NAME,n1->TYPE);
								if((temp2->type)!=(n1->type) )//|| (t1->left->type)!=(n1->TYPE))
								{
									printf("mismatch while passing arguments to function\n");
									exit(1);
								}
								
							}
							else if((t1->left->NODETYPE)==0)//!0 ?
							{
								
								if(t1->left->type==NULL){printf("1\n");}
								if(n1->type==NULL){printf("2\n");}
								printf("kkkkkkkkkkkkkkkkkkkkkkkkk%s %s\n",t1->left->type->name,n1->type->name);
									if((t1->left->type)!=(n1->type))
									{
										printf("mismatch while passing arguments to function21\n");
										exit(1);
									}//}
								//else	fact(TRUE)	fact(2)
							}
							else
							{
								if(t1->left->left==NULL && t1->left->right==NULL)
								{
								temp=Glookup(t1->left->op);
								//printf("%s\n",t1->left->op);
								if(temp!=NULL)
								{//printf("pppp%s %d %s %d\n",temp->NAME,temp->TYPE,n1->NAME,n1->TYPE);

									if((temp->type)!=(n1->type))// || (t1->left->type)!=(n1->TYPE))
									{
										printf("mismatch while passing arguments to function\n");
										exit(1);
									}
									
								}
								else
								{
									printf("variable not declared in caaling function parameters\n");
									exit(1);
								}
								}
								//n-1
							}
							
							t1=t1->right;
							n1=n1->NEXT;
							if(n1==NULL && t1!=NULL)
							{
								printf("function calling arguments less or more");
								exit(1);
							}
							if(n1!=NULL && t1==NULL)
							{
								printf("function calling arguments less or more");
								exit(1);
							}
						}
							if(!(n1==NULL && t1==NULL))
							{
								printf("function calling arguments less or more");
								exit(1);
							}
						//$$->type=$1->type;
						}
	;
Passlist: 
	 E ',' Passlist			{$$=makeOperatorNode(22,$1,$3);}
	| E					{$$=makeOperatorNode(22,$1,NULL);}
	| F					{$$=makeOperatorNode(22,$1,NULL);}
	| F ',' Passlist			{$$=makeOperatorNode(22,$1,$3);}
	;

%%

yyerror(char const *s)
{
    printf("yyerror %s",s);
}


int main() {
	yyin = fopen("input_file.txt","r");
	storing=(char*)malloc(sizeof(char));
	retstr=(char*)malloc(sizeof(char));
	TypeTableCreate();
	yyparse();
	return 0;
}
