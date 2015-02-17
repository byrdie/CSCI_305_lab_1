######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Roy Smart >			
#  < roytsmart@gmail.com >			
#										
#########################################

use strict;
use warnings;

# Replace the string value of the following variable with your names.
my $name = "<Roy Smart>";
my $partner = "<Nevin Leh>";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
my $title_count = 0;
my %word_hashtable;
my %bigram_hashtable;


# This loops through each line of the file
while(my $line = <INFILE>) {

	#There are 3 "<>" pairs in the file, only keep the end. Only use valid lines for song titles
	if($line =~ /(.*)<.*?>(.*)<.*?>(.*)<.*?>(.*)/){		
		my $title = $4;

		#Eliminate text after these characters, per lab step 2
		$title =~ s/[\(\[\{\\\/\_\-\:\"\`\+\=\*]+.*//;
		$title =~ s/feat.*//;

		#Eliminate punctuation, Lab Step 3
		$title =~ s/[\?\xBF\!\xA1\.;&\$\@%#\|]+//g;

		#Don't include any titles with non-English characters, Lab Step 4
		 if($title =~ /.*[^'\w\s'].*/){
	 		$title = "";	# Unneeded statement, should probably figure out how to fix this
		 } else {

		 	# Convert all titles to lower case, Lab Step 5
		 	$title = lc $title;
 	
	 		print $title . "\n";

			# Add each line to double hash table
		 	&add_line_to_hashtable($title);	 



	 		$title_count++;
	 	}
	}
}

#Print out the number of titles we found
print $title_count . "\n";

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";


# User control loop
print "Enter a word [Enter 'q' to quit]: ";
my $input = <STDIN>;
chomp($input);
print "\n";	
while ($input ne "q"){
	# for $input(keys %{$word_hashtable{}})
	# Replace these lines with some useful code
}



## Subroutine  declaration

# Puts bigrams into double hash table to analyze bigram frequency.
# Need a list of words as a parameter
#my %word_hashtable;
sub add_line_to_hashtable {
	my $song_title = $_[0];
	my @words = split " ", $song_title;		# Split up song title into separate words to add to hashtable
	for (my $i = 0; $i < (0 + @words - 1); $i++){	# Only loop up to second-to-last word


		#grab the this and next word from the song title
		my $this_word = $words[$i];
		my $next_word = $words[$i + 1];

		# print "$this_word \n";


		# Check to see if word is already in the hash table.
		my $hash_value = $word_hashtable{$this_word};
		if(defined $hash_value){				# If so, put next word into second hashtable

			# Check to see if the next word in the bigram is in the second hash table
			my $freq_count = $word_hashtable{$this_word}{$next_word};
			
			if(defined $freq_count){	# If the bigram is already present, increment the frequency counter

				$word_hashtable{$this_word}{$next_word} = $freq_count + 1;
			} else {					# Otherwise add the next word to the second hash table.
				$word_hashtable{$this_word}{$next_word} = 0;	# Initialize frequency counter to zero
			}

		} else	{	# If not put word into first hashtable, and select new second hastable from array
			$word_hashtable{$this_word} ={$next_word=>0};	# set value to the index of the second hash table in the array
		}
	}
}

# Finds the highest frequency words and puts them into a hash table
sub trim_hashtable {
	
}