%{
  #include <iostream>
  using namespace std;

  struct symbolTableEntry {
    int line;
    char name[20];
    char type[20];
  } symbolTable[20];

  int entryCount = 0;
  int lineNumber = 1;

  void insertToSymbolTable(int lineNumber, const char *type);
  void printSymbolTable();
%}

function "main()"|"getch()"
brace "{"|"}"|"("|")"|"["|"]"
operator "+"|"-"|"/"|"*"|"="|"++"|"--"|"<"|">"|"<="|">="
indent "//"|"/*"|"*/"
alpha [a-zA-Z]
number [0-9]
dtype "int"|"float"|"double"|"char"
keyword "return"|"void"|"while"|"for"|"if"|"do"|"break"
ws " "
separator "\n"|","|";"|"\t"
format "%d"|"%s"|"%c"|"%f"
comment {indent}({alpha}|{number}|{ws})*
identifier {alpha}({alpha}|{number})*
arithmetic-op [+|-|*|/]
relational-op [<|>|<=|>=|!=|==]
array {identifier}("["({number})*"]")+

%%

"#include"      {std::cout << yytext << " :include statement\n";}
({alpha})+".h"  {std::cout << yytext << " :header file\n";}
{function}      {std::cout << yytext << " :a standard function\n";}
{operator}      {std::cout << yytext << " :an operator\n";}
{comment}       {std::cout << yytext << " :a comment\n";}
{dtype}         {std::cout << yytext << " :a data type\n";}
{keyword}       {std::cout << yytext << " :a reserved keyword\n";}
{identifier}    {std::cout << yytext << " :an identifier\n"; insertToSymbolTable(lineNumber, "identifier");}
{array}         {std::cout << yytext << " :an array\n"; insertToSymbolTable(lineNumber, "array");}
{separator}     {std::cout << yytext << " :a separator\n"; if(strcmp(yytext, "\n") == 0) {lineNumber++;}}
{arithmetic-op} {std::cout << yytext << " :an arithmetic operator\n";}
{relational-op} {std::cout << yytext << " :a relational operator\n";}

%%

int yywrap(){
  return 1;
}

void insertToSymbolTable(int lineNumber, const char *type){
  int exists = 0;
  for(int i=0; i<20; i++){
      if(strcmp(symbolTable[i].name, yytext) ==0){
        exists = 1;
        break;
      }
  }

  if(!exists){
    symbolTable[entryCount].line = lineNumber;
    strcpy(symbolTable[entryCount].name, yytext);
    strcpy(symbolTable[entryCount].type, type);
    entryCount++;
  }
}

void printSymbolTable(){
  std::cout << "\nLine \t\t  Symbol \t\t Type\n";
  for(int i = 0; i <entryCount; i++){
    std::cout << symbolTable[i].line << "  \t\t  " << symbolTable[i].name << " \t\t " << symbolTable[i].type << "\n";
  }
}

int main(int argc, char* argv[]){
    FILE *fp = fopen("input.c", "r");
    if(fp){
      yyin = fp;
    }
    yylex();

    printSymbolTable();
    
    return 0;
  }
