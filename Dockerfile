FROM centos:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN yum update -y \
    && yum install -y python python-devel git gcc
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
RUN cd /opt && git clone https://github.com/austin-taylor/VulnWhisperer.git
RUN cd /opt/VulnWhisperer/deps/qualysapi && python setup.py install
RUN cd /opt/VulnWhisperer && pip install -r requirements.txt
RUN cd /opt/VulnWhisperer && python setup.py install
RUN useradd -ms /bin/bash vulnwhisperer &&  mkdir /var/log/vulnwhisperer \
    && chown vulnwhisperer: /var/log/vulnwhisperer \
    && ln -sf /dev/stderr /var/log/vulnwhisperer/vulnwhisperer.log \
    && chown -R vulnwhisperer: /opt/VulnWhisperer
USER vulnwhisperer

STOPSIGNAL SIGTERM

CMD  vuln_whisperer -c /opt/VulnWhisperer/frameworks_example.ini
