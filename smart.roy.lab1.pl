######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Roy Smart >			
#  < roytsmart@gmail.com >			
#										
#########################################

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


# This loops through each line of the file
while($line = <INFILE>) {

	#There are 3 "<>" pairs in the file, only keep the end
	if($line =~ /(.*)<.*?>(.*)<.*?>(.*)<.*?>(.*)/){		
		$title = $4;
	}

	#Eliminate text after these characters, per lab step 2
	$title =~ s/[\(\[\{\\\/\_\-\:\"\`\+\=\*]+.*//;
	$title =~ s/feat.*//;

	#Eliminate punctuation, Lab Step 3
	$title =~ s/[\?\xBF\!\xA1\.;&\$\@%#\|]+//g;

	#Filter titles with non-English characters, Lab Step 4
	 if($title =~ /.*[^'\w\s'].*/){
	 	$title = "";
	 }
	





	# This prints each line. You will not want to keep this line.
	print $title . "\n";
	
	# YOUR CODE BELOW...
}


# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";


# User control loop
print "Enter a word [Enter 'q' to quit]: ";
$input = <STDIN>;
chomp($input);
print "\n";	
while ($input ne "q"){
	# Replace these lines with some useful code
	print "Not yet implemented.  Goodbye.\n";
	$input = 'q';
}

# MORE OF YOUR CODE HERE....
