# WildFly  DockerFile
FROM ubi7/ubi:7.7
#ENV GOPATH=/root/buildah 

RUN yum -y install \ 
     java-1.8.0-openjdk-devel \ 
     git \ 
     sudo \ 
     zip \
     unzip \
     wget  

RUN mkdir -p /opt/wildfly-zip \
             /etc/wildfly \
             /opt/wildfly-app
RUN wget https://download.jboss.org/wildfly/21.0.1.Final/wildfly-21.0.1.Final.zip -P /opt/wildfly-zip/ 
RUN unzip /opt/wildfly-zip/wildfly-21.0.1.Final.zip -d  /opt/wildfly-app/
RUN ln -s /opt
ENV LogLevel "info" 
RUN groupadd -r wildfly 
RUN useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly 
RUN echo 'wildfly ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/wildfly
COPY ./src/wildfly.conf /etc/wildfly/
COPY ./src/launch.sh /opt/wildfly-app/bin/
RUN chmod +x /opt/wildfly-app/bin/launch.sh
USER wildfly 
RUN sudo chmod -R 776 /opt/wildfly*
#RUN sudo chgrp -R wildfly  /opt/wildfly/8
RUN sudo chown -RH wildfly:  /opt/wildfly*
#EXPOSE 80
#USER apache
#ENTRYPOINT ["sudo", "/opt/wildfly-app/bin/standalone.sh"]
#ENTRYPOINT ["/opt/wildfly-app/bin/standalone.sh"]
