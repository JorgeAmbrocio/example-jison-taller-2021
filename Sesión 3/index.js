const parse = require('./parser');

parse.parse(`
  funcion miMetodo(a como cadena)
  hacer
    imprimir("Esto viene en los parametros " + a)
  fin

  funcion miFuncion(a como numero) como cadena
  hacer
    retorno ("Mi numero es " + a)
  fin

  funcion Comparar(a como numero, b como numero) como numero
  hacer
    si a > b entonces hacer
     retorno(a)
    fin
    sino hacer
      retorno(b)
    fin
  fin

  funcion DiaSemana(a como numero) como cadena
  hacer
    seleccionar a 
      caso 1 hacer
        retorno("Lunes")
      fin
      caso 2 hacer
        retorno("Martes")
      fin
      caso 3 hacer
        retorno("Miercoles")
      fin
      caso 4 hacer
        retorno("Jueves")
      fin
      caso 5 hacer
        retorno("Viernes")
      fin
      caso 6 hacer
        retorno("Sabado")
      fin
      caso 7 hacer
        retorno("Domingo")
      fin
      ninguno hacer
        retorno("Error")
      fin
  fin

  crear a como numero = Comparar(10,20)
  imprimir("El valor mas grande es: " + a)

  imprimir("El dia de la semana es: " + DiaSemana(1))

  miMetodo(miFuncion(1))
`)

/*
parse.parse(`
// tipos que el lenguaje soporta
// cadena
// numero
// booleano

// operandos booleanos
// YY
// OO
// NEL

// declaración de variables
crear miCadena1 como cadena

crear miNumero1 como numero = 150
crear miNumero2 como numero = 200
crear resultado como numero

crear miBool1 como booleano
crear miBool2 como booleano = verdadero
crear miResultadoBool como booleano

// asignación de variables
miCadena1 = "soy una cadena"
resultado = miNumero1 + miNumero2
miResultadoBool = nel miBool2 

// imprprimir
imprimir(miCadena1)
imprimir(resultado)
imprimir(miCadena1)
imprimir(miResultadoBool)

imprimir("La suma de 1+1 es: " + "1" + 1 )

si nel falso entonces 
hacer
  crear miCadena1 como cadena = "Se ejecutó la parte verdadera"
  imprimir(miCadena1)
fin
sino hacer
  crear miCadena1 como cadena = "Se ejecutó la parte negativa"
  imprimir("Se ejecutó la parte negativa")
fin

crear varSeleccionar como numero = 10
seleccionar varSeleccionar
  caso 1 hacer
      imprimir("No es verdad")
      romper
    fin
  caso 10 hacer
    imprimir("El caso es correcto")
    romper
  fin
  caso 20 hacer
    imprimir("No es verdad")
    romper
  fin

// ciclos
crear varMientras como numero = 0
mientras varMientras < 10 hacer
  imprimir("El valor de la variable es " + varMientras)
  varMientras = varMientras + 1
  si varMientras == 5 entonces hacer
    romper
  fin
fin

crear varDesde como numero 
desde varDesde = 20 hasta 10 paso -1 hacer
  imprimir("El valor de la variable es " + varDesde)
fin

`);
*/