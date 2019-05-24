# todolist-dockerfile

## Docker가 있어야 실행 가능합니다.

- Docker Hub URL: https://hub.docker.com/r/iris4865/programmers-todo
- Image 다운로드: docker pull iris4865/programmers-todo

## Build
- docker build -t <이미지 이름> <Dockerfile 위치>
- ex) docker build -t iris4865/programmers-todo:latest .

# Run
- docker run -d --name <Container 이름> -e "PORT=<내부 Port번호>" -p <외부 Port번호>:<내부 Port번호> <이미지 이름>
- ex) docker run -d --name todolist-web -e "PORT=8765" -p 80:8765 iris4865/programmers-todo:latest
