const std = @import("std");

const number = struct {
    b1: u8,
    b2: u8,
    b3: u8,
    b4: u8,
    b5: u8,
};

const padding = struct {
    b1: u8,
    b2: u8,
    b3: u8,
};

const line = struct { a: number, b: padding, c: number };

pub fn main() !void {
    var inputs1: [1000]u64 = undefined;
    var inputs2: [1000]u64 = undefined;

    var gen_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gen_allocator.allocator();

    var file = try std.fs.cwd().openFile("./input.txt", .{});
    var reader = std.io.bufferedReader(file.reader());
    var stream = reader.reader();

    var line_buffer = std.ArrayList(u8).init(alloc);
    var vec1 = try alloc.alloc(u8, 5);
    var vec2 = try alloc.alloc(u8, 5);

    var iter: u32 = 0;

    while (true) {
        stream.streamUntilDelimiter(line_buffer.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        for (line_buffer.items[0..5], 0..5) |item, i| {
            vec1[i] = item;
        }

        for (line_buffer.items[8..13], 0..5) |item, i| {
            vec2[i] = item;
        }

        const val1 = try std.fmt.parseInt(u64, vec1, 10); //std.mem.bytesAsValue(u32, vec1.*);
        const val2 = try std.fmt.parseInt(u64, vec2, 10); //std.mem.bytesAsValue(u32, vec2.*);

        inputs1[iter] = val1;
        inputs2[iter] = val2;

        line_buffer.clearRetainingCapacity();
        iter += 1;
    }

    std.mem.sort(u64, &inputs1, {}, std.sort.asc(u64));
    std.mem.sort(u64, &inputs2, {}, std.sort.asc(u64));

    var sum: u64 = 0;

    for (inputs1, inputs2) |num, num2| {
        const diff: i64 = @as(i64, @intCast(num)) - @as(i64, @intCast(num2));
        sum += @abs(diff);
    }

    std.debug.print("Answer {d}\n", .{sum});
}
