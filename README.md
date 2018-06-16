In TypeScript 2.8 a regression was introduced where compilation in
watch mode under linux went from ~5 seconds on initial compilation
to about ~32 seconds (or more, depending on the number of files/folders
being watched). I've seen some projects taking nearly 2 minutes to
do initial watch compilation under > 2.8.

I've executed the watch commands under 2.7 and under 2.9 for comparision
and generated v8 profiles for both of them.

The problem from what I understood is somehow related to 2.9 scanning every
single folder and file from the project root down even if it's not included
or excluded. Through debugging I've seen it recursively scan to the depths
of .git or node_modules, which was a behaviour it did not had in 2.7, which
is consistent with what I have observed of the initial compilation time being
slower and slower as the dependencies grow.

## Running watch mode example

Just `npm install && docker-compose up`. You can change the command that
is executed inside docker by modifying `docker-command.sh`

## TypeScript 2.7

See `typescript-272-prof-process.txt`

```
node_modules/.bin/tsc --watch --extendedDiagnostics

08:31:33 - Starting compilation in watch mode...

Files:                   61
Lines:                62744
Nodes:               273576
Identifiers:          98075
Symbols:              80280
Types:                29130
Memory used:        125488K
I/O Read time:        0.19s
Parse time:           0.77s
Program time:         1.97s
Bind time:            0.48s
Check time:           1.62s
transformTime time:   0.02s
printTime time:       0.02s
Emit time:            0.04s
commentTime time:     0.00s
Source Map time:      0.00s
I/O Write time:       0.01s
Total time:           4.12s <<<<<<<<< see

08:31:37 - Compilation complete. Watching for file changes.
```

## TypeScript 2.9

See `typescript-292-prof-process.txt`

```
node_modules/.bin/tsc --watch --extendedDiagnostics

08:27:10 - Starting compilation in watch mode..

[redacted]

08:27:43 - Found 0 errors. Watching for file changes.

Files:                   61
Lines:                63371
Nodes:               279942
Identifiers:          99371
Symbols:              79865
Types:                30108
Memory used:        140212K
I/O Read time:        0.18s
Parse time:           0.70s
Program time:        30.17s
Bind time:            0.45s
Check time:           1.80s
transformTime time:   0.02s
commentTime time:     0.00s
Source Map time:      0.00s
I/O Write time:       0.01s
printTime time:       0.05s
Emit time:            0.05s
Total time:          32.47s <<<<<<<<< see
```

For comparision, non watch builds are still fast under 2.9

```
node_modules/.bin/tsc --extendedDiagnostics

Files:                   61
Lines:                63371
Nodes:               279942
Identifiers:          99371
Symbols:              79759
Types:                30108
Memory used:        126833K
I/O Read time:        0.15s
Parse time:           0.72s
Program time:         1.84s
Bind time:            0.47s
Check time:           1.82s
transformTime time:   0.02s
commentTime time:     0.00s
Source Map time:      0.00s
I/O Write time:       0.01s
printTime time:       0.04s
Emit time:            0.04s
Total time:           4.17s
```
