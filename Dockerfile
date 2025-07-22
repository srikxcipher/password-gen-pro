# Python runtime as base image - lightweight Alpine version
FROM python:3.11-alpine

# Set working directory inside container
WORKDIR /app

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=app.py \
    FLASK_ENV=production

# Install system dependencies required for Python packages
RUN apk add --no-cache \
    gcc \
    musl-dev \
    linux-headers

# Copy requirements file first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# Create templates directory and copy HTML template
RUN mkdir -p templates
COPY templates/ templates/

# Create non-root user for security best practices
RUN adduser -D -s /bin/sh appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port 5000 for Flask application
EXPOSE 5000

# Health check to ensure container is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5000/health || exit 1

# Run Flask application with Gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "60", "app:app"]