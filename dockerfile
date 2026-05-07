FROM ubuntu:latest

RUN apt-get update && apt-get install python3 -y 

RUN useradd app-user

WORKDIR /home/app-user/assessment

COPY app.py .

RUN chown -R app-user:app-user /home/app-user/assessment

USER app-user
 

ENTRYPOINT ["python3", "app.py"]
#CMD ["python, ""app.py"]
