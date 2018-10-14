## Test environments
* local OS X install, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* This package is useful for generating metrics
  to measure code complexity and language diversity
  as well as coding-style.

* I had neglected to re-build the Rd files before the
  first submission. Ironically, I modified the package 
  tests and examples to remove the .java file (since the
  CRAN pre-check system seems incapable of distinguishing
  between example files and actual code for pacakges when
  there's a .java file in the inst/ directory). This
  has been fixed.
