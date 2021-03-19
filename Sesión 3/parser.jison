%{
    var pilaCiclosSw = [];
    var pilaFunciones = [];
  	// entorno
  	const Entorno = function(anterior)
    {
    	return {
        	tablaSimbolos:new Map(),
          	anterior:anterior
        }
    }
  	var EntornoGlobal = Entorno(null)
  	//Ejecuciones
    function EjecutarBloque(LINS, ent)
	{
        var retorno=null;
        for(var elemento of LINS)
        {
        	switch(elemento.TipoInstruccion)
          	{
            	case "imprimir":
                    var res=Evaluar(elemento.Operacion, ent);
                    console.log(res.Valor);
                    break;
                case "crear":
                    retorno = EjecutarCrear(elemento, ent);
                    break;
                case "asignar":
                    retorno = EjecutarAsignar(elemento, ent);
                    break;
                case "hacer":
                    retorno = EjecutarHacer(elemento, ent);
                    break;
                case "si":
                    retorno = EjecutarSi(elemento, ent);
                    break;
                case "mientras":
                    retorno = EjecutarMientras(elemento, ent);
                    break;
                case "desde":
                    retorno = EjecutarDesde(elemento, ent);
                    break;
                case "seleccionar":
                    retorno = EjecutarSeleccionar(elemento, ent);
                    break;
                case "funcion":
                    retorno = EjecutarFuncion(elemento,EntornoGlobal);
                    break;
                case "llamada":
                    EjecutarLlamada(elemento,ent);
                    retorno = null;
                    break;
                case "retorno":
                    if (pilaFunciones.length>0)
                    {
                        retorno = elemento.Expresion;
                    }
                    else
                    {
                        console.log("Intruccion retorno fuera de una funcion")
                    }
                    break;
                case "romper":
                    if (pilaCiclosSw.length>0)
                    {
                        return elemento;
                    }
                    else
                    {
                        console.log("Intruccion romper fuera de un seleccionar o un ciclo")
                    }
                    
          	}
            if(retorno)
            {
                return retorno;
            }
        }
        return null;
    }
    //Expresion
    const nuevoSimbolo = function(Valor,Tipo)
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
    function NuevaOperacionUnario(Operando,Tipo)
	{
        return {
            OperandoIzq:Operando,
            OperandoDer:null,
            Tipo:Tipo
        }
    }
    function Evaluar(Operacion,ent)
    {
        var Valorizq=null;
        var Valorder=null;
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
                temp=ent;
                while(temp!=null)
                {
                    if(temp.tablaSimbolos.has(Operacion.Valor))
                    {
                        var valorID = temp.tablaSimbolos.get(Operacion.Valor);
                        return nuevoSimbolo(valorID.Valor,valorID.Tipo);
                    }
                    temp=temp.anterior;
                }
                console.log("No existe la variable " + Operacion.Valor);
                return nuevoSimbolo("@error@","error");
            case "funcion":
                var res = EjecutarLlamada(Llamada(Operacion.Valor.Id,Operacion.Valor.Params), ent)
                return res
        }
      	//Operaciones
        Valorizq=Evaluar(Operacion.OperandoIzq, ent);
        if(Operacion.OperandoDer!=null)
        {
            Valorder=Evaluar(Operacion.OperandoDer, ent);
        }
      	var tipoRetorno = "error";
      	// identificar qué operaciones sí podemos realizar dependiendo del tipo
    	switch(Valorizq.Tipo)
        {
          case "cadena":
            // cadena puede sumarse con cualquier otro tipo
            if(!Valorder){
            	tipoRetorno="cadena";
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
              	case "numero":
                case "bool":
                	tipoRetorno = "cadena";	
                	break;
            }
            break;
          case "numero":
            if(!Valorder){
            	tipoRetorno="numero";
              	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
                	tipoRetorno = "cadena";
                	break;
              	case "numero":
                	tipoRetorno = "numero";	
                	break;
            }
            break;
          case "bool":
            if(!Valorder){
            	tipoRetorno="bool";
              	break;
            }
            if(!Valorder){
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "bool":
                	tipoRetorno = "bool";
              		break;
            }
            break;
        }
      
        switch (Operacion.Tipo)
        {
            case "+":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                		break;
                }
            case "-":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                		break;
                }
            case "umenos":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(0-Valorizq.Valor, tipoRetorno);
                }
            case "*":
                switch(tipoRetorno)
                {
                	case "numero":
                    	return nuevoSimbolo(Valorizq.Valor * Valorder.Valor, tipoRetorno);
                }
            case "/":
                switch(tipoRetorno)
                {
                	case "numero":	
                    	return nuevoSimbolo(Valorizq.Valor / Valorder.Valor, tipoRetorno);
                }
            case "%":
                switch(tipoRetorno)
                {
                	case "numero":
            			return nuevoSimbolo(Valorizq.Valor % Valorder.Valor, tipoRetorno);
                }
            case "not":
                switch(tipoRetorno)
                {
                	case "bool":
            			return nuevoSimbolo(!Valorizq.Valor, tipoRetorno);
                }
            case "and":
                switch(tipoRetorno)
                {
                	case "bool":
            			return nuevoSimbolo(Valorizq.Valor && Valorder.Valor, tipoRetorno);
                }
            case "or":
                switch(tipoRetorno)
                {
                	case "bool":
                		return nuevoSimbolo(Valorizq.Valor || Valorder.Valor, tipoRetorno);
                }
            case ">":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor > Valorder.Valor, "bool");
                }
            case "<":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor < Valorder.Valor, "bool");
                }
            case ">=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor >= Valorder.Valor, "bool");
                }
            case "<=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor <= Valorder.Valor, "bool");
                }
            case "==":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                    	return nuevoSimbolo(Valorizq.Valor == Valorder.Valor, "bool");
                }
            case "!=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "numero":
                	case "bool":
                		return nuevoSimbolo(Valorizq.Valor != Valorder.Valor, "bool");
                }
        }
      	console.log(
          "Tipos incompatibles " + ( Valorizq ? Valorizq.Tipo : "" ) + 
          " y " + ( Valorder ? Valorder.Tipo : "" )); 
      	return nuevoSimbolo("@error@", "error");
    }

	/*-----------------------------------------------------------------------------------------------*/
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
    
    function EjecutarCrear (crear,ent) 
	{
      	// validar si existe la variable
      	if (ent.tablaSimbolos.has(crear.Id))
      	{
            console.log("La variable ",crear.Id," ya ha sido declarada en este ambito");
      		return;
      	}
    		// evaluar el resultado de la expresión 
		var valor ;	
      	if (crear && crear.Expresion)
      	{
        	valor = Evaluar(crear.Expresion, ent);
            if(valor.Tipo != crear.Tipo){
                console.log("El tipo no coincide con la variable a Crear");
                return
            }
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
      	ent.tablaSimbolos.set(crear.Id, valor);
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
    
    function EjecutarAsignar (asignar,ent) 
	{
      	//Evaluar la expresion
      	var valor = Evaluar(asignar.Expresion,ent);
        // validar si existe la variable
      	temp=ent;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(asignar.Id))
            {
                // evaluar el resultado de la expresión 
                var simbolotabla = temp.tablaSimbolos.get(asignar.Id);	
              	
                // comparar los tipos
                if (simbolotabla.Tipo === valor.Tipo)
                {
                	// reasignar el valor
                    temp.tablaSimbolos.set(asignar.Id, valor);
                    return
                }
                else
                {
                    console.log("Tipos incompatibles ",simbolotabla.Tipo," , ",valor.Tipo)
                    return
                }
            }
            temp=temp.anterior;
        }
        console.log("No se encontro la variable ",asignar.Id);
    }
	//Romper
  	const Romper = function()
    {
      	return {
          TipoInstruccion:"romper"
        }
    }
	
    const Retorno = function(Expresion)
    {
        return {
            Expresion:Expresion,
        	TipoInstruccion: "retorno"
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
    function EjecutarSi (si,ent)
    {
    	var res = Evaluar(si.Condicion, ent);
        if(res.Tipo=="bool")
        {
        	if(res.Valor)
          	{
      	        var nuevosi=Entorno(ent);
            	return EjecutarBloque(si.BloqueSi, nuevosi);
          	}
          	else if(si.BloqueElse!=null)
          	{
      	        var nuevosino=Entorno(ent);
            	return EjecutarBloque(si.BloqueElse, nuevosino);
        	}
    	}
        else
        {
            console.log("Se esperaba una condicion dentro del Si");
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
	
  	function EjecutarSeleccionar(seleccionar, ent)
	{  
        pilaCiclosSw.push("seleccionar");
		var ejecutado = false;  
      	var nuevo = Entorno(ent);
        for(var elemento of seleccionar.LCasos)
        {
            var condicion=Evaluar(NuevaOperacion(seleccionar.Expresion,elemento.Expresion,"=="), ent)
            if(condicion.Tipo=="bool")
            {
              	if(condicion.Valor || ejecutado)
              	{
                	ejecutado=true;
                	var res = EjecutarBloque(elemento.Bloque, nuevo)
                	if(res && res.TipoInstruccion=="romper")
                	{
                        pilaCiclosSw.pop();
                  		return
                	}
              	}
            }
          	else
            {
                pilaCiclosSw.pop();
                return
            }
        }
        if(seleccionar.NingunoBloque && !ejecutado)
        {
            EjecutarBloque(seleccionar.NingunoBloque, nuevo)
        }
        pilaCiclosSw.pop();
        return
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
  
  	function EjecutarMientras(mientras,ent)
	{
        pilaCiclosSw.push("ciclo");        
      	nuevo=Entorno(ent);
        while(true)
        {
        	var resultadoCondicion = Evaluar(mientras.Condicion, ent)
            if(resultadoCondicion.Tipo=="bool")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res=EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="romper")
                	{
                		break;
                	}
            	}
            	else
            	{
                	break;
              	}
            }
            else
            {
                console.log("Se esperaba una condicion dentro del Mientras")
                pilaCiclosSw.pop();
                return
            }
		}
        pilaCiclosSw.pop();
        return
	}

	const Desde = function(ExpDesde, ExpHasta, ExpPaso, Bloque, ent)
    {
        return {
            ExpDesde: ExpDesde,
            ExpHasta: ExpHasta,
            ExpPaso: ExpPaso,
            Bloque: Bloque,
            TipoInstruccion:"desde"
        }
    }
  
	function EjecutarDesde(Desde, ent)
	{
        pilaCiclosSw.push("ciclo"); 
      	var nuevo=Entorno(ent);
    	//controlador de la condicion
    	if( Desde.ExpDesde.TipoInstruccion == "crear" )
    	{
      		EjecutarCrear(Desde.ExpDesde, nuevo);
    	}
    	else
    	{
        	EjecutarAsignar(Desde.ExpDesde, nuevo);
    	}
      	//mientras no se llegue al hasta
    	var paso = Evaluar(Desde.ExpPaso, ent);
    	var hasta = Evaluar(Desde.ExpHasta, ent);
    	var Simbolo=nuevoSimbolo(Desde.ExpDesde.Id,"ID")
        if( !(paso.Tipo=="numero" && hasta.Tipo=="numero") )
        {
            pilaCiclosSw.pop();
            console.log("Se esperaban valores numericos en el Desde");
            return;
        }
    	while(true)
    	{
        	var inicio=Evaluar(Simbolo, nuevo)
            if( inicio.Tipo != "numero" )
            {
                pilaCiclosSw.pop();
                console.log("Se esperabam valores numericos en el Desde");
                return;
            }
        	if(paso.Valor > 0)
        	{
                if(inicio.Valor <= hasta.Valor)
                {
                    var res=EjecutarBloque(Desde.Bloque, nuevo);
                    if(res && res.TipoInstruccion=="romper")
                    {
                        break;
                    }
                }
                else
                {
                  break;
                }  
        	}
        	else
        	{
            	if(inicio.Valor >= hasta.Valor)
            	{
            		var res=EjecutarBloque(Desde.Bloque, nuevo);
            		if(res && res.TipoInstruccion=="romper")
                	{
                    	break;
                	}
                }
                else
                {
                	break;
                }
        	}
        	EjecutarAsignar(Asignar(Desde.ExpDesde.Id,NuevaOperacion(Simbolo,paso,"+")), nuevo)
    	}
        pilaCiclosSw.pop();
        return;
	}
    //Funcion
    const Funcion=function(Id, Parametros, Tipo, Bloque)
    {
        return{
            Id: Id,
            Parametros: Parametros,
            Bloque: Bloque,
            Tipo: Tipo,
            TipoInstruccion: "funcion"
        }
    }

    function EjecutarFuncion(elemento,ent)
    {
        var nombrefuncion = elemento.Id + "$";
        for(var Parametro of elemento.Parametros)
        {
            nombrefuncion+=Parametro.Tipo;
        }
        if (ent.tablaSimbolos.has(nombrefuncion))
      	{
            console.log("La funcion ",crear.Id," ya ha sido declarada");
      		return;
      	}
        ent.tablaSimbolos.set(nombrefuncion, elemento);
    }

    //Llamada
    const Llamada=function(Id,Params)
    {
        return {
            Id: Id,
            Params: Params,
            TipoInstruccion: "llamada"
        }
    }

    function EjecutarLlamada(Llamada,ent)
    {
        var nombrefuncion = Llamada.Id+"$";
        var Resueltos = [];
        for(var param of Llamada.Params)
        {
            var valor = Evaluar(param,ent);
            nombrefuncion += valor.Tipo;
            Resueltos.push(valor);
        }
        var temp = ent;
        var simboloFuncion = null;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(nombrefuncion))
            {
                // evaluar el resultado de la expresión 
                simboloFuncion = temp.tablaSimbolos.get(nombrefuncion);	
                break;
            }
            temp=temp.anterior;
        }
        if(!simboloFuncion){
            console.log("No se encontró la funcion "+Llamada.Id + " con esa combinacion de parametros")
            return nuevoSimbolo("@error@","error");
        } 
        pilaFunciones.push(Llamada.Id);
        var nuevo=Entorno(EntornoGlobal)
        var index=0;
        for(var crear of simboloFuncion.Parametros)
        {
            crear.Expresion=Resueltos[index];
            EjecutarCrear(crear,nuevo);
            index++;
        }
        var retorno=nuevoSimbolo("@error@","error");
        var res = EjecutarBloque(simboloFuncion.Bloque, nuevo)
        if(res)
        {
            if(res.Tipo=="void" )
            {
                if(simboloFuncion.Tipo!="void")
                {
                    console.log("No se esperaba un retorno");
                    retorno=nuevoSimbolo("@error@","error");
                }
                else
                {
                    retorno=nuevoSimbolo("@vacio@","vacio")
                }
            }
            else
            {
                var exp=Evaluar(res,nuevo);
                if(exp.Tipo!=simboloFuncion.Tipo)
                {
                    console.log("El tipo del retorno no coincide");
                    retorno=nuevoSimbolo("@error@","error");
                }
                else
                {
                    retorno=exp;
                }
            }
        }
        else
        {
            if(simboloFuncion.Tipo!="void")
            {
                console.log("Se esperaba un retorno");
                retorno=nuevoSimbolo("@error@","error");
            }
            else
            {
                retorno=nuevoSimbolo("@vacio@","vacio")
            }
        }
        pilaFunciones.pop();
        return retorno;
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

"imprimir"				return "Rimprimir";
"crear"					return "Rcrear"; // declaración
"como"					return "Rcomo";
"romper"        		return "Rromper";
"retorno"               return "Rretorno";
"sino"					return "Rsino";
"si"					return "Rsi"; // if
"entonces"				return "Rentonces";

"mientras"				return "Rmientras"; // while

"desde"					return "Rdesde"; // ciclo for
"hasta"					return "Rhasta";
"paso"					return "Rpaso";

"hacer"					return "Rhacer";
"fin"					return "Rfin";

"seleccionar"			return "Rseleccionar";// select case
"caso"					return "Rcaso";
"ninguno"				return "Rninguno";

"numero"				return "Rnumero"; // TIPOS
"cadena"				return "Rcadena";
"booleano"				return "Rbooleano";
"funcion"               return "Rfuncion";

";"                 return 'PTCOMA';
","                 return 'COMA';
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
%left JError
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
    : LINS EOF { console.log(JSON.stringify($1,null,2)); EjecutarBloque($1,EntornoGlobal) } 
	| error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.firstline,this.$.first_column)}

