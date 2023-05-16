FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache --virtual .build-deps gcc g++ libc-dev make cargo \
&& python -m pip install --upgrade pip \ 
&& pip install --upgrade wheel \ 
&& pip install --upgrade setuptools \ 
&& pip install --no-cache-dir -r requirements.txt \
&& apk del .build-deps gcc libc-dev make

COPY *.py ./
COPY *.sh ./

CMD [ "sh", "main.sh" ]
