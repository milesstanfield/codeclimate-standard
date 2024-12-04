Identifies unnecessary use of a regex where `String#include?` would suffice.

@safety
    This cop's offenses are not safe to autocorrect if a receiver is nil or a Symbol.

### Example:
    # bad
    str.match?(/ab/)
    /ab/.match?(str)
    str =~ /ab/
    /ab/ =~ str
    str.match(/ab/)
    /ab/.match(str)
    /ab/ === str

    # good
    str.include?('ab')