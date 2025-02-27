#!/bin/bash -e
#
# Copyright (c) 2023 Oracle and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BASE_URL="https://github.com/koalaman/shellcheck/releases/download"
readonly BASE_URL

VERSION=0.9.0
readonly VERSION

CACHE_DIR="${HOME}/.shellcheck"
readonly CACHE_DIR

# Caching the shellcheck
mkdir -p "${CACHE_DIR}"
if [ ! -e "${CACHE_DIR}/${VERSION}/shellcheck" ] ; then
    curl -Lso "${CACHE_DIR}/sc.tar.xz" "${BASE_URL}/v${VERSION}/shellcheck-v${VERSION}.linux.x86_64.tar.xz"

    tar -xf "${CACHE_DIR}/sc.tar.xz" -C "${CACHE_DIR}"

    mkdir "${CACHE_DIR}/${VERSION}"
    mv "${CACHE_DIR}/shellcheck-v${VERSION}/shellcheck" "${CACHE_DIR}/${VERSION}/shellcheck"
    export PATH="${CACHE_DIR}/${VERSION}:${PATH}"
fi

echo "ShellCheck version"
shellcheck --version

status_code=0
# shellcheck disable=SC2044
for file in $(find . -name "*.sh") ; do
    printf "\n-- Checking file:  %s --\n" "${file}"
    shellcheck "${file}" || status_code=${?}
done

exit ${status_code}
