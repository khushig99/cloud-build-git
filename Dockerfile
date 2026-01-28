# Use a lightweight Python base image
FROM python:3.11-slim

# Environment settings to make Python behave nicely in containers
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Create a non-root user (good practice)
RUN adduser --disabled-password --gecos "" appuser

# Set working directory
WORKDIR /app

# Copy and install Python dependencies first (for caching)
COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app code
COPY . .

# Switch to non-root user
USER appuser

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# Start the Flask app
CMD ["python", "app.py"]