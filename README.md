###### Tomasz Mycielski (304248)



```bash
$ time ./consumer.sh workdir --slow
...
real    0m52.650s
user    0m48.647s
sys     0m3.869s
```

```bash
$ time ./consumer.sh workdir --fast 8
...
real    0m10.003s
user    0m36.200s
sys     0m3.544s
```