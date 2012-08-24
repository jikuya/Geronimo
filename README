##########################################################
# Mac 環境構築
##########################################################

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ perlbrewインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ curl -LO http://xrl.us/perlbrew
$ perl perlbrew install
$ rm perlbrew
$ ~/perl5/perlbrew/bin/perlbrew init
$ echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
$ source ~/.bashrc
$ which perlbrew
$ perlbrew install-patchperl

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ perl-5.16.1インストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ perlbrew available
$ perlbrew install perl-5.16.1
$ perlbrew switch perl-5.16.1

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ cpanmインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ perlbrew install-cpanm
$ cpanm App::pmuninstall
$ cpanm App::cpanoutdated

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ cartonインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ cpanm Carton
$ cpanm Module::Install

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ MySQLインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
※http://dev.mysql.com/downloads/mysql/　からMySQLをダウンロード。
　メアドを登録しないといけない。
※ダウンロードして展開し、以下をすべてインストール
  #インストーラー
「mysql-5.5.XX-osx10.6-x86_64.pkg」
「MySQLStartupItem.pkg」
  #環境設定ファイル
「MySQL.prefPane」

// ----------------------------------------------
// Pathを環境変数に設定
// ----------------------------------------------
$ echo 'export PATH="/usr/local/mysql/bin/:$PATH"' >> ~/.bashrc
$ echo 'export DYLD_LIBRARY_PATH="/usr/local/mysql/lib"' >> ~/.bashrc
$ source ~/.bashrc

// ----------------------------------------------
// パスワード設定
// ----------------------------------------------
※ システム環境設定からMySQLを起動
$ mysqladmin -u root password 'root'
$ mysql -u root -p #パスワードを入力してMySQLにログイン
$ mysql> exit

// ----------------------------------------------
// utf8対応
// ----------------------------------------------
$ cp /etc/my.cnf /etc/my.cnf.org
$ sudo cp /usr/local/mysql/support-files/my-medium.cnf /etc/my.cnf
$ sudo vi /etc/my.cnf

[client]
default-character-set = utf8

[mysqld]
default-character-set = utf8

[mysqldump]
default-character-set = utf8

[mysql]
default-character-set = utf8


+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Geronimoインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ mkdir -p ~/perl5/app
$ cd ~/perl5/app
$ git clone https://github.com/jikuya/Geronimo.git
$ cd Geronimo
$ carton install
  ※入らないモジュールがある場合は、そのモジュールを一端、cpanmでインストールする
  ※例）cpanm モジュール名

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Geronimoアプリ起動
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ carton exec -- plackup app.psgi

##########################################################
# さくらVPS 環境構築
##########################################################

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ perlbrewインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ curl -LO http://xrl.us/perlbrew
$ perl perlbrew install
$ rm perlbrew
$ ~/perl5/perlbrew/bin/perlbrew init
$ echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
$ source ~/.bashrc
$ which perlbrew
$ perlbrew install-patchperl

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ perl-5.16.1インストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ perlbrew available
$ perlbrew install perl-5.16.1
$ perlbrew switch perl-5.16.1

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ cpanmインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ perlbrew install-cpanm
$ cpanm App::pmuninstall
$ cpanm App::cpanoutdated

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ cartonインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ cpanm Carton
$ cpanm Module::Install

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ MySQLインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ----------------------------------------------
// cmakeインストール
// ----------------------------------------------
$ cd ~
$ wget http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz
$ tar xvzf cmake-2.8.4.tar.gz
$ rm cmake-2.8.4.tar.gz 
$ cd cmake-2.8.4
$ ./configure
$ gmake
$ sudo gmake install

// ----------------------------------------------
// MySQL専用ユーザ作成
// ----------------------------------------------
$ sudo su -
# useradd -s /sbin/nologin mysql
# exit

// ----------------------------------------------
// MySQLインストール
// ----------------------------------------------
$ sudo yum install -y ncurses-devel
$ wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.27.tar.gz/from/http://ftp.iij.ad.jp/pub/db/mysql/
$ tar xvzf mysql-5.5.27.tar.gz 
$ rm mysql-5.5.27.tar.gz
$ cd mysql-5.5.27
$ cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
$ make
$ sudo make install

// ----------------------------------------------
// DBの初期化
// ----------------------------------------------
$ sudo su -
# cd /usr/local/mysql
# chown -R mysql .
# chgrp -R mysql .
# scripts/mysql_install_db --user=mysql
# chown -R root .
# chown -R mysql data

// ----------------------------------------------
// my.cnf の設定。utf8 の設定を追加。
// ----------------------------------------------
# mv /etc/my.cnf /etc/my.cnf.org
# cp /usr/local/mysql/share/mysql/my-medium.cnf /etc/my.cnf
# vi /etc/my.cnf
[client]
default-character-set=utf8

[mysqld]
skip-character-set-client-handshake
character-set-server=utf8

[mysqldump]
default-character-set=utf8

// ----------------------------------------------
// 自動起動設定ファイルを設置
// ----------------------------------------------
# cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld
# vi /etc/rc.d/init.d/mysqld
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data

