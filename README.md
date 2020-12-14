log-spirit 是一个不错的k8s环境中应用日志集中收集方案实现的工具，本工具基于aliyuen开源的log-pilot基础上实现，新增多行日志功能。使用log-spirit，您可以从docker主机收集日志并将其发送到您的集中日志系统，如elasticsearch、graylog2、awsog等。log-spirit不仅可以收集docker stdout，还可以收集docker容器内的日志文件,解决实际运行过程中日志痛点。

先决条件：
    docker-compose >= 1.6
    Docker Engine >= 1.10
    

# 下载 log-spirit 项目
git clone  git@github.com:taoshanghu/log-spirit.git
build log-pilot image
cd log-pilot/ && ./build-image.sh
# quick start
cd quickstart/ && ./run

目前多汗只支持filebeat模块收集

用法：
  apiVersion: v1
  kind: Pod
  metadata:
    name: tomcat
  spec:
    tolerations:
    - key: "node-role.kubernetes.io/master"
      effect: "NoSchedule"
    containers:
    - name: tomcat
      image: "tomcat:7.0"
      env:
      # 收集stdout 日志
      - name: logspirit_logs_catalina
        value: "stdout"
      #收集 容器内 日志文件中的日志
      - name: logspirit_logs_access
        value: "/usr/local/tomcat/logs/catalina.*.log"
      #开启多行日志收集功能
      - name: "logspirit_logs_multiline"
        value: "true"
      #指定多行日志匹配，支持正则表达式
      - name: "logspirit_logs_pattern"
        value: "^\d{4}\-\d{2}\-\d{2}T\d{2}\:\d{2}\:\d{2}"
      volumeMounts:
        - name: tomcat-log
          mountPath: /usr/local/tomcat/logs
    volumes:
      - name: tomcat-log
        emptyDir: {}

