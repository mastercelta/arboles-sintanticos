const fs = require('fs');
const peggy = require('peggy');

// Cargar y compilar la gramática
const grammar = fs.readFileSync('./sintasis.pegjs', 'utf8');
const parser = peggy.generate(grammar);

// Analizar la expresión
const input = 'z = a * (b + c) - d';
const tree = parser.parse(input);

console.dir(tree, { depth: null });