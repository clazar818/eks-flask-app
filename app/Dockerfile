FROM python:3.8.13

RUN apt-get update -y

# Create app directory
WORKDIR /app

ADD . /app

# Install packages 
RUN pip3 install -r requirements.txt 

EXPOSE 80

CMD python3 app.py
