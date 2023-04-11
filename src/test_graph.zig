const std = @import("std");
const expect = std.testing.expect;
const GraphType = @import("graph.zig").GraphType;

test "basic graph construction" {
    const Graph = GraphType(i32);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var allocator = arena.allocator();
    defer arena.deinit();

    var graph = Graph.new(&allocator);
    try expect(graph.node_count() == 0);
    // try expect(graph.edge_count() == 0);

    var u = try graph.add_node(1);
    try expect(graph.node_count() == 1);
    std.log.warn("added node with value = {}", .{u.value});
    // try expect(graph.edge_count() == 0);

    var v = try graph.add_node(2);
    try expect(graph.node_count() == 2);
    // try expect(graph.edge_count() == 0);

    try graph.add_edge(u, v);
    try expect(graph.node_count() == 2);
    try expect(graph.edge_count() == 1);

    // try graph.add_edge(&v, &u);
    // try expect(graph.edge_count() == 2);
}
