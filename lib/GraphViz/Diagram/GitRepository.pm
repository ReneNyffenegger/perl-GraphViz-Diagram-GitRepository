#_{ Encoding and name
=encoding utf8
=head1 NAME

C<GraphViz::Diagram::GitRepository> - Create diagrams showing the content of a (small) GitRepository

C<GraphViz::Diagram::ClassDiagram> builds on L<GraphViz::Graph>.

=cut
package GraphViz::Diagram::GitRepository;

use strict;
use warnings;
use utf8;
#_}
#_{ Version
=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
our @ISA = qw(GraphViz::Graph);
#_}
#_{ Synopsis
=head1 SYNOPSIS

    use GraphViz::Diagram::GitRepository;
    my $gr = GraphViz::Diagram::GitRepository->new('/path/to/github/repository', "Diagram.pdf");
    …
    $gr->create();
   
=cut
#_}
#_{ use …
use Carp;
use lib '/home/rene/github/lib/perl-GraphViz-Graph/lib/'; # Temporary...
use lib '/home/rene/github/lib/perl-GraphViz-Diagram-ClassDiagram/lib/'; # Temporary...
use GraphViz::Diagram::ClassDiagram::Class;
use GraphViz::Diagram::ClassDiagram::GlobalVar;
use GraphViz::Graph;
use lib '/home/rene/github/lib/perl-Git-Repository-Internal/lib/'; # Temporary...
use Git::Repository::Internal;
#_}
#_{ Methods
#_{ POD
=head1 METHODS

=cut
#_}
sub new { #_{

=head2 new

    my $git_repo_diagram = GraphViz::Diagram::GitRepository->new('/path/to/github/repository', 'File.pdf');

Start drawing a git repository diagram.

=cut

  my $class            = shift;
  my $github_repo_path = shift;
  my $output_file      = shift;
  my $opts             = shift // {};

  my $dot_git_dir = "$github_repo_path/.git";
  carp "$dot_git_dir does not exist or is not a directory" unless -d $dot_git_dir;

  # TODO: same functionality already used in GraphViz::Diagram::ClassDiagram
  my ($file_base_name, $suffix) = $output_file =~ m!(.*)\.([^.]+)$!;

  my $self           = GraphViz::Graph->new($file_base_name);
  $self -> {suffix } = $suffix;
# $self -> {nodes_ } = [];
# $self -> {links  } = [];


  my $git_repository_internal = Git::Repository::Internal->new($dot_git_dir) or carp "GraphViz::Diagram::GitRepository - new: Could not initialize Git::Repository::Internal with $dot_git_dir";

  bless $self, $class;

  my @objects = $git_repository_internal->objects;
  for my $obj (@objects) {
    my $node_obj = $self->node();
    my $text = $obj->{text};
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/\n/<br\/>/mg;
    $node_obj -> label({html=> "<table><tr><td>$obj->{object_id}</td></tr><tr><td>$obj->{type}</td></tr><tr><td>$text</td></tr></table>" });

  }


  return $self;

} #_}
sub title { #_{

=head2 title

    $git_repo_diagram -> title("Foo classes");

Start drawing a git repository diagram.

=cut

  # TODO: same functionality already used in GraphViz::Diagram::ClassDiagram

  my $self   = shift;
  my $title  = shift;

  my $title_label = $self->label({html => "<font point-size='30'>$title</font>"});
  $title_label->loc('t');

} #_}
sub create { #_{
#_{
=head2 create
    $git_repo_diagram -> create();

Writes the git repository diagram.

=cut

#_}
  my $self    = shift;

# for my $class (@{$self->{nodes_ }}) {
#   $class->render();
# }
# for my $link_description (@{$self->{links}}) {

#   my $edge = $self->edge(
#     $link_description->{from}->connector_for_links(),
#     $link_description->{to  }->connector_for_links
#   );

#   if ($link_description->{inheritance}) {
#     $edge->arrow_end('invempty');
#   }
# }

  $self->SUPER::create($self->{suffix});

} #_}
sub color_comment { #_{

=head2 color_comment
    my $color_comment = GraphViz::Diagram::ClassDiagram::color_comment()

Static method. Returns the color for comments.

Compare with L<GraphViz::Diagram::ClassDiagram::Attribute/ident_color>

=cut

  return '#22c050';

} #_}

#_}
#_{ Source Code

=head1 Source code

The source code is on L<github|https://github.com/ReneNyffenegger/perl-GraphViz-Diagram-GitRepository>.

=cut
#_}

'tq84';
