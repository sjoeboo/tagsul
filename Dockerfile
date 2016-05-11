FROM centos:7

RUN yum -y update && yum install rubygems rubygem-bundler && yum clean all

RUN mkdir /tagsul

ADD Gemfile /tagsul/
ADD tagsul /tagsul/
ADD run.sh /tagsul/

RUN cd /tagsul && bundle install

EXPOSE 4567

ENV CONSUL_HOST consul.local

CMD /tagsul/run.sh
