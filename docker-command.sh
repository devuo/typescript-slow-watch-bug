#!/bin/sh

# // Watch command, really, really slow *initial* compilation
# // time since 2.8 (2.7 was ok). See benchmarks file for
# // differences

node_modules/.bin/tsc --watch --extendedDiagnostics

# // Non-watch build are still OK

# node_modules/.bin/tsc --extendedDiagnostics

# // Generate watch mode profile

# node --prof node_modules/.bin/tsc --watch --extendedDiagnostics
