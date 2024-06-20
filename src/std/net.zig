const std = @import("std");

pub const NetMethods = enum(u8) {
    GET,
    POST,
};

pub const Response = struct {
    // anyopaque for now
    Headers: anyopaque,
    Body: anyopaque,
};

pub const NetConfig = struct {
    method: NetMethods,
    headers: anyopaque,
};

pub const NetBuilder = struct {
    const Self = @This();

    pub fn new(url: []const u8, config: NetConfig) Self {
        return Self{
            .url = url,
            .method = config.method,
        };
    }

    // Process Request
    pub fn process() !void {}

    // Request Handlers
    fn get() !void {}
    fn post() !void {}
};

test "Network Request Test" {
    const request = NetBuilder.new("http://localhost:3440", NetConfig{
        .method = NetMethods.GET,
        .headers = {},
    });

    const response = request.process();
    std.debug.print("{}", response);
}
