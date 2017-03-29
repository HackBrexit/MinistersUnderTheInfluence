defmodule DataSanitiser.CanonicaliserTests do

  defmodule DocTests do
    use ExUnit.Case
    doctest DataSanitiser.Canonicaliser
  end


  defmodule CanonicaliseTests do
    use ExUnit.Case

    import DataSanitiser.Canonicaliser, only: [canonicalise: 1]

    test "First lookup of a string returns itself" do
      assert canonicalise("ALWAYS SHOUT") == "ALWAYS SHOUT"
      assert canonicalise("never shout") == "never shout"
      assert canonicalise("sometimes SHOUT") == "sometimes SHOUT"
    end

    test "Differently cased strings return first seen version" do
      assert canonicalise("ALWAYS SHOUT")
      assert canonicalise("AlWaYs ShOuT") == "ALWAYS SHOUT"
      assert canonicalise("always shout") == "ALWAYS SHOUT"
      assert canonicalise("Always shout!") == "Always shout!"
    end
  end
end
