#!/usr/bin/env bash

_CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build_images(){
    GO_IMAGE_VERSION=${GO_IMAGE_VERSION:-1.27-alpine}
    PYTHON_IMAGE_VERSION=${PYTHON_IMAGE_VERSION:-3.13-slim-bookworm}
    PIPX_VERSION=${PIPX_VERSION:-1.16.0}
    HADOLINT_VERSION=${HADOLINT_VERSION:-v2.14.0}
    GH_VERSION=${GH_VERSION:-2.96.0}
    UV_VERSION=${UV_VERSION:-0.11.29}
    PRE_COMMIT_VERSION=${PRE_COMMIT_VERSION:-4.3.0}
    HELM_DOCS_VERSION=${HELM_DOCS_VERSION:-v1.14.2}
    NODE_VERSION=${NODE_VERSION:-26}
    PREK_VERSION=${PREK_VERSION:-0.4.10}
    PULUMI_VERSION=${PULUMI_VERSION:-3.3247.0}
    RUST_VERSION=${RUST_VERSION:-1.98.0}
    TERRAFORM_VERSION=${TERRAFORM_VERSION:-1.16.5}
    MISE_VERSION=${MISE_VERSION:-v2026.11.3}
    TRIVY_VERSION=${TRIVY_VERSION:-0.75.0}

    docker buildx build --platform linux/amd64,linux/arm64 \
        --no-cache \
        --build-arg GO_IMAGE_VERSION="${GO_IMAGE_VERSION}" \
        --build-arg PYTHON_IMAGE_VERSION="${PYTHON_IMAGE_VERSION}" \
        --build-arg PIPX_VERSION="${PIPX_VERSION}" \
        --build-arg HADOLINT_VERSION="${HADOLINT_VERSION}" \
        --build-arg GH_VERSION="${GH_VERSION}" \
        --build-arg UV_VERSION="${UV_VERSION}" \
        --build-arg PRE_COMMIT_VERSION="${PRE_COMMIT_VERSION}" \
        --build-arg HELM_DOCS_VERSION="${HELM_DOCS_VERSION}" \
        --build-arg RUST_VERSION="${RUST_VERSION}" \
        --build-arg TERRAFORM_VERSION="${TERRAFORM_VERSION}" \
        --build-arg MISE_VERSION="${MISE_VERSION}" \
        --build-arg TRIVY_VERSION="${TRIVY_VERSION}" \
        --build-arg NODE_VERSION="${NODE_VERSION}" \
        --build-arg PREK_VERSION="${PREK_VERSION}" \
        --build-arg PULUMI_VERSION="${PULUMI_VERSION}" \
        -t ghcr.io/bitbrew-dev/pre-commit:latest \
        -t ghcr.io/bitbrew-dev/r-workflows/pre-commit:latest \
        -t ghcr.io/bitbrew-dev/reusable-workflows/pre-commit:latest \
        -t ghcr.io/bitbrew-dev/r-workflows/prek:latest \
        -t ghcr.io/bitbrew-dev/reusable-workflows/prek:latest \
        --push \
        -f "${_CURRENT_DIR}/Dockerfile" \
        "${_CURRENT_DIR}/."
}

build_images
