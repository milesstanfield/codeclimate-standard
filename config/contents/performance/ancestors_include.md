Identifies usages of `ancestors.include?` and change them to use `<=` instead.

@safety
    This cop is unsafe because it can't tell whether the receiver is a class or an object.
    e.g. the false positive was for `Nokogiri::XML::Node#ancestors`.

### Example:
    # bad
    A.ancestors.include?(B)

    # good
    A <= B
