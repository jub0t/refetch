const std = @import("std");
const Recode = @import("./lexer/recode.zig").Recode;

const lexer = @import("./lexer/lexer.zig");
const files = @import("./files/files.zig");

pub fn main() anyerror!void {
    var args = std.process.args();
    const m = args.next().?; // Skip the binary path, first arg
    std.debug.print("{s}", .{m});

    const file_path = args.next().?;
    const code = try files.read_file_clean(file_path);
    std.debug.print("{s}\n\n[------------------ ^ RAW CODE ^ ------------------]\n\n", .{code});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var count: u16 = 0;
    const lexed = lexer.Build(code, &allocator);

    if (lexed) |tokens| {
        for (tokens) |token| {
            count = count + 1;

            if (token.value) |val| {
                std.debug.print("[{d}]: {} => {s}\n", .{ count, token.t, val });
            }
        }

        std.debug.print("\n\n[------------------ ^ TOKENS ^ ------------------]\n\n", .{});

        // const re_code = try Recode(tokens);
        // std.debug.print("{s}", .{re_code});
    } else |_| {
        std.debug.print("Lexer Failed...", .{});
    }

    // Stop it from dying early
    // while (true) {
    //     const stdin = std.io.getStdIn().reader();
    //     var buf: [10]u8 = undefined;

    //     if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |_| {} else {}
    // }
}

test "main_tests" {
    std.debug.print("Testing...", .{});
}
