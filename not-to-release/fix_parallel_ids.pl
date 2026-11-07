#!/usr/bin/env perl
# Tries to fix parallel_ids in Old Church Slavonic PROIEL. The problem is that
# for some Bible verses, we have multiple translations: one from Codex
# Zographensis, another from Codex Marianus.
# Copyright © 2026 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my $path = '/net/work/people/zeman/unidep/UD_Old_Church_Slavonic-PROIEL';
my %corpus;
my $current_source;
my $current_parallel_id;
my %hash;
foreach my $part (qw(train dev test))
{
    my $partpath = "$path/cu_proiel-ud-$part.conllu";
    open(my $in, $partpath) or die("Cannot read '$partpath': $!");
    my $iline = 0;
    while(<$in>)
    {
        $iline++;
        chomp;
        push(@{$corpus{$part}}, $_);
        if(m/^\#\s*source\s*=\s*(.+)$/)
        {
            $current_source = $1;
        }
        if(m/^\#\s*parallel_id\s*=\s*(.+)$/)
        {
            $current_parallel_id = $1;
            $current_parallel_id =~ s:^bible/([a-z0-9]+-[0-9]+)-.*$:$1:;
            unless(exists($hash{$current_parallel_id}{$current_source}))
            {
                $hash{$current_parallel_id}{$current_source} = {'part' => $part, 'line' => $iline};
            }
        }
        if(m/^\s*$/)
        {
            $current_source = undef;
            $current_parallel_id = undef;
        }
    }
    close($in);
}
# Print Bible chapters that are available from multiple sources.
my @chapters = sort(grep {scalar(keys(%{$hash{$_}})) > 1} (keys(%hash)));
foreach my $chapter (@chapters)
{
    my @sources = sort(keys(%{$hash{$chapter}}));
    foreach my $source (@sources)
    {
        print("$chapter\t$source\t$hash{$chapter}{$source}{part}\t$hash{$chapter}{$source}{line}\n");
    }
}
