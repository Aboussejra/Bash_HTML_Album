# Shell_Web_Album
Creates HTML photo albums from pictures

Fake Manual Page :

General Commands Manual					palbum(1)

NAME
	palbum - create a photo album from a set of photos taken by a digital
	camera or a smartphone.

SYNOPSIS
	palbum <INPUT-DIRECTORY> <OUTPUT-DIRECTORY>

OVERVIEW
	The  palbum  program is a utility that helps you create simple static
	HTML photo albums from the  pictures taken with a digital camera or a
	smartphone stored in INPUT-DIRECTORY.  The resulting album is created
	in  OUTPUT-DIRECTORY.  An already existing album  may be complemented
	with more photographs.

DESCRIPTION
	INPUT-DIRECTORY must exist and contain image files with embedded Exif
	data (at least the date the photo was taken).

	OUTPUT-DIRECTORY  may not exist as it will be created.  If it already
	exists and contains a  pre-generated photo album,  the latter will be
	complemented with the new photographs from INPUT-DIRECTORY.
	Be aware that older files with the same name will be overwritten with
	newest ones.

	In the OUTPUT-DIRECTORY, the structure of your photo album will be as
	described below.

	An  index.html file is present in OUTPUT-DIRECTORY, referencing each
	year in the album together with the number of photos taken each year.
	A click on the name of the year opens the album for this year.

	A  directory  is created for every year a photograph  has been taken,
	with its name being the number of the year in the YYYY form.

	Inside each year directories is an index.html file displaying the al-
	bum for this year, organised by month, oldest first, alongside direc-
	tories  representing  days  of the year  named  after the  YYYY_MM_DD
	format.

	Each daily directory contains  the photos taken this very day  plus a
	.thumbs  directory in which are stored  thumbnails  for those photos.
	The photos are named according to their original name,  prefixed with
	the name of the directory they are in and a dash (-).
	Each thumbnail  has the  same name  as  the photograph  it represents
	postfixed with the -thumb string.  Thumbnails are smaller versions of
	their pictures with a height of 150 pixels.  However, they retain the
	aspect ratio of the original photo.

	To go into the gory details, the  index.html  file found in the years
	directories  actually displays the thumbnails as a link to the actual
	picture, to prevent huge loading times.

	The overall structure of the album  should resemble the following ex-
	ample where OUTPUT-DIRECTORY is My Photo Album.

	My Photo Album
	├── 2018
	│   ├── 2018_01_13
	│   │   ├── 2018_01_13-175529.jpg
	│   │   ├── 2018_01_13-175605.jpg
	│   │   └── .thumbs
	│   │       ├── 2018_01_13-175529-thumb.jpg
	│   │       └── 2018_01_13-175605-thumb.jpg
	│   ├── 2018_10_29
	│   │   ├── 2018_10_29-114723.jpg
	│   │   ├── 2018_10_29-182517.jpg
	│   │   └── .thumbs
	│   │       ├── 2018_10_29-114723-thumb.jpg
	│   │       └── 2018_10_29-182517-thumb.jpg
	│   ├── 2018_10_30
	│   │   ├── 2018_10_30-082113.jpg
	│   │   ├── 2018_10_30-082148.jpg
	│   │   ├── 2018_10_30-115749.jpg
	│   │   ├── 2018_10_30-124116.jpg
	│   │   └── .thumbs
	│   │       ├── 2018_10_30-082113-thumb.jpg
	│   │       ├── 2018_10_30-082148-thumb.jpg
	│   │       ├── 2018_10_30-115749-thumb.jpg
	│   │       └── 2018_10_30-124116-thumb.jpg
	│   └── index.html
	├── 2019
	│   ├── 2019_02_19
	│   │   ├── 2019_02_19-165822.jpg
	│   │   ├── 2019_02_19-165847.jpg
	│   │   └── .thumbs
	│   │       ├── 2019_02_19-165822-thumb.jpg
	│   │       └── 2019_02_19-165847-thumb.jpg
	│   ├── 2019_03_17
	│   │   ├── 2019_03_17-img_1846.jpg
	│   │   ├── 2019_03_17-img_1870.jpg
	│   │   ├── 2019_03_17-img_1892.jpg
	│   │   ├── 2019_03_17-img_1902.jpg
	│   │   └── .thumbs
	│   │       ├── 2019_03_17-img_1846-thumb.jpg
	│   │       ├── 2019_03_17-img_1870-thumb.jpg
	│   │       ├── 2019_03_17-img_1892-thumb.jpg
	│   │       └── 2019_03_17-img_1902-thumb.jpg
	│   ├── 2019_03_20
	│   │   ├── 2019_03_20-img_1943.jpg
	│   │   ├── 2019_03_20-img_1946.jpg
	│   │   └── .thumbs
	│   │       ├── 2019_03_20-img_1943-thumb.jpg
	│   │       └── 2019_03_20-img_1946-thumb.jpg
	│   ├── 2019_07_17
	│   │   ├── 2019_08_01-img_2434.jpg
	│   │   └── .thumbs
	│   │       └── 2019_08_01-img_2434-thumb.jpg
	│   └── index.html
	└── index.html

AUTHOR
	Written by the clever <put your name here>.

REPORTING BUGS
	palbum has no known bug  at that time.  However, if you find one, you
	may want to report it at <bugs@palbum.org>.

COPYRIGHT
	Copyright © 2020 Free Software Foundation, Inc. License  GPLv3+:  GNU
	GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
	This is free  software:  you  are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.

SEE ALSO
	ImageMagick(1), convert(1), mogrify(1)
	exif(1)
	bash(1)

palbum(1)				General Commands Manual					palbum(1)
