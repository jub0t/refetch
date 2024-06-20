const std = @import("std");
const Allocator = std.mem.Allocator;

pub const VariableType = enum {
    STRING,
    NUMBER,
    HASHMAP,
};

pub const TokenType = enum(u8) {
    // Variables
    RETURN,
    CONST,
    LET,
    IF,

    // Types
    VARIABLE,

    // Punctuations
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    COMMA,
    DOT,

    // Functions
    FUNCTION,
    // Public Function Keyword
    PUB,

    // Operators
    EQ, // Equals To.
    NEQ, // Not Equals To.
};

pub const Value = struct {};

pub const Token = struct {
    // Type
    t: TokenType,

    // Index to a Value Struct Stored in an Array.
    v: u16,
};

pub fn Build(_: []const u8, allocator: *std.mem.Allocator) anyerror!void {
    const results = allocator.create(i32);
    if (results) |_| {} else |_| {}
}
