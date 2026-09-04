import fakeredis

import app as app_module


def make_client():
    app_module.app.testing = True
    return app_module.app.test_client()


def test_index_gibt_hallo_nachricht_zurueck():
    client = make_client()
    response = client.get("/")

    assert response.status_code == 200
    data = response.get_json()
    assert "nachricht" in data
    assert "pod" in data


def test_health_gibt_ok_zurueck():
    client = make_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"


def test_counter_zaehlt_ueber_fake_redis_hoch(monkeypatch):
    fake = fakeredis.FakeStrictRedis(decode_responses=True)
    monkeypatch.setattr(app_module, "get_redis_client", lambda: fake)

    client = make_client()
    erster_wert = client.get("/counter").get_json()["besucherzaehler"]
    zweiter_wert = client.get("/counter").get_json()["besucherzaehler"]

    assert zweiter_wert == erster_wert + 1


def test_ready_meldet_fehler_ohne_redis(monkeypatch):
    def kaputter_client():
        raise app_module.redis.exceptions.ConnectionError("kein redis erreichbar")

    monkeypatch.setattr(app_module, "get_redis_client", kaputter_client)

    client = make_client()
    response = client.get("/ready")

    assert response.status_code == 503
