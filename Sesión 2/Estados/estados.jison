
%{
%}
/* Definición Léxica */
%lex

%options case-insensitive
%x Comentario
%%
/* Espacios en blanco */
"//".*            	{}
"<!--"                {console.log("Comenzo el comentario"); this.begin("Comentario")}
<Comentario>[ \r\t]+  {}
<Comentario>\n        {}
<Comentario>"-->"     {console.log("Termino el comentario"); this.begin("INITIAL")}
<Comentario>[^"-->"]+ {console.log("Texto dentro del comentario: "+yytext+" :(")} 

[ \r\t]+            {}
\n                  {}


<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

/* Asociación de operadores y precedencia */
%left 'OR'
%left 'AND'
%right 'NOT'
%left 'IGUALADAD' 'DIFERENTE'
%left 'MENOR' 'MAYOR' 'MAYORI' 'MENORI'
%left 'MAS' 'MENOS'
%left 'POR' 'DIV' 'MOD'
%right UMENOS

%start INI

%% /* Definición de la gramática */

INI
  : EOF { console.log("Fin Archivo") }
;