const parse = require('./parser');

parse.parse(`
    crear a como numero = 10
    imprimir(a)
    a = 30
    imprimir(a)
`);