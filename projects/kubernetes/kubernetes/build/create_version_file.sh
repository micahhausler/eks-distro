#!/usr/bin/env bash
# Copyright 2020 Amazon.com Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

TAG=$1
RELEASE_BRANCH=$2

BASE_DIRECTORY=$(git rev-parse --show-toplevel)
MAKE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${MAKE_ROOT}/build/lib/init.sh"
BIN_DIR="${OUTPUT_DIR}/${RELEASE_BRANCH}/bin"
if [ ! -d ${BIN_DIR} ] ;  then
    echo "${BIN_DIR} not present! Run 'make binaries'"
    exit 1
fi
RELEASE_ENVIRONMENT=${RELEASE_ENVIRONMENT:-development}

VERSION_FILE="${MAKE_ROOT}/${RELEASE_BRANCH}/KUBE_GIT_VERSION_FILE"
rm -f $VERSION_FILE
touch $VERSION_FILE
RELEASE_FILE="${BASE_DIRECTORY}/release/${RELEASE_BRANCH}/${RELEASE_ENVIRONMENT}/RELEASE"
build::version::create_env_file "$TAG" "$VERSION_FILE" "$RELEASE_FILE" "kubernetes" "$RELEASE_BRANCH"
