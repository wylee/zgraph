const std = @import("std");

/// Make an arena allocator for use with a typical graph.
pub fn make_arena() std.heap.ArenaAllocator {
    return std.heap.ArenaAllocator.init(std.heap.page_allocator);
}

/// Create a new graph type with the specified node type.
pub fn GraphType(comptime NodeType: type) type {
    const Node = struct {
        const Self = @This();

        value: NodeType,
        neighbors: std.ArrayList(*Self),

        fn new(allocator: std.mem.Allocator, value: NodeType) Self {
            return Self{
                .value = value,
                .neighbors = std.ArrayList(*Self).init(allocator),
            };
        }

        fn add_neighbor(self: *Self, neighbor: *Self) !void {
            try self.neighbors.append(neighbor);
        }

        fn neighbor_count(self: Self) usize {
            return self.neighbors.items.len;
        }
    };

    const Graph = struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        nodes: std.ArrayList(Node),

        pub fn new(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .nodes = std.ArrayList(Node).init(allocator),
            };
        }

        pub fn add_node(self: *Self, value: NodeType) !Node {
            const node = Node.new(self.allocator, value);
            try self.nodes.append(node);
            return node;
        }

        pub fn add_edge(_: Self, u: *Node, v: *Node) !void {
            std.log.warn("\n\n", .{});
            std.log.warn("BEGIN add_edge", .{});
            std.log.warn("neighbor count: {}", .{u.neighbors.items.len});
            try u.add_neighbor(v);
            std.log.warn("neighbor count: {}", .{u.neighbors.items.len});
            std.log.warn("neighbors[0] value: {}", .{u.neighbors.items[0].value});
            std.log.warn("END add_edge", .{});
        }

        pub fn node_count(self: Self) usize {
            return self.nodes.items.len;
        }

        pub fn edge_count(self: Self) usize {
            std.log.warn("\n\n", .{});
            std.log.warn("BEGIN edge_count", .{});
            var count: usize = 0;
            for (self.nodes.items) |node| {
                std.log.warn("node value: {}", .{node.value});
                std.log.warn("neighbor count: {}", .{node.neighbor_count()});
                count += node.neighbor_count();
                std.log.warn("total count: {}", .{count});
            }
            std.log.warn("END edge_count", .{});
            return count;
        }
    };

    return Graph;
}
