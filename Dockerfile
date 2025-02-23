FROM bellsoft/liberica-runtime-container:jdk-21-stream-musl as builder
WORKDIR /app
ADD demo /app/demo
RUN cd demo && ./mvnw package

FROM bellsoft/liberica-runtime-container:jdk-21-cds-slim-musl as optimizer

WORKDIR /app
COPY --from=builder /app/spring-petclinic-main/target/*.jar petclinic.jar
RUN java -Djarmode=tools -jar petclinic.jar extract --layers --launcher

FROM bellsoft/liberica-runtime-container:jre-21-stream-musl

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
EXPOSE 8080
COPY --from=optimizer /home/app/dependencies/ ./
COPY --from=optimizer /home/app/spring-boot-loader/ ./
COPY --from=optimizer /home/app/snapshot-dependencies/ ./
COPY --from=optimizer /home/app/application/ ./