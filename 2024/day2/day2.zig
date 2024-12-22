const std = @import("std");

pub fn main() !void {
    var res: u32 = 0;
    var gen_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gen_allocator.allocator();

    var file = try std.fs.cwd().openFile("./input.txt", .{});
    var reader = std.io.bufferedReader(file.reader());
    var stream = reader.reader();

    var line_buffer = std.ArrayList(u8).init(alloc);
    var num_str = try alloc.alloc(u8, 2);
    var num_list = try alloc.alloc(i32, 10);
    var num_list_itr: u32 = 0;
    var num_str_itr: u32 = 0;

    while (true) {
        stream.streamUntilDelimiter(line_buffer.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        std.debug.print("{s}\n", .{line_buffer.items});

        for (line_buffer.items) |item| {
            if ((item == ' ') or (item == '\n')) {
                num_list[num_list_itr] = try std.fmt.parseInt(i32, num_str[0..num_str_itr], 10);

                std.debug.print("{}\n", .{num_list[num_list_itr]});

                num_list_itr += 1;
                num_str_itr = 0;
                continue;
            }
            num_str[num_str_itr] = item;
            num_str_itr += 1;
        }

        num_list[num_list_itr + 1] = 1000;
        num_str_itr = 0;
        num_list_itr = 0;

        for (num_list) |num| {
            if (num < 0)
                std.debug.print("{}\n", .{num});
        }

        res += check_safe(num_list);
        line_buffer.clearRetainingCapacity();
    }

    std.debug.print("Answer {d}\n", .{res});
}

pub fn check_safe(line: []i32) u32 {
    const diff: i32 = line[0] - line[1];
    var result: i8 = 0;

    if (diff > 0) {
        result = check_descending(line);
    } else if (diff < 0) {
        result = check_ascending(line);
    }

    return @as(u32, @intCast(result));
}

pub fn check_descending(line: []i32) i8 {
    var prev: i32 = line[0];

    for (line[1..]) |num| {
        if ((prev - num >= 1) and (prev - num <= 3)) {
            prev = num;
            continue;
        } else if (num == 1000) {
            break;
        } else {
            return 0;
        }
    }

    return 1;
}

pub fn check_ascending(line: []i32) i8 {
    var prev: i32 = line[0];

    for (line[1..]) |num| {
        if ((prev - num <= -1) and (prev - num >= -3)) {
            prev = num;
            continue;
        } else if (num == 1000) {
            break;
        } else {
            return 0;
        }
    }

    return 1;
}
