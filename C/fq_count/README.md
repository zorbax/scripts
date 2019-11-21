# fq_count
Speedy tool for counting reads in fastq / fastq.gz files

A c++ fastq read counter with openMP multithreading

```
Usage: fqcounter  <*fastq>
       fqcounter -b  -t <int> <*fastq.gz>

  -b        Add a basecount column

  -l        Add basecount and mean length columns

  -t <int>  [2] Select number of threads
            (one fastq file/thread)

  -o        Delayed ordered output

  -h        This message
```

To compile use make or:
```
   g++ -o fqcounter -fopenmp  fqcounter.cpp -lz
```
