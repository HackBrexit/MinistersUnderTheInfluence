defmodule DataSanitiser.DateUtilsTests do

  defmodule DocTests do
    use ExUnit.Case
    doctest DataSanitiser.DateUtils
    doctest DataSanitiser.DateUtils.DateTuple
    doctest String.Chars.DataSanitiser.DateUtils.DateTuple
  end

  defmodule NormaliseDayTests do
    use ExUnit.Case

    import DataSanitiser.DateUtils, only: [ normalise_day: 1 ]

    test "An empty string normalises to :nil" do
      assert normalise_day("") == :nil
    end

    test "A non empty string normalises to its integer representation" do
      assert normalise_day("1") == 1
      assert normalise_day("04") == 4
      assert normalise_day("31") == 31
    end
  end


  defmodule NormaliseMonthTests do
    use ExUnit.Case

    import DataSanitiser.DateUtils, only: [ normalise_month: 1 ]

    test "Short month names normalise to their integer representation" do
      assert normalise_month("Jan") == 1
      assert normalise_month("Feb") == 2
      assert normalise_month("Mar") == 3
      assert normalise_month("Apr") == 4
      assert normalise_month("Jun") == 6
      assert normalise_month("Jul") == 7
      assert normalise_month("Aug") == 8
      assert normalise_month("Sep") == 9
      assert normalise_month("Sept") == 9
      assert normalise_month("Oct") == 10
      assert normalise_month("Nov") == 11
      assert normalise_month("Dec") == 12
    end

    test "Full month names normalise to their integer representation" do
      assert normalise_month("January") == 1
      assert normalise_month("February") == 2
      assert normalise_month("March") == 3
      assert normalise_month("April") == 4
      assert normalise_month("May") == 5
      assert normalise_month("June") == 6
      assert normalise_month("July") == 7
      assert normalise_month("August") == 8
      assert normalise_month("September") == 9
      assert normalise_month("October") == 10
      assert normalise_month("November") == 11
      assert normalise_month("December") == 12
    end

    test "Invalid month names normalise to :nil" do
      assert normalise_month("Smarch") == :nil
    end

    test "Integers between 1 and 12 inclusive normalise to its integer version" do
      assert normalise_month("1") == 1
      assert normalise_month("2") == 2
      assert normalise_month("3") == 3
      assert normalise_month("4") == 4
      assert normalise_month("5") == 5
      assert normalise_month("6") == 6
      assert normalise_month("7") == 7
      assert normalise_month("8") == 8
      assert normalise_month("9") == 9
      assert normalise_month("10") == 10
      assert normalise_month("11") == 11
      assert normalise_month("12") == 12
    end

    test "Integers less than 0 or greater than 12 normalise to :nil" do
      assert normalise_month("0") == :nil
      assert normalise_month("13") == :nil
    end
  end


  defmodule NormaliseYearTests do
    use ExUnit.Case

    import DataSanitiser.DateUtils, only: [ normalise_year: 1 ]

    test "Four digit year beginning with 19 normalises to its integer version" do
      assert normalise_year("1900") == 1900
      assert normalise_year("1999") == 1999
    end

    test "Four digit year beginning with 20 from the past normalises to its integer version" do
      assert normalise_year("2000") == 2000
      assert normalise_year("2012") == 2012
    end

    test "Two digit years normalise to integer version within the last 100 years" do
      assert normalise_year("50") == 1950
      assert normalise_year("12") == 2012
    end

    test "Empty string normalises to :nil" do
      assert normalise_year("") == :nil
    end
  end


  defmodule DateStringToTupleTests do
    use ExUnit.Case

    import DataSanitiser.DateUtils, only: [ date_string_to_tuple: 2 ]
    alias DataSanitiser.DateUtils.DateTuple

    test "Date strings with valid day month and year extract individual components" do
      assert date_string_to_tuple("31/Jan/2010", :nil) == %DateTuple{day: 31, month: 1, year: 2010}
      assert date_string_to_tuple("1 December 1904", 1234) == %DateTuple{day: 1, month: 12, year: 1904}
      assert date_string_to_tuple("04-04-04", 4444) == %DateTuple{day: 4, month: 4, year: 2004}
    end

    test "Date strings with only two components extract as month and year" do
      assert date_string_to_tuple("04-04", 4444) == %DateTuple{day: :nil, month: 4, year: 2004}
      assert date_string_to_tuple("Sept/1912", 4321) == %DateTuple{day: :nil, month: 9, year: 1912}
      assert date_string_to_tuple("August 99", :nil) == %DateTuple{day: :nil, month: 8, year: 1999}
    end

    test "Date strings with only a single component extract the month and use default year provided" do
      assert date_string_to_tuple("July", 3456) == %DateTuple{day: nil, month: 7, year: 3456}
      assert date_string_to_tuple("05", 2000) == %DateTuple{day: nil, month: 5, year: 2000}
      assert date_string_to_tuple("3", :nil) == %DateTuple{day: nil, month: 3, year: :nil}
    end

    test "Date strings with no discernable components return all nils" do
      assert date_string_to_tuple("I'm not a date", :nil) == %DateTuple{day: nil, month: :nil, year: :nil}
      assert date_string_to_tuple("The date 12/Jan/12 has stuff around it", :nil) == %DateTuple{day: nil, month: :nil, year: :nil}
      assert date_string_to_tuple("Smarch", 1313) == %DateTuple{day: nil, month: :nil, year: :nil}
    end
  end


  defmodule ExtractYearFromStringTests do
    use ExUnit.Case

    import DataSanitiser.DateUtils, only: [ extract_year_from_string: 1 ]

    test "Single four digit number beginning with 19 or 20 extracted" do
      assert extract_year_from_string("1900") == 1900
      assert extract_year_from_string("Let's all meet up in the year 2000") == 2000
      assert extract_year_from_string("2099 is the end of the range") == 2099
      assert extract_year_from_string("What will 2017 bring?") == 2017
    end

    test "Single two digit number extracted and returned so not in the future" do
      assert extract_year_from_string("17") == 2017
      assert extract_year_from_string("I've got 99 problems, but this test ain't 1") == 1999
      assert extract_year_from_string("With an apostrophe '04") == 2004
      assert extract_year_from_string("1337 is ignored for 00") == 2000
    end

    test "Multiple instances of two or four digits returned as ambiguous" do
      assert extract_year_from_string("'04 to 2005") == :ambiguous
      assert extract_year_from_string("2005 to 2006") == :ambiguous
      assert extract_year_from_string("'06 to '07") == :ambiguous
    end

    test "No four digit range beginning with 19 or 20 and no two digit range returns :nil" do
      assert extract_year_from_string("1 isn't long enough") == :nil
      assert extract_year_from_string("'191 is an awkward size") == :nil
      assert extract_year_from_string("This has no numbers at all") == :nil
      assert extract_year_from_string("") == :nil
    end
  end


  defmodule DateTupleToStringTests do
    use ExUnit.Case

    alias DataSanitiser.DateUtils.DateTuple

    test "Tuple with all components is in format dd-mm-yyyy" do
      assert to_string(%DateTuple{day: 1, month: 1, year: 2001}) == "01-01-2001"
      assert to_string(%DateTuple{day: 1, month: 2, year: 2003}) == "01-02-2003"
      assert "#{%DateTuple{day: 24, month: 12, year: 1900}}" == "24-12-1900"
      assert "#{%DateTuple{day: 28, month: 1, year: 2017}}" == "28-01-2017"
    end

    test "Tuple with day missing is in format mm-yyyy" do
      assert to_string(%DateTuple{month: 11, year: 2099}) == "11-2099"
      assert "#{%DateTuple{month: 3, year: 1999}}" == "03-1999"
    end
  end


  defmodule DateTupleIsValid do
    use ExUnit.Case

    alias DataSanitiser.DateUtils.DateTuple

    test "Tuples without months are invalid" do
      assert DateTuple.is_valid?(%DateTuple{day: 12, month: :nil, year: 2000}) == false
      assert DateTuple.is_valid?(%DateTuple{day: 12, month: :nil, year: :nil}) == false
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: :nil, year: 2000}) == false
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: :nil, year: :nil}) == false
    end

    test "Tuples without years are invalid" do
      assert DateTuple.is_valid?(%DateTuple{day: 12, month: 3, year: :nil}) == false
      assert DateTuple.is_valid?(%DateTuple{day: 12, month: :nil, year: :nil}) == false
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: 5, year: :nil}) == false
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: :nil, year: :nil}) == false
    end

    test "Tuples with or without days are valid" do
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: 3, year: 1900}) == true
      assert DateTuple.is_valid?(%DateTuple{day: 1, month: 3, year: 1900}) == true
      assert DateTuple.is_valid?(%DateTuple{day: 29, month: 2, year: 2004}) == true
    end

    test "Invalid date combos are invalid" do
      assert DateTuple.is_valid?(%DateTuple{day: 1, month: 13, year: 1900}) == false
      assert DateTuple.is_valid?(%DateTuple{day: :nil, month: 13, year: 1900}) == false
      assert DateTuple.is_valid?(%DateTuple{day: 29, month: 2, year: 2003}) == false
      assert DateTuple.is_valid?(%DateTuple{day: 31, month: 9, year: 2007}) == false
    end

    test "Things that aren't date tuples are invalid" do
      assert DateTuple.is_valid?(~D[2004-02-01]) == false
      assert DateTuple.is_valid?("2000-01-01") == false
      assert DateTuple.is_valid?("01-01-2000") == false
      assert DateTuple.is_valid?(1485685661) == false
    end
  end
end
