#!/bin/sh

yum install -y java-1.8.0-openjdk-headless

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

tee /etc/yum.repos.d/elasticsearch.repo <<-EOF
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF

yum install -y elasticsearch

/usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf

echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch
systemctl start elasticsearch

sleep 20

curl -XPOST http://localhost:9200/sample_index

curl -XPUT http://localhost:9200/sample_index/sample_log/1 -d '
{
  "timestamp": "01/May/2015:05:10:22 +0000",
  "value": "hoge",
  "number": "200"
}
'

curl -XGET http://localhost:9200/sample_index/_search -d '
{
  "query": {
    "match_all": {}
  }
}
'
