const std = @import("std");

// I made this module to manage file read/writes seprately.
const Files = @This();

// No allocator parameter needed, everything happens in the function
// Takes path and returns full content of the file
pub fn read_file_clean(path: []const u8) anyerror![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const stats = try file.stat();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    const buffer = try allocator.alloc(u8, stats.size);
    try file.reader().readNoEof(buffer);

    return buffer;
}
