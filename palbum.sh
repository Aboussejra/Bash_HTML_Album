#!/bin/bash

# Checking parameters

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
prog=$(basename $0)
OUT_DIR=$2
INP_DIR=$1
function usage() {

	printf "$prog: creates HTML photo albums from pictures in ${GREEN}<INPUT-DIRECTORY>,${NC} the resulting album is created in ${GREEN}OUTPUT-DIRECTORY${NC}\n"
	printf "$prog ${GREEN}<INPUT-DIRECTORY> <OUTPUT-DIRECTORY>${NC}... \n"
}

#If we did not recieve two arguments, there is a problem
if [ $# -lt 2 ]
then
	printf "Not enough input arguments, please put ${RED}2 directories ${NC}as arguments \n"
	usage
	exit 1
fi

# We check if the first arguments is a directory, if not, we explain to the user what he needs to do for the program to work as conceived.
[ -d $INP_DIR ] || (printf "problem with ${RED}'$1'${NC} argument \n" && usage && exit 1)

# We create the output directory if it does not already exists:
if [ -d "$OUT_DIR" ]; then
	printf "${YELLOW}'$OUT_DIR'${NC} directory already exists\n"
else
	printf "creating ${YELLOW}'$2'${NC} directory as it did not already existed\n"
	mkdir $OUT_DIR
fi

# We are looping through each file in the input directory
# Using find command to be able to treat easely sub-directories
for file in $(find $INP_DIR -type f -print)
do
	# We extract filename and extension from each files to later create thumbnails
	filename=$(basename $file)
	extension="${filename##*.}"
	filename="${filename%.*}"

	# I chose to treat the Date and Time (Origin) field which seemed like
	# the one that correspondad to the date the photo was taken
	DATE_WHOLE=$(exif $file | grep "Date and Time (Origi" |  cut -d "|" -f2)

	# I extract Year, Month and Day informations from exif metadata in images
	YEAR=$(echo $DATE_WHOLE | cut -d ":" -f1)
	MONTH=$(echo $DATE_WHOLE | cut -d ":" -f2)
	DAY=$(echo $DATE_WHOLE | cut -d ":" -f3 | head -c2)

	# I prepare directory which must receive image files
	FILE_DIRECTORY=""$YEAR"_"$MONTH"_"$DAY""
	COMPLETE_PATH="$OUT_DIR/$YEAR/$FILE_DIRECTORY"

	# I create the necessary directories, copy file in corresponding directory
	# according to date extracted
	mkdir -p $COMPLETE_PATH/.thumbs
	#cp $file $COMPLETE_PATH
	pwd
	cd $COMPLETE_PATH
	echo "i must link $file"
	ln -sf ../../../$file $filename.$extension
	pwd
	cd ../../../
	pwd
	# We could have used exif utility to extract thumbnails from 
	# images containing thumbnails
	#exif -e $file --output=$COMPLETE_PATH/.thumbs/$filename-thumb.$extension
	convert -thumbnail 160 $file $COMPLETE_PATH/.thumbs/$filename-thumb.$extension 2>/dev/null
done

# We need now to create the html files for each year
# COULD HAVE BEEN ADDED: Adding a check of images already here if the user miss-use this script
# By applying it more than one time to the same INPUT_FOLDER, yet we do not have enough time for that

for dir in $(find $OUT_DIR/ -maxdepth 1 -mindepth 1 -type d | sort -r)
	# We want to iterate over Year directories, not base directory nor any other deeper
	# Newer first, so we apply a reverse sort
do 
	CURRENT_YEAR=$dir
	echo "we are treating $CURRENT_YEAR"
	# We want to be able to add photos to an already existing album
	# We check for each Year folder if we have already created the html header
	# If not it means the Year did not already exist and we need to 
	# create the Header of the HTML
	if grep -Fxq "<!DOCTYPE HTML>" $CURRENT_YEAR/index.html 2>/dev/null
	then	
		echo "index.html already exist for $CURRENT_YEAR"
	else	
		#### Create Startpage
		echo '<!DOCTYPE HTML>
		<html>
		<head>
		<meta charset="utf-8">
		<title>'$CURRENT_YEAR'</title>
		<meta name="viewport" content="width=device-width">
		<meta name="robots" content="noindex, nofollow">
		</head>
		<body>
		<h1>Photos of '$CURRENT_YEAR'</h1>'>> $CURRENT_YEAR/index.html
	fi

	for file in $(find -L $CURRENT_YEAR -mindepth 2 -maxdepth 2 -type f | sort -r)
	       # We are too adding a reverse sort, to have in each year the newest first	       
	do
		# We extract filename to iterate only on photos of the album
		filename=$(basename $file)
		extension="${filename##*.}"
		filename="${filename%.*}"
		# With those conditions, I work only images of the album,
		# html files art at depth 1 from current year dir
		# thumbnails are at depth 3
		# for each of them, I go search for the thumbnails
		# and construct the index.html of each year accordingly by adding a paragraph
		# with the thumbnail image inserted with a link to the true image
		RELATIVE_IMAGE_PATH=$(echo $file |  awk -F/ '{print $3"/"$4"/"$5}')
		THUMBNAIL_PATH=$(echo $file |  awk -F/ '{print $3}')/.thumbs/$filename-thumb.$extension
		if grep -Fq $THUMBNAIL_PATH $CURRENT_YEAR/index.html 2>/dev/null
		then 
			echo "Album already contains this photo"
		else
		echo "i look at $file must iterate through $RELATIVE_IMAGE_PATH and insert into html"
		echo " i must insert into html the thumbnail: $THUMBNAIL_PATH" 
		echo '<div class="col">
		<p>
		<a href="'$RELATIVE_IMAGE_PATH'"><img src="'$THUMBNAIL_PATH'" alt="image"></a>
		</p>
		</div>'>> $CURRENT_YEAR/index.html
		fi
	done 
done
# the last thing to do now is creating the index.html file in OUTPUT-DIRECTORY
if grep -Fxq "<!DOCTYPE HTML>" $OUT_DIR/index.html 2>/dev/null
then
	echo "index.html already exist for $OUT_DIR"
else
	#### Create Startpage
	echo '<!DOCTYPE HTML>
	<html>
	<head>
	<meta charset="utf-8">
	<title>'$OUT_DIR' photo album </title>
	<meta name="viewport" content="width=device-width">
	<meta name="robots" content="noindex, nofollow">
	</head>
	<body>
	<h1>Photo Album</h1>'>> $OUT_DIR/index.html
fi

		# We want to add to this html a ref to each album year, as well as the number of photos taken each year
		for dir in $(find $OUT_DIR/ -maxdepth 1 -mindepth 1 -type d | sort -r)
			# We want to iterate over Year directories, not base directory nor any other deeper
		do 

			CURRENT_YEAR=$dir
			RELATIVE_FOLDER_YEAR=$(echo $CURRENT_YEAR |  awk -F/ '{print $2}')
echo " i must insert link to $RELATIVE_FOLDER_YEAR"
			NB_PHOTOS=$(find -L $CURRENT_YEAR -mindepth 2 -maxdepth 2 -type f | wc -l) 
				echo '
                <p>
		<h2>Album from '$CURRENT_YEAR' containing '$NB_PHOTOS' photos </h2>
                <a href="'$RELATIVE_FOLDER_YEAR'/index.html"> link to the album </a>
                </p>' >> $OUT_DIR/index.html

			done
