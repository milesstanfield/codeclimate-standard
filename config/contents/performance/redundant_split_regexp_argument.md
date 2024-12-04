Identifies places where `split` argument can be replaced from
a deterministic regexp to a string.

### Example:
    # bad
    'a,b,c'.split(/,/)

    # good
    'a,b,c'.split(',')