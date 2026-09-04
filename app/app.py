from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

# Der Hostname zeigt in Kubernetes den Namen des Pods an.
# Das ist praktisch, um zu sehen, welcher Pod gerade antwortet.
HOSTNAME = socket.gethostname()
VERSION = os.environ.get("APP_VERSION", "0.1.0")


@app.route("/")
def index():
    return jsonify(
        nachricht="Hallo aus meinem kleinen DevOps Lernprojekt!",
        pod=HOSTNAME,
        version=VERSION,
    )


@app.route("/health")
def health():
    return jsonify(status="ok")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
