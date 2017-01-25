defmodule CliTest do
  use ExUnit.Case
  doctest DataSanitiser

  import DataSanitiser.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["-h" ]) == :help
    assert parse_args(["-h", "Correct number", "of arguments"]) == :help
    assert parse_args(["--help", "anything"]) == :help
    assert parse_args(["--help" ]) == :help
    assert parse_args(["--help", "Correct number", "of arguments"]) == :help
  end

  test "two values returned if two given" do
    assert parse_args(["metadata_path", "data_path"]) == { "metadata_path", "data_path" }
  end

  test ":help returned if two values not provided" do
    assert parse_args(["Only One Argument"]) == :help
    assert parse_args(["More Than", "Two", "Arguments"]) == :help
  end
end
