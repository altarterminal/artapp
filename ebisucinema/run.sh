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

ncol=41    # フレームの幅
nrow=41    # フレームの高さ
msec=50    # フレームあたりの時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）
dframe=24  # 各文字を表示するフレーム数
step=5     # カウンターの表示ピクセルの増分

######################################################################
# 本体処理
######################################################################

# サブプロセスに切り離して描画を実行
(
  {
    # ヱ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/e.txt" -o"0,0"                    |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # ビ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/bi.txt" -o"0,0"                   |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # ス
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/su.txt" -o"0,0"                   |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # シ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/shi.txt" -o"0,0"                  |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # ネ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/ne.txt" -o"0,0"                   |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # マ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    overwrite.sh -r"$nrow" -f"text/ma.txt" -o"0,0"                   |
    repeat.sh -n"$dframe"                                            |
    displayignition.sh -r"$nrow" -c"$ncol" -p"crd/ccrd.txt" -s"$step"

    # しばらく待つ
    canbas.sh -r"$nrow" -c"$ncol"                                    |
    repeat.sh -n"16"

    # ヱビスシネマのアイコン
    repeat.sh -n"$dframe" "text/icon.txt"
  }                                                                  |

  # 色アルファベットに変換
  tr '■' 'Ｗ'                                                       |
  tr '□' 'Ｋ'                                                       |

  # アスキーエスケープシーケンスに変換
  color2escseq.sh                                                    |
  
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
