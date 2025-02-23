FROM bellsoft/liberica-runtime-container:jdk-21-cds-slim-musl as optimizer

WORKDIR /app
COPY --from=builder target/*.jar app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --launcher

FROM bellsoft/liberica-runtime-container:jre-21-stream-musl

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
EXPOSE 8080
COPY --from=optimizer /home/app/dependencies/ ./
COPY --from=optimizer /home/app/spring-boot-loader/ ./
COPY --from=optimizer /home/app/snapshot-dependencies/ ./
COPY --from=optimizer /home/app/application/ ./