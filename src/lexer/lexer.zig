const std = @import("std");

pub const TokenType = enum(u8) {
    // Keywords
    RETURN,
    CONST,
    LET,
    IF,

    // Identifiers and Literals
    IDENTIFIER,
    STRING_LITERAL,
    NUMBER_LITERAL,

    // Punctuations
    COMMENT,
    SINGLE_QOUTE,
    DOUBLE_QOUTE,
    SEMICOLON,
    COLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    COMMA,
    DOT,

    // Operators
    EQ, // Equals To.
    NEQ, // Not Equals To.

    // Expressions
    BINARYEXP,
};

pub const Token = struct {
    t: TokenType,
    value: ?[]const u8,

    pub fn setType(self: *Token, newType: TokenType) void {
        self.t = newType;
    }
};

fn is_alpha(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_';
}

fn is_digit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn is_alnum(c: u8) bool {
    return is_alpha(c) or is_digit(c);
}

pub fn Keywording(tokens: []Token) void {
    for (tokens) |*token| {
        // We skip the non-identifiers
        if (token.t != TokenType.IDENTIFIER) continue;

        // We might not need this true/false converter later?
        // Or Maybe we'll need something like this in the parser?
        // if (token.t == TokenType.STRING_LITERAL and (token.value.?.len == 4 or token.value.?.len == 5)) {
        //     if (std.mem.eql(u8, token.value.?, "true")) {}
        // }

        const value: []const u8 = token.value.?;

        if (std.mem.eql(u8, value, "return")) {
            token.setType(TokenType.RETURN);
        }

        if (std.mem.eql(u8, value, "const")) {
            token.setType(TokenType.CONST);
        }

        if (std.mem.eql(u8, value, "let")) {
            token.setType(TokenType.LET);
        }
    }
}

pub fn Build(source: []const u8, allocator: *std.mem.Allocator) ![]Token {
    const source_len = source.len;
    var tokens = try allocator.alloc(Token, source_len);
    var token_count: usize = 0;
    var i: usize = 0;

    while (i < source_len) {
        const c = source[i];

        switch (c) {
            ' ' => {},
            '\n' => {},
            '\t' => {},
            '\r' => {},
            '{' => {
                tokens[token_count] = Token{ .t = .LBRACE, .value = "{" };
                token_count += 1;
            },
            '}' => {
                tokens[token_count] = Token{ .t = .RBRACE, .value = "}" };
                token_count += 1;
            },
            '(' => {
                tokens[token_count] = Token{ .t = .LPAREN, .value = "(" };
                token_count += 1;
            },
            ';' => {
                tokens[token_count] = Token{ .t = .SEMICOLON, .value = ";" };
                token_count += 1;
            },
            ':' => {
                tokens[token_count] = Token{ .t = .COLON, .value = ":" };
                token_count += 1;
            },
            ')' => {
                tokens[token_count] = Token{ .t = .RPAREN, .value = ")" };
                token_count += 1;
            },
            ',' => {
                tokens[token_count] = Token{ .t = .COMMA, .value = "," };
                token_count += 1;
            },
            '.' => {
                tokens[token_count] = Token{ .t = .DOT, .value = "." };
                token_count += 1;
            },
            '=' => {
                tokens[token_count] = Token{ .t = .EQ, .value = "=" };
                token_count += 1;
            },
            '"', '\'' => {
                const start = i + 1;
                i += 1;

                while (i < source_len and source[i] != '"') {
                    i += 1;
                }

                if (i >= source_len) break;
                const str_value = source[start..i];
                tokens[token_count] = Token{ .t = .STRING_LITERAL, .value = str_value };
                token_count += 1;
            },
            else => {
                if (is_alpha(c)) {
                    const start = i;

                    while (i < source_len and is_alnum(source[i])) {
                        i += 1;
                    }

                    const ident = source[start..i];
                    if (std.mem.eql(u8, ident, "let")) {
                        tokens[token_count] = Token{ .t = .LET, .value = ident };
                    } else if (std.mem.eql(u8, ident, "const")) {
                        tokens[token_count] = Token{ .t = .CONST, .value = ident };
                    } else if (std.mem.eql(u8, ident, "if")) {
                        tokens[token_count] = Token{ .t = .IF, .value = null };
                    } else {
                        tokens[token_count] = Token{ .t = .IDENTIFIER, .value = ident };
                    }

                    token_count += 1;
                    i -= 1;
                } else if (is_digit(c) or c == '.') {
                    const start = i;
                    while (i < source_len and is_digit(source[i])) {
                        i += 1;
                    }

                    const num_value = source[start..i];
                    tokens[token_count] = Token{ .t = .NUMBER_LITERAL, .value = num_value };
                    token_count += 1;
                    i -= 1;
                } else if (c == '/') {
                    // Single line Comment
                    if (i + 1 < source_len and source[i + 1] == '/') {
                        // Skip characters until newline or end of source
                        const start = i;
                        i += 2; // Skip both '/' characters
                        while (i < source_len and source[i] != '\n') {
                            i += 1;
                        }
                        // Extract the comment string
                        const comment_content = source[start..i];
                        tokens[token_count] = Token{ .t = .COMMENT, .value = comment_content };
                        token_count += 1;
                        // Decrement i because the loop increments it once more
                        i -= 1;
                    } else {
                        std.log.info("You attempted to create an in-complete comment", .{});
                    }
                }
            },
        }
        i += 1;
    }

    // Some keyword cleaning before we return
    Keywording(tokens);

    return tokens[0..token_count];
}
