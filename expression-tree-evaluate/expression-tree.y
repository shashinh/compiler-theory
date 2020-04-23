%{
    #include <iostream>
    using namespace std;
    #include "tree.h"
    extern int yylex();
    extern int yyerror(char const* s);
%}

%union{
        struct node* node;
}

%type <node> expr NUMBER program END
%token NUMBER PLUS MINUS MUL DIV END
%left PLUS MINUS
%left MUL DIV

%%

program : expr END  {
                        std::cout << "Result = " << evaluate ($1) << endl;
                        exit(1);
                    }
        ;

expr    : expr PLUS expr    {$$ = makeOperatorNode('+',$1,$3);}
        | expr MINUS expr   {$$ = makeOperatorNode('-',$1,$3);}
        | expr MUL expr     {$$ = makeOperatorNode('*',$1,$3);}
        | expr DIV expr     {$$ = makeOperatorNode('/',$1,$3);}
        | '(' expr ')'      {$$ = $2;}
        | NUMBER            {$$ = $1;}
        ;

%%

int yyerror(char const* s){
    std::cout << "yyerror : " << s << endl;
    return 1;
}

int main(){
    yyparse();
    return 0;
}
