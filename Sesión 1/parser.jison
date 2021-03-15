
%{
    function EjecutarBloque(LINS){
        LINS.forEach(elemento =>  
            {
                switch(elemento.TipoInstruccion){
                    case "imprimir":
                        var res=Evaluar(elemento.Operacion)
                        console.log(res.Valor);
                        break;
                }
            }
        )
    }
    //Expresion
    function nuevoSimbolo(Valor,Tipo){
        return {
            Valor:Valor,
            Tipo:Tipo
        }
    }
    function NuevaOperacion(OperandoIzq,OperandoDer,Tipo){
        return {
            OperandoIzq:OperandoIzq,
            OperandoDer:OperandoDer,
            Tipo:Tipo
        }
    }
    function Evaluar(Operacion)
    {
        var Valorizq;
        var Valorder;
        switch(Operacion.Tipo){
            case "bool":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "cadena":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "numero":
                return nuevoSimbolo(parseFloat(Operacion.Valor),Operacion.Tipo);
        }
        Valorizq=Evaluar(Operacion.OperandoIzq);
        Valorder=Evaluar(Operacion.OperandoDer);
        switch (Operacion.Tipo) {
            case "+":
                return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, Valorizq.Tipo);
            case "-":
                return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, Valorizq.Tipo);
            case "umenos":
                return nuevoSimbolo(0-Valorizq.Valor, Valorizq.Tipo);
            case "*":
                return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, Valorizq.Tipo);
            case "/":
                return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, Valorizq.Tipo);
            case "%":
                return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, Valorizq.Tipo);
            case "not":
                return nuevoSimbolo(!Valorizq.Valor,Valorder.Tipo);
            case "and":
                return nuevoSimbolo(Valorizq.Valor && Valorder.Valor, Valorizq.Tipo);
            case "or":
                return nuevoSimbolo(Valorizq.Valor || Valorder.Valor, Valorizq.Tipo);
            case ">":
                return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, Valorizq.Tipo);
            case "<":
                return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, Valorizq.Tipo);
            case ">=":
                return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, Valorizq.Tipo);
            case "<=":
                return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, Valorizq.Tipo);
            case "==":
                return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, Valorizq.Tipo);
            case "!=":
                return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, Valorizq.Tipo);
        }
    }
    function NuevaOperacionUnario(Operando,Tipo){
        return {
            OperandoIzq:Operando,
            OperandoDer:null,
            Tipo:Tipo
        }
    }
    //Instruccion
    const Imprimir=function(TipoInstruccion,Operacion){
        return {
            TipoInstruccion:TipoInstruccion,
            Operacion:Operacion
        }
    }
%}
/* Definición Léxica */
%lex

%options case-insensitive

%%
/* Espacios en blanco */
"//".*            	{}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]           {}
[ \r\t]+            {}
\n                  {}

"imprimirts"		return "Rimprimir";

";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';
"true"              return 'TRUE';
"false"             return 'FALSE';

">="                return 'MAYORI';
"<="                return 'MENORI';
"=="                return 'IGUAL';
"!="                return 'DIFERENTE';
"**"				return "POT";
"="                 return 'IGUAL';
"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'POR';
"/"                 return 'DIV';
"%"                 return 'MOD';
">"                 return 'MAYOR';
"<"                 return 'MENOR';
"&&"                return 'AND';
"||"                return 'OR';
"!"                 return 'NOT';
"?"                 return 'TERNARIO';


[0-9]+("."[0-9]+)?\b    return 'NUMERO';
\"((\\\")|[^\n\"])*\"   { yytext = yytext.substr(1,yyleng-2); return 'Cadena'; }
\'((\\\')|[^\n\'])*\'	{ yytext = yytext.substr(1,yyleng-2); return 'Cadena'; }
\`[^\n\`]*\`			{ yytext = yytext.substr(1,yyleng-2); return 'TEMPLATE'; }

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

/* Asociación de operadores y precedencia */
%left 'OR'
%left 'AND'
%right 'NOT'
%left 'IGUAL' 'DIFERENTE'
%left 'MENOR' 'MAYOR' 'MAYORI' 'MENORI'
%left 'MAS' 'MENOS'
%left 'POR' 'DIV' 'MOD'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
    : LIns EOF { console.log(JSON.stringify($1,null,2)); EjecutarBloque($1) }
    | error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
;

LIns 
    : LINS INS  { $$=$1; $$.push($2) }
    | INS       { $$=[]; $$.push($1) }
;

INS 
    :Rimprimir PARIZQ Exp PARDER { $$=Imprimir("imprimir",$3);}
;

Exp 
    : Exp MAS Exp           { $$=NuevaOperacion($1,$3,"+"); }
    | Exp MENOS Exp         { $$=NuevaOperacion($1,$3,"-"); }
    | Exp POR Exp           { $$=NuevaOperacion($1,$3,"*"); }
    | Exp DIV Exp           { $$=NuevaOperacion($1,$3,"/"); }
    | Exp MOD Exp           { $$=NuevaOperacion($1,$3,"%"); }
    | Exp MENOR Exp         { $$=NuevaOperacion($1,$3,"<"); }
    | Exp MAYOR Exp         { $$=NuevaOperacion($1,$3,">"); }
    | Exp DIFERENTE Exp     { $$=NuevaOperacion($1,$3,"!="); }
    | Exp IGUAL Exp         { $$=NuevaOperacion($1,$3,"=="); }
    | Exp MAYORI Exp        { $$=NuevaOperacion($1,$3,">="); }
    | Exp MENORI Exp        { $$=NuevaOperacion($1,$3,"<="); }
    | Exp AND Exp           { $$=NuevaOperacion($1,$3,"and"); }
    | Exp OR Exp            { $$=NuevaOperacion($1,$3,"or"); }
    | NOT Exp               { $$=NuevaOperacionUnario($1,"not"); }
    | MENOS Exp %prec UMENOS { $$=NuevaOperacionUnario($1,"umenos"); }
    | Cadena                { $$=nuevoSimbolo($1,"cadena"); }
    | NUMERO                { $$=nuevoSimbolo($1,"numero"); }
    | TRUE                  { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                 { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ Exp PARDER     { $$=$2 }
;
