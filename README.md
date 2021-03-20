# TallerJison_2021
Taller explicación del uso jison.

## Recursos

### Node JS
- Página oficial https://nodejs.org/es/

### JISON
- Página oficial https://zaa.ch/jison/ 
- Documentación https://zaa.ch/jison/docs/

### Probar tu gramática
- LL(1)    http://jsmachines.sourceforge.net/machines/ll1.html
- LR(1)    http://jsmachines.sourceforge.net/machines/lr1.html
- LALR(1)  http://jsmachines.sourceforge.net/machines/lalr1.html

### Extensiones
- Extensión para visualizar json [Extensión chrome|edge](https://chrome.google.com/webstore/detail/json-viewer-pro/eifflpmocdbdmepbjaopkkhbfmdgijcc?hl=es) 
- Extensión para visualizar json en firefox [Complemento firefox](https://addons.mozilla.org/es/firefox/addon/json-beautifier-editor/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- Extensión para suporte jison en vs code [Extensión vs code](https://marketplace.visualstudio.com/items?itemName=cruzelante098.jison-syntax-highlight)

## SESIONES GRABADAS
- [Ver parte 1](https://drive.google.com/file/d/10tHh5h5yAFmsOgpOqc62AUmJCrF061NX/view?usp=sharing)
- [Ver parte 2](https://drive.google.com/file/d/1rZ0rv_Xn1A0oMYz5oLUWP1ywV_fr68oM/view?usp=sharing)
- [Ver parte 3](https://drive.google.com/file/d/1pCWZy5eM4-oUwV3RwqQCo3IDL0JL4d7j/view?usp=sharing)

## PREGUNTAS
### ¿Para qué sirve %prec en la producción?
- Los números negativos utilizan el mismo caracter utilizado para la resta. Se coloca la expresión %prec para asignarle de manera especial la precendecia adecuada.
- El nombre de la producción no es UMENOS de manera explícita (menos expresion). Se debe asignar la precedencia de manera manual.

###  En las predecencias, ¿diferencia entre %left y %rigth?
- Ambas palabras reservadas indican la dirección en la que se produce la recursividad y prioridad de ejecución.
- Left indica que la recursividad y la prioridad se ejecutan por la izquierda.
- Rigth indica que la recursividad y la prioridad se ejecutan por la derecha.
- Al tener la expresión  '5 + - 5', primero se debe ejecutar el negativo y luego realizar la suma.

### ¿Cómo asignar un tipo a un no terminal?
- Se debe crear un objeto con las propiedades que requieras, ese objeto se le asigna al retorno $$ mediante una igualación y luego de eso se podrá acceder a los atributos desde el retorno $$. ($$ = {atributoA:"una cadena", atributoB:"otra cadena"}).

### ¿Por qué usaríamos estados en el analizador léxico?
- Si tomamos como ejemplo el lenguaje PHP inscrustado en html,el analizador léxico iniciaría en el estado "ReadHTML" para reconocer únicamente etiquetas html y al momento de reconocer el inicio de una instrucción php "<?php echo '<p>Hola Mundo</p>'; ?>" iría un estado "ReadPHP" en el cuál ya se pueden identificar los tokens pertenecientes a php.

