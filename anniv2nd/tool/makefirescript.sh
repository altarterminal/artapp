#!/bin/sh
set -eu

######################################################################
# 設定
######################################################################

w=90
h=40
n=80
t=40

######################################################################
# 本体処理
######################################################################

yes                                                                  |
head -n"$n"                                                          |

gawk -v w=$w -v h=$h -v t=$t '
  BEGIN {
    srand();
  }

  {
    printf "%d %d %d\n", randn(0, t), randn(1+5,w-5), randn(1+3,h-3);
  }

  function randn(l, u) {
    return int(rand() * 65535) % (u-l+1) + l;
  }
'                                                                    |

gawk '
  BEGIN {
    srand();
    c[0] = "b";  c[1] = "g";  c[2] = "r";
    c[3] = "o";  c[4] = "bg"; c[5] = "rp";
    cn = 6;
  }

  { printf "%s %s\n", c[randn(cn)], $0; }

  function randn(n) { return int(rand() * 65535) % n; }
'                                                                     |

gawk '
  { printf "-p\"crd/fire%s.txt\" -w%d -o\"%d,%d\"\n", $1,$2,$3,$4; }
'                                                                     |

gawk '
  {printf "%s %s |\n", "displayseries.sh -c\"$ncol\" -r\"$nrow\"", $0;}
'
