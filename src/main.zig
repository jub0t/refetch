const std = @import("std");

const lexer = @import("./lexer/lexer.zig");
const files = @import("./files/files.zig");

pub fn main() anyerror!void {
    const code = try files.read_file_clean("./coverage/main.rv");
    std.debug.print("{s}\n\n[------------------ ^ RAW CODE ^ ------------------]\n\n", .{code});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var count: u16 = 0;
    const lexed = lexer.Build(code, &allocator);
    if (lexed) |tokens| {
        for (tokens) |token| {
            count = count + 1;
            std.debug.print("[{d}]: {}\n", .{ count, token });
        }
    } else |_| {
        std.debug.print("Lexer Failed...", .{});
    }
}
