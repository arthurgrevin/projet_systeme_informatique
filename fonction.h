#ifndef FONCTION_H
#define FONCTION_H

typedef struct fonction{
	char* nom;
	int adr;
} Fonction;

Fonction tab_fonction[255];

int pile_arg[255];



void init_table_fonction();
Fonction* get_fonction(char* nom);
void add_fonction(char* nom, int adr);
void push_arg(int adr);
int pop_arg();
void init_pile_arg();
int get_index_pile_arg();


#endif
