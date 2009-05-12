package Module::META;
use strict;
use vars qw[$VERSION];
$VERSION = '0.01';
use base qw[Class::Accessor::Fast];

__PACKAGE__->mk_accessors(qw[
    meta_spec
    name
    version
    generation
    abstract
    author
    license
    distribution_type
    requires
    recommends
    build_requires
    conflicts
    requires_build_tools
    requires_packages
    dynamic_config
    configure
    requires_os
    excludes_os
    index
    no_index
    keywords
    generated_by
    auto_regenrate
    provides
    resources
]);

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new();
    
    while (my ($k, $v) = each %args) {
        $k = 'keywords' if $k eq 'tags';
        if ( $k eq 'meta-spec' ) {
            $self->meta_spec(Module::META::MetaSpec->new(%{$v}));
        } elsif ( ref($v) eq 'HASH' && grep {$k eq $_} qw[requires recommends build_requires conflicts provides] ) {
            $self->$k([
                map Module::META::Requires->new(%{$_}),
                map {{
                        name    => $_,
                        version => $v->{$_},
                    }}
                    keys %{$v}
            ]);
        } elsif ( ref($v) eq 'HASH' && $k eq 'requires_packages' ) {
            $self->$k([
                map Module::META::Packages->new(%{$_}),
                map {{
                        name        => $_,
                        version     => $v->{$_}->{version},
                        has_library => $v->{$_}->{has_library},
                        has_program => $v->{$_}->{has_program},
                    }}
                    keys %{$v}
            ]);
        } elsif ( grep {$k eq $_} qw[index no_index] ) {
            $self->$k(Module::META::Index->new(%{$v}));
        } else {
            $self->$k($v);
        }
    }
    return $self;
}

package Module::META::MetaSpec;
    use strict;
    use base qw[Class::Accessor::Fast];
    __PACKAGE__->mk_accessors(qw[url version]);
    sub new { shift->SUPER::new({@_}) }

package Module::META::Requires;
    use strict;
    use base qw[Class::Accessor::Fast];
    __PACKAGE__->mk_accessors(qw[name version]);
    sub new { shift->SUPER::new({@_}) }

package Module::META::Packages;
    use strict;
    use base qw[Class::Accessor::Fast];
    __PACKAGE__->mk_accessors(qw[name version has_library has_program]);
    sub new { shift->SUPER::new({@_}) }

package Module::META::Index;
    use strict;
    use base qw[Class::Accessor::Fast];
    __PACKAGE__->mk_accessors(qw[file dir package namespace]);
    sub new { shift->SUPER::new({@_}) }


1;

__END__

=head1 NAME

Module::META - Generic Representation of META.yml 1.0 Spec

=head1 SYNOPSIS

  use Module::META;

  my $meta = Module::META->new(
      name           => 'Module-Name',
      build_requires => {
          'Test::More' => '0.46',
      },
  );
  $meta->abstract("Module with a Name");

=head1 SEE ALSO

Reference document, L<http://module-build.sourceforge.net/META-spec-new.html>.

=cut
