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

// an Endpoint

pub const Self = @This();

alloc: std.mem.Allocator = undefined,
ep: zap.Endpoint = undefined,

pub fn init(
    a: std.mem.Allocator,
    path: []const u8,
) Self {
    return .{
        .alloc = a,
        .ep = zap.Endpoint.init(.{
            .path = std.fmt.allocPrint(a, "{s}/joshua", .{path}) catch return undefined,
            .get = getHandler,
        }),
    };
}

pub fn deinit(_: *Self) void {}

pub fn endpoint(self: *Self) *zap.Endpoint {
    return &self.ep;
}

fn getHandler(_: *zap.Endpoint, r: zap.Request) void {
    r.setStatus(.ok);
}
