const std = @import("std");

pub const VariableType = enum {
    STRING,
    NUMBER,
    HASHMAP,
};

pub const Variable = union(VariableType) {
    STRING: []const u8,
    NUMBER: f64,
    HASHMAP: std.StringHashMap([]const u8),

    pub fn set(self: *Variable, t: VariableType, value: anyopaque) void {
        self.* = switch (t) {
            .STRING => Variable{ .STRING = value },
            .NUMBER => Variable{ .NUMBER = value },
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
    value: []const u8,
};

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
            // Add more token recognition as needed
            else => {
                // Handle identifiers, keywords, and other tokens
            },
        }
        i += 1;
    }

    return tokens[0..token_count];
}

pub fn main() anyerror!void {
    const allocator = std.heap.page_allocator;
    const source = "let results = {};"; // Example source code
    const tokens = try Build(source, allocator);
    for (tokens) |token| {
        std.debug.print("Token: {}\n", .{token});
    }
}
