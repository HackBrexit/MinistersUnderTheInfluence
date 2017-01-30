# UK Government Data Sanitiser

An app that reads in transparency data files provided by the UK government and
attempts to sanitise the data into a consistent format.

The app currently only works on a subset of files relating to meeting data that
are in csv format, but we are continuing to improve its sanitation methods to
expand that subset. 

## Prerequesites
This was created using Elixir 1.3.4 with Erlang 19.2 and hasn't been tested on
other versions yet.
You will also need to have fetched some data using the php webscraper found
elsewhere in this repository (look under src/php/gov-harvester)

## Usage
First build the executable by running `mix escript.build` from the directory
containing this README

Then run pointing it at both the metadata file and the directory containing all
the scraped files:
  ```bash
  ./data_sanitiser /path/to/metadata/file.csv /path/to/scraped/files
  ```

If you want to run without compiling you can do so via mix:
  ```bash
  mix run -e 'DataSanitiser.CLI.main(["/path/to/metadata/file.csv", "/path/to/scraped/files"])'
  ```

This will output a file named `processed_data.csv` in your working directory
which can be pushed to the API using the push_data.py python script found
elsewhere in this repo (look under src/python/sample_data).

## Tests
To run the tests just use:
  ```bash
  mix test
  ```

## Style conventions
The code tries to follow the style guide at
https://github.com/christopheradams/elixir_style_guide
