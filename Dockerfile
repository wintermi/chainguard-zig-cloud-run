# Copyright 2024, Matthew Winter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM cgr.dev/chainguard/zig AS builder

WORKDIR /work
COPY build/ /work/
RUN zig build -Doptimize=ReleaseFast

FROM cgr.dev/chainguard/glibc-dynamic
COPY --from=builder /work/zig-out/bin/service /app/service
CMD ["/app/service"]
