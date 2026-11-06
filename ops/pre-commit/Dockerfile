ARG GO_IMAGE_VERSION=1.27-alpine
ARG PYTHON_IMAGE_VERSION=3.13-slim-bookworm
FROM golang:${GO_IMAGE_VERSION} AS go
FROM python:${PYTHON_IMAGE_VERSION}

ARG PIPX_VERSION=1.7.1
ENV PIPX_VERSION=${PIPX_VERSION}

ARG HADOLINT_VERSION=v2.14.0
ENV HADOLINT_VERSION=${HADOLINT_VERSION}

ARG GH_VERSION=2.80.0
ENV GH_VERSION=${GH_VERSION}

ARG UV_VERSION=0.8.18
ENV UV_VERSION=${UV_VERSION}

ARG PRE_COMMIT_VERSION=4.3.0
ENV PRE_COMMIT_VERSION=${PRE_COMMIT_VERSION}

ARG HELM_DOCS_VERSION=v1.14.2
ENV HELM_DOCS_VERSION=${HELM_DOCS_VERSION}

ARG NODE_VERSION=24
ENV NODE_VERSION=${NODE_VERSION}

ARG PREK_VERSION=0.2.4
ENV PREK_VERSION=${PREK_VERSION}

ARG PULUMI_VERSION=3.198.0
ENV PULUMI_VERSION=${PULUMI_VERSION}

ARG RUST_VERSION=stable
ENV RUST_VERSION=${RUST_VERSION}

ARG TERRAFORM_VERSION=1.16.5
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}

ARG MISE_VERSION=v2026.11.3
ENV MISE_VERSION=${MISE_VERSION}

ARG TRIVY_VERSION=0.75.0
ENV TRIVY_VERSION=${TRIVY_VERSION}

WORKDIR /workspace

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

COPY --from=go /usr/local/go/ /usr/local/go/

ENV GOBIN="/usr/local/go/bin"
ENV CARGO_HOME="/usr/local/cargo"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_ROOT="${CARGO_HOME}/bin"
ENV PULUMI_BIN="/root/.pulumi/bin"
ENV PATH="/root/.local/bin:${CARGO_ROOT}:${GOBIN}:${PULUMI_BIN}:${PATH}"

SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl ca-certificates gnupg sudo \
    unzip wget openssl iproute2 coreutils wireguard-tools build-essential jq && \
    # ---- install nodejs ---- #
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    # ---- install pipx and pre-commit ---- #
    pip install --no-cache-dir --root-user-action ignore pipx && \
    pipx install pre-commit==${PRE_COMMIT_VERSION} uv==${UV_VERSION} && \
    # ---- install helm-docs ---- #
    go install github.com/norwoodj/helm-docs/cmd/helm-docs@${HELM_DOCS_VERSION} && \
    # ---- install helm ---- #
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    # ---- install prek ---- #
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/j178/prek/releases/download/v${PREK_VERSION}/prek-installer.sh | sh && \
    # ---- install tomlv ---- #
    go install github.com/BurntSushi/toml/cmd/tomlv@latest && \
    # ---- install typescript ---- #
    npm install -g typescript@ && \
    # ---- install rust ---- #
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
        --no-modify-path --default-toolchain ${RUST_VERSION} -c rustfmt -c clippy && \
    chmod -R a+rwX "${CARGO_HOME}" "${RUSTUP_HOME}" && \
    # ---- install hadolint ---- #
    if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM="x86_64"; elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then export PLATFORM="arm64"; else echo "Unsupported architecture"; exit 1; fi && \
    curl -sSL https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-${PLATFORM} --output /usr/local/bin/hadolint && \
    # ---- install terraform ---- #
    if [ "$(uname -m)" = "x86_64" ]; then export TF_ARCH="amd64"; elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then export TF_ARCH="arm64"; else echo "Unsupported architecture"; exit 1; fi && \
    curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip" -o /tmp/terraform.zip && \
    unzip -q /tmp/terraform.zip terraform -d /usr/local/bin && \
    # ---- install mise ---- #
    curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh && \
    # ---- install trivy ---- #
    if [ "$(uname -m)" = "x86_64" ]; then export TRIVY_ARCH="64bit"; elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then export TRIVY_ARCH="ARM64"; else echo "Unsupported architecture"; exit 1; fi && \
    curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${TRIVY_ARCH}.tar.gz" | tar -xz -C /usr/local/bin trivy && \
    # ---- install pulumi ---- #
    # curl -fsSL https://get.pulumi.com | sh -s -- --version ${PULUMI_VERSION} && \
    # ---- install github cli ---- #
    # (type -p wget >/dev/null || ( \
    # apt-get update && \
    # apt-get install wget -y)) && \
    # mkdir -p -m 755 /etc/apt/keyrings && \
    # out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    # cat $out | \
    # tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    # chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    # mkdir -p -m 755 /etc/apt/sources.list.d && \
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    # tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    # apt-get update && \
    # apt-get install gh -y && \
    # ---- install awscli ---- #
    # if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM="x86_64"; elif [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then export PLATFORM="aarch64"; else echo "Unsupported architecture"; exit 1; fi && \
    # curl "https://awscli.amazonaws.com/awscli-exe-linux-${PLATFORM}.zip" -o "awscliv2.zip" && \
    # unzip awscliv2.zip && \
    # ./aws/install && \
    # rm -rf aws* && \
    # ---- install vault ---- #
    # wget https://releases.hashicorp.com/vault/1.15.6/vault_1.15.6_linux_amd64.zip && \
    # unzip vault_1.15.6_linux_amd64.zip && \
    # mv vault /usr/local/bin/ && \
    # chmod +x /usr/local/bin/vault && \
    # vault version  && \
    # ---- set permissions and cleanup ---- #
    chmod +x /usr/local/bin/hadolint && \
    apt-get autoremove -yqq --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /var/tmp/*

CMD [ "prek" ]
