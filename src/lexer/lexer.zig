const std = @import("std");

pub const VariableType = enum {
    STRING,
    NUMBER,
    HASHMAP,
};

pub const Variable = union(VariableType) {
    BOOLEAN: bool,
    NUMBER: f64,
    STRING: []const u8,
    HASHMAP: std.StringHashMap([]const u8),

    pub fn set(self: *Variable, t: VariableType, value: anyopaque) void {
        self.* = switch (t) {
            .BOOLEAN => Variable{ .BOOLEAN = (if (std.mem.eql(u8, value, "true")) true else false) },
            .NUMBER => Variable{ .NUMBER = value },
            .STRING => Variable{ .STRING = value },
            .HASHMAP => Variable{ .HASHMAP = value },
        };
    }

    pub fn get(self: Variable) anyopaque {
        return self;
    }
};

pub const BinaryOperator = enum {
    EQ,
    NEQ,
};

pub const BinaryExpression = struct {
    operator: BinaryOperator,
    lhs: *const Variable,
    rhs: *const Variable,
};

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
    var tokens = try allocator.alloc(Token, source.len);
    var token_count: usize = 0;

    var i: usize = 0;
    while (i < source.len) {
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

                while (i < source.len and source[i] != '"') {
                    i += 1;
                }

                if (i >= source.len) break;
                const str_value = source[start..i];
                tokens[token_count] = Token{ .t = .STRING_LITERAL, .value = str_value };
                token_count += 1;
            },
            else => {
                if (is_alpha(c)) {
                    const start = i;
                    while (i < source.len and is_alnum(source[i])) {
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
                } else if (is_digit(c)) {
                    const start = i;
                    while (i < source.len and is_digit(source[i])) {
                        i += 1;
                    }
                    const num_value = source[start..i];
                    tokens[token_count] = Token{ .t = .NUMBER_LITERAL, .value = num_value };
                    token_count += 1;
                    i -= 1;
                }
            },
        }
        i += 1;
    }

    // Some keyword cleaning before we return
    Keywording(tokens);

    return tokens[0..token_count];
}
