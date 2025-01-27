FROM python:3.8

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY llmgen.py /app/

CMD ["uvicorn", "llmgen:app", "--host", "0.0.0.0", "--port", "80"]
