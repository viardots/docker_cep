# Copyright {2017} {Viardot Sebastien}
# Pour créer l'image docker build . -t centoscep
# docker run -ti --rm -v "$(cd ../bigsoft;pwd)":/bigsoft \
#                     -v "$(cd ../matieres;pwd)":/matieres \
#                     -v "$(cd ../cep;pwd)":/home/someone/ \
#                     -v "$(cd ./sshKey;pwd)":/home/someone/.gitlabPrivateKey \
#                     -v "$(cd ./vnc;pwd)":/home/someone/.vnc \
#                     -e screen_width=1280 -e screen_height=720
#                     -p 5901:5901 centoscep
# Image de base la même qu'à l'Ensimag
FROM centos:7.7.1908 
#FROM centos
MAINTAINER Sebastien Viardot <Sebastien.Viardot@grenoble-inp.fr>
# Ajoute 1 utilisateur someone avec comme mot de passe mdpSomeone
RUN useradd -ms /bin/bash someone
RUN echo 'someone:mdpSomeone' | chpasswd
# Installe de quoi compiler le programme vulnérable et le serveur ssh
RUN yum update -y 
RUN yum install -y centos-release-scl 
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum install -y git vim devtoolset-8 llvm-toolset-7
RUN scl enable devtoolset-8 bash 
RUN scl enable llvm-toolset-7 bash
RUN yum -y --enablerepo=extras install epel-release
RUN yum install -y fluxbox tigervnc-server xterm
RUN yum install -y screen bc guile librdmacm.x86_64 libibumad libepoxy libgbm libaio gtk3-3.22.30-3.el7.x86_64 SDL2 pulseaudio
RUN yum install -y tmate
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y python35u
COPY rhscl.sh /etc/profile.d/
COPY xilinx.sh /etc/profile.d/
COPY config /home/someone/.ssh/config
RUN chown someone /home/someone/.ssh/config
USER someone
WORKDIR /home/someone
ENV DISPLAY :1
ENV screen_width 2500
ENV screen_height 1400
EXPOSE 5901
CMD vncserver -geometry ${screen_width}x${screen_height} ; source /etc/profile; bash

