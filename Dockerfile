FROM python:alpine

RUN mkdir /app
WORKDIR /app

RUN apk update
RUN apk add make bash git
RUN apk add protobuf

RUN python3 -m venv ./env
RUN source ./env/bin/activate
COPY ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

COPY . /app

RUN make protos

CMD [ "python3", "ai/main.py" ]