mysqld_pid_file_path=$datadir/`/bin/hostname`.pid

// ----------------------------------------------
// 自動起動設定後、MySQL起動
// ----------------------------------------------
# chkconfig --add mysqld
# chkconfig mysqld on
# chkconfig --list | grep mysqld
mysqld 0:off 1:off 2:on 3:on 4:on 5:on 6:off
# service mysqld start

// ----------------------------------------------
// root でログインして root 以外のユーザ削除、root のパスワード設定をしておく
// ----------------------------------------------
$ /usr/local/mysql/bin/mysql -u root
mysql> use mysql;
mysql> delete from user where !(host="localhost" and user="root"); # root 以外のユーザを削除
mysql> update user set password=password('hogehoge');              # パスワード（hogehoge）を設定
mysql> FLUSH PRIVILEGES;
mysql> exit

// ----------------------------------------------
// 設定したパスワードで入れるか確認
// ----------------------------------------------
$ /usr/local/mysql/bin/mysql -u root -p

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Sqlite3インストール（開発時はsqliteをDBにする）
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ sudo yum -y install sqlite

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Geronimoインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ sudo yum -y install openssl-devel

$ mkdir -p ~/perl5/app
$ cd ~/perl5/app
$ git clone https://github.com/jikuya/Geronimo.git
$ cd Geronimo
$ carton install

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Geronimoアプリ起動
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ carton exec -- plackup app.psgi

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Git push設定
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ git add .
$ git commit .
$ git commit --amend --author='jikuya <jikuya@gmail.com>'
$ vi ~/.ssh/config
Host github.com
User git
Port 22
IdentityFile ~/.ssh/id_rsa
$ ssh-keygen
$ cat ~/.ssh/id_rsa.pub 
※中身をGithubに登録する
$ git push origin master

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Nginxインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

// ----------------------------------------------
// Nginxの最新版をダウンロードしてインストール
// ----------------------------------------------
$ cd ~
$ sudo yum -y install pcre-devel openssl-devel
$ wget http://nginx.org/download/nginx-1.3.4.tar.gz
$ rm nginx-1.3.4.tar.gz
$ cd nginx-1.3.4/
$ sudo ./configure && sudo make && sudo make install

// ----------------------------------------------
// 起動ファイルを設置後、起動
// ----------------------------------------------
$ sudo vi /etc/init.d/nginx
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemon
#
# chkconfig:   - 85 15
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /usr/local/nginx/conf/nginx.conf
# pidfile:     /usr/local/nginx/logs/nginx.pid

## Source function library.
. /etc/rc.d/init.d/functions

nginx="/usr/local/nginx/sbin/nginx"
prog=$(basename $nginx)

NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"

start() {
    [ -x $nginx ] || exit 5
    [ -f $NGINX_CONF_FILE ] || exit 6
    echo -n $"Starting $prog: "
    daemon $nginx -c $NGINX_CONF_FILE
    retval=$?
    echo
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -QUIT
    retval=$?
    echo
    return $retval
}

restart() {
    configtest || return $?
    stop
    sleep 1
    start
}

reload() {
    configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $nginx -HUP
    RETVAL=$?
    echo
}
 
force_reload() {
    restart
}
 
configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}
 
rh_status() {
    status $prog
}
 
rh_status_q() {
    rh_status >/dev/null 2>&1
}
 
case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac
$ sudo chmod 755 /etc/init.d/nginx
$ sudo /etc/rc.d/init.d/nginx start
$ sudo /etc/rc.d/init.d/nginx stop
$ sudo /etc/rc.d/init.d/nginx start
$ sudo /etc/rc.d/init.d/nginx restart

// ----------------------------------------------
// 自動起動設定
// ----------------------------------------------
$ sudo chkconfig --add nginx
$ sudo chkconfig nginx on
$ sudo chkconfig --list nginx
$ sudo /etc/rc.d/init.d/nginx restart

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ supervisordインストール
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

// ----------------------------------------------
// setuptools + pip + supervisord のインストール
// ----------------------------------------------
$ cd ~
$ sudo yum install -y python-setuptools
$ sudo easy_install pip
$ sudo pip install http://pypi.python.org/packages/source/s/supervisor/supervisor-3.0a12.tar.gz

// ----------------------------------------------
// ログ保存用ディレクトリ作成
// ----------------------------------------------
$ sudo mkdir /var/log/supervisord/

// ----------------------------------------------
// 個別設定を格納するディレクトリを作成
// ----------------------------------------------
$ sudo mkdir /etc/supervisord.d/

// ----------------------------------------------
// configファイルを設定
// ----------------------------------------------
$ sudo su - root -c "echo_supervisord_conf > /etc/supervisord.conf"
$ sudo cp /etc/supervisord.conf /etc/supervisord.conf.org
$ sudo vi /etc/supervisord.conf
--- /etc/supervisord.conf.orig        2012-07-01 22:11:13.646400571 +0900
+++ /etc/supervisord.conf       2012-07-02 00:14:14.761082685 +0900
@@ -13,15 +13,15 @@
 ;password=123               ; (default is no password (open server))
 
 [supervisord]
