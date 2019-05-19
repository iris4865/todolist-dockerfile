# todolist-dockerfile

Docker가 있어야 실행 가능합니다.

새로 이미지 생성 시 아래 규칙을 준수해야 합니다.

1. Github에서 다운받기

    - todolist-vue: https://github.com/iris4865/todolist-vue
    - todolist-flask: https://github.com/iris4865/todolist-flask

2. Dockerfile은 Github에서 다운받은 코드와 같은 위치여야 합니다.
    - 주소: https://github.com/iris4865/todolist-dockerfile/blob/master/Dockerfile
    - 임의의 위치: todolist-vue(폴더), todolist-flask(폴더), Dockerfile

3. Docker 빌드
    - docker build -t <이미지 이름> <Dockerfile 위치>
    - ex) docker build -t iris4865/programmers-todo:latest .

4. Docker 실행
    - docker run -d --name <Container 이름> -e "PORT=<내부 Port번호>" -p <외부 Port번호>:<내부 Port번호> <이미지 이름>
    - ex) docker run -d --name todolist-web -e "PORT=8765" -p 80:8765 iris4865/programmers-todo:latest
