Identifies uses of `Range#include?` and `Range#member?`, which iterates over each
item in a `Range` to see if a specified item is there. In contrast,
`Range#cover?` simply compares the target item with the beginning and
end points of the `Range`. In a great majority of cases, this is what
is wanted.

@safety
    This cop is unsafe because `Range#include?` (or `Range#member?`) and `Range#cover?`
    are not equivalent behavior.
    Example of a case where `Range#cover?` may not provide the desired result:

    [source,ruby]
    ----
    ('a'..'z').cover?('yellow') # => true
    ----

### Example:
    # bad
    ('a'..'z').include?('b') # => true
    ('a'..'z').member?('b')  # => true

    # good
    ('a'..'z').cover?('b') # => true