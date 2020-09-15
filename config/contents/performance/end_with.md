This cop identifies unnecessary use of a regex where `String#end_with?` would suffice.

This cop has `SafeMultiline` configuration option that `true` by default because
`end$` is unsafe as it will behave incompatible with `end_with?`
for receiver is multiline string.

### Example:
    # bad
    'abc'.match?(/bc\Z/)
    /bc\Z/.match?('abc')
    'abc' =~ /bc\Z/
    /bc\Z/ =~ 'abc'
    'abc'.match(/bc\Z/)
    /bc\Z/.match('abc')

    # good
    'abc'.end_with?('bc')

### Example: SafeMultiline: true (default)

    # good
    'abc'.match?(/bc$/)
    /bc$/.match?('abc')
    'abc' =~ /bc$/
    /bc$/ =~ 'abc'
    'abc'.match(/bc$/)
    /bc$/.match('abc')

### Example: SafeMultiline: false

    # bad
    'abc'.match?(/bc$/)
    /bc$/.match?('abc')
    'abc' =~ /bc$/
    /bc$/ =~ 'abc'
    'abc'.match(/bc$/)
    /bc$/.match('abc')
