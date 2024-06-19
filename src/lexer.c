#include "../include/lexer.h"  // Include the header file with TokenType and Token definitions
#include <stdlib.h>  // For memory allocation

Token* tokenize(const char* source) {
    Token* token;
    
    token->value = strdup("");  // Allocate memory for value and copy "1"
    token->type = LET;

    return token;
}
