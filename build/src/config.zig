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

const Allocator = std.mem.Allocator;

/// Cloud Run Service Configuration
///
/// Provides a single location in which to host the Environment Variables
/// configured for the Cloud Run Service.
const Self = @This();

/// The port the Cloud Run ingress container is to listen for requests from.
port: usize,

/// The request timeout setting in seconds, specifying the time which a
/// response must be returned by a service deployed to Cloud Run.
timeout_seconds: ?u8,

/// Memory Allocator used by the Command Line Applications
allocator: Allocator,

/// Cloud Run Service Configuration `init` function
///
/// Deinitialize using `deinit` to flush buffers and deallocate memory.
pub fn init(allocator: Allocator) Self {
    return .{
        .port = undefined,
        .timeout_seconds = undefined,
        .allocator = allocator,
    };
}

/// Flush buffers and release any allocated memory.
pub fn deinit(_: *Self) void {
    // No memory to deallocate
}

/// Get the Environment Variables and populate the configuration values
pub fn GetVariables(self: *Self) !void {
    var env_map = try std.process.getEnvMap(self.allocator);
    defer env_map.deinit();

    self.port = try std.fmt.parseInt(usize, env_map.get("PORT") orelse "8080", 10);
    self.timeout_seconds = try std.fmt.parseInt(u8, env_map.get("CLOUD_RUN_TIMEOUT_SECONDS") orelse "10", 10);
}
