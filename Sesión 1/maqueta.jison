%{

%}

%lex

%options case-insenstive

%%
    [ \t\r\n]*   {}

    <<EOF>>     return 'EOF'

    . { console.log("El simvbolo"+ yytext +" no se reconoce")};
/lex


%start ini

%%

ini
