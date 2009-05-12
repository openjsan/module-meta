use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Module::META',
    license            => 'perl',
    create_makefile_pl => 'passthrough',
    create_readme      => 1,
    requires           => {
                            'Module::Build' => '0.2701',
                            'Class::Accessor::Fast' => '0.19',
    },
);
$build->create_build_script;
