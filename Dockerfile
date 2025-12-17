# Use Python 3.10 slim image for smaller size
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy application files from app/app directory
COPY app/app/requirements.txt .
COPY app/app/ .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (Cloud Run will set PORT env variable)
EXPOSE 8080

# Set environment variable for production
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# Use gunicorn for production
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app

