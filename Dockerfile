# ---- Flask app image (repo root: ./Dockerfile)
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# App deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir gunicorn

# App code
COPY . .

# --- FIX: Install dos2unix and convert line endings ---
RUN apt-get update && apt-get install -y dos2unix

# 1. Convert the file in the current working directory (/app)
# The file is currently at /app/docker-entrypoint-app.sh
RUN dos2unix docker-entrypoint-app.sh

# 2. MOVE the fixed file to the final destination (/usr/local/bin/)
#    This is the only way to ensure the fixed version is in the ENTRYPOINT path.
#    We do not need the old `COPY ... /usr/local/bin/` step anymore.
RUN mv docker-entrypoint-app.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-app.sh


EXPOSE 5000


# Use the custom entrypoint to run the database setup first
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-app.sh"]
CMD [] 
# CMD is no longer needed since the entrypoint contains the full command
#CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