;

LINS 
    : LINS INS      { $$=$1; $$.push($2); }
    | INS           { $$=[]; $$.push($1); }
;


INS 
    : Rimprimir PARIZQ EXP PARDER   { $$=Imprimir("imprimir",$3);}
    | CREAR				            { $$ = $1; }									
    | ASIGNAR			            { $$ = $1; }
    | SI					        { $$ = $1; }
    | MIENTRAS		                { $$ = $1; }
    | DESDE				            { $$ = $1; }
    | HASTA		                    { $$ = $1; } 
    | CASOS                         { $$ = $1; }
    | Rromper                       { $$ = Romper(); }
    | FUNCION                       { $$ = $1; }
    | LLAMADA                       { $$ = $1; }
    | RETORNO
	//| error INS {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

RETORNO   
    : Rretorno PARIZQ EXP PARDER    { $$ = Retorno($3); }
    | Rretorno PARIZQ PARDER        { $$ = Retorno(Simbolo("@Vacio@","void")); }
;

CREAR
	:Rcrear ID Rcomo TIPO				{$$ = Crear($2, $4, null);}
	|Rcrear ID Rcomo TIPO IGUAL EXP 	{$$ = Crear($2, $4, $6);}
	|Rcrear error EXP {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

FUNCION 
    :Rfuncion ID PARIZQ PARDER Rcomo TIPO BLOQUE                { $$ = Funcion($2,[],$6,$7); }
    |Rfuncion ID PARIZQ PARDER BLOQUE                           { $$ = Funcion($2,[],"void",$5); }
    |Rfuncion ID PARIZQ PARAMETROS PARDER Rcomo TIPO BLOQUE     { $$ = Funcion($2,$4,$7,$8); }
    |Rfuncion ID PARIZQ PARAMETROS PARDER BLOQUE                { $$ = Funcion($2,$4,"void",$6); }
;

PARAMETROS
    :PARAMETROS COMA ID Rcomo TIPO      { $$=$1;$$.push(Crear($3,$5,null)) }
    |ID Rcomo TIPO                      { $$=[];$$.push(Crear($1,$3,null)) }
;

ASIGNAR
	:ID IGUAL EXP						{ $$ = Asignar($1, $3); }
;

SI 
	: Rsi EXP Rentonces BLOQUE 					{ $$ = Si($2,$4,null); }
	| Rsi EXP Rentonces BLOQUE Rsino BLOQUE		{ $$ = Si($2,$4,$6); }
	| Rsi error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

CASOS
    : Rseleccionar EXP LCASOS Rninguno BLOQUE     { $$=Seleccionar($2,$3,$5); }
    | Rseleccionar EXP LCASOS                     { $$=Seleccionar($2,$3,null); }
	| Rseleccionar error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

LCASOS
    : Rcaso EXP BLOQUE                      { $$=[]; $$.push(Caso($2,$3)); }
    | LCASOS Rcaso EXP BLOQUE               { $$=$1; $$.push(Caso($3,$4)); }
	| Rcaso error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

MIENTRAS
	: Rmientras EXP BLOQUE { $$=new Mientras($2, $3); }
	| Rmientras error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

BLOQUE
    : Rhacer LINS Rfin  		{ $$ = $2; }
    | Rhacer Rfin				{ $$ = []; }
	| Rhacer error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

DESDE
	:Rdesde ASIGNAR Rhasta EXP Rpaso EXP BLOQUE { $$ = Desde($2, $4, $6, $7); }
	|Rdesde CREAR Rhasta EXP Rpaso EXP BLOQUE { $$ = Desde($2, $4, $6, $7); }
	|Rdesde error Rfin {console.log("Se recupero en ",yytext," (",this._$.last_line,",",this._$.last_column,")");}
;

LLAMADA 
    : ID PARIZQ PARDER          { $$=Llamada($1,[]); }
    | ID PARIZQ L_EXP PARDER    { $$=Llamada($1,$3); }
;

TIPO
	:Rnumero			{ $$="numero" }
	|Rcadena			{ $$="cadena" }
	|Rbooleano		    { $$="bool" }
;

EXP 
    : EXP MAS EXP               { $$=NuevaOperacion($1,$3,"+"); }
    | EXP MENOS EXP             { $$=NuevaOperacion($1,$3,"-"); }
    | EXP POR EXP               { $$=NuevaOperacion($1,$3,"*"); }
    | EXP DIV EXP               { $$=NuevaOperacion($1,$3,"/"); }
    | EXP MOD EXP               { $$=NuevaOperacion($1,$3,"%"); }
    | EXP MENOR EXP             { $$=NuevaOperacion($1,$3,"<"); }
    | EXP MAYOR EXP             { $$=NuevaOperacion($1,$3,">"); }
    | EXP DIFERENTE EXP         { $$=NuevaOperacion($1,$3,"!="); }
    | EXP IGUALADAD EXP         { $$=NuevaOperacion($1,$3,"=="); }
    | EXP MAYORI EXP            { $$=NuevaOperacion($1,$3,">="); }
    | EXP MENORI EXP            { $$=NuevaOperacion($1,$3,"<="); }
    | EXP AND EXP               { $$=NuevaOperacion($1,$3,"and"); }
    | EXP OR EXP                { $$=NuevaOperacion($1,$3,"or"); }
    | NOT EXP                   { $$=NuevaOperacionUnario($2,"not"); }
    | MENOS EXP %prec UMENOS    { $$=NuevaOperacionUnario($2,"umenos"); }
    | Cadena                    { $$=nuevoSimbolo($1,"cadena"); }
	| ID					    { $$=nuevoSimbolo($1,"ID");}
    | ID PARIZQ PARDER          { $$=nuevoSimbolo({Id:$1,Params:[]},"funcion"); }
    | ID PARIZQ L_EXP PARDER    { $$=nuevoSimbolo({Id:$1,Params:$3},"funcion"); }
    | NUMERO                    { $$=nuevoSimbolo(parseFloat($1),"numero"); }
    | TRUE                      { $$=nuevoSimbolo(true,"bool"); }
    | FALSE                     { $$=nuevoSimbolo(false,"bool"); }
    | PARIZQ EXP PARDER         { $$=$2 }
;

L_EXP 
    :L_EXP COMA EXP             { $$=$1;$$.push($3); }
    |EXP                        { $$=[];$$.push($1); }
;