#include <stdio.h>
#include "stack_instruction.h"
#include <stdlib.h>




void init_stack_ins(){
	stack=malloc(sizeof(stack_ins));
	stack->index=1;
}

void push (int numero, int type, int var1, int var2){
	stack->tab_ins[stack->index].numero=numero;
	stack->tab_ins[stack->index].type=type;
	stack->tab_ins[stack->index].var1 = var1;
	stack->tab_ins[stack->index].var2=var2;
	stack->index++;
}

ins* pop(){
	return &stack->tab_ins[stack->index++];
}

void move_index(int new_index){
	stack->index=new_index;
}






