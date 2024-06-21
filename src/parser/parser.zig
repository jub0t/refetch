const Token = @import("../lexer/lexer.zig").Token;
const std = @import("std");

pub const InstructionType = enum {
    FunctionDefine,
    FunctionCall,
    VariableDefine,
};

pub const Operators = enum {
    EQUALS,
    EQADD, // +=
};

pub const NodeAst = struct {
    type: InstructionType,

    // Recursive stupidity
    condition: *NodeAst,
    then: *NodeAst,
    otherwise: *NodeAst, // "else" is a zig keyword
};

pub fn Parse(tokens: []Token) anyerror![]NodeAst {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = arena.allocator();

    const nodes = try allocator.alloc(NodeAst, 1024);

    for (tokens) |token| {
        std.debug.print("{}\n\n", .{token.t});
    }

    return nodes;
}
