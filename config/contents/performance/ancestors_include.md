This cop is used to identify usages of `ancestors.include?` and
change them to use `<=` instead.

### Example:
    # bad
    A.ancestors.include?(B)

    # good
    A <= B
