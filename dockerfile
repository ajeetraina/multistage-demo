# Regular Docker Build without multi-stage
FROM python:3.9-slim

WORKDIR /app

# Install required packages
RUN pip install flask

# Copy the app source code
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
