#!/bin/bash

echo "Script name (Value of \$0): $0"

echo "First argument (Value of \$1): ${1:-<not provided>}"
echo "Second argument (Value of \$2): ${2:-<not provided>}"
echo "Third argument (Value of \$3): ${3:-<not provided>}"

echo "All arguments: $@"
echo "Total number of arguments: $#"
