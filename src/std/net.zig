pub const RequestMethods = enum(u8) {
    GET,
    POST,
};

pub const Response = struct {
    // anyopaque for now
    Headers: anyopaque,
    Body: anyopaque,

    time_elapsed: u64,
};

pub const RequestBuilder = struct {
    const Self = @This();

    pub const method: null!RequestMethods = null;

    pub fn new(url: []const u8) Self {
        return Self{
            .url = url,
        };
    }

    // Process Request
    pub fn process() !void {}

    // Request Handlers
    pub fn get() !void {}
    pub fn post() !void {}
};
