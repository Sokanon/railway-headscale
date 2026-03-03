FROM headscale/headscale:stable

# Copy custom config and entrypoint
COPY config.yaml /etc/headscale/config.yaml
COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 8080 9090

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
