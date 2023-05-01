# Summary

The Old Church Slavonic (OCS) UD treebank is based on canonical Old Church Slavonic data from the PROIEL and TOROT treebanks.

# Introduction

The Old Church Slavonic (OCS) UD treebank is based on a selection of canonical Old Church Slavonic data from the PROIEL and TOROT treebanks, which are both maintained at the University of Oslo. The conversion is based on the 20230428 release of the PROIEL and TOROT treebanks available from [https://github.com/syntacticus/syntacticus-treebank-data](https://github.com/syntacticus/syntacticus-treebank-data). The original annotators are acknowledged in the files available there. The conversion code was written by Dag Haug and Hanne Eckhoff and is available in the Rubygem proiel-cli, released as part of the [PROIEL command-line interface](https://github.com/proiel/proiel-cli).

The treebank contains the text of the Codex Marianus New Testament translation (parts of the Gospels) from the PROIEL treebank, as well as the Codex Suprasliensis (lives of saints and homilies), the Kiev Missal (liturgy), the Psalterium Sinaiticum and extracts from the Codex Zographensis New Testament manuscript. The original annotation guidelines are available at [http://folk.uio.no/daghaug/syntactic_guidelines.pdf](http://folk.uio.no/daghaug/syntactic_guidelines.pdf). 

# Acknowledgements

The data have been automatically converted to the UD scheme by Dag Haug. Thanks to all the original annotators!

# Data splits
Development set: 
Codex Marianus: John 11; Luke 8, 11, 22, 24; Mark 15; Matthew 26
Codex Zographensis: Mark 14; Matthew 7
Psalterium Sinaiticum: Psalms 76–77, 89, 103–106
Codex Suprasliensis: John Chrysostom, Homily on the resurrection of Lazarus after four days 2; Vita of Artemios (24th March); Vita of Basiliskos; Vita of Basil and Kapiton; Vita of Terentios, Afrikanos, and Pompeos (20th March); Vita of Gregory I the Great (11th March)
Kiev Missal:	Mass for every day of the year

Test set: 
Codex Marianus: John 6; Luke 9, 23; Mark 14, 16; Matthew 6
Codex Zographensis: Matthew 6; Mark 15
Psalterium Sinaiticum: Psalms 34–39, 70–73
Codex Suprasliensis: Patriarch Photios, Homily on Palm Sunday; Vita of St. Aninas the Wonderworker; Vita of the 40 Martyrs of Sebasteia
Kiev Missal: On the day of St. Clement

The training set consists of larger, continuous passages from the same texts (all mss. except Codex Zographensis are annotated nearly in full).

# References
Dag T. T. Haug and Marius L. Jøhndal. 2008. 'Creating a Parallel Treebank of the Old Indo-European Bible Translations'. In Caroline Sporleder and Kiril Ribarov (eds.).  *Proceedings of the Second Workshop on Language Technology for Cultural Heritage Data (LaTeCH 2008)* (2008), pp. 27-34.
Hanne Martine Eckhoff and Aleksandrs Berdičevskis. 2015. 'Linguistics vs. digital editions: The Tromsø Old Russian and OCS Treebank'. *Scripta & e-scripta* 14–15, pp. 9-25.

# Changelog

* 2022-05-15 v2.10
  * MISC ref= changed to Ref= to match other UD treebanks.
* 2021-05-15 v2.8
  * Undocumented feature Strength replaced with Variant=Short as in other Slavic treebanks.
  * Undocumented Aspect=Res converted to VerbForm=PartRes|Tense=Past as in the Old East Slavic treebanks.
  * Negative copula не.бꙑти lemmatized as бꙑти, added Polarity=Neg.
* 2018-07-01 v2.2
  * Repository renamed from UD_Old_Church_Slavonic to UD_Old_Church_Slavonic-PROIEL.
* 2017-03-01 v2.0
  * The treebank was converted to UDv2 and the data splits were changed.
* 2015-11-15 v1.2
  * Initial release in Universal Dependencies.

=== Machine-readable metadata (DO NOT REMOVE!) ================================
Data available since: UD v1.2
License: CC BY-NC-SA 4.0
Includes text: yes
Genre: bible
Lemmas: converted from manual
UPOS: converted from manual
XPOS: manual native
Features: converted from manual
Relations: converted from manual
Contributors: Haug, Dag
Contributing: elsewhere
Contact: daghaug@ifikk.uio.no
===============================================================================
