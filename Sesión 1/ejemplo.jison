
/* Definición JS */
%{
    /*
      CÓDIGO JS
    */
%}



%lex

%options case-insensitive

%%
/* Espacios en blanco */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]           {}
[ \r\t]+            {}
\n                  {}

"imprimir"		return "Rimprimir";

";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';

//\"([^])*\"   { yytext = yytext.substr(1,yyleng-2); return 'Cadena'; }


<<EOF>>                 return 'EOF'; // INDICA EL FINAL DEL ARCHIVO

// TODO LO QUE NO SE HA DESCRITO, SE IDENTIFICA COMO ERROR
.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

/* Asociación de operadores y precedencia */

//%left 'OR'
//%left 'AND'
//%right 'NOT'


%start ini

%% /* Definición de la gramática */

ini
    : LIns EOF { console.log($1);  }
    | error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
;

LIns 
    : LINS INS  { $$=$1; }
    | INS       { $$=$1; }
;


INS 
    :Rimprimir PARIZQ  PARDER { $$=$1 + $2 + $3;}
;

