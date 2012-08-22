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
            client_id       => '274134296026437',                                     # アプリケーションID
            client_secret   => '8d683563625c6e22bde55161866a5f94',                    # アプリケーション秘密鍵
            callback_uri    => 'http://localhost:5000',                               # FacebookアプリURL
            scope           => 'offline_access,email,read_stream,read_friendlists',   # 権限
        }
    },
    'Facebook::Graph' => {
        postback => 'http://localhost:5000',
        app_id   => '274134296026437',
        secret   => '8d683563625c6e22bde55161866a5f94',
    },
    'SITE_URL'  => 'http://localhost:5000',
};
