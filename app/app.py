import logging
import os
import socket

from flask import Flask, jsonify
import redis

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Der Hostname zeigt in Kubernetes den Namen des Pods an.
# Das ist praktisch, um zu sehen, welcher Pod gerade antwortet.
HOSTNAME = socket.gethostname()
VERSION = os.environ.get("APP_VERSION", "0.2.0")
REDIS_HOST = os.environ.get("REDIS_HOST", "localhost")
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))
SECRET_CONFIGURED = bool(os.environ.get("APP_SECRET_KEY"))

_redis_client = None


def get_redis_client():
    """Erstellt den Redis Client erst beim ersten Zugriff.

    So laesst er sich in Tests leicht durch ein Fake ersetzen,
    ohne dass beim Import der App schon eine echte Verbindung noetig ist.
    """
    global _redis_client
    if _redis_client is None:
        _redis_client = redis.Redis(
            host=REDIS_HOST,
            port=REDIS_PORT,
            decode_responses=True,
            socket_connect_timeout=2,
        )
    return _redis_client


@app.route("/")
def index():
    return jsonify(
        nachricht="Hallo aus meinem DevOps Lernprojekt!",
        pod=HOSTNAME,
        version=VERSION,
        secret_konfiguriert=SECRET_CONFIGURED,
    )


@app.route("/health")
def health():
    """Liveness Check. Prueft nur, ob der Prozess selbst noch laeuft."""
    return jsonify(status="ok")


@app.route("/ready")
def ready():
    """Readiness Check. Prueft zusaetzlich, ob Redis als Abhaengigkeit erreichbar ist.

    Der Unterschied zu health ist bewusst so gewaehlt. Liveness soll nur
    einen kaputten Prozess erkennen, Readiness soll auch erkennen,
    wenn eine Abhaengigkeit gerade nicht bereit ist.
    """
    try:
        get_redis_client().ping()
    except redis.exceptions.RedisError as exc:
        logger.warning("Redis nicht erreichbar. %s", exc)
        return jsonify(status="not ready", grund="redis nicht erreichbar"), 503
    return jsonify(status="ready")


@app.route("/counter")
def counter():
    """Zaehlt Aufrufe ueber alle Pods hinweg mit.

    Der Zaehler liegt in Redis statt im Pod selbst, damit er auch dann
    stimmt, wenn mehrere Replicas laufen oder ein Pod neu gestartet wird.
    """
    try:
        client = get_redis_client()
        value = client.incr("besucherzaehler")
    except redis.exceptions.RedisError as exc:
        logger.warning("Redis nicht erreichbar. %s", exc)
        return jsonify(fehler="redis nicht erreichbar"), 503
    return jsonify(besucherzaehler=value, pod=HOSTNAME)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
