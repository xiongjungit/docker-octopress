Octopress 博客 Dockerfile
==============================
![](http://www.loverobots.cn/wp-content/uploads/2015/06/Octopress-site-01.jpg)

![](http://xuhehuan.com/wp-content/uploads/2012/08/CA535E9CF7D76A628C58F8EC287C225E_762_352.jpeg)

创建Octopress博客docker镜像的Dockerfile[Octopress framework](https://github.com/imathis/octopress)

## 从index.docker.io部署

运行实例要保持config和posts持续性, 你必须映射本地目录到Octopress容器:

    docker pull dockerxman/docker-octopress
    git clone https://github.com/xiongjungit/docker-octopress
    cd docker-octopress
    docker run -d -v `pwd`/source:/srv/octopress-master/source -v `pwd`/config:/srv/octopress-master/config -p 80:80 dockerxman/docker-octopress

编辑 `config/` 满足你的需求  
写博客到`source/_posts/`
然后导航到 `http://ip`

## 创建镜像

要创建自己的镜像, 在克隆后的包含`Dockerfile`的docker-octopress目录里面运行 `sudo docker build -t 镜像名字 .` 

## 用Octopress写博客

新建博客的两种方式:

### 自动

运行一个交互的shell:

    docker run -v `pwd`/source:/srv/octopress-master/source -v `pwd`/config:/srv/octopress-master/config -p 80:80 -i -t --entrypoint="/bin/bash" dockerxman/docker-octopress

    rake new_post["Post title"]

然后在`source/_posts/`目录里面编辑它。　

当你新建了一个博客, 它可以通过Octopress容器在后台模式重新运行。

### 手动

在 `source/_posts` 目录里面创建 `YYYY-MM-DD-title.markdown` 文件:
    
    ---
    layout: post #当前使用的模板文件source/_layout。
    title: "Post Title" #title：文章标题。当前显示的是生成文件时帮助生成路径的名称，这里可以任意修改。例如，这里可以改为“文章标题”。
    date: YYYY-MM-DD HH:MM #文章创建/修改日期。
    comments: true #为true则打开评论，false则关闭评论。
    categories: General #文章所属分类。这里分类设定为“[分类1,分类2]”。
    ---
    
    **示例**
    这是一个非常简短的内容的例子

然后重启容器。


## 代码创建和维护

* QQ: 479608797

* 邮件: fenyunxx@163.com

* [github](https://github.com/xiongjungit/docker-octopress)

* [dockerhub](https://hub.docker.com/r/dockerxman/)
