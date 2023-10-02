# Lazy ways to speed up

## In General:

 no. 0 see if there is any other pcs you can use (Google Colab, kaggle, the hypercluster servers...)

Rule no. 1 Temparature/ sensors data and usage percentiles

have lm-sensors installed, then
```bash
sudo sensors detect
```

This is for cpu /  motherboard sensors. We can launch another terminal (ctrl alt t) to view it real time:

```bash
watch -n 1 sensors
```

If you have a nvidia card with nvidia drivers installed, you can watch the GPU temp

```bash
watch -n 1 nvidia-smi
```
When the usage is <50% the temp should be <80 deg C. If not, check you fan, dust, or thermal compound. (I had one watercooler failure, solved by replacing watercooler and new compound).

Sometimes Hyperthreading is annoying. Use bios to disable it. If you messed up, take out the CMOS battery to reset motherboard, then make a flash drive to flash your bios again.
Sometimes Efficiency cores are also annoying if your task is on them. On linux,
```bash
taskset -c 0,1,2,3,4,5,6 [your task]
```
(-c followed by the corresponding efficiency core)

you can even taskset -c jupyter lab in a conda env and enter dask-distributed, and see that the cluster will only contain your specific tasks.

```bash
time -o run_name/time_name --verbose [your task]
```
This is especially useful when you don't know how large scale you can run, or if the time is highly correlated with RAM needed (which may indicate the need of garbage collection).

**things like getting a better pc, getting better config is not the discussion of this**

## Slow-running code?

Some almost cheating ways of rewriting algorithm will be written in another post.

### In R:

Just:
```r
library(compiler)
enableJIT(2) # or maybe 3?
```
in the front,
see if it changes.

See if you are using a loop to modify a matrix or dataframe (**extremely slow** for some reasons).  In this case, use something like a data.table instead of data.frame, and so on.
data.table also works with parallel(but I don't know if it recognizes same registration like the way below.

Embarassing(ly easy) parallel: just use foreach and doParallel.
Very easy. See https://cran.r-project.org/web/packages/doParallel/vignettes/gettingstartedParallel.pdf
Not only parallel but also much better arrangement when saving the arrays (.combine = 'cbind', etc) this .combine is very useful.

**caret uses the advantage of this registerDoParallel()** so you might get speed up for free.

The Art of R Programming explained why arrays in native R are hard to modify. I forgot where and I am too lazy to pull it out.

If some of the loops are not faster in either combinations, try the old sapply and lapply.

plotting can be slow, try use rgl, plot3D, misc3d, plot3Drgl.

### In py?

If everything is not mutable, use cython? this can be installed in conda.

If not, wrap anything purely numeric in numba. But you do have to check nopython=True really makes it faster **sometimes not**.

Lots of ML packages do have their own ways to parallelize.

On very small data (usually tabular with <800 rows).
Model selection with inter par maybe good. 
You almost always have to use GPU for TabPFN models when rows gets close to 1000.

On small data (usually tabular with < 1500 rows <20 vars).
For Sklearn family (it's relatives, neighbors and neighbor's cats), some model task can be intra par-ed with njobs settings. 
This is used in a lot of gradient boost tree forests. For CPU parallelism.

On GBTF
For some weird kids like XG boost, Catboost, lightgbm, they have very easy commands to use GPU (maybe install cuda beforehands, but even if not, sometimes they work, maybe they shouldn't, but they just did)

speeding up of xgb, cbst, are ~3-8 times the cpu on smaller cases, but better when there is more rows. (I have never got more than 10 times the cpu, maybe my cpu is too good)




You can write stuffs in cuda, or use torch/ tf tensors directly to use gpu to do matrices (can also do no grad).

Cu has CuFFT.

But what to do if not everything in the world is not linear, and that you still want GPU?

### In Julia?

**wrap your stuff in begin ...  end blocks if not already in functions, write proper stuffs, don't always use global**
**do you really need something to be mutable?**
**vectorization will sometimes bite. In contrast to R/ matlab, loops are not that bad sometimes in JL**







