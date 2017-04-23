FROM jruby:9.1-jre-alpine

ADD . /exporter
WORKDIR /exporter
RUN bundler install --deployment --jobs=4

EXPOSE 8080

ENV RAILS_ENV=production

CMD /usr/local/bundle/bin/torquebox run -b 0.0.0.0
