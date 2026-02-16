BEGIN {
    comment_block = ""
    in_header = 1
}

# Store comment lines that appear before functions
/^#/ {
    comment_line = $0
    sub(/^# ?/, "", comment_line)
    comment_block = comment_block comment_line "\n"
    
    next
}

# Match function definition
/^[a-zA-Z_][a-zA-Z0-9_]*\(\)/ {
    func_name = $1
    sub(/\(\).*/, "", func_name)
    
    # Use function name as header print preceding comment block 
    if (comment_block != "") {
        print "### " func_name
        print comment_block
        print ""
        comment_block = ""
    }

    next
}

# Handle all other lines (not comments, not function definitions)
{
    if (in_header) {
        print comment_block
        print "### Available functions\n"
    }

    in_header = 0
    comment_block = ""
}

