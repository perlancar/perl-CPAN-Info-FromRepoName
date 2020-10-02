package CPAN::Author::FromRepoName;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use CPAN::Info::FromRepoName qw(extract_cpan_info_from_repo_name);

use Exporter qw(import);
our @EXPORT_OK = qw(extract_cpan_author_from_repo_name);

our %SPEC;

$SPEC{extract_cpan_author_from_repo_name} = {
    v => 1.1,
    summary => 'Extract CPAN author from a repo name',
    args => {
        repo_name => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    args_as => 'array',
    result => {
        schema => 'str',
    },
    result_naked => 1,
    examples => [
    ],
};
sub extract_cpan_author_from_repo_name {
    my $repo_name = shift;

    my $ecires = extract_cpan_info_from_repo_name($repo_name);
    return undef unless defined $ecires;
    $ecires->{author};
}

1;
# ABSTRACT:

=head1 SEE ALSO

L<CPAN::Author::FromURL>.

L<CPAN::Info::FromRepoName>, the more generic module which is used by this module.

L<CPAN::Dist::FromRepoName>

L<CPAN::Module::FromRepoName>

L<CPAN::Release::FromRepoName>
