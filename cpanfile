requires 'perl', '5.014';

requires 'Moo';
requires 'Types::Standard';
requires 'List::Util';
requires 'Carp';
requires 'namespace::clean';

on test => sub {
    requires 'Test::More', '0.96';
};
