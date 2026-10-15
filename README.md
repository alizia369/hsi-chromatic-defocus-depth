# Exploring Chromatic Aberration and Defocus Blur for Relative Depth Estimation from Monocular Hyperspectral Image

**Ali Zia, Jun Zhou, Yongsheng Gao**
*IEEE Transactions on Image Processing, vol. 30, pp. 4357–4370, 2021*

[![Paper](https://img.shields.io/badge/Paper-IEEE%20TIP%202021-blue)](https://ieeexplore.ieee.org/document/9403964/) ![Language](https://img.shields.io/badge/Language-MATLAB-orange) [![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> **Status.** This is the original research code behind the publication,
> prepared for release. Duplicate, backup and autosave files, data and personal
> file paths were removed and third-party code was separated into
> `third_party/`; the algorithms themselves were not modified. It is research
> code rather than a polished toolbox, and it was developed on Windows MATLAB.

## Overview

Depth from a single image is usually inferred from learned priors or from
defocus in one channel. A hyperspectral camera offers a physical cue that RGB
cameras largely lack: because of chromatic aberration, each wavelength is in
focus at a slightly different depth, so the defocus blur of an edge varies
systematically across bands. This paper turns that variation into relative
depth from a single, monocular hyperspectral cube.

The repository contains the MATLAB implementation of both stages of the
method: estimating a sparse relative depth map at edges, and propagating it
into a dense map guided by the spectral (material) similarity of neighbouring
pixels. It extends our DICTA 2015 work
([`hsi-relative-depth-estimation`](https://github.com/alizia369/hsi-relative-depth-estimation)).

## Method

**Stage 1: sparse relative depth** (`src/sparse/`)

1. The cube is dark-frame corrected and normalised, and strong edges are
   detected across bands and grouped into small patches (`getedgecube.m`,
   `getpatches.m`).
2. Five band-wise cues of chromatic aberration and defocus are computed for each
   patch:
   - area under the spectral blur curve (`SDisUnderCurve.m`)
   - gradient ratio (`Gradientfun.m`)
   - entropy (`entropyfun.m`)
   - sum of spectral differences (`SumofDifferenceMap.m`)
   - variance of local histograms (`VarianceOfHistogramMap.m`)
3. Patches are compared jointly by spatial position and cue values, and Isomap
   embeds them in one dimension. The embedding is the sparse relative depth map
   (`MainScript.m`, `MainFunSparseMap.m`).

**Stage 2: dense relative depth** (`src/dense/`)

4. A graph Laplacian is built over the image grid. Its edge weights come from
   the spectral similarity of neighbouring pixels, measured with a
   divergence-based (spectral information) term, so that depth is propagated
   within materials rather than across them (`AliDenseProposed*.m`,
   `MainDenseMattingProposed3.m`).
5. The sparse values on edges are filtered and then propagated by solving
   (L + λD) x = λD s, where s is the sparse map and D marks the pixels where
   it is defined.

## Repository structure

```
setup_paths.m                    add all code folders to the MATLAB path
src/sparse/
  MainScript.m                   stage 1 entry point (one scene)
  MainFunSparseMap.m             stage 1 as a function
  SDisUnderCurve.m, Gradientfun.m, entropyfun.m,
  SumofDifferenceMap.m, VarianceOfHistogramMap.m   the five cues
  MainScript_smallCamera.m, MainSnapScanScript.m   other cameras
src/dense/
  AliBatchRun.m                  stage 2 entry point (batch over scenes)
  AliDenseProposed1/2/3.m        sparse-to-dense propagation
  MainDenseMattingProposed3.m    script form of the final version
  MainDenseMatting{SAM,SID,SGA,SCA,SpectralL2,...}.m   alternative similarity measures
utils/                           cube loading, dark-frame correction, normalisation
third_party/                     Isomap, Zhuo & Sim helpers, box filter, colour gradient
data/                            place your data here (not tracked)
```

## Requirements

- MATLAB (developed with R2016–R2020 on Windows; the loaders split paths on `\`)
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox (`pdist2`)

## Getting started

```matlab
>> cd hsi-chromatic-defocus-depth
>> setup_paths
```

1. **Sparse map.** In `src/sparse/MainScript.m`, set `filename` (ENVI `.dat`),
   `dpath` (dark reference cube) and `resultfolder`, then run it. It writes
   `result.png`, `resultimagesc.png` and `workspace.mat` (containing `normat`,
   `nneidis`, `meanvalpat`, `OneDresult`, …) to `resultfolder`.
2. **Dense map.** In `src/dense/AliBatchRun.m`, point `mainDataFolder` at the
   folder that holds one sub-folder per scene, each with its `workspace.mat`,
   and run it. Sparse and dense maps are written to `resultsProposed1/`.
   Switch the commented line in the loop to run version 2 or 3 of the
   propagation.

## Data

The lab, rooftop, outdoor and SnapScan scenes used in the paper are not
distributed with this repository. The code expects ENVI cubes plus a dark
reference cube captured with the same camera settings; see `data/README.md`.

## Notes on reproducibility

- `src/dense/MainDenseMatting*.m` reproduce the comparison between spectral
  similarity measures; `src/sparse/DenseDepthScript*.m` are earlier dense
  attempts kept for reference.
- Four small helper files existed in both `sparse/` and `dense/`. For this
  release they are kept once, in `sparse/`, so they no longer shadow each other
  on the MATLAB path.
- The edge threshold (`spectrastepedge`) and patch size (`neisize`) in
  `MainScript.m` were set per camera in the paper.

## Citation

If you use this code, please cite:

```bibtex
@article{zia2021chromatic,
  title   = {Exploring Chromatic Aberration and Defocus Blur for Relative Depth Estimation from Monocular Hyperspectral Image},
  author  = {Zia, Ali and Zhou, Jun and Gao, Yongsheng},
  journal = {IEEE Transactions on Image Processing},
  volume  = {30},
  pages   = {4357--4370},
  year    = {2021}
}
```

A `CITATION.cff` file is included, so GitHub's **Cite this repository** button gives the same reference.

## Licence and third-party code

The author's code is released under the **MIT licence** (see `LICENSE`).
Third-party code keeps its own terms, listed in `third_party/README.md`. In
particular, `third_party/zhuo_sim_defocus_2011/` (Zhuo & Sim, *Pattern
Recognition*, 2011) is provided by its authors **for academic use only**.

## Acknowledgements

The original work was carried out in the School of Information and Communication Technology, Griffith University, Australia. See the paper for full acknowledgements. Thanks also to the authors of the third-party code listed above.

## Contact

Questions and bug reports are welcome through [GitHub issues](https://github.com/alizia369/hsi-chromatic-defocus-depth/issues).
Ali Zia, La Trobe University — [www.ali-zia.me](https://www.ali-zia.me)

## Related repositories

This repository is one of a set released together from the same line of work on hyperspectral computer vision:

- [`hsi-3d-reconstruction`](https://github.com/alizia369/hsi-3d-reconstruction): 3D reconstruction from hyperspectral images (WACV 2015)
- [`hsi-relative-depth-estimation`](https://github.com/alizia369/hsi-relative-depth-estimation): Relative depth from a hyperspectral cube (DICTA 2015)
- [`hsi-occluded-object-detection`](https://github.com/alizia369/hsi-occluded-object-detection): Occluded object detection (PhD thesis, arXiv forthcoming)
- [`hsi-material-boundary-detection`](https://github.com/alizia369/hsi-material-boundary-detection): Material-based boundary detection (DICTA 2017)
- [`sugarcane-smut-hsi`](https://github.com/alizia369/sugarcane-smut-hsi): Early sugarcane smut detection (IVCNZ 2021)
- [`hsi-matlab-utils`](https://github.com/alizia369/hsi-matlab-utils): Shared hyperspectral I/O and normalisation helpers
