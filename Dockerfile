FROM python:3.7-slim

# Set the working directory inside the container
WORKDIR /code

# Install system dependencies required by some Python packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt requirements.txt

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 5000 for Flask application
EXPOSE 5000

# Use the Flask development server for running the application
CMD ["python", "app.py"]
