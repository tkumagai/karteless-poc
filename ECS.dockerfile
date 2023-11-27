FROM registry.access.redhat.com/ubi8/dotnet-70-runtime
###ADD bin/Release/net7.0/publish/. .

# nginx unzip wget install
USER root
###COPY nginx.repo /etc/yum.repos.d/nginx.repo
ADD nginx.repo /etc/yum.repos.d/nginx.repo
RUN microdnf update -y && rm -rf /var/cache/yum
RUN microdnf -y --enablerepo nginx-mainline install nginx unzip wget libaio; microdnf clean all;

# oracle client install
RUN wget https://download.oracle.com/otn_software/linux/instantclient/1921000/instantclient-basic-linux.x64-19.21.0.0.0dbru.zip
RUN unzip ./instantclient-basic-linux.x64-19.21.0.0.0dbru.zip
RUN rm ./instantclient-basic-linux.x64-19.21.0.0.0dbru.zip
RUN wget https://download.oracle.com/otn_software/linux/instantclient/1921000/instantclient-sqlplus-linux.x64-19.21.0.0.0dbru.zip
RUN unzip ./instantclient-sqlplus-linux.x64-19.21.0.0.0dbru.zip
RUN rm ./instantclient-sqlplus-linux.x64-19.21.0.0.0dbru.zip
RUN mkdir -p /usr/lib/oracle/19.21/client64/lib/
RUN cp -p ./instantclient_19_21/sqlplus /usr/local/bin/.
RUN cp -p ./instantclient_19_21/lib* /usr/lib/oracle/19.21/client64/lib/.
RUN echo "/usr/lib/oracle/19.21/client64/lib" >> /etc/ld.so.conf.d/oracle.conf
RUN ln -s /usr/lib64/libnsl.so.2 /usr/lib64/libnsl.so.1
RUN ldconfig
RUN rm -fr ./instantclient_19_21

# nginx setup
###ADD ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
ADD ./nginx/nginx.conf /etc/nginx/
change configmap
### ADD ./nginx/default.conf /etc/nginx/conf.d/

###EXPOSE 80
EXPOSE 8000

# .net app & nginx startup script copy and exec
COPY startup.sh /startup.sh
###RUN chmod 744 /startup.sh
RUN chmod 777 /startup.sh

RUN mkdir -p /karte-efs/dealer01/
RUN chmod -R 777 /karte-efs/dealer01/ 
RUN mkdir -p /var/log/nginx/
RUN chmod -R 777 /var/log/nginx/
RUN mkdir -p /var/cache/nginx/
RUN chmod -R 777 /var/cache/nginx/
RUN chmod -R 777 /var/run/

RUN mkdir -p /tmp/nginx
RUN chmod -R 777 /tmp/nginx

### test webhook

CMD ["/startup.sh"]
###CMD ["sleep", "300"]
