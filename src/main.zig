const std = @import("std");

const lexer = @import("./lexer/lexer.zig");
const files = @import("./files/files.zig");

pub fn main() anyerror!void {
    const code = try files.read_file_clean("./coverage/main.rv");
    std.debug.print("{s}", .{code});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();
    const lexed = lexer.Build(code, &allocator);

    if (lexed) |_| {} else |_| {
        std.debug.print("Lexer Failed...", .{});
    }
}
