FROM eid-jenkins02.dmz.local:8081/eid-hiera-config:latest AS hiera-config
FROM eid-jenkins02.dmz.local:8081/eid-puppet-modules:latest AS eid-puppet-modules
FROM eid-jenkins02.dmz.local:8081/eid-puppet-modules-oidc:latest AS eid-puppet-modules-oidc
FROM eid-jenkins02.dmz.local:8081/eid-base:latest as config

ENV FACTER_platform=ondemand
ENV FACTER_hostname=placeholder-app-name
ENV FACTER_fqdn=${FACTER_hostname}
RUN mkdir /etc/puppetlabs/code/environments/ondemand
RUN /opt/puppetlabs/puppet/bin/puppet config set environment ondemand --section user
COPY --from=eid-puppet-modules /puppet_modules /puppet/modules
COPY --from=eid-puppet-modules-oidc /puppet_modules_oidc /puppet/modules_oidc
COPY --from=hiera-config /hiera /puppet/hiera
COPY /puppet_modules/ /puppet/modules/
COPY /puppet_hiera/ /puppet/hiera/

RUN /puppet/puppet-apply

FROM openjdk:8-jdk-slim

RUN apt-get update; apt-get install curl -y
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.13-amd64.deb
RUN dpkg -i filebeat-5.6.13-amd64.deb
RUN rm filebeat-5.6.13-amd64.deb

ARG APPLICATION=placeholder-app-name
ARG ARTIFACT_ID=placeholder-artifact-name
ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY --from=config /etc/filebeat/ /etc/filebeat/

COPY --from=config /etc/opt/${APPLICATION}/ /etc/opt/${APPLICATION}/

RUN mkdir /usr/local/webapps/
COPY /placeholder-packaging/${ARTIFACT_ID}.placeholder-packaging /usr/local/webapps/application.placeholder-packaging
COPY --from=config /opt/${APPLICATION}/${ARTIFACT_ID}.conf /usr/local/webapps/application.conf
COPY entrypoint.sh /entrypoint.sh
HEALTHCHECK --interval=10s --start-period=10s --retries=15 \
   CMD { curl -f --max-time 10 http://localhost:8080/health; } || exit 1

ENTRYPOINT ["sh", "/entrypoint.sh"]
