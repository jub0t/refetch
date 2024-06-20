// Second Phase of the language, The parser, parses the Tokens processed by the Lexer.
const std = @import("std");

const rstd = @import("../rstd/hashmap.zig");
const HashMap = rstd.HashMap;

const lexer = @import("../lexer/lexer.zig");
const TokenType = lexer.TokenType;

pub const VariableType = enum {
    STRING,
    NUMBER,
    HASHMAP,
};

pub const Variable = union(VariableType) {
    BOOLEAN: bool,
    NUMBER: f64, // default number is a 64 bit float
    STRING: []const u8,
    HASHMAP: HashMap,

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

// Abstract Syntax Tree Node, More on this later.
pub const NodeAst = struct {};

pub const Parser = struct {
    pub fn Parse(tokens: []lexer.Token) []lexer.Token {
        for (tokens) |token| {

            // Comments don't make it pass the parser, we're saving memory
            if (token.t == TokenType.COMMENT) {
                token.*; // Is this how you free memory in zig, lol?
            }
        }
    }
};
