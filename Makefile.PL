use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Match::Smart',
    VERSION_FROM => 'Smart.pm',
    PREREQ_PM    => { Scalar::Util => 1.10,
                      Test::More   => 0.01, },
    $] >= 5.005 ?  (AUTHOR => 'Daniel B. Boorstein <danboo@cpan.org>') : (),
);
