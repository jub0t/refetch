const std = @import("std");

pub const HashMap = struct {
    const map: std.StringHashMap = std.StringHashMap([]const u8);

    pub fn new() anyerror!void {}

    pub fn insert() void {}

    pub fn get() anyopaque {}
};
