

go assigns a default zero value to any variable that is declared but not assigned

a go literal is an explicitly specified number, character or string. 
four common kinds of literals:

an integer literal, base 10 by default, 0b for binary(base 2), 0o for octal(base 8), 0x for hexadecimal(base 16)

mark: need to remember what is base something


to make it easier to read longer integer literals, go allows you to put underscores in the middle of your literal
this allows for example to group by thousands in base 10 (1_234) (can't be at the begining or the end of numbers)

a floating point literal has a decimal point to indicate the fractional portion of the value. You also have the option
to write them in hexadecimal by using the 0x prefix and the letter p for
indicating any exponent (0x12.34p5, which is equal to 582.5 in base 10). As
integer literals, you can use underscores to format your floating-point
literals.


a rune literal represents a character is sorrounded by single quotes.
**Unlike many other languages, in Go single quotes and double quotes are not**
**interchangeable.**
Rune literals can be written as single Unicode characters
('a'), 8-bit octal numbers ('\141'), 8-bit hexadecimal numbers
('\x61'), 16-bit hexadecimal numbers ('\u0061'), or 32-bit Unicode
numbers ('\U00000061'). There are also several backslash-escaped rune
literals, with the most useful ones being newline ('\n'), tab ('\t'),
single quote ('\''), and backslash ('\\').

- A Go `byte` (which is an alias for `uint8`) only looks at a single byte.
- A Go `rune` (an alias for `int32`) looks at the entire **Unicode code point**, no matter how many bytes it takes to display it. [[1](https://www.geeksforgeeks.org/go-language/go-strings-bytes-runes-and-characters/), [2](https://go.dev/blog/strings), [3](https://dev.to/jeseekuya/understanding-runes-in-go-4ie5)]

The only characters that cannot appear in an interpreted string literal are
unescaped backslashes, unescaped newlines, and unescaped double quotes.
If you use an interpreted string literal and want your greetings on a different
line from your salutations and want “Salutations” to appear in quotes, you
need to type "Greetings and\n\"Salutations\"".
If you need to include backslashes, double quotes, or newlines in your
string, using a raw string literal is easier. These are delimited with
backquotes (`) and can contain any character except a backquote. There’s
no escape character in a raw string literal; all characters are included as is.
When using a raw string literal, you write a multiline greeting like so:
`Greetings and
"Salutations"`
Literals are considered untyped. I’ll explore this concept more in “Literals
Are Untyped”. As you will see in “var Versus :=”, there are situations in Go
where the type isn’t explicitly declared. In those cases, Go uses the default
type for a literal; if there’s nothing in the expression that makes clear what
the type of the literal is, the literal defaults to a type. I will mention the
default type for literals when discussing the different predeclared types



The bool type represents Boolean variables. Variables of bool type can
have one of two values: true or false. The zero value for a bool is
false:
var flag bool // no value assigned, set to false
var isAwesome = true


Go has a large number of numeric types: 12 types (and a few special names)
that are grouped into three categories.

Table 1-1. The integer types in Go
Type nameValue range
intplatform dependent
int8: -128 to 127
int16: -32768 to 32767
int32: -2147483648 to 2147483647
int64: -9223372036854775808 to 9223372036854775807
uintplatform dependent
uint80 to 255
uint160 to 65535
uint320 to 4294967295
uint640 to 18446744073709551615


The special integer types
Go does have some special names for integer types. A byte is an alias for
uint8; it is legal to assign, compare, or perform mathematical operations
between a byte and a uint8. However, you rarely see uint8 used in Go
code; just call it a byte.

The second special name is int. On a 32-bit CPU, int is a 32-bit signed
integer like an int32. On 64-bit CPUs, int is a 64-bit signed integer, just
like an int64. Because int isn’t consistent from platform to platform, it
is a compile-time error to assign, compare, or perform mathematical
operations between an int and an int32 or int64 without a type
conversion (see “Explicit Type Conversion” for more details). Integer
literals default to being of int type.
The third special name is uint. It follows the same rules as int, only it is
unsigned (the values are always 0 or positive).
There are two other special names for integer types, rune and uintptr.
You looked at rune literals earlier and I’ll discuss the rune type in “A Taste
of Strings and Runes” and uintptr in Chapter 16.


Go provides more integer types than some other languages. Given all these
choices, you might wonder when you should use each of them. You should
follow three simple rules:
By default, use int.
If you are working with a binary file format or network protocol
that has an integer of a specific size or sign, use the corresponding
integer type.
If you are writing a library function that should work with any
integer type, take advantage of Go’s generics support and use a
generic type parameter to represent any integer type (I talk more
about functions and their parameters in Chapter 5 and more about
generics in Chapter 8.)

Go integers support the usual arithmetic operators: +, -, *, /, with % for
modulus.

You can combine any of the arithmetic operators with = to modify a
variable: +=, -=, *=, /=, and %=. For example, the following code results
in x having the value 20:
var x int = 10
x *= 2

Go also includes the ++ and -- operators to increment and decrement the
value of a variable. Gorequires these operators to appear after the variable.

You compare integers with ==, !=, >, >=, <, and <=.

Go also has bit-manipulation operators for integers. You can bit shift left
and right with << and >>, or do bit masks with & (bitwise AND), | (bitwise
OR), ^ (bitwise XOR), and &^ (bitwise AND NOT). As with the arithmetic
operators, you can also combine all the bitwise operators with = to modify a
variable: &=, |=, ^=, &^=, <<=, and >>=.

Like many other languages, Go allows you to increment and decrement
integer variables past their limits. Adding one to a variable set to the
maximum value for a type returns the minimum value for the type, and
subtracting one from the minimum returns the maximum. Be careful when
writing code; don’t assume that x + 1 is always greater than x and x -
1 is always less than x.


Go includes strings
as a built-in type. The zero value for a string is the empty string. Go
supports Unicode; as I showed “Literals”, you can put any Unicode
character into a string. Like integers and floats, strings are compared for
equality using ==, difference with !=, or ordering with >, >=, <, or <=.
They are concatenated by using the + operator.

Strings in Go are immutable; you can reassign the value of a string variable,
but you cannot change the value of the string that is assigned to it.

Go also has a type that represents a single code point. The rune type is an
alias for the int32 type, just as byte is an alias for uint8. As you could
probably guess, a rune literal’s default type is a rune, and a string literal’s
default type is a string.

If you are referring to a character, use the rune type, not the int32 type.
They might be the same to the compiler, but you want to use the type that
clarifies the intent of your code:
var myFirstInitial rune = 'J' // good - the type name matches the
usage
var myLastInitial int32 = 'B' // bad - legal but confusing

## Explicit Type Conversion

Most languages that have multiple numeric types automatically convert from one to another when needed. This is called automatic type promotion, and while it seems very convenient, it turns out that the rules to properly convert one type to another can get complicated and produce unexpected results. As a language that values clarity of intent and readability, Go doesn't allow automatic type promotion between variables. You must use a type conversion when variable types do not match. Even different-sized integers and floats must be converted to the same type to interact. This makes it clear exactly what type you want without having to memorize any type conversion rules.

### Type conversions
```go
var x int = 10
var y float64 = 30.2
var sum1 float64 = float64(x) + y
var sum2 int = x + int(y)
fmt.Println(sum1, sum2) // prints 40.2 40
```
In this code, x is an int with value 10, and y is a float64 with value 30.2. Since these are not identical types, you need to convert them to add them together. For sum1, convert x to float64 using `float64(x)`. For sum2, convert y to int using `int(y)` (which truncates the decimal). Prints `40.2 40`.

### Integer type conversions
The same behavior applies with different-sized integer types:
```go
var x int = 10
var b byte = 100
var sum3 int = x + int(b)
var sum4 byte = byte(x) + b
fmt.Println(sum3, sum4)
```

### No Truthiness / Booleans
This strictness around types has other implications. Since all type conversions in Go are explicit, you cannot treat another Go type as a boolean. In many languages, a nonzero number or a nonempty string can be interpreted as a boolean true. Just like automatic type promotion, the rules for "truthy" values vary from language to language and can be confusing. Go doesn't allow truthiness. In fact, no other type can be converted to a bool, implicitly or explicitly (e.g. `bool(1)` is a compile error). If you want to convert from another data type to boolean, you must use one of the comparison operators (`==`, `!=`, `>`, `<`, `<=`, or `>=`):
- To check if variable x is equal to 0: `x == 0`
- To check if string s is empty: `s == ""`