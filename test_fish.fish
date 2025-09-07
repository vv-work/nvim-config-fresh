#!/usr/bin/env fish

# Simple script to sanity check fish LSP and formatting
function greet
    set -l name (count $argv) > /dev/null; and set name $argv[1]; or set name world
    echo "Hello, $name!"
end

greet $argv

