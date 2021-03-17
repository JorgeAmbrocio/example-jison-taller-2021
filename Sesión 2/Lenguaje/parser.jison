
%{
  	// entorno
  	var tablaSimbolos = new Map();
  	//Ejecuciones
    function EjecutarBloque(LINS)
		{
        var retorno=null;
        LINS.forEach(elemento =>  
            {
                switch(elemento.TipoInstruccion)
                {
                    case "imprimir":
                      var res=Evaluar(elemento.Operacion);
                      console.log(res.Valor);
                      break;
                  	case "crear":
                    	EjecutarCrear(elemento);
                    	break;
                  	case "asignar":
                    	EjecutarAsignar(elemento);
                    	break;
                    case "hacer":
                    	EjecutarHacer(elemento);
                    	break;
                    case "si":
                      EjecutarSi(elemento);
                      break;
                    case "mientras":
                      EjecutarMientras(elemento);
                      break;
                    case "desde":
                      EjecutarDesde(elemento);
                      break;
                    case "seleccionar":
                      EjecutarSeleccionar(elemento);
                      break;
                    case "romper":
                      retorno = elemento;
                      break;
                }
            }
        )
        return retorno;
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
                return nuevoSimbolo(!Valorizq.Valor,"bool");
            case "and":
                return nuevoSimbolo(Valorizq.Valor && Valorder.Valor, "bool");
            case "or":
                return nuevoSimbolo(Valorizq.Valor || Valorder.Valor, "bool");
            case ">":
                return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, "bool");
            case "<":
                return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, "bool");
            case ">=":
                return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, "bool");
            case "<=":
                return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, "bool");
            case "==":
                return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, "bool");
            case "!=":
                return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, "bool");
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
      if (tablaSimbolos.has(crear.Id))
      {
      	return;
      }
    		// evaluar el resultado de la expresión 
    	var valor ;	
      if (crear && crear.Expresion)
      {
          	valor = Evaluar(crear.Expresion);
    	}
      else
        {
            switch(crear.Tipo)
            {
                case "numero":
                    valor=nuevoSimbolo(0,"numero");
                    break;
                case "cadena":
                    valor=nuevoSimbolo("","cadena");
                    break;
                case "bool":
                    valor=nuevoSimbolo(false,"bool");
                    break;
            }
        }
      
      // crear objeto a insertar
      tablaSimbolos.set(crear.Id, valor);
    }
		// asignar
  	const Asignar = function(id, expresion)
    {
    	return {
      		Id:id,
        	Expresion: expresion,
        	TipoInstruccion: "asignar"
      }
    }
    
    function EjecutarAsignar (asignar) 
		{
      // validar si existe la variable
      if (!tablaSimbolos.has(asignar.Id))
      {
      	return;
      }
      
    		// evaluar el resultado de la expresión 
    	var simbolotabla = tablaSimbolos.get(asignar.Id) ;	
      var valor = Evaluar(asignar.Expresion);
    	
      // comparar los tipos
      if (simbolotabla.Tipo === valor.Tipo)
      {
    			// reasignar el valor
      		tablaSimbolos.set(asignar.Id, valor);
      }
    }
  //Romper
  const Romper = function(){
    return {
      TipoInstruccion:"romper"
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
        else if(si.BloqueElse!=null)
        {
        	EjecutarBloque(si.BloqueElse);
        }
      }
  }
  //Casos
  const Caso = function(Expresion,Bloque)
  {
    return {
      Expresion:Expresion,
      Bloque:Bloque
    }
  }

  const Seleccionar = function(Expresion, LCasos, NingunoBloque)
  {
    return  {
      Expresion: Expresion,
      LCasos: LCasos,
      NingunoBloque: NingunoBloque,
      TipoInstruccion: "seleccionar"
    }
  }

  function EjecutarSeleccionar(seleccionar)
  {
    var ejecutado=false;
    for(var elemento of seleccionar.LCasos)
    {
        var condicion=Evaluar(NuevaOperacion(seleccionar.Expresion,elemento.Expresion,"=="));
        if(condicion.Tipo=="bool"){
          if(condicion.Valor || ejecutado){
            ejecutado=true;
            var res = EjecutarBloque(elemento.Bloque)
            if(res && res.TipoInstruccion=="romper"){
              break;
            }
          }
        }else{
          break
        }
    }
    if(seleccionar.NingunoBloque && !ejecutado){
      EjecutarBloque(seleccionar.NingunoBloque);
    }
    return null;
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
    	var resultadoCondicion = Evaluar(mientras.Condicion)
      if(resultadoCondicion.Tipo=="bool")
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
  
  function EjecutarDesde(Desde)
  {
    //controlador de la condicion
    if( Desde.ExpDesde.TipoInstruccion == "crear" )
    {
      EjecutarCrear(Desde.ExpDesde);
    }
    else
    {
      EjecutarAsignar(Desde.ExpDesde);
    }
    //mientras no se llegue al hasta
    var paso = Evaluar(Desde.ExpPaso);
    var hasta = Evaluar(Desde.ExpHasta);
    var Simbolo=nuevoSimbolo(Desde.ExpDesde.Id,"ID")
    while(true){
      var inicio=Evaluar(Simbolo)
      if(paso.Valor > 0){
        if(inicio.Valor <= hasta.Valor){
          var res=EjecutarBloque(Desde.Bloque);
        }else{
          break;
        }  
      }
      else
      {
        if(inicio.Valor >= hasta.Valor){
          var res=EjecutarBloque(Desde.Bloque);
        }else{
          break;
        }
      }
      EjecutarAsignar(Asignar(Desde.ExpDesde.Id,NuevaOperacion(Simbolo,paso,"+")))
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
"romper"        return "Rromper"

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
"caso"					return "Rcaso";
"ninguno"				return "Rninguno";

// TIPOS
"numero"					return "Rnumero";
"cadena"					return "Rcadena";
"booleano"				return "Rbooleano";

";"                 return 'PTCOMA';
"("                 return 'PARIZQ';
")"                 return 'PARDER';
"verdadero"         return 'TRUE';
"falso"             return 'FALSE';

">="                return 'MAYORI';
"<="                return 'MENORI';
"=="                return 'IGUALADAD';
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
%left 'IGUALADAD' 'DIFERENTE'
%left 'MENOR' 'MAYOR' 'MAYORI' 'MENORI'
%left 'MAS' 'MENOS'
%left 'POR' 'DIV' 'MOD'
%right UMENOS

%start INI

%% /* Definición de la gramática */

INI
    : LINS EOF { console.log(JSON.stringify($1,null,2)); EjecutarBloque($1) }
;

LINS 
    : LINS INS  { $$=$1; $$.push($2); }
    | INS       { $$=[]; $$.push($1); }
		| error '\n' {console.log("Sintactico","Error en : '"+yytext+"'",this._$.firstline,this.$.first_column)}
;


INS 
    : Rimprimir PARIZQ EXP PARDER { $$=Imprimir("imprimir",$3);}
    | CREAR				{ $$ = $1; }									
		| ASIGNAR			{ $$ = $1; }
		| SI					{ $$ = $1; }
		| MIENTRAS		{ $$ = $1; }
		| DESDE				{ $$ = $1; }
		| HASTA				{ $$ = $1; } 
    | CASOS       { $$ = $1; }
    | Rromper     { $$ = Romper(); }
;

CREAR
	:Rcrear ID Rcomo TIPO							{$$ = Crear($2, $4, null);}
  |Rcrear ID Rcomo TIPO IGUAL EXP 	{$$ = Crear($2, $4, $6);}
  ;

ASIGNAR
	:ID IGUAL EXP							{$$ = Asignar($1, $3);}
  ;

SI 
	: Rsi EXP Rentonces BLOQUE 								{ $$ = Si($2,$4,null); }
	| Rsi EXP Rentonces BLOQUE Rsino BLOQUE		{ $$ = Si($2,$4,$6); }
;

CASOS
  : Rseleccionar EXP LCASOS Rninguno BLOQUE     { $$=Seleccionar($2,$3,$5); }
  | Rseleccionar EXP LCASOS                     { $$=Seleccionar($2,$3,null); }
;

LCASOS
  : Rcaso EXP BLOQUE                      { $$=[]; $$.push(Caso($2,$3)); }
  | LCASOS Rcaso EXP BLOQUE               { $$=$1; $$.push(Caso($3,$4)); }
;

MIENTRAS
	: Rmientras EXP BLOQUE { $$=new Mientras($2, $3); }
;

BLOQUE
	: Rhacer LINS Rfin  {$$ = $2;}
	| Rhacer Rfin				{$$ = [];}
;

DESDE
	:Rdesde ASIGNAR Rhasta EXP Rpaso EXP BLOQUE { $$ = Desde($2, $4, $6, $7); }
  |Rdesde CREAR Rhasta EXP Rpaso EXP BLOQUE { $$ = Desde($2, $4, $6, $7); }
;

TIPO
	:Rnumero			{$$="numero"}
  |Rcadena			{$$="cadena"}
  |Rbooleano		{$$="bool"}
;

EXP 
    : EXP MAS EXP           { $$=NuevaOperacion($1,$3,"+"); }
    | EXP MENOS EXP         { $$=NuevaOperacion($1,$3,"-"); }
    | EXP POR EXP           { $$=NuevaOperacion($1,$3,"*"); }
    | EXP DIV EXP           { $$=NuevaOperacion($1,$3,"/"); }
    | EXP MOD EXP           { $$=NuevaOperacion($1,$3,"%"); }
    | EXP MENOR EXP         { $$=NuevaOperacion($1,$3,"<"); }
    | EXP MAYOR EXP         { $$=NuevaOperacion($1,$3,">"); }
    | EXP DIFERENTE EXP     { $$=NuevaOperacion($1,$3,"!="); }
    | EXP IGUALADAD EXP     { $$=NuevaOperacion($1,$3,"=="); }
    | EXP MAYORI EXP        { $$=NuevaOperacion($1,$3,">="); }
    | EXP MENORI EXP        { $$=NuevaOperacion($1,$3,"<="); }
    | EXP AND EXP           { $$=NuevaOperacion($1,$3,"and"); }
    | EXP OR EXP            { $$=NuevaOperacion($1,$3,"or"); }
    | NOT EXP               { $$=NuevaOperacionUnario($2,"not"); }
    | MENOS EXP %prec UMENOS { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                { $$=nuevoSimbolo($1,"cadena"); }
		| ID										{ $$=nuevoSimbolo($1,"ID");}
    | NUMERO                { $$=nuevoSimbolo(parseFloat($1),"numero"); }
    | TRUE                  { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                 { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ EXP PARDER     { $$=$2 }
;
