This cop identifies unnecessary use of a regex where `String#start_with?` would suffice.

This cop has `SafeMultiline` configuration option that `true` by default because
`^start` is unsafe as it will behave incompatible with `start_with?`
for receiver is multiline string.

### Example:
    # bad
    'abc'.match?(/\Aab/)
    /\Aab/.match?('abc')
    'abc' =~ /\Aab/
    /\Aab/ =~ 'abc'
    'abc'.match(/\Aab/)
    /\Aab/.match('abc')

    # good
    'abc'.start_with?('ab')

### Example: SafeMultiline: true (default)

    # good
    'abc'.match?(/^ab/)
    /^ab/.match?('abc')
    'abc' =~ /^ab/
    /^ab/ =~ 'abc'
    'abc'.match(/^ab/)
    /^ab/.match('abc')

### Example: SafeMultiline: false

    # bad
    'abc'.match?(/^ab/)
    /^ab/.match?('abc')
    'abc' =~ /^ab/
    /^ab/ =~ 'abc'
    'abc'.match(/^ab/)
    /^ab/.match('abc')
