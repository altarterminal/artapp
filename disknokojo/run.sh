#!/bin/sh
set -eu

######################################################################
# 端末制御の関数を定義
######################################################################

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

######################################################################
# シグナルに対するアクションを設定
######################################################################

# 親プロセス（自身）に対する終了シグナルは無視
trap : TERM

######################################################################
# 前準備
######################################################################

init_tty
open_screen
clear_screen

######################################################################
# 設定
######################################################################

ncol=61    # フレームの幅
nrow=41    # フレームの高さ
msec=60    # フレームあたりの時間（ミリ秒）
wtime=500  # 起動時の待ち時間（ミリ秒）

######################################################################
# 本体処理
######################################################################

# サブプロセスに切り離して描画を実行
(
  # 黒背景を入力
  canbas.sh -r"$nrow" -c"$ncol" -p"　"                               |
  repeat.sh -n"200"                                                  |
  
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/aki.txt"                    \
              -p"cmp/cmp.txt" -d"trk/trkt.txt"  -s"2" -w"20"         |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/fuka.txt"                   \
              -p"cmp/cmp.txt" -d"trk/trktr.txt" -s"2" -w"40"         |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/subaru.txt"                 \
              -p"cmp/cmp.txt" -d"trk/trkr.txt"  -s"2" -w"55"         |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/rion.txt"                   \
              -p"cmp/cmp.txt" -d"trk/trkbr.txt" -s"2" -w"80"         |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/masamune.txt"               \
              -p"cmp/cmp.txt" -d"trk/trkb.txt"  -s"2" -w"100"        |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/ureshino.txt"               \
              -p"cmp/cmp.txt" -d"trk/trkbl.txt" -s"2" -w"120"        |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/kokoro.txt"                 \
              -p"cmp/cmp.txt" -d"trk/trkl.txt"  -s"2" -w"135"        |
  anypenet.sh -r"$nrow" -c"$ncol" -a"txt/okami.txt"                  \
              -p"cmp/cmp.txt" -d"trk/trktl.txt" -s"2" -w"160"        |

  # 黒背景の見え方を変換
  sed 's!　!  !g'                                                    |
  
  # 出力位置を調整
  resetcursor.sh -r"$nrow"                                           |

  # 出力速度を調整
  linevalve -m"$msec" -r"$nrow" -w"$wtime"
) &

######################################################################
# キー入力を制御
######################################################################

while true
do
  key=$(dd bs=1 count=1 2> /dev/null)
  
  case "$key" in
    q)
      # サブプロセスを終了させる
      kill -TERM 0
      break
      ;;
    *)
      :
      ;;
  esac
done

######################################################################
# 後始末
######################################################################

clear_screen
close_screen
quit_tty
