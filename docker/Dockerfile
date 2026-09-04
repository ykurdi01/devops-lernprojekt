# Mehrstufiges Image, damit im fertigen Image keine Build-Werkzeuge
# und keine ungenutzten Pakete landen.

FROM python:3.12-slim AS builder

WORKDIR /build

COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


FROM python:3.12-slim

WORKDIR /app

# Eigener Benutzer statt root, aus Sicherheitsgruenden.
RUN addgroup --system app && adduser --system --ingroup app appuser

COPY --from=builder /install /usr/local
COPY app/app.py .

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
