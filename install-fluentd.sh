#!/bin/sh

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

/opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-elasticsearch

sed -i -e 's/TD_AGENT_USER=td-agent/TD_AGENT_USER=root/' /etc/init.d/td-agent
sed -i -e 's/TD_AGENT_GROUP=td-agent/TD_AGENT_GROUP=root/' /etc/init.d/td-agent
systemctl daemon-reload

tee /etc/td-agent/td-agent.conf <<-EOF
<source>
  type tail
  format ltsv
  time_format %d/%b/%Y:%H:%M:%S %z
  path /var/log/nginx/access.log
  pos_file /var/log/td-agent/nginx-access.pos
  tag nginx
</source>

<match nginx>
  type copy

  <store>
    type stdout
  </store>

  <store>
    type elasticsearch
    host 127.0.0.1
    port 9200
    logstash_format true
    logstash_prefix nginx
    flush_interval 3s
  </store>
</match>
EOF

/etc/init.d/td-agent start

