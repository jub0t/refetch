#ifndef LEXER_H
#define LEXER_H

typedef enum {
    LET, CONST, IDENTIFIER, EQUALS,
    SEMICOLON, LPAREN, RPAREN, LBRACE,
    RBRACE, COMMA, DOT, STRING, IF,
    RETURN, EOFF, UNKNOWN
} TokenType;

typedef struct {
    TokenType type;
    char* value;
} Token;

Token* tokenize(const char* source);

#endif /* LEXER_H */
