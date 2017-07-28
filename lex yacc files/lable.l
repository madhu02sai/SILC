%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <stdlib.h>
FILE *newfile_pointer,*newfile_pointer2;
	int a[1000][2],b[1000][2],i,count=0,count2=0,k=0,m=0,satti;
	char str[1000];
%}

%%
"\n"		{if(k==0){if(m>7)
                                   count2++;}else{fprintf(newfile_pointer2,"\n");}m++;}
"L"[0-9]+":""\n"	{ 
				if(k==0)
				{
					strcpy(str,yytext);
					for(i=1;i<strlen(str)-2;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					a[i][0]=count;
					a[i][1]=2056+2*count2;printf("%d\n",count2);
					printf("%d\n",a[i][1]);
				}
				else{

                                   }
			}
"F"[0-9]+":""\n"	{ 
				if(k==0)
				{
					strcpy(str,yytext);
					for(i=1;i<strlen(str)-2;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					b[i][0]=count;
					b [i][1]=2056+2*count2;printf("%d\n",count2);
					printf("%d\n",b[i][1]);
				}
				else{
                                   

                                   }
			}
"M""A""I""N"":""\n"	{ 
				if(k==0)
				{
					strcpy(str,yytext);
					for(i=1;i<strlen(str)-2;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					//b[i][0]=count;
					satti=2056+2*count2;printf("%d\n",count2);
					printf("%d\n",satti);
				}
				else{
                                   

                                   }
			}
"L"[0-9]+"\n"	{       count2++;
				if(k==1)
				{    strcpy(str,yytext);
					for(i=1;i<strlen(str)-1;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					printf("lala %d\n",i);
					fprintf(newfile_pointer2,"%d\n",a[i][1]);
				}
				else{
                                   

                                   }
			}
"F"[0-9]+"\n"	{       count2++;
				if(k==1)
				{    strcpy(str,yytext);
					for(i=1;i<strlen(str)-1;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					printf("lala %d\n",i);
					fprintf(newfile_pointer2,"%d\n",b[i][1]);
				}
				else{
                                   

                                   }
			}
"M""A""I""N""\n"	{       count2++;
				if(k==1)
				{    strcpy(str,yytext);
					for(i=1;i<strlen(str)-1;i++)
					{
						str[i-1]=str[i];
					}
					str[i-1]='\0';
					i=atoi(str);
					//i/=10;
					printf("lala %d\n",i);
					fprintf(newfile_pointer2,"%d\n",satti);
				}
				else{
                                   

                                   }
			}


.   { if(k==1){fprintf(newfile_pointer2,yytext);
	}}

%%

int yywrap()
{      
  	
  	newfile_pointer = fopen("xexe.xsm","r");
	newfile_pointer2=fopen("xsm_expl/xexexe.xsm","w");
  	     if(k==0){
  		yyin = newfile_pointer;
                k=1;
		return 0;
       }else
    		return 1;
}

int main()
{     printf("hjnhhjhj\n");
  	yyin = fopen("xexe.xsm","r");
  	yylex();
  	return 1;
}
