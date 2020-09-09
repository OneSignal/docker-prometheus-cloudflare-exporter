FROM python:3-slim AS build-env

WORKDIR /exporter

ADD requirements.txt /exporter

RUN pip install --target="/exporter/pip" --requirement="/exporter/requirements.txt" \
      && rm -rf ~/.cache/pip

ADD ./exporter /exporter

FROM gcr.io/distroless/python3
ENTRYPOINT ["python", "-m", "exporter"]
EXPOSE 9199
ENV FLASK_APP=/app/exporter/app.py \
    SERVICE_PORT=9199 \
    PYTHONPATH=$PYTHONPATH:/app/exporter/pip

WORKDIR /app

COPY --from=build-env /exporter /app/exporter
