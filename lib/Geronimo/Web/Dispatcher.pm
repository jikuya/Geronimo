package Geronimo::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON qw(decode_json);
use SQL::Interp qw(sql_interp);

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Data::Recursive::Encode;
use Encode;

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
        $c->render('login.tt', {login_url => qq|$c->config->{'SITE_URL'}/login|});
    }
};

any '/register_friend' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $friendsData = getFacebookFriends($c);

        $c->render(
            'register_friend.tt',
            {
                name            => $c->session->get('name'),
                data            => $friendsData,
            }
        );
    } else {
        $c->render('login.tt', {login_url => qq|$c->config->{'SITE_URL'}/login|});
    }
};

post '/register_friend_complete' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {

        #   TODO:MODELに切り出す
        $c->dbh->do_i(q{INSERT INTO likes }, {
            'from_id'      => $c->session->get('id'),
            'from_name'    => $c->session->get('name'),
            'to_id'        => $c->req->param('friendId'),
            'to_name'      => $c->req->param('friendName')
        });

        sendMailOfReciprocalLove($c) if (checkReciprocalLove($c));

        $c->redirect('/');
    } else {
        $c->render('login.tt', {login_url => qq|$c->config->{'SITE_URL'}/login|});
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

        $c->render(
            'registered_friends.tt',
            {
                name            => $c->session->get('name'),
                likes           => @$likes ? $likes : undef,
            }
        );
    } else {
        $c->render('login.tt', {login_url => qq|$c->config->{'SITE_URL'}/login|});
    }
};

any '/likes_of_your_friends' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $likes = getLikesOfYourFriends($c);
        $c->render(
            'likes_of_your_friends.tt',
            {
                name            => $c->session->get('name'),
                likes           => @$likes ? $likes : undef,
            }
        );
    } else {
        $c->render('login.tt', {login_url => qq|$c->config->{'SITE_URL'}/login|});
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

sub getFacebookUserInfo {
    my ($c, $token) = @_;
    if ( $token ) {
        $c->fb->access_token( $token );
        return $c->fb->fetch('me/');
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

sub getLikesOfYourFriends {
    my ($c) = @_;
    my $friendsData = getFacebookFriends($c);
    my @friendIds;
    while ( (my $k, my $v) = each $friendsData ) {
        push (@friendIds, $v->{id});
    }
    my ($sql, @bind) = sql_interp "SELECT * FROM likes WHERE from_id IN", \@friendIds;
    my $likes = $c->dbh->selectall_arrayref($sql, { Slice => {} }, @bind);
    return $likes;
};

sub checkReciprocalLove {
    my ($c) = @_;
    my $from_id = $c->session->get('id');
    my $to_id   = $c->req->param('friendId');

    #  TODO:MODELに切り出す
    my $sth = $c->dbh->prepare(qq/SELECT COUNT(*) FROM likes WHERE from_id = $to_id AND to_id = $from_id/);
    $sth->execute();
    my @rec = $sth->fetchrow_array;
    return $rec[0];
}

sub sendMailOfReciprocalLove {
    my ($c) = @_;
    my @to_ids = ($c->session->get('id'), $c->req->param('friendId'));
    
    foreach my $to_id (@to_ids) {
        my $token = $c->dbh->selectrow_arrayref(qq/SELECT token FROM users WHERE id = $to_id/);
        if ($token) {
            my $userData = getFacebookUserInfo($c, $token->[0]);
            $c->send_mail($userData->{name}, $userData->{email});
        }
    }
}

1;
