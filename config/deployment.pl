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
        "dbi:mysql:database=Geronimo",
        'root',
        '',
        {
            mysql_enable_utf8 => 1,
        }
    ],
    Auth => {
        Facebook => {
            client_id       => '172163892919796',                    # アプリケーションID
            client_secret   => '2be721dc7cba72e138afa67e77ac7fde',   # アプリケーション秘密鍵
            callback_uri    => 'http://59.106.177.81/',              # FacebookアプリURL
            scope           => 'offline_access,email,read_stream,read_friendlists',   # 権限
            display         => 'touch',                                               # 表示方法自動判別
        }
    },
    'Facebook::Graph' => {
        postback => 'http://59.106.177.81/',
        app_id   => '172163892919796',
        secret   => '2be721dc7cba72e138afa67e77ac7fde',
    },
    'SITE_URL'  => 'http://59.106.177.81',
};
