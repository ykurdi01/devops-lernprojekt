# Kleines Beispielimage fuer eine simple Flask App.
# Bewusst einfach gehalten, damit man den Aufbau gut nachvollziehen kann.

FROM python:3.12-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/app.py .

EXPOSE 5000

CMD ["python", "app.py"]
