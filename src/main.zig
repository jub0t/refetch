const std = @import("std");
const lexer = @import("./lexer/lexer.zig");

pub fn main() anyerror!void {
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    var file_alloc = gp.allocator();

    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath("./coverage/main.rv", &path_buffer);
    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    // Read the contents
    const buffer_size = 2000;
    const file_buffer = try file.readToEndAlloc(file_alloc, buffer_size);
    defer file_alloc.free(file_buffer);

    // Split by "\n" and iterate through the resulting slices of "const []u8"
    var iter = std.mem.split(u8, file_buffer, "\n");

    var count: usize = 0;
    while (iter.next()) |line| : (count += 1) {
        std.log.info("{s}", .{line});
    }

    const code: []const u8 = "print('Hi')";
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();
    var allocator = arena.allocator();

    const lexed = lexer.Build(code, &allocator);

    if (lexed) |_| {} else |_| {
        std.debug.print("Lexer Failed..., {s}", .{});
    }
}
