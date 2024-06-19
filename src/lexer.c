typedef enum {
    TOKEN_LET, TOKEN_CONST, TOKEN_IDENTIFIER, TOKEN_EQUALS,
    TOKEN_SEMICOLON, TOKEN_LPAREN, TOKEN_RPAREN, TOKEN_LBRACE,
    TOKEN_RBRACE, TOKEN_COMMA, TOKEN_DOT, TOKEN_STRING, TOKEN_IF,
    TOKEN_RETURN, TOKEN_EOF, TOKEN_UNKNOWN
} TokenType;

typedef struct {
    TokenType type;
    char* value;
} Token;

// Tokenize the input script
Token* tokenize(const char* source);

