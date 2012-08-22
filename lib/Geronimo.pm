package Geronimo;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(qw/DBI/);

# initialize database
use DBI;
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh();
    my $driver_name = $dbh->{Driver}->{Name};
    my $fname = lc("sql/${driver_name}.sql");
    open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
    my $source = do { local $/; <$fh> };
    for my $stmt (split /;/, $source) {
        next unless $stmt =~ /\S/;
        $dbh->do($stmt) or die $dbh->errstr();
    }
}

use Facebook::Graph;
sub fb {
    my $self = shift;
    if ( !defined $self->{fb} ) {
        my $conf = $self->config->{'Facebook::Graph'}
            or die "missing configuration for 'Facebook::Graph'";
        my $fb = Facebook::Graph->new(
            postback    => $conf->{postback},
            app_id      => $conf->{app_id},
            secret      => $conf->{secret},
        );
        $self->{fb} = $fb;
    }
    return $self->{fb};
}

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Data::Recursive::Encode;
use Encode;
sub send_mail {
    my $self        = shift;
    my $to_name     = shift;
    my $to_address  = shift;
    my $url         = $self->config->{'SITE_URL'} . '/likes_of_your_friends';

    my $email = Email::Simple->create(
        header => Data::Recursive::Encode->encode(
            'MIME-Header-ISO_2022_JP' => [
                To      => qq/"$to_name" <$to_address>/,
                From    => '"Geronimo" <geronimo@geronimo.com>',
                Subject => "あなたは両想いかもしれません！",
            ]
        ),
        body       => encode( 'iso-2022-jp', "あなたが気になる人も、あなたのことを気になっているみたいです。\n$url" ),
        attributes => {
            content_type => 'text/plain',
            charset      => 'ISO-2022-JP',
            encoding     => '7bit',
        },
    );
    sendmail($email);
}

1;
