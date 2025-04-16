#!/bin/bash
#
# This script installs various tools by downloading them from their respective sources.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Destination directory for the binaries
DESTINATION_DIR="${SCRIPT_DIR}/bin"

# Versions of the tools to be installed
HELM_VERSION="3.1.0"
JQ_VERSION="1.7.1"
LOKITOOL_VERSION="3.4.2"
PINT_VERSION="0.64.0"
PROMETHEUS_VERSION="2.54.0"
YQ_VERSION="4.44.3"

# Detect the operating system and use the appropriate tar command and source URLs
OS_BASE="$(uname -s)"

case "${OS_BASE}" in
  Linux*)
    # Use tar for Linux
    TAR_CMD="$(command -v tar)"

    # Source URLs for the tools
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64"
    export JQ_PATH="jq-linux-amd64"
    export LOKITOOL_SOURCE="https://github.com/grafana/loki/releases/download/v${LOKITOOL_VERSION}/lokitool-linux-amd64.zip"
    export LOKITOOL_PATH="lokitool-linux-amd64"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-linux-amd64.tar.gz"
    export PINT_PATH="pint-linux-amd64"
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz"
    export YQ_PATH="yq_linux_amd64"
    ;;

  Darwin*)
    # Use gtar for macOS
    TAR_CMD="$(command -v gtar)"

    # Source URLs for the tools
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-darwin-amd64.tar.gz"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-macos-amd64"
    export JQ_PATH="jq-macos-amd64"
    export LOKITOOL_SOURCE="https://github.com/grafana/loki/releases/download/v${LOKITOOL_VERSION}/lokitool-darwin-amd64.zip"
    export LOKITOOL_PATH="lokitool-darwin-amd64"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-darwin-amd64.tar.gz"
    export PINT_PATH="pint-darwin-amd64"
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.darwin-amd64.tar.gz"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_amd64.tar.gz"
    export YQ_PATH="yq_darwin_amd64"
    ;;

  *)
    echo "${OS_BASE} not supported"
    exit 1
    ;;
esac

# Extract and install a tool.
# $1: The name of the tool (used for the destination filename).
# $2: The source URL of the tool.
# $3: The path to the file inside the archive (optional, default is the tool name).
# $4: The number of components to strip from the archive (optional, default is 1).
extract() {
  local bin="$1"
  local source_url="$2"
  local archive_path="${3:-$bin}"
  local strip_components="${4:-1}"

  local archivefile
  remotearchivefile="${source_url##*/}"
  archivefile="$TMP_DIR/$remotearchivefile"
  destination="$DESTINATION_DIR/$bin"

  # extract files only if not exist yet
  if [[ ! -f "$destination" ]]; then
    echo "## Installing $source_url into $(realpath --relative-to "$SCRIPT_DIR" "$destination")"
    # download the archive
    curl --silent --location --output "$archivefile" "$source_url"

    # extract the archive
    archivedir="$TMP_DIR/${remotearchivefile}.extracted"
    mkdir -p "$archivedir"

    case "$archivefile" in
      *.tar*)
        "$TAR_CMD" --extract --gzip --verbose --file "$archivefile" \
          --directory "$archivedir" \
          --strip-components "$strip_components" 1> /dev/null
        ;;
      *.zip)
        unzip -q "$archivefile" -d "$archivedir" "$archive_path" 1> /dev/null
        ;;
      *)
        # assuming it's a binary
        mv "$archivefile" "$archivedir/$archive_path"
        ;;
    esac

    # move the binary to the destination
    mv "$archivedir/$archive_path" "$destination"
    chmod +x "$destination"
  fi

  if [[ ! -f "$destination" ]]; then
    echo "Failed downloading $destination"
    return 1
  fi
}

main() {
  TMP_DIR="$(mktemp -d -t fetch-tools-XXXXXXXXXX)"
  trap 'rm -rf "$TMP_DIR"' EXIT

  mkdir -p "$DESTINATION_DIR"

  extract \
    "helm" \
    "$HELM_SOURCE"

  extract \
    "jq" \
    "$JQ_SOURCE" \
    "$JQ_PATH"

  extract \
    "lokitool" \
    "$LOKITOOL_SOURCE" \
    "$LOKITOOL_PATH"

  extract \
    "pint" \
    "$PINT_SOURCE" \
    "$PINT_PATH" \
    0

  extract \
    "promtool" \
    "$PROMETHEUS_SOURCE"

  extract \
    "yq" \
    "$YQ_SOURCE" \
    "$YQ_PATH"
}

main "$@"
