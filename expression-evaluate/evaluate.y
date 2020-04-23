%{
    #include <iostream>
    using namespace std;
    extern int yylex();
    extern int yyerror(char const* s);
    extern FILE *yyin;
%}

%token DIGIT NEWLINE


%left '-' '+'
%left '*'

%%

start : expr NEWLINE {std::cout << "Expression value = " << $1 << "\n"; exit(1);}
      ;

expr  : expr '*' expr {$$ = $1 * $3;}
      | expr '+' expr {$$ = $1 + $3;}
      | expr '-' expr {$$ = $1 - $3;}
      | '(' expr ')' {$$ = $2;}
      | DIGIT         {$$ = $1;}
      ;


%%

int yyerror(char const* s){
    std::cout << s;
}

int main (){
    FILE *fp = fopen("input.txt", "r");
    if(fp){
      yyin = fp;
    }
    yyparse();
    return 1;
}
