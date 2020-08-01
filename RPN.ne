# RPN

main -> _ OP _ {% function(d) {return {type:'main', d:d[1], v:d[1].v}} %}

OP -> OP _ OP _  "^"   {% function(d) {return {type:'E', d:[d[0],d[2]], v:Math.pow(d[0].v, d[2].v)}} %}
	| OP _ OP _ "*" {% function(d) {return {type: 'M', d:[d[0],d[2]], v:d[0].v*d[2].v}} %}
	| OP _ OP _ "/" {% function(d) {return {type: 'D', d:[d[0],d[2]], v:d[0].v/d[2].v}} %}
	| OP _ OP _ "+" {% function(d) {return {type: 'A', d:[d[0],d[2]], v:d[0].v+d[2].v}} %}
	| OP _ OP _ "-" {% function(d) {return {type: 'S', d:[d[0],d[2]], v:d[0].v-d[2].v}} %}
	| N {% id %}

# A number or a function of a number
N -> float        {% id %}
    | OP _ "sin"      {% function(d) {return {type:'sin', d:d[0], v:Math.sin(d[0].v)}} %}
    | OP _ "cos"      {% function(d) {return {type:'cos', d:d[0], v:Math.cos(d[0].v)}} %}
    | OP _ "tan"      {% function(d) {return {type:'tan', d:d[0], v:Math.tan(d[0].v)}} %}
    
    | OP _ "asin"     {% function(d) {return {type:'asin', d:d[0], v:Math.asin(d[0].v)}} %}
    | OP _ "acos"     {% function(d) {return {type:'acos', d:d[0], v:Math.acos(d[0].v)}} %}
    | OP _ "atan"     {% function(d) {return {type:'atan', d:d[0], v:Math.atan(d[0].v)}} %}

    | "pi"          {% function(d) {return {type:'pi', d:d[0], v:Math.PI}} %}
    | "e"           {% function(d) {return {type:'e', d:d[0], v:Math.E}} %}
    | OP _ "sqrt"     {% function(d) {return {type:'sqrt', d:d[0], v:Math.sqrt(d[0].v)}} %}
    | OP _ "ln"       {% function(d) {return {type:'ln', d:d[0], v:Math.log(d[0].v)}}  %}

# I use `float` to basically mean a number with a decimal point in it
float ->
      int "." int   {% function(d) {return {v:parseFloat(d[0].v + d[1] + d[2].v)}} %}
    | int           {% function(d) {return {v:parseInt(d[0].v)}} %}

int -> [0-9]:+        {% function(d) {return {v:d[0].join("")}} %}

# Whitespace. The important thing here is that the postprocessor
# is a null-returning function. This is a memory efficiency trick.
_ -> [\s]:*     {% function(d) {return null } %}
