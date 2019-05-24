#git download
FROM alpine as downloader
RUN apk --update add git
RUN git clone --depth=1 https://github.com/iris4865/todolist-flask.git
RUN rm -rf ./todolist-flask/.git

FROM iris4865/programmers-todo-vue as build-vue

# production
FROM nginx:stable-alpine as production
WORKDIR /app
COPY --from=build-vue /app/dist /usr/share/nginx/html
COPY --from=downloader /todolist-flask .
RUN apk update && apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev
RUN cp ./nginx/default.conf /etc/nginx/conf.d/default.conf
RUN pip install -r ./requirements.txt
RUN pip install gunicorn
CMD gunicorn -b 0.0.0.0:5000 app:app --daemon && \
      sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && \
      nginx -g 'daemon off;'
