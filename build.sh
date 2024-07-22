#!/bin/bash

# Copyright © 2024 Matthew Winter
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

export PROJECT_ID=$(gcloud config get project)
export REGION=${REGION:=us-central1}

SERVICE_NAME="chainguard-zig-service"
REPOSITORY="core"
IMAGE_NAME=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/${SERVICE_NAME}

echo "Enabling required services"
gcloud services enable \
    cloudbuild.googleapis.com

echo "Execute Cloud Build to build the new container image"
gcloud builds submit --tag ${IMAGE_NAME} --region=${REGION} --project=${PROJECT_ID}
