use ExtUtils::MakeMaker;

@extras = ();

push(@extras,
     ABSTRACT_FROM => 'lib/XML/Encoding.pm',
     AUTHOR        => 'Clark Cooper (coopercc@netheaven.com), Steve Hay (shay@cpan.org)')
    if ($ExtUtils::MakeMaker::VERSION >= 5.4301);
     
push(@extras,
     LICENSE       => 'perl')
    if ($ExtUtils::MakeMaker::VERSION >= 6.3001);

WriteMakefile(
              NAME	   => 'XML::Encoding',
              dist         => {COMPRESS => 'gzip', SUFFIX => '.gz'},
	      VERSION_FROM => 'lib/XML/Encoding.pm',
	      PREREQ_PM    => {XML::Parser => 2.18},
	      EXE_FILES    => [qw(bin/compile_encoding bin/make_encmap)],
	      @extras
             );

