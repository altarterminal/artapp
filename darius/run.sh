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

ncol=33    # フレームの幅
nrow=35    # フレームの高さ
axis=17    # 軸列番号
msec=100   # フレームあたりの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）
nrep=28    # フレームの繰り返し回数

######################################################################
# 本体処理
######################################################################

# 動画を再生して次の処理に進む
(
  {
    # ベース画像の静止状態
    repeat.sh -n"5" "text/frame.txt"
    
    # ベース画像を入力
    repeat.sh -n"$nrep" "text/frame.txt"                             |
    # 灯を点灯
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/r_trace_M.txt"     |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/l_trace_C.txt"     |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/c_trace_Y.txt"     |
    # 回転
    ./sinewave.sh -r"$nrow" -c"$ncol" -a"$axis"

    # ベース画像を入力
    repeat.sh -n"$nrep" "text/frame_M_C.txt"                         |
    # 回転
    ./sinewave.sh -r"$nrow" -c"$ncol" -a"$axis"

    # ベース画像を入力
    repeat.sh -n"$nrep" "text/frame_C_M.txt"                         |
    # 回転
    ./sinewave.sh -r"$nrow" -c"$ncol" -a"$axis"
    
    # ベース画像を入力
    repeat.sh -n"$nrep" "text/frame_M_C.txt"                         |
    # 灯を消灯
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/r_trace_A.txt"     |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/l_trace_A.txt"     |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/c_trace_A.txt"     |
    # 回転
    ./sinewave.sh -r"$nrow" -c"$ncol" -a"$axis"
    
    # ベース画像の静止状態
    repeat.sh -n"5" "text/frame.txt"
  }                                                                  |

  # 土台を上書き
  overwrite.sh -r"$nrow" -c"$ncol" -f"text/base.txt"                 |

  # 背景を黒に
  tr '□' 'Ｋ'                                                       |

  # アスキーエスケープシーケンスに変換
  color2escseq.sh                                                    |
   
  # 出力位置を調整
  resetcursor.sh -r"$nrow"                                           |  

  # 出力スピードを調整
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
      # 子プロセスを終了させる
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
