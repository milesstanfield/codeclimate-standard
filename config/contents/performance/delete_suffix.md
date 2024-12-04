In Ruby 2.5, `String#delete_suffix` has been added.

This cop identifies places where `gsub(/suffix\z/, '')` and `sub(/suffix\z/, '')`
can be replaced by `delete_suffix('suffix')`.

This cop has `SafeMultiline` configuration option that `true` by default because
`suffix$` is unsafe as it will behave incompatible with `delete_suffix?`
for receiver is multiline string.

The `delete_suffix('suffix')` method is faster than `gsub(/suffix\z/, '')`.

@safety
    This cop is unsafe because `Pathname` has `sub` but not `delete_suffix`.

### Example:

    # bad
    str.gsub(/suffix\z/, '')
    str.gsub!(/suffix\z/, '')

    str.sub(/suffix\z/, '')
    str.sub!(/suffix\z/, '')

    # good
    str.delete_suffix('suffix')
    str.delete_suffix!('suffix')

### Example: SafeMultiline: true (default)

    # good
    str.gsub(/suffix$/, '')
    str.gsub!(/suffix$/, '')
    str.sub(/suffix$/, '')
    str.sub!(/suffix$/, '')

### Example: SafeMultiline: false

    # bad
    str.gsub(/suffix$/, '')
    str.gsub!(/suffix$/, '')
    str.sub(/suffix$/, '')
    str.sub!(/suffix$/, '')
