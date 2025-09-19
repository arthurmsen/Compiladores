%{
#include <iostream>
#include <string>

using namespace std;

string lexema;
%}

D           [0-9]
L           [a-zA-Z_]

_ID         ({L}|[\$])({L}|{D})*

_INV_ID     [_]({L}|{D}|[\$])*|({L}|[\$])({L}|{D}|[\$])*

_INT        {D}+

_FLOAT      {D}+(\.{D}+)?([Ee][+\-]?{D}+)?

_FOR        [F|f][O|o][R|r]

_IF         [I|i][F|f]

_STRING     \"([\t]|[^\n\"]|\\\"|\\\'|\"\"|\'\')*\"|\'([\t]|[^\n\']|\\\"|\\\'|\"\"|\'\')*\'

_STRING2    (\`|\})([\n\t]|[^\`\{]|\')*(\`|[\$])|\`([\n\t]|[ˆ\`]|\'|[\$][^{])*\`

_EXPR       \{{_ID}

_COMENTARIO \/\*(([^\*\/]|[ \n\t])*)\*\/|\/\/([^\n])*|\/\*(\*|[^\*\/]|[ \n\t]|\/[^\/])*\*\/

WS          [ \t\n]+

%%

{WS}    { }

">="    { lexema = yytext; return _MAIG; }
"<="    { lexema = yytext; return _MEIG; }
"=="    { lexema = yytext; return _IG; }
"!="    { lexema = yytext; return _DIF; }

{_FOR}   { lexema = yytext; return _FOR; }

{_IF}    {lexema = yytext; return _IF;}

{_ID}    { lexema = yytext; return _ID; }

{_INV_ID}    { cout << "Erro: Identificador invalido: " << yytext << endl; }

{_INT}   { lexema = yytext; return _INT; }

{_FLOAT} { lexema = yytext; return _FLOAT; }

{_STRING} {    // Cria a string pulando o primeiro char e ignorando o último
    if (lexema == "") { }
    else{
    lexema = string(yytext + 1, yyleng - 2);
    }
    for (int i = 0; i < lexema.length(); i++){
        if (lexema[i] == '"' && i != lexema.length() - 1){
            if (i != 0 && lexema[i-1] == '\\'){
                lexema.erase(i-1,1);
            }
            if (i != lexema.length() - 2 && lexema[i+1] == '"' && lexema[i+2] != ' ') {
                lexema.erase(i,1);
            }
        }
    }
    for (int i = 0; i < lexema.length(); i++){
        if (lexema[i] == '\'' && i != lexema.length() - 1){
            if (i != 0 && lexema[i-1] == '\\'){
                lexema.erase(i-1,1);
            }
            if (i != lexema.length() - 2 && lexema[i+1] == '\'' && lexema[i+2] != ' ') {
                lexema.erase(i,1);
            }
        }
    }
    return _STRING;
}


{_STRING2} { 
    lexema = string(yytext + 1, yyleng - 2);
    return _STRING2;
}

{_EXPR} {     
    lexema = string(yytext + 1, yyleng - 1);
    return _EXPR;
}

{_COMENTARIO} { lexema = yytext; return _COMENTARIO; }

.       { lexema = yytext; return yytext[0]; }

%%




/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */
