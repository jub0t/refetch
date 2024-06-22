const Parser = @import("../parser/parser.zig");
const Lexer = @import("../lexer/lexer.zig");
const std = @import("std");

pub fn println(t: Parser.VunionTypes, v: Parser.Vunion) void {
    const writer = std.io.getStdOut().writer();
    const print = writer.print;

    switch (t) {
        .Boolean => {},
        .String => {
            print("{}", .{v.to_string()});
        },

        else => {
            print("[ERROR]: Not configured to print type {}", .{t});
        },
    }
}
