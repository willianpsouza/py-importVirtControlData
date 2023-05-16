FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN apk update \
&& apk upgrade \
&& python -m pip install --upgrade pip \ 
&& pip install --upgrade wheel \ 
&& pip install --upgrade setuptools \ 
&& pip install --no-cache-dir -r requirements.txt
#&& apk del .build-deps gcc libc-dev make

COPY *.py ./

CMD ["sh"]
