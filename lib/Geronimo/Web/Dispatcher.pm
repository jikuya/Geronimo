package Geronimo::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON qw(decode_json);

any '/' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        $c->render(
            'index.tt',
            {
                name      => $c->session->get('name'),
            }
        );
    } else {
        $c->render('login.tt', {login_url => $c->config->{'LOGIN_URL'}});
    }
};

any '/register_friend' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $friendsData = getFacebookFriends($c);

        #   TODO:MODELに切り出す
        my $like_status_mst = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM like_status_mst/,
            {Slice => {}}
        );

        $c->render(
            'register_friend.tt',
            {
                name            => $c->session->get('name'),
                data            => $friendsData,
                like_status_mst => $like_status_mst,
            }
        );
    } else {
        $c->render('login.tt', {login_url => $c->config->{'LOGIN_URL'}});
    }
};

post '/register_friend_complete' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {

        #   TODO:MODELに切り出す
        $c->dbh->do_i(q{INSERT INTO likes }, {
            'from_id'      => $c->session->get('id'),
            'to_id'        => $c->req->param('friendId'),
            'to_name'      => $c->req->param('friendName'),
            'to_explain'   => $c->req->param('friendExplain'),
            'like_status'  => $c->req->param('likeStatus'),
        });

        $c->redirect('/');
    } else {
        $c->render('login.tt', {login_url => $c->config->{'LOGIN_URL'}});
    }
};

any '/registered_friends' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $id = $c->session->get('id');

        #   TODO:MODELに切り出す
        my $likes = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM likes WHERE from_id = $id/,
            {Slice => {}}
        );

        #   TODO:MODELに切り出す
        my $like_status_mst = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM like_status_mst/,
            {Slice => {}}
        );

        $c->render(
            'registered_friends.tt',
            {
                name            => $c->session->get('name'),
                likes           => @$likes ? $likes : undef,
                like_status_mst => $like_status_mst,
            }
        );
    } else {
        $c->render('login.tt', {login_url => $c->config->{'LOGIN_URL'}});
    }
};

any '/tag_search' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $text = $c->req->param('term');

        #   TODO:MODELに切り出す
        my @tags = @{$c->dbh->selectall_arrayref(
            qq/SELECT * FROM tags WHERE text like '%$text%'/,
            {Slice => {}}
        )};
        my @ret_tags;
        foreach my $tag ( @tags ) {
            push (@ret_tags, {id => "$tag->{id}", label => $tag->{text}, value => $tag->{text}});
        }

        $c->render_json(\@ret_tags);
    }
};

any '/login' => sub {
    my ($c) = @_;
    $c->session->remove('token');
    $c->redirect('/auth/facebook/authenticate');
};

any '/logout' => sub {
    my ($c) = @_;
    $c->session->remove('token');
    $c->render('logout.tt', {logout_url => 'http://www.facebook.com'});
};

###########################################################
## ここから下はロジック
##   TODO:後でModelなどに切り出す
###########################################################
sub facebookAuth {
    my ($c) = @_;
    my $token = $c->session->get('token');
    if ( $token ) {
        return 1;
    } else {
        return 0;
    }
};

sub getFacebookMyInfo {
    my ($c) = @_;
    my $token = $c->session->get('token');
    if ( $token ) {
        $c->fb->access_token( $token );
        return $c->fb->fetch('me/home')->{data};
    } else {
        return 0;
    }
};

sub getFacebookFriends {
    my ($c) = @_;
    my $token = $c->session->get('token');
    if ( $token ) {
        $c->fb->access_token( $token );
        return $c->fb->fetch('me/friends')->{data};
    } else {
        return 0;
    }
};

1;
