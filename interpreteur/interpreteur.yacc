%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "stack_instruction.h"
#include "stack_assembleur.h"



void yyerror(const char *a);
int tab_mem[1024];
int memR1,memR2; 
int debut;
%}

%token tAFC tSTORE tLOAD tADD tMUL tSUB tDIV tR1 tR2 tNEG tEQ tSUP tINF tEND tJMP tJMF tSTART tJMPR tPUSH tPOP
%token <numero> tNUMERO
%union {int numero;}

%error-verbose
%%




	input: DEBUT;

	DEBUT : {init_stack_ins();}INSTRUCTIONS{
				printf("index : %d\n",stack->index);
				move_index(debut);
				printf("index : %d\n",stack->index);
				ins *aux_ins= pop();
				//printf("numero : %d\n",aux_ins->numero);
				while(aux_ins->type!=END){
					printf("numero : %d\n",aux_ins->numero);					
					switch (aux_ins->type){
						case LOAD : switch(aux_ins->var1){
										case R1 : memR1=tab_mem[aux_ins->var2];
											printf("R1 = %d\n",memR1);
										break;
										case R2 : memR2=tab_mem[aux_ins->var2];
											printf("R2 = %d\n",memR2);
									}
						break;
						case STORE : switch(aux_ins->var2){
										case R1 :if(aux_ins->var1==R2){
													tab_mem[memR2]=memR1;
													printf("var %d = %d\n",memR2,tab_mem[memR2]);
												}else{
													tab_mem[aux_ins->var1]=memR1;
													printf("R1 = %d\n",memR1);
													printf("var %d = %d\n",aux_ins->var1,tab_mem[aux_ins->var1]);
												}
										break;
										case R2 : tab_mem[aux_ins->var1]=memR2;
												printf("var %d = %d\n",aux_ins->var1,tab_mem[aux_ins->var1]);
									}
						break;
						case AFC : switch(aux_ins->var1){
									case R1 : memR1=aux_ins->var2;
											printf("R1 = %d\n",memR1);
									break;
									case R2 : memR2 = aux_ins->var2;
									}
						break;
						case ADD : memR1 = memR1 + memR2;
								printf("R1 = %d\n",memR1);
						break;
						case SUB : memR1 = memR1 - memR2;
								printf("R1 = %d\n",memR1);
						break;
						case MUL : memR1 = memR1 * memR2;
									printf("R1 = %d\n",memR1);
						break;
						case DIV : memR1 = memR1 / memR2;
						break;
						case EQ  : if(memR1==memR2)memR1=1;
									else memR1=0;
						break;
						case NEG : memR1 = -memR1;
								printf("R1 = %d\n",memR1);
						break;
						case JMP : move_index(aux_ins->var1);
						break;
						case JMF : if(!memR1)move_index(aux_ins->var2);
						break;
						case INF : if(memR1<memR2)memR1=1;
								else memR1=0;
						break;
						case SUP : if (memR1>memR2)memR1=1;
							else memR1=0;
						break;
						case JMPR : move_index(memR1);
						break;
						case PUSH : push_a(memR1);
									print_a();
						break;
						case POP :	switch(aux_ins->var1){

										case R1 : printf("%d\n",memR1=pop_a());
										print_a();
										printf("R1 = %d\n",memR1);
										break;
										case R2 : memR2=pop_a();
										print_a();
										printf("R2=%d\n",memR2);
									}
					}
					aux_ins=pop();
				}

			};

	INSTRUCTIONS : INSTRUCTION INSTRUCTIONS
				| INSTRUCTION;
	
	INSTRUCTION : tNUMERO tAFC tR1 tNUMERO{
				//R1 = $4; 
				printf("AFC R1\n");
				push($1,AFC,R1,$4);
				}				
			| tNUMERO tAFC tR2 tNUMERO{
				printf("AFC R2\n");
				push($1,AFC,R2,$4);			
				}	
			| tNUMERO tADD tR1 tR2{
				//R1 = R1 + R2;
				printf("ADD\n");
				push($1,ADD,R1,R2);				
				}
			|tNUMERO tSUB tR1 tR2{
				//R1 = R1 - R2;
				//printf("R1 <- R1 - R2, R1 = %d \n",R1);
				push($1,SUB,R1,R2);				
				}
			|tNUMERO tDIV tR1 tR2	{
				//R1 = R1 / R2;
				//printf("R1 <- R1 / R2, R1 = %d \n",R1);
				push($1,DIV,R1,R2);
				}
			| tNUMERO tMUL tR1 tR2{
				//R1 = R1 * R2;
				//printf("R1 <- R1 * R2, R1 = %d \n",R1);
				push($1,MUL,R1,R2);
			}
			|tNUMERO tLOAD tR1 tNUMERO{
				//R1 = tab_mem[$4];
				printf("LOAD R1\n");
				push($1,LOAD,R1,$4);
			}
			|tNUMERO tLOAD tR2 tNUMERO{
			//	R2 = tab_mem[$4];
				printf("LOAD R2\n");
				push($1,LOAD,R2,$4);
			}
			|tNUMERO tSTORE tNUMERO tR1{
			//	tab_mem[$3] = R1;
				printf("STORE R1\n");
				push($1,STORE,$3,R1);
			}
			|tNUMERO tSTORE tNUMERO tR2{
			//	tab_mem[$3] = R2;
				printf("STORE R2\n");
				push($1,STORE,$3,R2);
			}
			|tNUMERO tSTORE tR2 tR1{push($1,STORE,R2,R1);printf("STORE R1 R2\n");}
			|tNUMERO tNEG tR1{
				//R1 = -R1;
				//printf("R1 <- -R1, R1 = %d\n",R1);
				push($1,NEG,R1,0);
			}
			|tNUMERO tEQ tR1 tR2{
				//if(R1 == R2)R1=1;
				//else R1 = 0;
				//printf("TEST : R1 == R2 -> R1 = %d\n",R1);
				push($1,EQ,R1,R2);				
			}
			|tNUMERO tSUP tR1 tR2{
				//if(R1 > R2)R1=1;
				//else R1=0;
				//printf("TEST : R1 > R2 -> R1 = %d\n",R1);
				push($1,SUP,R1,R2);				

			}
			|tNUMERO tINF tR1 tR2{
				//if(R1 < R2)R1=1;
				//else R1=0;
				//printf("TEST : R1 > R2 -> R1 = %d\n",R1);
				push($1,INF,R1,R2);			

			}
			|tNUMERO tJMF tR1 tNUMERO{
				push($1,JMF,R1,$4);
			}
			|tNUMERO tJMP tNUMERO{
				printf("JMP\n");
				push($1,JMP,$3,0);
			}
			|tNUMERO tEND{push($1,END,0,0);printf("END\n");}
			|tNUMERO tSTART{push($1,START,0,0);printf("START\n");debut=$1;}
			|tNUMERO tJMPR tR1{push($1,JMPR,R1,0);printf("JMPR R1\n");}
			|tNUMERO tPUSH tR1{push($1,PUSH,R1,0);printf("PUSH R1\n");}
			|tNUMERO tPOP tR1{push($1,POP,R1,0);printf("POP R1\n");}
			|tNUMERO tPOP tR2{push($1,POP,R2,0);printf("POP R2\n");};			

%%

void yyerror(const char *a){
	printf("%s",a);
}		
