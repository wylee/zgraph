const std = @import("std");
const ArrayList = std.ArrayList;

const GraphError = error{
    NodeNotFound,
};

/// Create a new graph type with the specified node and edge types.
pub fn GraphType(comptime Node: type, comptime Edge: type) type {
    const Neighbor = struct {
        const Self = @This();

        node: Node,
        edge: Edge,

        fn init(node: Node, edge: Edge) Self {
            return .{ .node = node, .edge = edge };
        }
    };

    return struct {
        const Self = @This();

        allocator: *std.mem.Allocator,
        nodes: ArrayList(Node),
        neighbors: ArrayList(ArrayList(Neighbor)),

        pub fn init(allocator: *std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .nodes = ArrayList(Node).init(allocator.*),
                .neighbors = ArrayList(ArrayList(Neighbor)).init(allocator.*),
            };
        }

        pub fn find_node(self: Self, node: Node) GraphError!usize {
            const i = for (self.nodes.items, 0..) |curr, i| {
                if (std.meta.eql(curr, node)) break i;
            } else return GraphError.NodeNotFound;
            return i;
        }

        pub fn add_node(self: *Self, node: Node) !void {
            try self.nodes.append(node);
            try self.neighbors.append(ArrayList(Neighbor).init(self.allocator.*));
        }

        pub fn add_edge(self: *Self, u: Node, v: Node, edge: Edge) !void {
            const i = try self.find_node(u);
            const neighbor = Neighbor.init(v, edge);
            try self.neighbors.items[i].append(neighbor);
        }

        pub fn node_count(self: Self) usize {
            return self.nodes.items.len;
        }

        pub fn edge_count(self: *const Self) usize {
            var count: usize = 0;
            for (self.neighbors.items) |neighbors| {
                count += neighbors.items.len;
            }
            return count;
        }
    };
}
