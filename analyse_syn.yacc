%{
#include <stdio.h>
#include "symboles.h"
#include <string.h>
#include <stdlib.h>
#include "jmp.h"
#include <readline/readline.h>
#include <readline/history.h>
#include "fonction.h"


//%type <type> nonTerminaux

void yyerror(const char *a);
FILE * fichier= NULL;
FILE * fichier_fin = NULL;
int compteur =0;
int num=1;
int index_mem=0;


%}
%token tMAIN tPRINTF tINT tCONST tEXP tACC_OUVR tACC_FERM tADD tSUB tMUL tDIV tEQ tPAR_OUVR tPAR_FERM tVIRG tSPACE tTAB tRETURN tPOINT_VIRGULE tELSE tIF tINF tSUP tOR tAND tNOT tWHILE
%token <chaine> tID
%token <decimal> tDECI
%type <adresse> EXPRESSION 
%type <adresse> DECLARATION
%type <adresse> APPEL_FONCTION
%error-verbose
%start input
%union {char* chaine; int adresse; int decimal;}
%left tADD tSUB
%left tMUL tDIV
%left NEG
%%

	input: DEBUT;
	DEBUT :{
		fichier= fopen("assembleur","w+");
		init_table_fonction();
		}
		 FONCTION tMAIN tACC_OUVR{compteur++;fprintf(fichier,"%d : START\n",compteur);init_table();} INSTRUCTIONS tACC_FERM { 
				compteur ++;
				fprintf(fichier,"%d : END\n",compteur);
				fclose(fichier);
				fichier=fopen("assembleur","r");
				fichier_fin=fopen("assembleur_final","w+");
				int size = 1024;
				char* ligne=malloc(sizeof(char)*size);
				int compteur_ligne=1;
				int type;
				int to;
				int to_wh;
				int type_wh;
				int adr_jmf_if;
				int adr_jmf_while;				
				while(fgets(ligne,size,fichier)!=NULL){
					to=get_to(compteur_ligne,&type,&adr_jmf_if);
					to_wh=get_while_to(compteur_ligne,&type_wh,&adr_jmf_while);
					if((to==-1)&&(to_wh==-1)){
						printf("2e passe : %d copie simple\n",compteur_ligne);
						fputs(ligne,fichier_fin);
					}else{
						printf("to : %d, to_wh : %d\n",to,to_wh);
						if(to != -1){
						switch (type){
							case JMP :
								printf("2e passe : %d : JMP %d\n",compteur_ligne,to);
								fputs("",fichier_fin);
								fprintf(fichier_fin,"%d : JMP %d\n",compteur_ligne,to);
								

								break;
							case JNE :
								printf("2e passe : JMF %d\n",to);
								fputs("",fichier_fin);
								fprintf(fichier_fin,"%d : JMF R1 %d\n",compteur_ligne,to);
								break;
						}
					}else{						
						printf("valeur type_wh : %d",type_wh);
						switch (type_wh){
							case JMP :
								printf("2e passe while : %d : JMP %d\n",compteur_ligne,to_wh);
								fputs("",fichier_fin);
								fprintf(fichier_fin,"%d : JMP %d\n",compteur_ligne,to_wh);	 
								break;
							case JNE :
								printf("2e passe while : JMF %d %d\n",adr_jmf_while,to_wh);
								fputs("",fichier_fin);
								fprintf(fichier_fin,"%d : JMF R1 %d\n",compteur_ligne,to_wh);
								break;
						}
					}
				}
					compteur_ligne++;
				}
				printf("FIN\n");};

	FONCTION :TYPE tID{
				init_table();
				add_fonction($2,compteur+1);
				//printf("%d",compteur);
				init_pile_arg();
				}tPAR_OUVR PARAMETRES tPAR_FERM tACC_OUVR{
				while(get_index_pile_arg()!=0){
					//compteur++;
					fprintf(fichier,"%d : POP R1\n",++compteur);
					fprintf(fichier,"%d : STORE %d R1\n",++compteur,pop_arg());
				}
				} INSTRUCTIONS tACC_FERM{
					fprintf(fichier,"%d : POP R1\n",++compteur);
					fprintf(fichier,"%d : JMPR R1\n",++compteur);
				}
		|;

	PARAMETRES : PARAMETRE
			|PARAMETRE tVIRG PARAMETRES;

	PARAMETRE : DECLARATION{push_arg($1);};

	APPEL_FONCTION : tID{init_pile_arg();} tPAR_OUVR ARGS tPAR_FERM{
					symbole * temp;
	
					fprintf(fichier,"%d : AFC R1 %d\n",++compteur,compteur+6+(get_index_pile_arg()*2));
					fprintf(fichier,"%d : PUSH R1\n",++compteur); 
					add_symbole($1,index_mem++);
					fprintf(fichier,"%d : AFC R1 %d\n",++compteur,get_adr_mem(get_next()-1));
					fprintf(fichier,"%d : PUSH R1\n",++compteur);
					printf("%d\n",get_index_pile_arg());

					while(get_index_pile_arg()>0){
						int aux = get_index_pile_arg();
						//printf("%d\n",aux);
						fprintf(fichier,"%d : LOAD R1 %d\n",++compteur,pop_arg());
						fprintf(fichier,"%d : PUSH R1\n",++compteur);
					}
					fprintf(fichier,"%d : JMP %d\n",++compteur, get_fonction($1)->adr);
					$$=get_adr_mem(get_next()-1);							
					};
	
	ARGS : ARG
		| ARG tVIRG ARGS;
	ARG : EXPRESSION{
		printf("%d\n",$1);
		push_arg($1);
		enlever_symbole();
		}
	OPERATION :  AFFECTATION
				| DECLARATION
				| PRINTF
				|APPEL_FONCTION
				|RETURN;

	RETURN : tRETURN EXPRESSION{
			fprintf(fichier,"%d : LOAD R1 %d\n",++compteur,$2);
			fprintf(fichier,"%d : POP R2\n",++compteur);
			fprintf(fichier,"%d : STORE R2 R1\n",++compteur);
			};


	INSTRUCTION :OPERATION tPOINT_VIRGULE
				|IF
				|WHILE;

	INSTRUCTIONS : INSTRUCTION INSTRUCTIONS
        		| INSTRUCTION;

	TYPE		: tINT 
				|tCONST;

	DECLARATION : //TYPE tID DECLARATION2
				 TYPE tID{
					add_symbole($2,index_mem++);
					//printf("DECLARATION SIMPLE\n\n");
					//print();

					$$=get_adr_mem(get_next()-1);
				};

	

				
	AFFECTATION :| tID tEQ EXPRESSION{
				symbole * mon_symbole;
				compteur ++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$3);
				compteur ++;
				fprintf(fichier,"%d : STORE %d R1\n",compteur,get_symbole($1,&mon_symbole));
				enlever_symbole();
				}
				| DECLARATION tEQ EXPRESSION{
				compteur ++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$3);
				compteur ++;
				fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
				enlever_symbole();
				}
				| tID tEQ APPEL_FONCTION{
				symbole * mon_symbole;
				fprintf(fichier,"%d : LOAD R1 %d\n",++compteur,$3);
				fprintf(fichier,"%d : STORE %d R1\n",++compteur,get_symbole($1,&mon_symbole));				
				};


	EXPRESSION	:	EXPRESSION tADD EXPRESSION {
					//	printf("%d : LOAD R1 %d\n",compteur, $1);
						compteur ++;
						fprintf(fichier,"%d : LOAD R1 %d\n",compteur, $1);
					//	printf("LOAD R2 %d\n", $3);
						compteur ++;
						fprintf(fichier,"%d : LOAD R2 %d\n",compteur, $3);
						//printf("ADD R1 R2 \n");
						compteur ++;
						fprintf(fichier,"%d : ADD R1 R2\n",compteur);
						compteur ++;
						fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
						enlever_symbole();			
						//print();
						$$=$1;
						}
				|	EXPRESSION tSUB EXPRESSION {
						//printf("SOUSTRACTION\n");
						compteur ++;
						fprintf(fichier,"%d : LOAD R1 %d\n",compteur, $1);
						compteur ++;
						fprintf(fichier,"%d : LOAD R2 %d\n",compteur, $3);
						compteur ++;
						fprintf(fichier,"%d : SUB R1 R2\n",compteur);
						compteur ++;
						fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
						enlever_symbole();
						//print();
						$$=$1;
						}

				|	EXPRESSION tMUL EXPRESSION{
					//printf("MULTIPLIER\n");
					compteur ++;
					print();
					fprintf(fichier,"%d : LOAD R1 %d\n",compteur, $1);
					compteur ++;
					fprintf(fichier,"%d : LOAD R2 %d\n",compteur, $3);
					compteur ++;
					fprintf(fichier,"%d : MUL R1 R2\n",compteur);
					compteur ++;
					fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
					enlever_symbole();
					//print();
					$$=$1;
				}
				|	EXPRESSION tDIV EXPRESSION {
					//printf("DIVISER\n");
					compteur ++;
					fprintf(fichier,"%d : LOAD R1 %d\n",compteur, $1);
					compteur ++;
					fprintf(fichier,"%d : LOAD R2 %d\n",compteur, $3);
					compteur ++;
					fprintf(fichier,"%d : MUL R1 R2\n",compteur);
					compteur ++;
					fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
					enlever_symbole();
					//print();
					$$=$1;
					}
				|	tPAR_OUVR EXPRESSION tPAR_FERM{$$=$2;}
				|	tID{
					//printf("%s\n",$1);
					symbole * mon_symbole;
					symbole * temp;
					add_symbole("tmp",index_mem++);						
					//print();
					//printf("%d : LOAD R2 %d\n",compteur,get_symbole($1,&mon_symbole));
					compteur ++;
					fprintf(fichier,"%d : LOAD R1 %d\n",compteur,get_symbole($1,&mon_symbole));
					//printf("STORE %d R2\n\n",get_adr_mem(get_next()-1));
					compteur++;
					fprintf(fichier,"%d : STORE %d R1\n",compteur,get_adr_mem(get_next()-1));
					$$ = get_adr_mem(get_next()-1);
					}
				|	tDECI{
						//symbole * mon_symbole;
						symbole * temp;
						add_symbole("tmp",index_mem++);						
						//print();
						//printf("AFC R1 %d\n",$1);
						compteur ++;
						fprintf(fichier,"%d : AFC R1 %d\n",compteur,$1);
						compteur ++;
						fprintf(fichier,"%d : STORE %d R1\n",compteur, get_adr_mem(get_next()-1));
						$$ = get_adr_mem(get_next()-1);
						}
				| EXPRESSION tSUP EXPRESSION {
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$1);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$3);
				compteur++;
				fprintf(fichier,"%d : SUP R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1\n",compteur,$1);
				enlever_symbole();
				$$=$1;
				}
				| EXPRESSION tINF EXPRESSION 
				{
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$1);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$3);
				compteur++;
				fprintf(fichier,"%d : INF R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n", compteur,$1);
				enlever_symbole();
				$$=$1;
				}
				| EXPRESSION tEQ tEQ EXPRESSION {
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$1);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$4);
				compteur++;
				fprintf(fichier,"%d : EQ R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n", compteur,$1);
				enlever_symbole();
				$$=$1;
				}
				|EXPRESSION tOR EXPRESSION {
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$1);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$3);
				compteur++;
				fprintf(fichier,"%d : OR R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n", compteur,$1);
				enlever_symbole();
				$$=$1;}
				|EXPRESSION tAND EXPRESSION {
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$1);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$3);
				compteur++;
				fprintf(fichier,"%d : AND R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n", compteur,$1);
				enlever_symbole();
				$$=$1;}
				|tSUB EXPRESSION %prec NEG{
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$2);
				compteur++;
				fprintf(fichier,"%d : NEG R1\n",compteur);
				compteur++;
				$$=$2;
				fprintf(fichier,"%d : STORE %d R1\n",compteur,$$);
				print();			
				};
	
	PRINTF : tPRINTF tID tPAR_FERM;
	
	/*CONDITION : tPAR_OUVR EXPRESSION tSUP EXPRESSION tPAR_FERM{
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$2);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$5);
				compteur++;
				fprintf(fichier,"%d : SUP R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1\n",compteur,$2);
				$$=$2;
				}
				|tPAR_OUVR EXPRESSION tINF EXPRESSION tPAR_FERM
				{
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$2);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$5);
				compteur++;
				fprintf(fichier,"%d : INF R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n" comteur,$2);
				$$=$2;
				}
				|tPAR_OUVR EXPRESSION tEQ tEQ EXPRESSION tPAR_FERM{
				compteur++;
				fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$2);
				compteur++;
				fprintf(fichier,"%d : LOAD R2 %d\n",compteur,$5);
				compteur++;
				fprintf(fichier,"%d : EQ R1 R2\n",compteur);
				compteur++;
				fprintf(fichier,"%d : STORE %d R1 \n" comteur,$2);
				$$=$2;
				};

		
	CONDITIONS : CONDITION
				{
					$$=$1;
				}
				|CONDITION tOR CONDITIONS
				{
					compteur++;
					fprintf(fichier,"%d : ")
				}
				|CONDITION tAND CONDITIONS
				|tNOT tPAR_OUVR CONDITIONS tPAR_FERM;
	
	*/
	//reduce reduce problem;
	IF :tIF tPAR_OUVR EXPRESSION tPAR_FERM{

		compteur++;

		fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$3);
		compteur++;
		add_from(compteur,JNE,$3);
		fprintf(fichier,"%d : JMF R1 \n",compteur);
		 }BODY{
		 	num++;
		 	print_tab();
		 	remplir(compteur+1,num);

		 	
		 	print_tab();

		 }
		|IF tELSE{
		add_offset();	
		compteur++;
		add_from(compteur,JMP,-1);
		fprintf(fichier,"%d : JMP\n",compteur);		
		}			
		BODY{
			remplir(compteur+1,num);
			num++;
		};

	WHILE : {
			printf(" Début while : %d \n", compteur);
			add_while(compteur+1,-1,JMP,-1);
			}tWHILE tPAR_OUVR EXPRESSION tPAR_FERM{
			compteur ++;
			fprintf(fichier,"%d : LOAD R1 %d\n",compteur,$4);
			compteur++;
			fprintf(fichier,"%d : JMF R1 \n",compteur);
			add_while(-1,compteur,JNE,$4);
			//print_tab_while();
	} BODY{
		compteur++;
		fprintf(fichier,"%d : JMP\n",compteur);
		print_tab_while();
		remplir_while_to(compteur+1);
		remplir_while_from(compteur);
		print_tab_while();


		/*test
		add_while(-1,10,JNE);
		add_while(15,-1,JNE);
		remplir_while_from(15);
		remplir_while_to(10);
		print_tab_while();
		*/

	};

		
	


	BODY : tACC_OUVR INSTRUCTIONS tACC_FERM
		| 	INSTRUCTION;
	
%%

void yyerror(const char *a){
	printf("%s",a);
}


