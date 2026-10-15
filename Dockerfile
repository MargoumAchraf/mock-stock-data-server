FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Unzip the sample data (the repo only has the .zip)
COPY sample-stocks.zip ./
RUN python -c "import zipfile; zipfile.ZipFile('sample-stocks.zip').extractall('.')" \
    && rm sample-stocks.zip

COPY ["app.py", "utils.py", "./"]

ENV PORT=5001
EXPOSE 5001

# 1 worker so the simulated price clock (start_time) stays consistent
CMD ["sh", "-c", "gunicorn -w 1 -b 0.0.0.0:${PORT} app:app"]