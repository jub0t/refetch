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

    // Stop it from dying early
    while (true) {
        const stdin = std.io.getStdIn().reader();
        var buf: [10]u8 = undefined;

        if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |_| {} else {}
    }
}
