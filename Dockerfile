FROM python:3.5

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN mkdir /app
WORKDIR /app

RUN apt-get update
RUN apt-get install make bash git --assume-yes
RUN apt-get install build-essential --assume-yes
RUN apt-get install protobuf-compiler --assume-yes

RUN python -V
RUN pip -V

RUN python3 -m venv ./env
RUN source ./env/bin/activate
COPY ./requirements.txt ./requirements.txt

RUN pip install -r requirements.txt

COPY . /app

CMD [ "python3", "ai/main.py" ]