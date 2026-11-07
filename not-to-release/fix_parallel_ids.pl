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
        # We assume that each sentence has source; and if it also has parallel_id,
        # the parallel_id occurs later than the source.
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
                $chapters{$current_chapter}{$current_source}{'sentences'}++;
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
                $verses{"$current_chapter-$current_verse"}{$current_source}{'sentences'}++;
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
# Modify parallel_ids so that the same verse from different sources get different
# alt; if there are multiple sentences with the same source, they get the part id.
my %lastpart;
foreach my $part (qw(train dev test))
{
    foreach my $line (@{$corpus{$part}})
    {
        # We assume that each sentence has source; and if it also has parallel_id,
        # the parallel_id occurs later than the source.
        if($line =~ m/^\#\s*source\s*=\s*(.+)$/)
        {
            $current_source = $1;
        }
        if($line =~ m/^\#\s*parallel_id\s*=\s*(.+)$/)
        {
            my $parallel_id = $1;
            if($parallel_id =~ m:^bible/([a-z0-9]+-[0-9]+-[0-9]+).*$:)
            {
                my $verse = $1;
                my $alt = '';
                if(exists($verses{$verse}{$current_source}{alt}))
                {
                    $alt = "alt$verses{$verse}{$current_source}{alt}";
                }
                my $sentpart = '';
                if(exists($verses{$verse}{$current_source}{sentences}) && $verses{$verse}{$current_source}{sentences} > 1)
                {
                    $lastpart{$verse}{$current_source}++;
                    $sentpart = "part$lastpart{$verse}{$current_source}";
                }
                my $new_parallel_id = "bible/$verse";
                if($alt || $sentpart)
                {
                    $new_parallel_id .= "/$alt$sentpart";
                }
                if($new_parallel_id ne $parallel_id)
                {
                    print("CHANGE $parallel_id\t==>\t$new_parallel_id\t($current_source)\n");
                }
            }
        }
        if($line =~ m/^\s*$/)
        {
            $current_source = undef;
        }
    }
}
# Print Bible chapters that are available from multiple sources.
if(0)
{
    my @chapters = sort(grep {scalar(keys(%{$chapters{$_}})) > 1} (keys(%chapters)));
    foreach my $chapter (@chapters)
    {
        my @sources = sort(keys(%{$chapters{$chapter}}));
        foreach my $source (@sources)
        {
            print("$chapter\t$source\t$chapters{$chapter}{$source}{part}\t$chapters{$chapter}{$source}{line}\talt$chapters{$chapter}{$source}{alt}");
            my $sentences = exists($chapters{$chapter}{$source}{sentences}) ? $chapters{$chapter}{$source}{sentences} : 1;
            print("\t$sentences sentences\n");
        }
    }
}
