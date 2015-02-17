######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Roy Smart >			
#  < roytsmart@gmail.com >			
#										
#########################################

# Use -a as argument 2 to just print the word and the associated bigram frequencies. Use for question 1-5.
# Use -b as argument 2 to print basic average song names, WITHOUT stop words removed. Use for questions 6-10.
# Use -c as argument 2 to print average song names WITH stop words removed. Use for questions 10-15.
# Use -d as arg 2 to print average song names with repeats eliminated. Use for questions 16-20.

use strict;
use warnings;

# Replace the string value of the following variable with your names.
my $name = "Roy Smart";
my $partner = "Nevin Leh";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if( ! defined $ARGV[0]) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
} elsif (! defined $ARGV[1]){
	print "You must specify a second argument for lab questions\n";
	exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
my $title_count = 0;	# Count of valid titles found in the input file
my %word_hashtable;		# double hashtable to hold words and their possible bigrams
my $highest_freq;		# highest frequency occurance of current bigram
my $word_count;			# number of words in the average song title
my $line;			#Global variable to track current file line number for debugging purposes

# This loops through each line of the file
while($line = <INFILE>) {

	#There are 3 "<>" pairs in the file, only keep the end. Only use valid lines for song titles
	if($line =~ /(.*)<.*?>(.*)<.*?>(.*)<.*?>(.*)/){		
		my $title = $4;

		#Eliminate text after these characters, per lab step 2
		$title =~ s/[\(\[\{\\\/\_\-\:\"\`\+\=\*]+.*//;
		$title =~ s/\bfeat.*//;

		#Eliminate punctuation, Lab Step 3
		$title =~ s/[\?\xBF\!\xA1\.;&\$\@%#\|]+//g;

		#Don't include any titles with non-English characters, Lab Step 4
		 if($title =~ /.*[^'\w\s'].*/){
	 		$title = "";	# Unneeded statement, should probably figure out how to fix this
		 } else {

		 	# Convert all titles to lower case, Lab Step 5
		 	$title = lc $title;
 	
	 		# print $title . "\n";

			# Add each line to double hash table
		 	&add_line_to_hashtable($title);	 

		 	# Update number of valid titles found
	 		$title_count++;
	 	}
	}
}

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.

print "File parsed. Bigram model built.\n";

#Print out the number of titles we found
print $title_count . " valid song titles found\n\n";

my $input;	# Global variable to test input

# User control loop
print "\n";	
do {
	print "Enter a word [Enter 'q' to quit]: ";

	$input = <STDIN>;
	chomp($input);

	# Option to change mode of the program
	if ($input eq "-a" || $input eq "-b" ||$input eq "-c" ||$input eq "-d"){
		$ARGV[1] = $input;
	} elsif($input ne "" && $input ne "q"){	# Not empty string or exiting

		# Argument parse tree
		if($ARGV[1] eq "-a"){	# frequency counting argument enabled, print all bigram frequencies, questions 1-5
			my $next_bigram =  &mcw($input);	# print the most commmon word to follow input word

			# Check to make sure that the word exists in the hash table
			if($next_bigram ne ""){
				&print_bigrams($input);   # Print out every possible bigram associated with the input word
				my $dec_freq = $highest_freq + 1;	# Adjust for zero based frequency offset
				print "   The most common bigram is : " . $next_bigram . ", " . $dec_freq . "\n";
			} else {
				print "*ERROR* String not present\n";
			}

		} elsif ($ARGV[1] eq "-b" || $ARGV[1] eq "-c"){	# For answering questions 6 - 15
			my $most_common_title = &mct($input);
			print $most_common_title . ", $word_count words\n";
		} elsif($ARGV[1] eq "-d"){		# For answering question 16-20
			my $most_common_title = &mct_no_repeat($input);
			print $most_common_title . ", $word_count words\n";
		} else {
			print "Argument 2 undefined!\n"
		}		
	}
	
} while ($input ne "q");




## Subroutine  declaration

# Puts bigrams into double hash table to analyze bigram frequency.
# Need a list of words as a parameter
#my %word_hashtable;
sub add_line_to_hashtable {
	my $song_title = $_[0];
	my @words = split /\s+/, $song_title;		# Split up song title into separate words to add to hashtable

	for (my $i = 0; $i < (0 + @words - 1); $i++){	# Only loop up to second-to-last word

		#grab the this and next word from the song title
		#a, an, and, by, for, from, in, of, on, or, out, the, to, with
		my $this_word = $words[$i];
		my $next_word = $words[$i + 1];
		my $check_word = $next_word;
		# print "$this_word \n";
        
        # If -c or -d argument is supplied, eliminate stop words for the second word in the bigram
        if(($check_word =~ s/\bfor\b|\bthe\b|\ba\b|\ban\b|\band\b|\bby\b|\bfrom\b|\bin\b|\bof\b|\bon\b|\bor\b|\bout\b|\bto\b|\bwith\b//) && (($ARGV[1] eq "-c") || ($ARGV[1] eq "-d"))){
        	
       	} else {

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

			} else	{	# If not put word into double hashtable and initialize frequency to zero
				$word_hashtable{$this_word} = {$next_word=>0};
			}
		}	
	}
}

# Prints out all of the possible bigrams of the supplied word and their frequecies
sub print_bigrams {
	my $first_word = $_[0];
	my $num_bigrams = 0;

	foreach my $key (keys %{$word_hashtable{$first_word}}){
		my $bigram_freq = $word_hashtable{$first_word}{$key} + 1;
		print $key . "==>" . $bigram_freq . ", ";	# frequency is zero-based so add 1
		$num_bigrams++;
	}

	print "\n\n   Total number of bigrams found is: " . $num_bigrams . "\n";

	return;

}

# Finds the highest frequency words and puts them into a hash table
sub mcw {

	my $first_word = $_[0];
	my %used_words;
	$highest_freq = -1;
	my $most_common_word = "";

	#Loop through each item in the hashtable
	foreach my $key (keys %{$word_hashtable{$first_word}}){

		# Retrieve frequency value stored in the hash table
		my $freq = $word_hashtable{$first_word}{$key};

		# Determine if the current word has the highest frequency
		if ($ARGV[1] eq "-d") {		# For the last step, eliminate repeating words

				# Check if the word has already been used				
				%used_words = %{$_[1]};	# The reference to the hash table of used words will be passed as an argument
				if( defined $used_words{$key}){		# If the word has been used
					next;	# Already used this word, go to the next item
				}

		} 
		if ($freq > $highest_freq){		# Check if this item has the highest frequency
     		$highest_freq = $freq;		# If so it is the new highest frequency
     		$most_common_word = $key;	# Save the most commmon word for output

     	} elsif ($freq == $highest_freq) {	# Pick randomly if two words have the same frequency
     		my $fate = int(rand(2));			# Binary random number
     		if($fate == 0){				# If zero, change most common word
     			$highest_freq = $freq;	# modify frequency
     			$most_common_word = $key;	# save most common word
     		}
     	}
	}

	return $most_common_word;
}

# Find the most common song title up to 20 words
sub mct {
	my $this_word = $_[0];	# The first word is a user supplied argument
	my $title = $this_word;		# allocate space for title and initialize to first word

	# Loop for a 20 word title, if we hit an empty bigram, exit early.
	my $count;	# save looping variable outside of loop so we can access it
	for(my $i = 0; $i < 20; $i++){

		$count = $i;

		# Get next word in the bigram from the double hash table
		my $next_word = &mcw($this_word);

		if($next_word ne ""){	# If the next word exists
			$title = $title . " " . $next_word;
			$this_word = $next_word;
		} else {	# otherwise we're done, break out of the loop
			last;
		}

	}

	$word_count = $count + 1; # update word count

	return $title;
}

# Find the most common song title without repeats
sub mct_no_repeat {
	my $this_word = $_[0];	# The first word is a user supplied argument
	my $title = $this_word;		# allocate space for title and initialize to first word
	my %used_words;			# 1D hash table for storing words already used in the average song title

	# Loop until a full song title is developed
	my $i = 0;
	while($i < 1000){

		# Insert current word into hash table to ensure no repeats
		$used_words{$this_word} = 0;	# Can keep value as zero, since we only check if it is defined.

		# Get next word in the bigram from the double hash table, pass hash table of alredy used words
		my $next_word = &mcw($this_word, \%used_words);	# Pass reference to the hash table of used words

		if($next_word ne ""){	# If the next word exists
			$title = $title . " " . $next_word;
			$this_word = $next_word;

		} else {	# otherwise we're done, break out of the loop
			last;
		}
		$i++;	# Increment word count variable
	}

	$word_count = $i + 1; # update word count

	return $title;	
}
