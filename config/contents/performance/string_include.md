This cop identifies unnecessary use of a regex where
`String#include?` would suffice.

This cop's offenses are not safe to auto-correct if a receiver is nil.

### Example:
    # bad
    'abc'.match?(/ab/)
    /ab/.match?('abc')
    'abc' =~ /ab/
    /ab/ =~ 'abc'
    'abc'.match(/ab/)
    /ab/.match('abc')

    # good
    'abc'.include?('ab')