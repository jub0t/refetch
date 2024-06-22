// The Parser.

const Token = @import("../lexer/lexer.zig").Token;
const std = @import("std");

pub const VunionTypes = enum(u8) {
    String,
    Number,
    Boolean,
    Null,
};

pub const InstructionType = enum {
    StandardFunction,
    FuncCall,
    FuncDefine,
    IdentAssign, // Identifier Assign

    PrintLine, // prinlnt() function
};

pub const Operators = enum(u4) {
    EQUALS,
    EQADD, // +=
};

pub const Vunion = struct {
    const Self = @This();
    pub var data: Data = Data.new();

    pub fn new() Self {
        const v = Self{};

        return v;
    }

    pub fn value(self: *Self) Data {
        return self.data;
    }

    const Data = union(enum) {
        const Me = @This();

        Boolean: ?bool,
        String: ?[]u8,
        Number: ?f64,
        Null: ?bool,

        pub fn new() Me {
            return Me{ .Null = false };
        }

        pub fn to_string(me: *Me) []const u8 {
            return me.String;
        }

        pub fn increment_by(me: *Me, amount: u32) void {
            me.Number += amount;
        }
    };
};

pub const NodeAst = struct {
    const Self = @This();

    type: InstructionType,
    name: ?[]const u8,

    value: ?Vunion,
    v_type: ?VunionTypes,

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
            .name = null,
            .condition = null,
            .value = null,
            .lhs = null,
            .rhs = null,
            .otherwise = null,
            .v_type = null,
            .operator = null,
            .then = null,
        };

        return node;
    }

    pub fn set_value(me: *NodeAst, value: Vunion) void {
        me.value = value;
    }

    pub fn set_value_null(me: *NodeAst) void {
        me.value = Vunion.new();
    }

    pub fn get_value(me: *NodeAst) ?Vunion {
        return me.value;
    }
};

pub fn Parse(tokens: []Token) anyerror![]NodeAst {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = arena.allocator();

    const nreserve = 64 * @sizeOf(NodeAst);
    var nodes = try allocator.alloc(NodeAst, nreserve);
    var n_idx: usize = 0; // Node Index;

    var node = NodeAst.new(InstructionType.IdentAssign);
    node.set_value_null();
    node.set_value(Vunion.new());

    const val = node.get_value();
    if (val) |_| {}
    // std.debug.print("{}\n", .{val.?});

    nodes[n_idx] = node;
    n_idx += 1;

    for (tokens) |token| {
        if (token.value == null) {
            continue;
        }
    }

    nodes.len = n_idx + 1; // Remove unused memory

    return nodes;
}
