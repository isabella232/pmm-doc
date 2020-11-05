#!/usr/bin/perl -w
# Write a md glossary file from stdin tsv file containing:
# keyword[,keyword]<tab>Definition
# Master copy: https://docs.google.com/spreadsheets/d/1KUL-dcfBrR3bWsFUcugy5SsJcR5ot-P4Bt27z3ka0x0/edit#gid=0
# Export this sheet as tab-separated values into source/_res/glossary.tsv
# Usage:
# sort source/_res/glossary.tsv | bin/make_glossary_md.pl > source/glossary-terminology.md

use File::Basename;
my $prog = basename($0);

print "# Glossary\n\n";

while (<STDIN>) {
   chomp;
   my @parts = split("\t");
   my $bm = "";

   foreach my $kw (split (",",$parts[0])) {
       $bm = $kw;
       $bm =~ s/([[:upper:]])/lc $1/eg;
       $bm =~ s/([[:space:]])/\-/g;
       print "## $kw\n\n";
   }
   print "$parts[1]\n\n";
 }
