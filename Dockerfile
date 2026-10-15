FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Unzip the sample data (works whether or not the zip has a top-level folder)
COPY sample-stocks.zip ./
RUN python -c "import zipfile; zipfile.ZipFile('sample-stocks.zip').extractall('/tmp/x')" \
    && if [ -d /tmp/x/sample-stocks ]; then mv /tmp/x/sample-stocks ./sample-stocks; else mv /tmp/x ./sample-stocks; fi \
    && rm -rf ./sample-stocks/__MACOSX sample-stocks.zip

COPY ["app.py", "utils.py", "./"]

ENV PORT=5001
EXPOSE 5001

# 1 worker so the simulated price clock (start_time) stays consistent
CMD ["sh", "-c", "gunicorn -w 1 -b 0.0.0.0:${PORT} app:app"]