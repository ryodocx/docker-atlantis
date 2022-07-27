ARG ATLANTIS_VERSION=0.19.7
ARG TERRAGRUNT_VERSION=0.38.6
ARG ALPINE_VERSION=3.16.1
ARG APK_PACKAGES="curl jq"

FROM alpine:${ALPINE_VERSION} AS workspace
COPY util.sh .

FROM workspace AS terragrunt
ARG TERRAGRUNT_VERSION
RUN source util.sh && wget -q -O terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_$(getos)_$(getarch)"
RUN chmod +x terragrunt

# output
FROM ghcr.io/runatlantis/atlantis:v${ATLANTIS_VERSION}

ARG APK_PACKAGES
RUN apk add ${APK_PACKAGES}

COPY --from=terragrunt /terragrunt /usr/local/bin/
