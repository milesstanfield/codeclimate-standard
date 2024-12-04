Identifies places where `Hash#merge!` can be replaced by `Hash#[]=`.
You can set the maximum number of key-value pairs to consider
an offense with `MaxKeyValuePairs`.

@safety
    This cop is unsafe because RuboCop cannot determine if the
    receiver of `merge!` is actually a hash or not.

### Example:
    # bad
    hash.merge!(a: 1)
    hash.merge!({'key' => 'value'})

    # good
    hash[:a] = 1
    hash['key'] = 'value'

### Example: MaxKeyValuePairs: 2 (default)
    # bad
    hash.merge!(a: 1, b: 2)

    # good
    hash[:a] = 1
    hash[:b] = 2