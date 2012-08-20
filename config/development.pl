use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
my $dbpath;
if ( -d '/home/dotcloud/') {
    $dbpath = "/home/dotcloud/development.db";
} else {
    $dbpath = File::Spec->catfile($basedir, 'db', 'development.db');
}
+{
    'DBI' => [
        "dbi:SQLite:dbname=$dbpath",
        '',
        '',
        +{
            sqlite_unicode => 1,
        }
    ],
    Auth => {
        Facebook => {
            client_id       => '166312860171592',                    # アプリケーションID
            client_secret   => 'f6114315282544884d683712e3c37689',   # アプリケーション秘密鍵
            callback_uri    => 'http://apps.facebook.com/terryman_te/', # FacebookアプリURL
            scope           => 'read_stream,read_friendlists',       # 権限
        }
    },
    'LOGIN_URL' => 'http://localhost:5000/login',
};
