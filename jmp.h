#ifndef JUMP
# define JUMP
#define JNE 1
#define JMP 0

typedef struct jmp Jump;

void init_tab_jmp();

void add_from(int from,int type,int adr_jmf);

void remplir(int to,int num);

void print_tab();

int get_to(int from,int *type,int *adr_jmf);

void remplir_while_from(int from);

void remplir_while_to(int to);

int add_while(int to,int from, int type,int adr_jmf);
int get_while_to(int from,int *type, int *adr_jmf);

void print_tab_while();

#endif



