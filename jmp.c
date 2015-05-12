#include <stdio.h>
#include <stdlib.h>
#include "jmp.h"


struct jmp{
	int from;
	int to;
	int type;
	int num;
	int adr_jmf;
};

int index_table;
int index_while;


Jump tab[1024];
Jump tab_while[1024];

void init_tab_jmp(){
index_table= 0;
index_while=0;
}


void add_from(int from,int type,int adr_jmf){
	tab[index_table].from=from;
	tab[index_table].to = -1;
	tab[index_table].type=type;
	tab[index_table].adr_jmf=adr_jmf;
	index_table++;
}



void add_offset(){
	//chercher le num max et ajouter +1 dans le TO
	int i = index_table-1;
	int resultat;
	int max = 0;

	while(i>=0){
		if(tab[i].num>max){
			max=tab[i].num;
			resultat = i;
		}
		i--;
	}
	tab[resultat].to++;
}

void remplir(int to, int num){
	int i = index_table-1;
	int trouve =0;
	while(i>=0 && trouve==0){
		if(tab[i].to == -1){
			trouve=1;
			tab[i].to=to;
			tab[i].num = num;
		}else{
			i--;
		}
	}
}


void print_tab(){
	int i=0;
	printf("***DEBUT AFFICHAGE TABLE JMP***\n");
	while(i<index_table){
		printf("%d : %d : %d : %d\n",tab[i].from,tab[i].to,tab[i].type,tab[i].num);
		i++;
	}
	printf("***FIN AFFICHAGE TABLE JMP***\n");
}

int get_to(int from,int *type,int *adr_jmf){
	int i = index_table-1;
	int resultat = -1;
	while(i>=0){
		if(tab[i].from==from){
			*type = tab[i].type;
			*adr_jmf=tab[i].adr_jmf;
			printf("SUCCES : %d\n",tab[i].to);
			return tab[i].to;		
		}
		i--;
	}
	return resultat;	
}

int add_while(int to,int from,int type,int adr_jmf){
	tab_while[index_while].to=to;
	tab_while[index_while].from=from;
	tab_while[index_while].type=type;
	tab_while[index_while].adr_jmf=adr_jmf;
	index_while++;
}

void remplir_while_from(int from){
	int i = index_while-1;
	int trouve =0;
	while(trouve==0&&i>=0){
		if(tab_while[i].from==-1){
			tab_while[i].from=from;
			trouve=1;
		}
		i--;
	}
}

void remplir_while_to(int to){
	int i = index_while-1;
	int trouve =0;
	while(i>=0 && trouve==0){
		if(tab_while[i].to == -1){
			trouve=1;
			tab_while[i].to=to;
		}else{
			i--;
		}
	}
}

int get_while_to(int from,int *type,int *adr_jmf){
		int i = index_while-1;
	int resultat = -1;
	while(i>=0){
		if(tab_while[i].from==from){
			*type = tab_while[i].type;
			*adr_jmf=tab_while[i].adr_jmf;
			printf("type : %d\n",*type);
			printf("SUCCES : %d\n",tab_while[i].to);
			return tab_while[i].to;		
		}
		i--;
	}
	return resultat;
}


	

void print_tab_while(){
	int i=0;
	printf("***DEBUT AFFICHAGE TABLE JMP WHILE***\n");
	while(i<index_while){
		printf("%d : %d : %d : %d\n",tab_while[i].from,tab_while[i].to,tab_while[i].type,tab_while[i].num);
		i++;
	}
	printf("***FIN AFFICHAGE TABLE JMP WHILE***\n");
}







