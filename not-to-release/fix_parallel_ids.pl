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
my $current_chapter;
my $current_verse;
my %chapters;
my %verses;
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
            $current_chapter = $1;
            $current_chapter =~ s:^bible/([a-z0-9]+-[0-9]+)-([0-9]+).*$:$1:;
            $current_verse = $2;
            # Save the chapter with source.
            unless(exists($chapters{$current_chapter}{$current_source}))
            {
                my $n_sources = 0;
                if(exists($chapters{$current_chapter}))
                {
                    my @sources = keys(%{$chapters{$current_chapter}});
                    $n_sources = scalar(@sources);
                    if($n_sources == 1)
                    {
                        $chapters{$current_chapter}{$sources[0]}{'alt'} = 1;
                    }
                }
                $n_sources++;
                $chapters{$current_chapter}{$current_source} = {'part' => $part, 'line' => $iline};
                if($n_sources > 1)
                {
                    $chapters{$current_chapter}{$current_source}{'alt'} = $n_sources;
                }
            }
            else # this parallel_id + source already exists, thus this is second (or higher) part
            {
                $chapters{$current_chapter}{$current_source}{'parts'}++;
            }
            # Save the verse with source.
            unless(exists($verses{"$current_chapter-$current_verse"}{$current_source}))
            {
                my $n_sources = 0;
                if(exists($verses{"$current_chapter-$current_verse"}))
                {
                    my @sources = keys(%{$verses{"$current_chapter-$current_verse"}});
                    $n_sources = scalar(@sources);
                    if($n_sources == 1)
                    {
                        $verses{"$current_chapter-$current_verse"}{$sources[0]}{'alt'} = 1;
                    }
                }
                $n_sources++;
                $verses{"$current_chapter-$current_verse"}{$current_source} = {'part' => $part, 'line' => $iline};
                if($n_sources > 1)
                {
                    $verses{"$current_chapter-$current_verse"}{$current_source}{'alt'} = $n_sources;
                }
            }
            else # this parallel_id + source already exists, thus this is second (or higher) part
            {
                $verses{"$current_chapter-$current_verse"}{$current_source}{'parts'}++;
            }
        }
        if(m/^\s*$/)
        {
            $current_source = undef;
            $current_chapter = undef;
            $current_verse = undef;
        }
    }
    close($in);
}
# Print Bible chapters that are available from multiple sources.
%chapters = %verses; ###!!! quick hack to get fine-grained report on verses
my @chapters = sort(grep {scalar(keys(%{$chapters{$_}})) > 1} (keys(%chapters)));
foreach my $chapter (@chapters)
{
    my @sources = sort(keys(%{$chapters{$chapter}}));
    foreach my $source (@sources)
    {
        print("$chapter\t$source\t$chapters{$chapter}{$source}{part}\t$chapters{$chapter}{$source}{line}\talt$chapters{$chapter}{$source}{alt}");
        my $parts = exists($chapters{$chapter}{$source}{parts}) ? $chapters{$chapter}{$source}{parts} : 1;
        print("\t$parts parts\n");
    }
}
