# Natural Language Toolkit in MUTI

For now, all we have is some rough notes on the experiments we did
during the Hack Day on 5th March 2017.

## Details of experiments

This is what we tried:

- Run `python` to get an interactive REPL

- `import nltk`

- Run `nltk.download_shell()` and fetch the following:
    - `words`
    - `averaged_perceptron_tagger`
    - `punkt`
    - `maxent_ne_chunker`

- Run the following:

        from nltk import pos_tag, ne_chunk, word_tokenize

        # Pick a random chunk of text
        x = "Public sector mutuals and co-ops, Government Digital Services - Digital by Default, Implications of the Francis report (Mid Staffs) for all public services"
        tree = ne_chunk(pos_tag(word_tokenize(x)))

        for node in tree:
            if isinstance(node, nltk.tree.Tree):
            print(node)

The results didn't look very useful and we gave up / ran out of time
at that point.
