const std = @import("std");
const expect = std.testing.expect;
const GraphType = @import("graph.zig").GraphType;

test "basic graph construction" {
    const Node = struct {
        const Self = @This();

        const Tag = enum {
            a,
            b,
        };

        var currentId: u64 = 0;

        id: u64,
        tag: Tag,

        fn init(tag: Tag) Self {
            currentId += 1;
            return .{ .id = currentId, .tag = tag };
        }
    };

    const Edge = struct {
        const Self = @This();

        var currentId: u64 = 0;

        id: u64,
        weight: u32,

        fn init(weight: u32) Self {
            currentId += 1;
            return .{ .id = currentId, .weight = weight };
        }
    };

    const Graph = GraphType(*const Node, *const Edge);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var graph = Graph.init(&allocator);
    try expect(graph.node_count() == 0);
    try expect(graph.edge_count() == 0);

    const node1 = Node.init(.a);
    const node2 = Node.init(.b);
    const edge1 = Edge.init(10);
    const edge2 = Edge.init(20);

    try graph.add_node(&node1);
    try expect(graph.node_count() == 1);
    try expect(graph.edge_count() == 0);

    try graph.add_node(&node2);
    try expect(graph.node_count() == 2);
    try expect(graph.edge_count() == 0);

    try graph.add_edge(&node1, &node2, &edge1);
    try expect(graph.node_count() == 2);
    try expect(graph.edge_count() == 1);

    try graph.add_edge(&node2, &node1, &edge2);
    try expect(graph.node_count() == 2);
    try expect(graph.edge_count() == 2);
}
