From ubuntu:16.04

RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen ru_RU.UTF-8
ENV LANG='ru_RU.UTF-8' LANGUAGE='ru_RU:ru' LC_ALL='ru_RU.UTF-8'

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    git \
    vim \
    python3 \
    python3-pip \
    nginx \
    supervisor \
    libpq-dev \
    postgresql \
    postgresql-contrib \
    pwgen && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip3 install uwsgi django

# nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-site.conf /etc/nginx/sites-available/default

# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/

# uWSGI config
COPY uwsgi.ini /home/django/
COPY uwsgi_params /home/django/

# Model_example content
COPY admin.py /home/django/
COPY models.py /home/django/

# Copy initialization scripts
COPY init.sql /home/django/
COPY start.sh /home/django/

EXPOSE 80
CMD ["/bin/bash", "/home/django/start.sh"]
