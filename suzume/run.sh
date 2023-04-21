#!/bin/sh
set -eu

###########################################################################
# 設定
###########################################################################

###########################################################################
# 入力動画を設定
###########################################################################

###########################################################################
# 端末制御の関数を定義
###########################################################################

# 端末設定を変更
init_tty()     { stty -icanon -echo min 1 -ixon; }
# 端末設定を復帰
quit_tty()     { stty icanon echo ixon eof '^d'; }

# スクリーンをクリア
clear_screen() { printf '\033[H\033[2J';     }
# 新規のスクリーンをオープン
open_screen()  { printf '\033\067\033[?47h'; }
# 現在のスクリーンをクローズ
close_screen() { printf '\033[?47l\033\070'; }

###########################################################################
# シグナルに対するアクションを設定
###########################################################################

# 親プロセス（自身）に対する終了シグナルは無視
trap : TERM

###########################################################################
# 前準備
###########################################################################

init_tty
open_screen
clear_screen

###########################################################################
# 設定
###########################################################################

ncol=60   # フレームの幅
nrow=30   # フレームの高さ
msec=50   # フレームあたりの表示時間（ミリ秒）
nrep=600  # フレームの繰り返し回数
wtime=500 # 起動時の待ち時間（ミリ秒）

# ランダムな待ち時間を決めるための関数
function rwait() { echo $(((RANDOM * 3) % 180)); }

###########################################################################
# 本体処理
###########################################################################

(
  # 空を上書き
  repeat.sh -n"$nrep" "text/sky.txt"                                      |

  # 星を上書き
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star20t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star20t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star20t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star20t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star20t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star23t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star25t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star28t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star30.txt"  -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star32t.txt" -l -w$(rwait)   |

  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   | 
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star35t.txt" -l -w$(rwait)   |

  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star38t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star40t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star43t.txt" -l -w$(rwait)   |
  
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/star45t.txt" -l -w$(rwait)   |

  # 前景（人、椅子、草むら）を上書き
  overwrite.sh -r"$nrow" -f'text/foreground.txt'                          |
    
  # アスキーエスケープシーケンスに変換
  color2escseq.sh                                                         |

  # 出力位置を調整
  resetcursor.sh -r"$nrow"                                                |
  
  # 出力速度を調整
  linevalve -m"$msec" -r"$nrow" -w"$wtime"
) &

###########################################################################
# キー入力を制御
###########################################################################

while true
do
  key=$(dd bs=1 count=1 2> /dev/null)
  
  case "$key" in
    q)
      # 子プロセスを終了させる
      kill -TERM 0
      break
      ;;
    *)
      :
      ;;
  esac
done

###########################################################################
# 後始末
###########################################################################

clear_screen
close_screen
quit_tty
