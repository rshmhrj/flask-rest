FROM python:alpine3.7
COPY . .
RUN pip install -r requirements.txt
RUN chmod 755 /scripts/entrypoint.sh
EXPOSE 5001
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
