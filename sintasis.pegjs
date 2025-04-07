// Gramática basada en:
// S → id = E
// E → E + T | E - T | T
// T → T * F | T / F | F
// F → (E) | id | num

{
  function node(type, value) {
    return { type, ...value };
  }
}

Start = _ s:Statement _ { return s; }

Statement = id:Identifier _ "=" _ e:Expression {
  return node("S", { id, value: e });
}

Expression
  = head:Term tail:(_ ("+" / "-") _ Term)* {
      return tail.reduce((acc, [ , op, , term]) => ({
        type: "E",
        op,
        left: acc,
        right: term
      }), head);
    }

Term
  = head:Factor tail:(_ ("*" / "/") _ Factor)* {
      return tail.reduce((acc, [ , op, , factor]) => ({
        type: "T",
        op,
        left: acc,
        right: factor
      }), head);
    }

Factor
  = "(" _ e:Expression _ ")" {
      return node("F", { value: e });
    }
  / id:Identifier {
      return node("F", { value: node("id", { value: id }) });
    }
  / n:Number {
      return node("F", { value: node("num", { value: n }) });
    }

Identifier = [a-zA-Z]+ { return text(); }

Number = [0-9]+ { return text(); }

_ = [ \t\r\n]*  // espacios opcionales
