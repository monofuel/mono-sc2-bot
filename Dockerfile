FROM python:alpine

RUN mkdir /app
WORKDIR /app

RUN python3 -m venv ./env
RUN source ./env/bin/activate
COPY ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

CMD [ "python3", "ai/main.py" ]