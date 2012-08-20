package Terryman::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON qw(decode_json);
use SQL::Interp qw(sql_interp);

any '/' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {
        my $id = $c->session->get('id');

        #   TODO:MODELに切り出す
        my $respects = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM respecteds WHERE from_id = $id/,
            {Slice => {}}
        );

        $c->render(
            'index.tt',
            {
                name      => $c->session->get('name'),
                respects  => @$respects ? $respects : undef,
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
        $c->render(
            'register_friend.tt',
            {
                name      => $c->session->get('name'),
                data      => $friendsData->{data},
            }
        );
    } else {
        $c->render('login.tt', {login_url => $c->config->{'LOGIN_URL'}});
    }
};

post '/register_friend_complete' => sub {
    my ($c) = @_;
    if (facebookAuth($c)) {

        # パラメータが動的に変わるので以下のように取得している
        my (@tagIds, @newTags, $friendId, $friendName);
        my $params = $c->req->body_parameters;
        while ( (my $key, my $value) = each %$params ) {
            if ($key =~ m/^tag\[([0-9]+)-?(a|d)?\]$/) {
                push (@tagIds, $1);
            } elsif ($key =~ m/friendId/) {
                $friendId = $value;
            } elsif ($key =~ m/friendName/) {
                $friendName = $value;
            } elsif ($key =~ m/tag\[\]/) {
                @newTags =  $params->get_all($key);
            }
        }

        # 新規登録のタグはタグマスタに登録してタグ番号を取得する
        #   TODO:MODELに切り出す
        foreach my $newTag (@newTags) {
            $c->dbh->do_i(q{INSERT INTO tags }, { text => $newTag});
            push (@tagIds, $c->dbh->last_insert_id(undef, undef, undef, undef));
        }

        #   TODO:MODELに切り出す
        $c->dbh->do_i(q{INSERT INTO respecteds }, {
            from_id => $c->session->get('id'),
            to_id   => $friendId,
            to_name => $friendName,
            tags    => join (',',@tagIds)
        });

        $c->redirect('/');
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
##   TODO:後でModelに切り出す
###########################################################
sub facebookAuth {
    my ($c) = @_;
    my $token = $c->session->get('token');
    my $sign = $c->req->param('signed_request');
    if ( $token ) {
        return 1;
    } else {
        return 0;
    }
};

sub getFacebookMyInfo {
    my ($c) = @_;
    my $token = $c->session->get('token');
    my $sign = $c->req->param('signed_request');
    if ( $token ) { # loggedin
        my $ua = LWP::UserAgent->new();
        my $res = $ua->get("https://graph.facebook.com/me/home?access_token=${token}");
        if ($res->is_success){
            return decode_json($res->decoded_content);
        } else {
            return 0;
        }
    } else {
        return 0;
    }
};

sub getFacebookFriends {
    my ($c) = @_;
    my $token = $c->session->get('token');
    my $sign = $c->req->param('signed_request');
    if ( $token ) {
        my $ua = LWP::UserAgent->new();
        my $res = $ua->get("https://graph.facebook.com/me/friends?access_token=${token}");
        if ($res->is_success){
            return decode_json($res->decoded_content);
        } else {
            return 0;
        }
    } else {
        return 0;
    }
};

1;
