// Final stage of the language, all instructions are processed and ran here.
const Parser = @import("../parser/parser.zig");
const NodeAst = Parser.NodeAst;
const Rstd = @import("../rstd/std.zig");
const std = @import("std");

pub const Environment = struct {
    const Self = @This();

    globals: std.StringHashMap(Parser.Vunion),

    pub fn new() Self {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        const allocator = arena.allocator();
        const globals = std.StringHashMap(Parser.Vunion).init(allocator);

        return Self{
            .globals = globals,
        };
    }

    pub fn set_variable(self: *Self, k: []const u8, v: Parser.Vunion) anyerror!void {
        return try self.globals.put(k, v);
    }
};

pub fn Interpret(nodes: []NodeAst) anyerror!void {
    var menv = Environment.new(); // Main Env

    for (nodes) |node| {
        switch (node.type) {
            .IdentAssign => {
                try menv.set_variable(node.name.?, node.value.?);
            },

            else => {},
        }
    }
}
