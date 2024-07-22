// Copyright © 2024 Matthew Winter
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

const std = @import("std");
const zap = @import("zap");
const api = @import("api.zig");

// This handles any fallback requests by sending a 404
fn on_request(r: zap.Request) void {
    r.setStatus(.not_found);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .thread_safe = true,
    }){};
    const allocator = gpa.allocator();

    // We scope everything that can allocate into this block for leak detection
    {
        // setup listener
        var listener = zap.Endpoint.Listener.init(
            allocator,
            .{
                .port = 8080,
                .on_request = on_request,
                .log = true,
                .max_clients = 100000,
                .max_body_size = 100 * 1024 * 1024,
            },
        );
        defer listener.deinit();

        // register endpoint with the listener
        var apiEndpoint = api.init(allocator, "/api/v1");
        defer apiEndpoint.deinit();
        try listener.register(apiEndpoint.endpoint());

        // Start listening
        try listener.listen();
        zap.start(.{
            .threads = 2,
            .workers = 2,
        });
    }
}
