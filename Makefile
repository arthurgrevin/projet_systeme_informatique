# bonjour
TARGETS=cible
OBJECTS=
LDFLAGS=
CFLAGS=-Wall -Werror

all: $(TARGETS)

cible: y.tab.c lex.yy.c symboles.c jmp.c
	gcc -g y.tab.c lex.yy.c symboles.c fonction.c jmp.c -ll -o $@ 

lex.yy.c: token.lex
	flex token.lex 

y.tab.c: analyse_syn.yacc 
	yacc -d -v analyse_syn.yacc

run:
	./cible
