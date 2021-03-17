
%{
%}
/* Definición Léxica */
%lex

%options case-insensitive
%x Comentario
%x Etiqueta
%%                
/* Espacios en blanco */
"//".*            	  {}
"<!--"                {console.log("Comenzo el comentario"); this.begin("Comentario"); }
<Comentario>[ \r\t]+  {}
<Comentario>\n        {}
<Comentario>"-->"     {console.log("Termino el comentario"); this.popState();}
<Comentario>[^"-->"]+ {console.log("Texto dentro del comentario: "+yytext+" :(")} 

"<"[A-Za-z][A-Za-z0-9]*         {console.log("Comenzo una etiqueta"); this.begin("Etiqueta"); }
<Etiqueta>[ \r\t]+  {}
<Etiqueta>\n        {}
<Etiqueta>[A-Za-z][A-Za-z0-9]*  {console.log("Atributo");}
<Etiqueta>"="                   {console.log("Igual de Atributo");}
<Etiqueta>\"[^\n\"]*\"          {console.log("Valor")}
<Etiqueta>">"                   {console.log("Termino una etiqueta de apertura"); this.popState();}
<Etiqueta>"/>"                  {console.log("Termino una etiqueta de cierre"); this.popState();}

[ \r\t]+            {}
\n                  {}

<<EOF>>                 return 'EOF';

.*                  { console.error('Este es texto plano: ' + yytext) }

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