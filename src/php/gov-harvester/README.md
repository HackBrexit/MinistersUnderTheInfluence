

## Notes 

Ran the php script - ./govharvester.php with a data endpoint, this generated a listfile with download urls and metadata. Going to each link will download the files. 
It worked with php version 5.6.25 and did not work with php verison 5.5

Run example:
php ./govharvester.php "https://www.gov.uk/government/publications?keywords=meeting&publication_filter_option=transparency-data&topics%5B%5D=all&departments%5B%5D=ministry-of-defence&official_document_status=all&world_locations%5B%5D=all&from_date=01%2F01%2F2016&to_date="

