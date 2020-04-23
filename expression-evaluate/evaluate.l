%{
    #include <iostream>
    #include "y.tab.h"
    using namespace std;
%}

%%

[0-9]+  {
          yylval = atoi(yytext);
          return DIGIT;
        }

"*"     { return *yytext; }
"+"     { return *yytext; }
"-"     { return *yytext; }
[\n]    { return NEWLINE; }
[()]    { return *yytext; }

%%

int yywrap(){
  return 1;
}
