FROM govpf/openjdk:21-jdk-alpine

USER root

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

ARG DEPENDENCY=build/docker/dependency
ARG APPCLASS=physic/ai/demo/DemoApplication
ENV APPCLASS_ENV=$APPCLASS

COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT java -cp app:app/lib/* $APPCLASS_ENV