FROM python:3.5-alpine

RUN mkdir /app
WORKDIR /app

RUN apk update
RUN apk add make bash git
RUN apk add protobuf
RUN apk add build-base
RUN apk add libc6-compat

RUN python -V
RUN pip -V

RUN python3 -m venv ./env
RUN source ./env/bin/activate
COPY ./requirements.txt ./requirements.txt
#hack to make tensorflow install
RUN pip3 install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.3.0-cp35-cp35m-linux_x86_64.whl
RUN pip install -r requirements.txt

COPY . /app

RUN make protos

CMD [ "python3", "ai/main.py" ]