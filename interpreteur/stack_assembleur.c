#include "stack_assembleur.h"
#include <stdio.h>


int index_a = 0;

void push_a(int adr){
	stack_a[index_a++]=adr;
}

int pop_a(){
	index_a--;	
	return stack_a[index_a];
}

void print_a(){
	int i =0;
	printf("PILE\n");
	while(i<index_a){
		printf("%d\n",stack_a[i++]);
	}
}
