FROM centos:6.8

# ENV HOME=/home/jenkins PATH=/usr/local/bin:$PATH
ENV HOME /home/jenkins
ARG VERSION=2.62
# COPY jenkins-slave /usr/local/bin/jenkins-slave
ADD jenkins-slave /usr/local/bin/jenkins-slave
# RUN yum update -y -x kernel \
RUN yum install -y epel-release \
     && yum clean all \
     && yum update -y -x kernel \
     && yum install -y \
        # autoconf \
        # automake \
        bind-utils \
        # binutils \
        # bison \
        coreutils \
        curl \
        # flex \
        # gcc \
        # gcc-c++ \
        # gettext \
        git \
        # libtool \
        # make \
        openssh-server \
        # patch \
        # pkgconfig \
        # redhat-rpm-config \
        # rpm-build \
        # rpm-sign \
        sudo \
        tar \
        unzip \
        # vim \
        wget \
        #  java-1.8.0-openjdk \
        #  java-1.8.0-openjdk-devel \
     && yum --setopt=group_package_types=mandatory,default,optional groupinstall -y "Development Tools" \
     && wget -q -c --no-check-certificate \
        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm" \
        # "http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm" \
     && yum localinstall -y jdk-8u112-linux-x64.rpm \
     # && yum localinstall -y jdk-8u102-linux-x64.rpm \
     && rm -f jdk-8u112-linux-x64.rpm \
        # && rm -f jdk-8u102-linux-x64.rpm \
     && yum clean all \
     && groupadd -g 10000 jenkins \
     && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins \
     && usermod -aG wheel jenkins \
     && echo '%wheel      ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers \
    #  && chmod 755 /usr/local/bin/jenkins-slave
    #  && /usr/bin/ssh-keygen -A
     && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
     && chmod 755 /usr/share/jenkins \
     && chmod 644 /usr/share/jenkins/slave.jar

USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]
CMD tail -f /etc/hosts
# ENTRYPOINT ["jenkins-slave"]
