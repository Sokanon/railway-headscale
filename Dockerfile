# Stage 1: Extract headscale binary and certs from the distroless image
FROM headscale/headscale:stable AS source

# Stage 2: Build on Alpine so we have a shell for entrypoint.sh
FROM alpine:3.21

RUN apk add --no-cache ca-certificates sed

# Copy headscale binary from the distroless image
COPY --from=source /ko-app/headscale /usr/local/bin/headscale

# Copy custom config and entrypoint
COPY config.yaml /etc/headscale/config.yaml
COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 8080 9090

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
