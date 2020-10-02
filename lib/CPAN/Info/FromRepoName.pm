package CPAN::Info::FromRepoName;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(extract_cpan_info_from_repo_name);

our %SPEC;

our $re_proto_http = qr!(?:https?://)!i;
our $re_author   = qr/(?:\w+)/;
our $re_dist     = qr/(?:\w+(?:-\w+)*)/;
our $re_mod      = qr/(?:\w+(?:::\w+)*)/;
our $re_version  = qr/(?:v?[0-9]+(?:\.[0-9]+)*(?:_[0-9]+|-TRIAL)?)/;
our $re_end_or_q = qr/(?:[?&#]|\z)/;

sub _normalize_mod {
    my $mod = shift;
    $mod =~ s/'/::/g;
    $mod;
}

$SPEC{extract_cpan_info_from_repo_name} = {
    v => 1.1,
    summary => 'Extract/guess information from a repo name',
    description => <<'_',

Guess information from a repo name and return a hash (or undef if nothing can be
guessed). Possible keys include `dist` (Perl distribution name).

_
    args => {
        repo_name => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    args_as => 'array',
    result => {
        schema => 'hash',
    },
    result_naked => 1,
    examples => [
        {
            name => "perl-<dist>",
            args => {repo_name=>'perl-Foo-Bar'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "p5-<dist>",
            args => {repo_name=>'perl-Foo-Bar'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "cpan-<dist>",
            args => {repo_name=>'cpan-Foo-Bar'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "<dist>-perl",
            args => {repo_name=>'Foo-Bar-perl'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "<dist>-p5",
            args => {repo_name=>'Foo-Bar-p5'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "<dist>-cpan",
            args => {repo_name=>'Foo-Bar-cpan'},
            result => {dist=>"Foo-Bar"},
        },
        {
            name => "<dist>",
            args => {repo_name=>'CPAN-Foo-Bar'},
            result => {dist=>"CPAN-Foo-Bar"},
        },
        {
            name => "unknown",
            args => {repo_name=>'@foo'},
            result => undef,
        },
    ],
};
sub extract_cpan_info_from_repo_name {
    state $re_modname;
    state $re_distname = do {
        require Regexp::Pattern::Perl::Module;
        $re_modname  = $Regexp::Pattern::Perl::Module::RE{perl_modname}{pat};

        require Regexp::Pattern::Perl::Dist;
        $Regexp::Pattern::Perl::Dist::RE{perl_distname}{pat};
    };

    my $repo_name = shift;

    my $res;

    if ($repo_name =~ /\A(?:perl|p5|cpan)-($re_distname)\z/) {
        $res->{dist} = $1;
    } elsif ($repo_name =~ /\A($re_distname)-(?:perl|p5|cpan)\z/) {
        $res->{dist} = $1;
    } elsif ($repo_name =~ /\A($re_distname)\z/) {
        $res->{dist} = $1;
    }
    $res;
}

1;
# ABSTRACT:

=head1 SEE ALSO

L<CPAN::Info::FromURL>

L<CPAN::Author::FromRepoName>

L<CPAN::Dist::FromRepoName>

L<CPAN::Module::FromRepoName>

L<CPAN::Release::FromRepoName>
