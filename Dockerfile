FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app/

# Caching is bad in Docker because the container is temporary. 
# And caching Files are never reused. And they also increase Image size. 
# That's why we use a --no-cache-dir to prevent caching. 
# So It tells pip to Download the packages, install them, then delete the cache.

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

RUN python manage.py makemigrations
RUN python manage.py migrate

EXPOSE 8000

CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]