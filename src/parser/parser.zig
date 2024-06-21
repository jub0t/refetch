const Token = @import("../lexer/lexer.zig").Token;
const std = @import("std");

pub const InstructionType = enum {
    FuncCall,
    FuncDefine,
    IdentAssign, // Identifier Assign
};

pub const Operators = enum {
    EQUALS,
    EQADD, // +=
};

pub const Vunion = union {
    Boolean: bool,
    String: []u8,
    Number: f64,
};

pub const NodeAst = struct {
    value: Vunion,
    type: InstructionType,

    operator: Operators,

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
