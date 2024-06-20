const std = @import("std");
const lexer = @import("./lexer/lexer.zig");

pub fn main() !void {
    const code: []const u8 = "print('Hi')";
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();
    var allocator = arena.allocator();

    return lexer.Build(code, &allocator);
}
