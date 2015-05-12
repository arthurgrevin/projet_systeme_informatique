#include <stdio.h>
#include<string.h>
#include "symboles.h"
#define TAILLE 1024




//int index_adr;
int index_table;
symbole table[TAILLE];

void init_table(){
	//index_adr = 0;
	index_table = 0;
	memset(&table,0,TAILLE*sizeof(symbole));
}

void add_symbole(char* n,int adr){
	table[index_table].nom = n;
	table[index_table].adr_mem = adr;
	index_table++;
	//index_adr++;
}



int get_symbole(char * n, symbole** resultat){
	int i= 0;
	while(i<=index_table){
		if(strcmp(table[i].nom,n)==0){
			*resultat= &table[i];
			return table[i].adr_mem;
		}
		else{
			i++;
		}
	}
	printf("RATE\n");
	return 22;
}

int get_next(){
	return index_table;
}
 
int get_adr_mem(int position){
	return table[position].adr_mem;	
}

void enlever_symbole(){
	if(index_table>0)index_table--;
	//index_adr--;
}

int get_adr(symbole s){
	return s.adr_mem;
}

void print(){
	printf("*********TABLE DES SYMBOLES*********\n");
	int i;
	for(i=0;i<index_table;i++){
		printf("%s %d\n",table[i].nom,table[i].adr_mem);
	}
	printf("*********END OF TABLE *********\n\n");
}


