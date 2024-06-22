// Final stage of the language, all instructions are processed and ran here.
const Parser = @import("../parser/parser.zig");
const NodeAst = Parser.NodeAst;
const Rstd = @import("../rstd/std.zig");

pub const Environment = struct {
    const Self = @This();

    pub fn new() Environment {
        return Environment{};
    }

    // pub fn set_variable(self: *Self, k: []const u8, v: Parser.Vunion) void {}
};

pub fn Interpret(nodes: []NodeAst) void {
    for (nodes) |_| {}
}
