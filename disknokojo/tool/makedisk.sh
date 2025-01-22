#!/bin/sh
set -eu

######################################################################
# setting
######################################################################

nrow=41
ncol=61

######################################################################
# main routine
######################################################################

{
  # outer edge of disk
  calccircle.sh 31,21,19
  # inner edge of disk
  calccircle.sh 31,21,3

  # transparent part of center
  calccircle.sh 31,21,5
  calccircle.sh 31,21,7
}                                                                    |

crd2draw.sh -r"${nrow}" -c"${ncol}"                                  |

fillclosed.sh -p"31,5"                                               |

tr '□' 'Ｋ'                                                         |
tr '■' 'Ｗ'                                                         |
color2escseq.sh
