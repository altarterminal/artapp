#!/bin/sh
set -eu

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

# コマンド参照パスを設定
export PATH="$(pwd)/bin:${PATH}"

nrep=120   # フレームの繰り返し回数
ncol=55    # フレームの幅
nrow=72    # フレームの高さ
msec=120   # フレームの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）

###########################################################################
# 本体処理
###########################################################################

# サブプロセスに切り離して描画を実行
(
  # 空のフレームを作成
  canbas.sh -c"$ncol" -r"$nrow"                                           |
  # フレームを複製
  repeat.sh -n"$nrep"                                                     |

  # 「Traumerei」の文字を上書き
  overwrite.sh -r"$nrow" -c"$ncol" -f"text/traumerei.txt" -o"7,28"        |
  # ディスク部分を回転
  rotate.sh -r"$nrow" -c"$ncol" -p"28,28,25,-3"                           |
  # ディスクを下書き
  underwrite.sh -r"$nrow" -c"$ncol" -b"text/disk.txt" -o"2,2"             |
  # ディスクの縁の穴を動かす
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/hole.txt" -l -o"2,2"        |

  # アームを上書き
  overwrite.sh -r"$nrow" -c"$ncol" -f"text/arm.txt" -o"26,26"             |
  # 筐体を上書き
  overwrite.sh -r"$nrow" -c"$ncol" -f"text/housing.txt" -o"0,0"           |

  # ギアを動かす
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/gear.txt" -l -o"14,59"      |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/gear.txt" -l -o"14,60"      |

  # ゼンマイを動かす
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/spring.txt" -l -o"44,57"  |

  # 色アルファベットに変換
  tr '□' 'Ｋ'                                                            |
  tr '■' 'Ｗ'                                                            |
  
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
      # サブプロセスを終了させる
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
