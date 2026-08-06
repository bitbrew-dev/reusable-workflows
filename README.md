# Re-usable workflows for GitHub CI/CD

This repository contains a collection of re-usable workflows for GitHub CI/CD.
The workflows are designed to be used with GitHub Actions and are written in YAML.

How to use the workflows:
In the workflow file, put the path to the workflow you want to use in the `uses` key in the job definition.

For example:
```yaml
jobs:
  pre-commit:
    uses: bitbrew-dev/reusable-workflows/.github/workflows/pre-commit.yml@main
    secrets: inherit

  semantic-release:
    uses: bitbrew-dev/reusable-workflows/.github/workflows/semantic-release.yml@main
    secrets: inherit

  pypi-publish:
    uses: bitbrew-dev/reusable-workflows/.github/workflows/pypi-publish.yml@main
    secrets: inherit

  docker-build-push:
    uses: bitbrew-dev/reusable-workflows/.github/workflows/docker-build-push.yml@main
    secrets: inherit
    with:
      tags: ghcr.io/owner/repo:latest
```

## Required Permissions and Secrets
Some workflows require specific permissions and secrets to function properly:

**pre-commit workflow:**
- Requires permissions: `packages: read`, `contents: read`
- No additional secrets required

**semantic-release workflow:**
- Requires permissions: `packages: read`, `contents: write`, `issues: write`, `statuses: write`
- Required secrets: `TECHNICAL_APP_APP_ID` and `TECHNICAL_APP_PEM` for GitHub App authentication to perform releases

**pypi-publish workflow:**
- Requires permissions: `packages: read`, `contents: write`, `actions: read`
- Required secrets: `PYPI_USERNAME` and `PYPI_TOKEN` for authentication with PyPI to publish packages
- Auto-provided secrets: `GITHUB_TOKEN` for GitHub release operations

**docker-build-push workflow:**
- Requires permissions: `contents: read`, `packages: write`, `pull-requests: write`
- Auto-provided secrets: `GITHUB_TOKEN` for GitHub Container Registry authentication
- Optional secrets: Any build secrets specified in `build_repo_secrets` input

**manifest-update-digest workflow:**
- Requires permissions: # permissions: `contents: read`, `packages: write`, `pull-requests` write
- For trigger other brach workflows by providing sha
