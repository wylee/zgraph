const std = @import("std");
const expect = std.testing.expect;
const graphNS = @import("graph.zig");

test "basic graph construction" {
    const Graph_I32 = graphNS.GraphType(i32);

    var arena = graphNS.make_arena();
    defer arena.deinit();

    var graph = Graph_I32.new(arena.allocator());
    try expect(graph.node_count() == 0);
    // try expect(graph.edge_count() == 0);

    var u = try graph.add_node(1);
    try expect(graph.node_count() == 1);
    // try expect(graph.edge_count() == 0);

    var v = try graph.add_node(2);
    try expect(graph.node_count() == 2);
    // try expect(graph.edge_count() == 0);

    try graph.add_edge(&u, &v);
    try expect(graph.edge_count() == 1);

    // try graph.add_edge(&v, &u);
    // try expect(graph.edge_count() == 2);
}
