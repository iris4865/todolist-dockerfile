#git download
FROM alpine/git as downloader
#RUN apk --update add git
RUN git clone https://github.com/iris4865/todolist-flask.git

FROM iris4865/programmers-todo-vue as build-vue

# production
FROM nginx:stable-alpine as production
WORKDIR /app
RUN apk update && apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev
COPY --from=build-vue /app/dist /usr/share/nginx/html
COPY --from=downloader /todolist-flask/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=downloader /todolist-flask/requirements.txt ./
RUN pip install -r requirements.txt
RUN pip install gunicorn
COPY --from=downloader /todolist-flask .
CMD gunicorn -b 0.0.0.0:5000 app:app --daemon && \
      sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && \
      nginx -g 'daemon off;'
