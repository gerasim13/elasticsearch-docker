FROM develar/java
MAINTAINER gerasim13@gmail.com

ENV ES_VERSION 2.1.0
ENV ES_HOME /elasticsearch
ENV ES_BIN $ES_HOME/bin
ENV PATH $PATH:$ES_HOME:$ES_BIN

# Install Elasticsearch.
RUN apk --update add curl
RUN set -x \
    && curl -o /tmp/elasticsearch.tar.gz -sSL "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ES_VERSION.tar.gz" \
    && tar -xz -C /tmp -f /tmp/elasticsearch.tar.gz \
    && rm -rf $(find /tmp/elasticsearch-$ES_VERSION | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))") \
    && mv /tmp/elasticsearch-$ES_VERSION $ES_HOME \
    && rm /tmp/elasticsearch.tar.gz \
    && rm -rfv /var/cache/apk/* /tmp/* /var/tmp/*

ADD elasticsearch.yml $ES_HOME/config/
ADD docker-entrypoint.sh /entrypoint.sh

# Install plugins
RUN plugin install lmenezes/elasticsearch-kopf
RUN plugin install royrusso/elasticsearch-HQ
# RUN plugin install f-kubotar/elasticsearch-flavor
# RUN plugin install codelibs/elasticsearch-taste
# RUN plugin install elasticsearch/elasticsearch-lang-python
# RUN plugin install tlrx/elasticsearch-view-plugin
RUN plugin install http://dl.bintray.com/yann-barraud/elasticsearch-entity-resolution/org/yaba/elasticsearch-entity-resolution-plugin/2.1.0/elasticsearch-entity-resolution-plugin-2.1.0.zip

ENTRYPOINT ["/entrypoint.sh"]
CMD ["elasticsearch"]

EXPOSE 9200 9300
