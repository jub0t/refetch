// This module provieds the functions to convert Token(s) back to code, or atleast try to.

const std = @import("std");
const lexer = @import("./lexer.zig");
const TokenType = lexer.TokenType;
const Token = lexer.Token;

pub fn Recode(tokens: []Token) anyerror![]u8 {
    const allocator = std.heap.page_allocator;
    var codeList = std.ArrayList(u8).init(allocator);

    for (tokens) |token| {
        const stringed = TokenToString(token);
        try codeList.appendSlice(stringed);

        switch (token.t) {
            .IF,
            .LET,
            .CONST,
            .EQ,
            .SEMICOLON,
            .RETURN,
            => {
                try codeList.append(' ');
            },

            else => {},
        }
    }

    return codeList.toOwnedSlice();
}

pub fn TokenToString(token: lexer.Token) []const u8 {
    return switch (token.t) {
        .LET => "let",
        .CONST => "const",
        .EQ => "=",
        .SEMICOLON => ";\n",
        .COLON => ":",
        .NEQ => "!=",

        .LBRACE => "{",
        .RBRACE => "}",
        .COMMA => ",",
        .IF => "if",

        .LPAREN => "(",
        .RPAREN => ")",
        .DOT => ".",
        .DOUBLE_QOUTE => "\"",
        .SINGLE_QOUTE => "'",
        .RETURN => "return",

        .STRING_LITERAL => token.value.?,
        .NUMBER_LITERAL => token.value.?,
        .IDENTIFIER => token.value.?,

        else => "",
    };
}
