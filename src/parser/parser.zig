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
    StdCall,
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

    data: Data,
    v_type: VunionTypes,

    pub fn new() Self {
        return Self{
            .v_type = VunionTypes.Null,
            .data = Data.new(),
        };
    }

    pub fn to_string(self: *Self) []u8 {
        return self.data.String.?;
    }

    pub fn to_number(self: *Self) f64 {
        return self.data.Number;
    }

    pub fn to_bool(self: *Self) bool {
        return self.data.Boolean;
    }

    pub fn append_amount(self: *Self, amount: i32) void {
        self.data.Number += amount;
    }

    pub fn undef(
        // self: *Self,
    ) void {
        // self.v_type = VunionTypes.Null;
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
