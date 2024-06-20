const std = @import("std");
const Allocator = std.mem.Allocator;

pub const VariableType = enum {
    STRING,
    NUMBER,
    HASHMAP,
};

// This Struct can optimally store many different types of data/variables
pub const Variable = struct {
    // Variable? is it necessary?
    key: []const u8,

    // value: Some_Type_Implementation

    pub fn set() anyerror!void {}
    pub fn get() anyerror!void {}
};

pub const TokenType = enum(u8) {
    // Variables
    RETURN,
    CONST,
    LET,
    IF,

    // Types
    VARIABLE = Variable,
    OBJECT, // HasMap Fast K,V store zig

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
