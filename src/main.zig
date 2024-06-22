const std = @import("std");

const Recode = @import("./lexer/recode.zig").Recode;
const files = @import("./files/files.zig");

const lexer = @import("./lexer/lexer.zig");
const parser = @import("./parser/parser.zig");
const interpreter = @import("./interpreter/interpreter.zig");

pub fn main() anyerror!void {
    var args = std.process.args();
    if (args.next() == null) return; // Skip first argument

    const file_path = args.next().?;
    const code = try files.read_file_clean(file_path);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const lexer_start = std.time.microTimestamp();
    const lexed = lexer.Build(code, &allocator);

    if (lexed) |tokens| {
        std.debug.print("[LEXER]: Tokenized {} Tokens In {}μs\n", .{ tokens.len, (std.time.microTimestamp() - lexer_start) });

        const parser_start = std.time.microTimestamp();
        const ast_nodes = try parser.Parse(tokens);
        std.debug.print("[PARSER]: Parsed {} Nodes In {}μs\n", .{ ast_nodes.len, (std.time.microTimestamp() - parser_start) });

        // Interpret
        try interpreter.Interpret(ast_nodes);
    } else |_| {
        std.debug.print("Lexer Failed...", .{});
    }
}

test "main_tests" {
    const file_path = "./coverage/main.rv";
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

        // var gp = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        // var parser_allocator = gp.allocator();

        const parsed_data = try parser.Parse(tokens);
        for (parsed_data) |_| {
            // std.debug.print("{}", .{node.type});
        }

        std.debug.print("\n\n[------------------ ^ TOKENS ^ ------------------]\n\n", .{});

        // const re_code = try Recode(tokens);
        // std.debug.print("{s}", .{re_code});
    } else |_| {
        std.debug.print("Lexer Failed...", .{});
    }
}
