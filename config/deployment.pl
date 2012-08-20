use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
my $dbpath;
if ( -d '/home/dotcloud/') {
    $dbpath = "/home/dotcloud/deployment.db";
} else {
    $dbpath = File::Spec->catfile($basedir, 'db', 'deployment.db');
}
+{
    'DBI' => [
        "dbi:mysql:database=Terryman",
        'root',
        '',
        {
            mysql_enable_utf8 => 1,
        }
    ],
    Auth => {
        Facebook => {
            client_id       => '248768195243664',                    # アプリケーションID
            client_secret   => 'fd198fa74ce35a9ead922abfe6e47f0f',   # アプリケーション秘密鍵
            callback_uri    => 'http://apps.facebook.com/terryman/', # FacebookアプリURL
            scope           => 'read_stream,read_friendlists',       # 権限
        }
    },
    'LOGIN_URL' => 'http://askque.com/login',
};
