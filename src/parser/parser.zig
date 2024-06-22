// The Parser.

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

pub const Vunion = union(enum) {
    const Self = @This();

    Boolean: ?bool,
    String: ?[]u8,
    Number: ?f64,
    Null: ?bool,

    pub fn to_string(me: Self) []const u8 {
        return me.String;
    }
};

pub const NodeAst = struct {
    const Self = @This();

    value: ?Vunion,
    type: InstructionType,

    // Binary Operation.
    operator: ?Operators,
    lhs: ?*NodeAst,
    rhs: ?*NodeAst,

    // Recursive stupidity
    condition: ?*NodeAst,
    then: ?*NodeAst,
    otherwise: ?*NodeAst, // "else" is a zig keyword

    pub fn new(itype: InstructionType) Self {
        const node = Self{
            .type = itype,
            .condition = null,
            .value = null,
            .lhs = null,
            .rhs = null,
            .otherwise = null,
            .operator = null,
            .then = null,
        };

        return node;
    }

    pub fn set_value(me: *NodeAst, value: Vunion) void {
        me.value = value;
    }

    pub fn set_value_null(me: *NodeAst) void {
        me.value = Vunion{ .Null = false };
    }

    pub fn get_value(me: *NodeAst) ?Vunion {
        return me.value;
    }
};

pub fn Parse(tokens: []Token) anyerror![]NodeAst {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = arena.allocator();

    const nodes = try allocator.alloc(NodeAst, 1024);
    var n_idx: usize = 0; // Node Index;

    var node = NodeAst.new(InstructionType.IdentAssign);
    node.set_value_null();
    node.set_value(Vunion{ .Null = false });

    const val = node.get_value();
    std.debug.print("Vunion {}\n", .{val.?});

    nodes[n_idx] = node;
    n_idx += 1;

    for (tokens) |token| {
        if (token.value == null) {
            continue;
        }
    }

    return nodes;
}
