#include <stdlib.h>
#include <string.h>
#include "fonction.h"
int index_fonction;
int index_pile_arg;


void init_pile_arg(){
	index_fonction=0;
}

void push_arg(int adr){
	pile_arg[index_pile_arg++]=adr;
}

int pop_arg(){return pile_arg[--index_pile_arg];}

void init_table_fonction(){
	index_fonction=0;
}
int get_index_pile_arg(){return index_pile_arg;}


Fonction* get_fonction(char*nom){
	int i=0;
	while(strcmp(tab_fonction[i].nom,nom)!=0)i++;
	return &tab_fonction[i];
} 

void add_fonction(char* nom, int adr){
	tab_fonction[index_fonction].nom=nom;
	tab_fonction[index_fonction++].adr=adr;
}


