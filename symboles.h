#ifndef SYMBOLE
# define SYMBOLE


typedef struct{
	char * nom;
	int adr_mem;
} symbole;

void init_table();

void add_symbole(char* n,int adr);

int get_symbole(char * n, symbole** resultat);

void print();

int get_next();

int get_adr_mem(int position);

void enlever_symbole();

int get_adr(symbole s);


#endif
