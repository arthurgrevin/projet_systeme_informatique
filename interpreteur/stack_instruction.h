#ifndef STACK_H
#define STACK_H
#define LOAD 1
#define STORE 2
#define	AFC 3
#define	ADD 4
#define	MUL 5
#define	SUB 6
#define	DIV 7
#define	NEG 8
#define EQ 9
#define JMP 10
#define JMF 11
#define R1 12
#define R2 13
#define INF 14
#define SUP 15
#define END 16
#define JMPR 17
#define START 18
#define PUSH 19
#define POP 20

typedef struct instruction{
	int numero;
	int type;
	int var1;
	int var2;
} ins;

typedef struct stack_instruction{
	int index;
	ins tab_ins [255];
}stack_ins;

stack_ins* stack;

void init_stack_ins();
void push (int numero, int type, int var1, int var2);
ins* pop();
void move_index(int new_index);

#endif