-logfile=/tmp/supervisord.log ; (main log file;default $CWD/supervisord.log)
+logfile=/var/log/supervisord/supervisord.log ; (main log file;default $CWD/supervisord.log)
 logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
 logfile_backups=10           ; (num of main logfile rotation backups;default 10)
 loglevel=info                ; (log level;default info; others: debug,warn,trace)
-pidfile=/tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
+pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
 nodaemon=false               ; (start in foreground if true;default false)
 minfds=1024                  ; (min. avail startup file descriptors;default 1024)
 minprocs=200                 ; (min. avail process descriptors;default 200)
-;umask=022                   ; (process file creation umask;default 022)
+umask=002                   ; (process file creation umask;default 022)
 ;user=chrism                 ; (default is current user, required if root)
 ;identifier=supervisor       ; (supervisord identifier, default is 'supervisor')
 ;directory=/tmp              ; (default is not to cd during start)
@@ -127,5 +127,5 @@
 ; interpreted as relative to this file.  Included files *cannot*
 ; include files themselves.
 
-;[include]
-;files = relative/directory/*.ini
+[include]
+files = /etc/supervisord.d/*.ini

// ----------------------------------------------
// 起動ファイルを設定後、起動
// ----------------------------------------------
$ sudo vi /etc/init/supervisord.conf
description     "supervisord"
 
start on runlevel [2345]
stop on runlevel [!2345]
 
respawn
exec /usr/bin/supervisord -n
$ sudo initctl start supervisord
$ tail -f /var/log/supervisord/supervisord.log

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ アプリケーションをsupervisordで起動
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ----------------------------------------------
// cartonで使うパスを確認
// ----------------------------------------------
$ carton exec -I./lib/ -- perl -e "print join(q/:/,@INC)" 
./lib/:local/lib/perl5/x86_64-linux:local/lib/perl5:.:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/lib/5.16.1:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/lib/5.16.1/x86_64-linux
$ carton exec -I./lib/ -- echo $PATH
/home/geronimo/perl5/perlbrew/bin:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/geronimo/bin

// ----------------------------------------------
// アプリケーション管理用設定ファイルを設置
// ----------------------------------------------
$ sudo vi /etc/supervisord.d/geronimo.ini
[program:geronimo]
user=geronimo
umask=002
environment=PERL5LIB="/home/geronimo/perl5/app/Geronimo/lib:/home/geronimo/perl5/app/Geronimo/local/lib/perl5/x86_64-linux:/home/geronimo/perl5/app/Geronimo/local/lib/perl5:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/lib/site_perl/5.16.1/x86_64-linux/:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/lib/site_perl/5.16.1/",PATH="/home/geronimo/perl5/app/Geronimo/local/bin/:/home/geronimo/perl5/perlbrew/bin:/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/bin/"
command=/home/geronimo/perl5/perlbrew/perls/perl-5.16.1/bin/carton exec -- /home/geronimo/perl5/app/Geronimo/local/bin/start_server --port=8080 --path=/tmp/geronimo.sock --interval=10 --pid-file=/tmp/geronimo.pid -- /home/geronimo/perl5/app/Geronimo/local/bin/plackup -s Starman -E development --workers=3 --backlog=1024 --max-requests=10000 --preload-app /home/geronimo/perl5/app/Geronimo/app.psgi
directory=/home/geronimo/perl5/app/Geronimo
redirect_stderr=true
stdout_logfile=/var/log/supervisord/Geronimo.log
stdout_logfile_maxbytes = 5MB
stderr_logfile=/var/log/supervisord/Geronimo.err
stderr_logfile_maxbytes = 5MB
stdout_logfile_backups = 5
autorestart = true
startsecs = 5

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Vhostを設定
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
$ sudo vi /usr/local/nginx/conf/nginx.conf
19d18
<     include       /usr/local/nginx/conf/extra/*.conf;

$ sudo mkdir /usr/local/nginx/conf/extra
$ sudo vi /usr/local/nginx/conf/extra/vhost.conf
proxy_cache_path /var/cache/nginx/static_file_cache levels=1:2 keys_zone=cache_static_file:128m inactive=7d max_size=512m;
proxy_temp_path /var/cache/nginx/temp;

upstream backend {
server 127.0.0.1:8080;
}

server {
    listen 80;
    server_name askque.com;
    access_log /var/log/nginx/geronimo/access.log;
    location / {
        proxy_redirect off;

        set $do_not_cache 0;
        if ($request_method != GET) {
            set $do_not_cache 1;
        }
        if ($uri !~* ".(jpg|png|gif|jpeg|css|js|swf|pdf|html|htm)$") {
            set $do_not_cache 1;
        }
        proxy_no_cache $do_not_cache;
        proxy_cache_bypass $do_not_cache;
        proxy_cache cache_static_file;
        proxy_cache_key $scheme$host$uri$is_args$args;
        proxy_cache_valid 200 2h;
        proxy_cache_valid any 1m;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://59.106.177.81:8080;
    }
}

$ sudo mkdir -p /var/cache/nginx/static_file_cache

$ sudo mkdir -p /var/log/nginx/geronimo/
$ sudo /etc/rc.d/init.d/nginx restart

