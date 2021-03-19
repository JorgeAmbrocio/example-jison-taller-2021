const parse = require('./parser');


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
