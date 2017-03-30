FROM       ubuntu:16.04
MAINTAINER Kyle Umstatter "https://github.com/blackstar257"

RUN apt-get update

RUN apt-get install -y openssh-server curl
RUN mkdir /var/run/sshd

RUN mkdir /root/.ssh
RUN curl https://github.com/blackstar257.keys > /root/.ssh/authorized_keys

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
