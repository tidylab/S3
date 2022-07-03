
# `S3` <img src="https://raw.githubusercontent.com/tidylab/S3/master/pkgdown/logo.png" align="right" style="float:right; height:75px"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/tidylab/S3/workflows/R-CMD-check/badge.svg)](https://github.com/tidylab/S3/actions)
[![Codecov test
coverage](https://codecov.io/gh/tidylab/S3/branch/master/graph/badge.svg)](https://codecov.io/gh/tidylab/S3?branch=master)

<!-- badges: end -->

## Overview

A cross-platform interface to file system operations, built on top of
the ‘libuv’ C library.

## Installation

You can install `S3` by using:

``` r
install.packages("remotes")
remotes::install_github("tidylab/S3")
```

## Features

**File manipulation Functions**

| Description                                | Function         | S3                                                        |
|:-------------------------------------------|:-----------------|:----------------------------------------------------------|
| Copy files, directories or links           | `file_copy`      | <span style="color: green;">\[v\] Implemented</span>      |
| Create files, directories, or links        | `file_create`    | <span style="color: green;">\[v\] Implemented</span>      |
| Delete files, directories, or links        | `file_delete`    | <span style="color: green;">\[v\] Implemented</span>      |
| Change file permissions                    | `file_chmod`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Change owner or group of a file            | `file_chown`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Query file metadata                        | `file_info`      | <span style="color: green;">\[v\] Implemented</span>      |
| Query file metadata                        | `file_size`      | <span style="color: green;">\[v\] Implemented</span>      |
| Move or rename files                       | `file_move`      | <span style="color: green;">\[v\] Implemented</span>      |
| Open files or directories                  | `file_show`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create names for temporary files           | `file_temp`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create names for temporary files           | `file_temp_push` | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create names for temporary files           | `file_temp_pop`  | <span style="color: orange;">\[-\] Not Implemented</span> |
| Change file access and modification times  | `file_touch`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Query for existence and access permissions | `file_exists`    | <span style="color: green;">\[v\] Implemented</span>      |
| Query for existence and access permissions | `file_access`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| Query for existence and access permissions | `file_exists`    | <span style="color: orange;">\[-\] Not Implemented</span> |

**Directory manipulation Functions**

| Description                                         | Function     | S3                                                        |
|:----------------------------------------------------|:-------------|:----------------------------------------------------------|
| Copy files, directories or links                    | `dir_copy`   | <span style="color: green;">\[v\] Implemented</span>      |
| Create files, directories, or links                 | `dir_create` | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create files, directories, or links                 | `dir_copy`   | <span style="color: green;">\[v\] Implemented</span>      |
| List files                                          | `dir_ls`     | <span style="color: green;">\[v\] Implemented</span>      |
| List files                                          | `dir_map`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| List files                                          | `dir_walk`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| List files                                          | `dir_info`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| Print contents of directories in a tree-like format | `dir_tree`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| Query for existence and access permissions          | `dir_exists` | <span style="color: orange;">\[-\] Not Implemented</span> |

**Link manipulation Functions**

| Description                                | Function      | S3                                                |
|:-------------------------------------------|:--------------|:--------------------------------------------------|
| Query for existence and access permissions | `link_exists` | <span style="color: red;">\[x\] Irrelevant</span> |
| Copy files, directories or links           | `link_copy`   | <span style="color: red;">\[x\] Irrelevant</span> |
| Create files, directories, or links        | `link_create` | <span style="color: red;">\[x\] Irrelevant</span> |
| Delete files, directories, or links        | `link_delete` | <span style="color: red;">\[x\] Irrelevant</span> |

**Path manipulation Functions**

| Description                                                               | Function           | S3                                                        |
|:--------------------------------------------------------------------------|:-------------------|:----------------------------------------------------------|
| Create names for temporary files                                          | `path_temp`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Construct path to a file or directory                                     | `path`             | <span style="color: green;">\[v\] Implemented</span>      |
| Construct path to a file or directory                                     | `path_wd`          | <span style="color: red;">\[x\] Irrelevant</span>         |
| Test if a path is an absolute path                                        | `is_absolute_path` | <span style="color: red;">\[x\] Irrelevant</span>         |
| Finding the user home directory                                           | `path_expand`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Finding the user home directory                                           | `path_expand_r`    | <span style="color: red;">\[x\] Irrelevant</span>         |
| Finding the user home directory                                           | `path_home`        | <span style="color: red;">\[x\] Irrelevant</span>         |
| Finding the user home directory                                           | `path_home_r`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Manipulate file paths                                                     | `path_file`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Manipulate file paths                                                     | `path_dir`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Manipulate file paths                                                     | `path_ext`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Manipulate file paths                                                     | `path_ext_remove`  | <span style="color: orange;">\[-\] Not Implemented</span> |
| Manipulate file paths                                                     | `path_ext_set`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Filter paths                                                              | `path_filter`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_real`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_split`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_join`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_abs`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_norm`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_rel`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_common`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path computations                                                         | `path_has_parent`  | <span style="color: orange;">\[-\] Not Implemented</span> |
| Construct a path to a location within an installed or development package | `path_package`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Sanitize a filename by removing directory paths and invalid characters    | `path_sanitize`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| Tidy paths                                                                | `path_tidy`        | <span style="color: orange;">\[-\] Not Implemented</span> |

**Helpers Functions**

| Description                              | Function        | S3                                                        |
|:-----------------------------------------|:----------------|:----------------------------------------------------------|
| Functions to test for file types         | `is_file`       | <span style="color: green;">\[v\] Implemented</span>      |
| Functions to test for file types         | `is_dir`        | <span style="color: green;">\[v\] Implemented</span>      |
| Functions to test for file types         | `is_link`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Functions to test for file types         | `is_file_empty` | <span style="color: orange;">\[-\] Not Implemented</span> |
| File paths                               | `as_fs_path`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| File paths                               | `fs_path`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Human readable file sizes                | `as_fs_bytes`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| Human readable file sizes                | `fs_bytes`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create, modify and view file permissions | `as_fs_perms`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| Create, modify and view file permissions | `fs_perms`      | <span style="color: orange;">\[-\] Not Implemented</span> |

**System information Functions**

| Description                         | Function    | S3                                                        |
|:------------------------------------|:------------|:----------------------------------------------------------|
| Lookup users and groups on a system | `group_ids` | <span style="color: orange;">\[-\] Not Implemented</span> |
| Lookup users and groups on a system | `user_ids`  | <span style="color: orange;">\[-\] Not Implemented</span> |
