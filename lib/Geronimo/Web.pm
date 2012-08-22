package Geronimo::Web;
use strict;
use warnings;
use utf8;
use parent qw/Geronimo Amon2::Web/;
use File::Spec;

# dispatcher
use Geronimo::Web::Dispatcher;
sub dispatch {
    return (Geronimo::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# setup view class
use Text::Xslate;
{
    my $view_conf = __PACKAGE__->config->{'Text::Xslate'} || +{};
    unless (exists $view_conf->{path}) {
        $view_conf->{path} = [ File::Spec->catdir(__PACKAGE__->base_dir(), 'tmpl') ];
    }
    my $view = Text::Xslate->new(+{
        'syntax'   => 'TTerse',
        'module'   => [ 'Text::Xslate::Bridge::Star' ],
        'function' => {
            c => sub { Amon2->context() },
            uri_with => sub { Amon2->context()->req->uri_with(@_) },
            uri_for  => sub { Amon2->context()->uri_for(@_) },
            static_file => do {
                my %static_file_cache;
                sub {
                    my $fname = shift;
                    my $c = Amon2->context;
                    if (not exists $static_file_cache{$fname}) {
                        my $fullpath = File::Spec->catfile($c->base_dir(), $fname);
                        $static_file_cache{$fname} = (stat $fullpath)[9];
                    }
                    return $c->uri_for($fname, { 't' => $static_file_cache{$fname} || 0 });
                }
            },
        },
        %$view_conf
    });
    sub create_view { $view }
}


# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    #'Web::CSRFDefender',
    'Web::JSON',
);

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        #$res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

__PACKAGE__->add_trigger(
    BEFORE_DISPATCH => sub {
        my ( $c ) = @_;
        # ...
        return;
    },
);

__PACKAGE__->load_plugin(
    'Web::Auth',
    {
        module => 'Facebook',
        on_finished => sub {
            my ($c, $token, $user) = @_;
            my $id   = $user->{id} || die;
            my $name = $user->{name} || die;
            $c->session->set('id'   => $id);
            $c->session->set('name' => $name);
            $c->session->set('site' => 'facebook');
            $c->session->set('token' => $token);
            $c->dbh->do_i(q{REPLACE INTO users }, {
                'id'    => $id,
                'name'  => $name,
                'token' => $token,
            });
            return $c->redirect($c->config->{'Auth'}->{'Facebook'}->{'callback_uri'});
        },
        on_error => sub {
            my ( $c, $error ) = @_;
            warn ("auth_error!![$error]");
            return $c->redirect('/');
        },
    }
);

1;
