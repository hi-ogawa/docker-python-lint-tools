#
# stage_common
#
FROM python:3.9.9-alpine3.14 AS stage_common

RUN mkdir -p /app
WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

#
# stage_build
#
FROM stage_common AS stage_build

RUN apk add --no-cache \
  gcc=10.3.1_git20210424-r2 \
  musl-dev=1.2.2-r3

# hadolint ignore=DL3059
RUN pip install --no-cache-dir \
  black==21.11b1 \
  isort==5.10.1 \
  flake8==4.0.1 \
  mypy==0.910

# hadolint ignore=DL3059
RUN pip list

#
# stage_run
#
FROM stage_common AS stage_run

COPY --from=stage_build /opt/venv /opt/venv
