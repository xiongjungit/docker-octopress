FROM       daocloud.io/library/ubuntu:latest
MAINTAINER xiongjun,dockerxman <fenyunxx@163.com>

# aliyun
ADD sources.list /etc/apt/sources.list

# Install depndencies
RUN apt-get update && apt-get install -y \
    vim \
    unzip \
    wget \
    curl \
    openssl \
    libssl-dev \
    ruby1.9.3 \
    nodejs \
    nginx \
    build-essential

# Set proper locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Build Octopress from github
RUN wget --no-check-certificate -O /tmp/octopress.zip https://github.com/imathis/octopress/archive/master.zip
RUN unzip /tmp/octopress.zip -d /srv/
RUN rm /tmp/octopress.zip

# Install Octopress dependencies
WORKDIR /srv/octopress-master

#gem sources https://ruby.taobao.org
ADD Gemfile /srv/octopress-master/Gemfile

RUN gem install bundler
RUN bundle install


# Link config files to the mapped directory
RUN mkdir config
RUN mv Rakefile config/
RUN rm _config.yml
ADD config/_config.yml /srv/octopress-master/config/_config.yml

RUN ln -s config/Rakefile .
RUN ln -s config/_config.yml

# Install the default theme
RUN rake install

#duoshuo
ADD source/_includes/article.html /srv/octopress-master/source/_includes/article.html
ADD source/_includes/duoshuo_comment.html /srv/octopress-master/source/_includes/post/duoshuo_comment.html
ADD source/_layouts/page.html /srv/octopress-master/source/_layouts/page.html
ADD source/_layouts/post.html /srv/octopress-master/source/_layouts/post.html

# Generate static page and link it to nginx webserver
# RUN rake generate
RUN rm -rf /usr/share/nginx/html && \
    ln -s /srv/octopress-master/public/ /usr/share/nginx/html 

# 将jquery.js的源地址//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js修改为//libs.baidu.com/jquery/1.9.1/jquery.min.js
RUN sed -i "s/\/\/ajax.googleapis.com\/ajax\/libs\/jquery\/1.9.1\/jquery.min.js/\/\/libs.baidu.com\/jquery\/1.9.1\/jquery.min.js/g" /srv/octopress-master/source/_includes/head.html

# Disable nginx daemon mode
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Expose default nginx port
EXPOSE 80

# Run Octopress
CMD rake generate && nginx
