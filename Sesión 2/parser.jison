
%{
  	// entorno
  	var tablaSimbolos = new Map();
  	//Ejecuciones
    function EjecutarBloque(LINS)
		{
        LINS.forEach(elemento =>  
            {
                switch(elemento.TipoInstruccion)
                {
                    case "imprimir":
                        var res=Evaluar(elemento.Operacion);
                        console.log(res.Valor);
                        break;
                  	case "crear"
                    	EjecutarCrear(elemento);
                    	break;
                  	case "asignar"
                    	EjecutarAsignar(elemento);
                    	break;
                    case "hacer"
                    	EjecutarHacer(elemento);
                    	break;
                }
            }
        )
    }

    //Expresion
    const nuevoSimbolo= function(Valor,Tipo)
    {
        return {
            Valor:Valor,
            Tipo:Tipo
        }
    }
    const NuevaOperacion= function(OperandoIzq,OperandoDer,Tipo)
    {
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
      //Simbolos
        switch(Operacion.Tipo)
        {
            case "bool":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "cadena":
                return nuevoSimbolo(Operacion.Valor,Operacion.Tipo);
            case "numero":
                return nuevoSimbolo(parseFloat(Operacion.Valor),Operacion.Tipo);
          	case "ID":
            		if(tablaSimbolos.has(Operacion.Valor))
                {
                  var valorID = tablaSimbolos.get(Operacion.Valor);
                  return nuevoSimbolo(valorID.Valor,valorID.Tipo);
                }
        }
      //Operaciones
        Valorizq=Evaluar(Operacion.OperandoIzq);
        if(Operacion.OperandoDer!=null)
        {
            Valorder=Evaluar(Operacion.OperandoDer);
        }
        switch (Operacion.Tipo) 
        {
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
                return nuevoSimbolo(!Valorizq.Valor,Valorizq.Tipo);
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
    function NuevaOperacionUnario(Operando,Tipo)
		{
        return {
            OperandoIzq:Operando,
            OperandoDer:null,
            Tipo:Tipo
        }
    }
		/*------------------------------------------------------------*/
    //Imprimir
    const Imprimir=function(TipoInstruccion,Operacion)
    {
        return {
            TipoInstruccion:TipoInstruccion,
            Operacion:Operacion
        }
    }
  	//Crear
  	const Crear = function(id, tipo, expresion)
    {
    	return {
      		Id:id,
        	Tipo: tipo,
        	Expresion: expresion,
        	TipoInstruccion:"crear"
      }
    }
    
    function EjecutarCrear (crear) 
		{
      // validar si existe la variable
      if (tablaSimbolos.has(asignar.id))
      {
      	return;
      }
    		// evaluar el resultado de la expresión 
    	var valor ;	
      if (crear && crear.Expresion)
      {
          	valor = Evaluar(crear.Expresion);
    	}
      
      // crear objeto a insertar
      tablaSimbolos.set(crear.id, valor);
    }
		// asignar
  	const Asignar = function(id, tipo, expresion)
    {
    	return {
      		Id:id,
        	Tipo: tipo,
        	Expresion: expresion,
        	TipoInstruccion:"asignar"
      }
    }
    
    function EjecutarAsignar (asignar) 
		{
      // validar si existe la variable
      if (!tablaSimbolos.has(asignar.id))
      {
      	return;
      }
      
    		// evaluar el resultado de la expresión 
    	var simbolotabla = tablaSimbolo.get(asignar.id).valor ;	
      var valor = Evaluar(crear.Expresion);
    	
      // comparar los tipos
      if (simbolotabla.tipo === valor.tipo)
      {
    			// reasignar el valor
      		tablaSimbolos.set(asignar.id, valor);
      }
    }
	//Si	 
	const Si=function(Condicion,BloqueSi,BloqueElse)
  {
  		return {
      	Condicion:Condicion,
        BloqueSi:BloqueSi,
        BloqueElse:BloqueElse,
        TipoInstruccion:"si"
      }
  }
  
  function EjecutarSi (si)
	{
    	var res = Evaluar(si.Condicion);
  		if(res.Tipo=="bool")
      {
      	if(res.Valor)
        {
        	EjecutarBloque(si.BloqueSi);
        }
        else if(BloqueElse!=null)
        {
        	EjecutarBloque(si.BloqueElse);
        }
      }
  }

	//Mientras
	const Mientras = function(Condicion, Bloque)
  {
    return {
      Condicion: Condicion,
      Bloque: Bloque,
      TipoInstruccion:"mientras"
    }
  }
  
  function EjecutarMientras(mientras)
	{
    while(true)
    {
    	var resultadoCondicion = evaluar(mientras.Condicion)
      if(resultadoCondicion.Tipo==bool)
      {
      	if(resultadoCondicion.Valor)
        {
        		var res=EjecutarBloque(mientras.Bloque);
        }
        else
        {
          break;
      	}
      }
    }
  }

	const Desde = function(ExpDesde, ExpHasta, ExpPaso, Bloque){
    return {
      ExpDesde: ExpDesde,
      ExpHasta: ExpHasta,
      ExpPaso: ExpPaso,
      Bloque: Bloque,
      TipoInstruccion:"desde"
    }
  }
  
  function EjecutarDesde(Desde){
    //controlador de la condicion
    var contador = Evaluar(Desde.ExpDesde);
    //mientras no se llegue al hasta
    var paso = Evaluar(Desde.ExpPaso);
    var hasta = Evaluar(Desde.ExpHasta);
    
    while(true){
      if(paso > 0){
        
        if(contador <= hasta){
        var res=EjecutarBloque(Desde.Bloque);
          contador = contador + paso;
        }else{
          break;
        }
        
      }else{
        if(contador >= hasta){}
        var res=EjecutarBloque(Desde.Bloque);
          contador = contador + paso;
        }else{
          break;
        }
      }
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

"imprimir"			return "Rimprimir";
"crear"					return "Rcrear"; // declaración
"como"					return "Rcomo";

"sino"					return "Rsino";
"si"						return "Rsi"; // if
"entonces"			return "Rentonces";

"mientras"			return "Rmientras"; // while

"desde"					return "Rdesde"; // ciclo for
"hasta"					return "Rhasta";
"paso"					return "Rpaso";

"hacer"					return "Rhacer";
"fin"						return "Rfin";

"seleccionar"		return "Rseleccionar";// select case
"caso"					return "Rcasos";
"ninguno"				return "Rninguno";

// TIPOS
"numero"					return "Rnumero";
"cadena"					return "Rcadena";
"booleano"				return "Rbooleano";

";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';
"verdad"            return 'TRUE';
"falso"             return 'FALSE';

">="                return 'MAYORI';
"<="                return 'MENORI';
"=="                return 'IGUAL';
"!="                return 'DIFERENTE';
"="                 return 'IGUAL';
"+"                 return 'MAS';
"-"                 return 'MENOS';
"*"                 return 'POR';
"/"                 return 'DIV';
"%"                 return 'MOD';
">"                 return 'MAYOR';
"<"                 return 'MENOR';
"yy"                return 'AND';
"oo"                return 'OR';
"nel"               return 'NOT';

[a-zA-Z][a-zA-Z0-9_]*   return 'ID'
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
%right UMENOS

%start ini

%% /* Definición de la gramática */

ini
    : LIns EOF { console.log(JSON.stringify($1,null,2)); EjecutarBloque($1) }
    | error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
;

LIns 
    : LINS INS  { $$=$1; $$.push($2); }
    | INS       { $$=[]; $$.push($1); }
		
;


INS 
    : Rimprimir PARIZQ Exp PARDER { $$=Imprimir("imprimir",$3);}
    | CREAR				{ $$ = $1; }									
		| ASIGNAR			{ $$ = $1; }
		| Si					{ $$ = $1; }
		| Mientras		{ $$ = $1; }
		| Desde				{ $$ = $1; }
		| Hasta				{ $$ = $1; }   
;

CREAR
	:Rcrear ID Rcomo TIPO							{$$ = Crear($2, $4, null);}
  |Rcrear ID Rcomo TIPO Rigual Exp 	{$$ = Crear($2, $4, $6);}
  ;

ASIGNAR
	:ID Rcomo Exp							{$$ = Asignar($1, $3);}
  ;

Si 
	: Rsi Exp Rentonces Bloque 								{ $$ = Si($2,$4,null); }
	| Rsi Exp Rentonces Bloque Rsino Bloque		{ $$ = nSi($2,$4,$6); }
;	

Mientras
	: Rmientras Exp Bloque { $$=new Mientras($2, $3); }
;

Bloque
	: Rhacer LIns Rfin  {$$ = $2;}
	| Rhacer Rfin				{$$ = [];}
;

Desde
	:Rdesde E Rhasta E Rpaso E Bloque { $$ = Desde($2, $4, $6); }
;

TIPO
	:Rnumero			{$$=$1}
  |Rcadena			{$$=$1}
  |Rbooleano		{$$=$1}
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
    | NOT Exp               { $$=NuevaOperacionUnario($2,"not"); }
    | MENOS Exp %prec UMENOS { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                { $$=nuevoSimbolo($1,"cadena"); }
		| ID										{ $$=nuevoSimbolo($1,"ID");}
    | NUMERO                { $$=nuevoSimbolo($1,"numero"); }
    | TRUE                  { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                 { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ Exp PARDER     { $$=$2 }
;
