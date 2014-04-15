use ExtUtils::MakeMaker;

@extras = ();

push(@extras,
     ABSTRACT_FROM => 'Encoding.pm',
     AUTHOR        => 'Clark Cooper (coopercc@netheaven.com)')
    if ($ExtUtils::MakeMaker::Version >= 5.4301);
     
WriteMakefile(
              NAME	=> 'XML::Encoding',
              dist      => {COMPRESS => 'gzip', SUFFIX => '.gz'},
              VERSION_FROM => 'Encoding.pm',
	      EXE_FILES => [qw(bin/compile_encoding bin/make_encmap)],
	      @extras
             );

