This cop checks for extra/unnecessary whitespace.

### Example:

    # good if AllowForAlignment is true
    name      = "Standard"
    # Some comment and an empty line

    website  += "/bbatsov/standard" unless cond
    puts        "standard"          if     debug

    # bad for any configuration
    set_app("Standard")
    website  = "https://github.com/bbatsov/rubocop"
