const std = @import("std");

fn NodeType(comptime NodeValue: type) type {
    return struct {
        const Self = @This();

        value: NodeValue,
        neighbors: std.ArrayList(*Self),

        fn new(allocator: *std.mem.Allocator, value: NodeValue) Self {
            return .{
                .value = value,
                .neighbors = std.ArrayList(*Self).init(allocator.*),
            };
        }

        fn add_neighbor(self: *Self, node: *Self) !void {
            try self.neighbors.append(node);
        }

        fn neighbor_count(self: *const Self) usize {
            return self.neighbors.items.len;
        }
    };
}

/// Create a new graph type with the specified node and edge value
/// types.
pub fn GraphType(comptime NodeValue: type) type {
    const Node = NodeType(NodeValue);

    return struct {
        const Self = @This();

        allocator: *std.mem.Allocator,
        nodes: std.ArrayList(*Node),

        pub fn new(allocator: *std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .nodes = std.ArrayList(*Node).init(allocator.*),
            };
        }

        pub fn add_node(self: *Self, value: NodeValue) !*Node {
            var node = try self.nodes.allocator.create(Node);
            node.value = value;
            try self.nodes.append(node);
            return self.nodes.getLast();
        }

        pub fn add_edge(_: Self, u: *Node, v: *Node) !void {
            try u.add_neighbor(v);
        }

        pub fn node_count(self: Self) usize {
            return self.nodes.items.len;
        }

        pub fn edge_count(self: *const Self) usize {
            var count: usize = 0;
            for (self.nodes.items) |node| {
                std.log.warn("{}", .{@TypeOf(node)});
                std.log.warn("n count for {} = {}", .{ node.value, node.neighbor_count() });
                count += node.neighbor_count();
            }
            std.log.warn("TOTAL = {}", .{count});
            return count;
        }
    };
}
