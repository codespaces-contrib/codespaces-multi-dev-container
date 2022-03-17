FROM debian:bullseye as base
# 👇 Create non-root user called "worker" we will use when running the real app
RUN groupadd --gid 1000 worker && useradd -s /bin/bash --uid 1000 --gid worker -m worker

#  ******* Final production image  *******

# 👇 Use a temp image to mount the code during image build (only), build and then put result in /service
FROM save-june-worker-devcontainer as service-build
RUN --mount=source=.,target=/source-code,type=bind,rw bash /source-code/build-worker.sh /service

# 👇 Copy the contents of the /out folder in the temp image into /app in a fresh image from the base
FROM base as production
ENV GIN_MODE=release
COPY --from=service-build /service /service
WORKDIR /service/
USER worker
EXPOSE 8080
CMD ["/service/worker"]

