
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

| Category               | Subcategory            | Function           | S3                                                        |
|:-----------------------|:-----------------------|:-------------------|:----------------------------------------------------------|
| File manipulation      | File manipulation      | `file_copy`        | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_create`      | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_delete`      | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_chmod`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_chown`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_info`        | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_size`        | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_move`        | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_show`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_temp`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_temp_push`   | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_temp_pop`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_touch`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_exists`      | <span style="color: green;">\[v\] Implemented</span>      |
| File manipulation      | File manipulation      | `file_access`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| File manipulation      | File manipulation      | `file_exists`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_copy`         | <span style="color: green;">\[v\] Implemented</span>      |
| Directory manipulation | Directory manipulation | `dir_create`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_copy`         | <span style="color: green;">\[v\] Implemented</span>      |
| Directory manipulation | Directory manipulation | `dir_ls`           | <span style="color: green;">\[v\] Implemented</span>      |
| Directory manipulation | Directory manipulation | `dir_map`          | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_walk`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_info`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_tree`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Directory manipulation | Directory manipulation | `dir_exists`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Link manipulation      | Link manipulation      | `link_exists`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Link manipulation      | Link manipulation      | `link_copy`        | <span style="color: red;">\[x\] Irrelevant</span>         |
| Link manipulation      | Link manipulation      | `link_create`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Link manipulation      | Link manipulation      | `link_delete`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_temp`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path`             | <span style="color: green;">\[v\] Implemented</span>      |
| Path manipulation      | Path manipulation      | `path_wd`          | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `is_absolute_path` | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_expand`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_expand_r`    | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_home`        | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_home_r`      | <span style="color: red;">\[x\] Irrelevant</span>         |
| Path manipulation      | Path manipulation      | `path_file`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_dir`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_ext`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_ext_remove`  | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_ext_set`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_filter`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_real`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_split`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_join`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_abs`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_norm`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_rel`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_common`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_has_parent`  | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_package`     | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_sanitize`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| Path manipulation      | Path manipulation      | `path_tidy`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `is_file`          | <span style="color: green;">\[v\] Implemented</span>      |
| Helpers                | Helpers                | `is_dir`           | <span style="color: green;">\[v\] Implemented</span>      |
| Helpers                | Helpers                | `is_link`          | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `is_file_empty`    | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `as_fs_path`       | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `fs_path`          | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `as_fs_bytes`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `fs_bytes`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `as_fs_perms`      | <span style="color: orange;">\[-\] Not Implemented</span> |
| Helpers                | Helpers                | `fs_perms`         | <span style="color: orange;">\[-\] Not Implemented</span> |
| System information     | System information     | `group_ids`        | <span style="color: orange;">\[-\] Not Implemented</span> |
| System information     | System information     | `user_ids`         | <span style="color: orange;">\[-\] Not Implemented</span> |
