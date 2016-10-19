#!/usr/bin/php
<?php
// *************************************************************************************************
// * script tp harvest documents from from the https://www.gov.uk/government/publications
// * requires: php-cli, libxml
// * usage: ./govharvester.php '<url_with_seach_criteria>'
// * dumps urls and metadata in CSV file 'govharvester_listfile.csv' in the same directory
// * GNU public license v3
// *************************************************************************************************

// disable irritant useless messages
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING );

// opetions array
$args = getopt("f:");

// if a configuration file option is given
if($args['f'] != '')
	$confilepath = $args['f'];
else
	$confilepath = 'govharvester.conf';

// attempt to parse config file
if(!$confarray = confParseFile($confilepath))
{
	exit;
}


print_r($confarray);
//exit;

// file pointer to write to
$fp = fopen('govharvester_listfile.csv', 'w');


// loop through the urls
foreach($confarray['urls'] as $url)
	depParsePage($url);


// a function to parse the configuration file
function confParseFile($path)
{
	// attempt to read the file
	if(!$filecontent = file_get_contents($path))
	{
		echo "Could not read configuration file '$path'\n";
		return false;
	}

	// attempt to parse json
	if(!$confarray = json_decode($filecontent,true))
	{
		echo "Could not parse configuration file\n";
		return false;
	}


	// there must be urls
	//if(!$confarray['urls'] || count($confarray['urls']) == 0)
	if(!$confarray['urls'])
	{
		echo "No URLs specified configuration file\n";
		return false;
	}

	// there must be a destination directory for files
	if(($destinationdir = $confarray['destinationdir']) == '')
	{
		echo "No destination directory specified in configuration file\n";
		return false;
	}

	// if the the destination directory does exist 
	if(is_dir($destinationdir))
	{
		// if it's not writable for this script
		if(!is_writable($destinationdir))
		{
			echo "Destination directory '$destinationdir' is not writable\n";
			return false;
		}

	}
	//attempt to create it
	else if(!mkdir($destinationdir,0777,true))
	{
		echo "Could not create destination dir '$destinationdir'\n";
		return false;
	}


	// return the $confarray
	return $confarray;

}



// a function to open a department url (and parse the page)
function depParsePage($url)
{

	// open the url
	if(!$domdoc = openPageAsDom($url))
	{
		echo "Could not open or parse document '$url'\n";
		return;
	}
	
	echo "DEPARTMENT URL $url\n";


	// get all the urls from the index page
	$urls = indexPageParse($domdoc);

	// loop through the list
	foreach($urls as $url)
	{
		// open url
		$domdoc = openPageAsDom($url);

		// parse the page and write to file
		docParsePage($domdoc);
	}
}




// function open as dom ($url)
function openPageAsDom($url)
{
	echo "page parsing $url\n";

	// attempt open url
	if(!$content = file_get_contents ($url))
	{
		echo "cannot parse $url\n";	
	
		// return false if wew can't
		return false;
	}		
	
	// create a DOM object
	$domdoc = new DOMDocument();

	// read int DOM
	$domdoc->loadHTML($content);

	// return dom
	return $domdoc;
}


// function index page parser
function indexPageParse($domdoc)
{
	// xpath context
	$xpath = new DOMXpath($domdoc);

	// try and find the page counter span
	$elements = $xpath->query('//li[@class="document-row"]/h3/a');

	// if we have found elements
	if($elements->length > 0)
	{
		// loop through the elements
		foreach($elements as $element)
		{
			// write the url into an array
			$urlarray[] = ('https://www.gov.uk' .$element->getAttribute('href'));
		}
	}
	
	// look for a next page link
	$elements = $xpath->query('//nav[@id="show-more-documents"]/ul/li[@class="next"]/a');

	// if there is one
	if($elements->length > 0 )
	{
		// open it as dom
		$nextdomdoc = openPageAsDom('https://www.gov.uk' . $elements[0]->getAttribute('href'));

		// get it's url list
		$nextpageurlarray = indexPageParse($nextdomdoc);

		// merge it into the url list
		$urlarray = array_merge($urlarray, $nextpageurlarray);
	}

	// return the list
	return $urlarray;

}


// function docpageparser
function docParsePage($domdoc)
{
	// the filepointer for the csv file to write to
	global $fp;

	// xpath context
	$xpath = new DOMXpath($domdoc);

	// the type
	$type = $xpath->query('//div[@class="inner-heading"]/p[@class="type"]')[0]->nodeValue;

	// the title
	$title = $domdoc->getElementsByTagName('title')[0]->nodeValue;

	// the organization
	$organization = $xpath->query('//a[@class="organisation-link"]')[0]->nodeValue;

	// the collection
	$collection = $xpath->query('//a[@class="collection-link"]')[0]->nodeValue;

	// date and time published
	$datatimepublished = $xpath->query('//time[@class="date"]')[0]->getAttribute('datetime');

	// document sections
	$docsections =  $xpath->query('//section[@class="attachment embedded"]');


	// loop through the docsections
	foreach($docsections as $docsection)
	{
		// the array we will use to write to csv
		$csvdata = array($type,$title,$organization,$collection,$datatimepublished);

		// is the title a clickable link ?
		$link = $xpath->query('div[@class="attachment-details"]/h2[@class="title"]/a',$docsection);

		// if there is a node
		if($link[0])
		{
			echo "\tsaving data for " . basename($link[0]->getAttribute('href'))."\n";

			// add to csv data array
			$csvdata[] = 'https://www.gov.uk' . $link[0]->getAttribute('href');

			// write line to output file
			fputcsv($fp,$csvdata);

			// download the file
			downloadfile($link[0]->getAttribute('href'));

			continue;
		}

		// is there an explicit download link otherwise
		$link = $xpath->query('div[@class="attachment-details"]/p[@class="metadata"]/span[@class="download"]/a',$docsection);

		// if there is a node
		if($link[0])
		{
			echo "\tsaving data for " . basename($link[0]->getAttribute('href'))."\n";

			// add to csv data array
			$csvdata[] = 'https://www.gov.uk' . $link[0]->getAttribute('href');

			// write line to output file
			fputcsv($fp,$csvdata);

			// download the file
			downloadfile($link[0]->getAttribute('href'));


			continue;
		}
	}	
}

function downloadfile($path)
{
	global $confarray;

	// construct a sensible filename
	$filenumber = substr(strrchr(dirname($path),'/'),1);

	// download the file
	file_put_contents($confarray['destinationdir']. '/' . $filenumber . '_' . basename($path), fopen("https://www.gov.uk" . $path, 'r'));
}


php?>
