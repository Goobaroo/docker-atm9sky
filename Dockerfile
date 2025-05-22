# syntax=docker/dockerfile:1

FROM openjdk:17-buster

LABEL version="1.1.6"
LABEL homepage.group=Minecraft
LABEL homepage.name="atm9sky-1.1.6"
LABEL homepage.icon="https://media.forgecdn.net/avatars/999/347/638518044265918139.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://All-The-Mods-9-To-The-Sky:25565
RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]