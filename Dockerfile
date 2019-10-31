from debian:sid

# Build arguments
# ARG WEB_REPOSITORY=https://github.com/btvmeshnet/btvmesh-net.git
# ARG VERSION=sam
# ARG UID=10000
ARG WEB_REPOSITORY=https://github.com/tomeshnet/tomesh.net/
ARG VERSION=master

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y git ruby ruby-dev make gcc g++ zlib1g-dev locales

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "LANG=en_US.UTF-8" > /etc/locale.conf \
	&& locale-gen en_US.UTF-8

RUN mkdir -p /opt/web
RUN git clone $WEB_REPOSITORY /opt/web/website

WORKDIR /opt/web/website
RUN gem install jekyll
RUN gem install bundler
RUN gem install nokogiri
RUN bundle update --bundler

RUN bundle install

EXPOSE 4000

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

CMD ["bundle", "exec", "jekyll", "serve"]
