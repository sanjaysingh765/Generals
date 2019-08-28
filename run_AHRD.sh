
##################################################
#  Script perform AHRD on given proteome
###################################################

query="$1"

[ ! -d ./$query.blast_result ] && mkdir -p $query.blast_result
[ ! -d ./database ] && mkdir -p database

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# make sure blast database exist
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


if [[ -f ./database/uniprot-viridiplantae.dmnd && -f ./database/arabidopsis.dmnd && -f ./database/uniprot-taxonomy_viridiplantae_trembl.dmnd ]]

then

echo BLAST result found

else

echo BLAST result not found
exit;

fi

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Perform blast if it is not present
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if [[ -f $query.blast_result/$query.uniprot_sprot && -f $query.blast_result/$query.arabidopsis ]]

then

echo BLAST result found

else

echo BLAST is running
./dist/diamond blastp -d database/uniprot_sprot --outfmt 6 -k 1 -o $query.blast_result/$query.uniprot_sprot -q $query
./dist/diamond blastp -d database/arabidopsis --outfmt 6 -k 1 -o $query.blast_result/$query.arabidopsis -q $query
./dist/diamond blastp -d database/uniprot-taxonomy_viridiplantae_trembl --outfmt 6 -k 1 -o $query.blast_result/$query.uniprot_trembl -q $query

fi


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Run AHRD
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



echo creating the configuration file
sed -e "s/query/$query/g"  ./resources/my_ahrd_input.yml > $query.ahrd_input.yml

echo AHRD is running
if [[ -f "$query"_output.csv  ]]

then

       echo AHRD result is present for $query

else

java -Xmx2g -jar ./dist/ahrd.jar $query.ahrd_input.yml 


fi

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# perform Header mapping in query fasta file
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#convert multiline fasta to single line fasta
cat $query | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | awk 'NR>1' >$query.modified
grep "^>" $query | sed 's/>//g' >$query.old_header
cat "$query"_output.csv|   awk 'NR>3'  | awk 'BEGIN{ FS=OFS="\t" } {print $1,$4}' >$query.AHRD.new_header
awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}' $query.AHRD.new_header $query.old_header | sed -e 's/\t/ /' >new_header
paste -d '\t' $query.old_header new_header | awk 'BEGIN{OFS="\t";print "Old_fasta_header","New_fasta_header"}1'  >$query.mapped_header


#change the fasta header
cat new_header | paste - <(sed '/^>/d' $query.modified) | sed -e 's/^/>/' -e 's/\t/\n/' >m.$query



rm $query.modified
rm $query.old_header
rm $query.AHRD.new_header
rm new_header

















