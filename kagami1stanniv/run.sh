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

ncol=120   # フレームの幅
nrow=58    # フレームの高さ
msec=80    # フレームあたりの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（表示時間）

######################################################################
# 本体処理
######################################################################

tc='text/screen.txt'

tk='text/kokoro.txt'
ta='text/aki.txt'
ts='text/subaru.txt'
tr='text/rion.txt'
tm='text/masamune.txt'
tu='text/ureshino.txt'
tf='text/fuka.txt'
to='text/okami.txt'

sp='ＷｗｓｏｋｇｄａｄｇｋｏｓｗＷ'

# サブプロセスに切り離して描画を実行
(
  {
    repeat.sh -n"28" "$tc"

    overwrite.sh -c"$ncol" -r"$nrow" -f"$ts" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$tm" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$tf" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$tu" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$ta" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$tk" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$tr" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    overwrite.sh -c"$ncol" -r"$nrow" -f"$to" -o30,4 -t'■' "$tc"    |
    repeat.sh -n'14'                                                |
    strgrad.sh -r"$nrow" -s"$sp" -c'・'

    repeat.sh -n"28" "$tc"
  }                                                                 |


  tr '□' 'Ｗ'                                                      |
  tr '■' 'Ｋ'                                                      |

  # アスキーエスケープシーケンスに変換
  color2escseq.sh                                                   |
  
  # 出力位置を調整
  resetcursor.sh -r"$nrow"                                          |
  
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
