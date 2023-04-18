#!/bin/sh
set -eu

################################################################################
# 端末制御の関数を定義
################################################################################

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

################################################################################
# シグナルに対するアクションを設定
################################################################################

# 親プロセス（自身）に対する終了シグナルは無視
trap : TERM

################################################################################
# 前準備
################################################################################

init_tty
open_screen
clear_screen

################################################################################
# 設定
################################################################################

ncol=80    # フレームの幅
nrow=40    # フレームの高さ
msec=60    # フレームあたりの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）
nrep=200   # フレームの繰り返し回数

################################################################################
# 本体処理
################################################################################

# サブプロセスに切り離して描画を実行
(
  # 空のフレームを作成
  canbas.sh -c"$ncol" -r"$nrow"                                                |
  # フレームを黒塗り
  tr '□' 'Ｋ'                                                                 |
  # フレームを複製
  repeat.sh -n"$nrep"                                                          |

  # 星を上書き（星は２種類）
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"4,11"        |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/starvh.txt" -l -o"14,4"        |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"18,18"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/starvh.txt" -l -o"18,38"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"38,36"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/starvh.txt" -l -o"42,4"        |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"50,20"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/starvh.txt" -l -o"64,32"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"66,18"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/starvh.txt" -l -o"76,12"       |
  displayparallel.sh -c"$ncol" -r"$nrow" -p"crd/stardg.txt" -l -o"79,39"       |

  # 月を上書き
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/moon.txt" -l -o"70,5"             |
  
  # 花火を上書き
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w5  -l -o"10,10"    |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w3  -l -o"15,14"    |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w6  -l -o"33,19"    |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firey.txt"  -w10 -l -o"45,6"     |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w8  -l -o"44,18"    |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w12 -l -o"65,11"    |
  displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w8  -l -o"70,15"    |
  
  # メッセージを上書き
  overwrite.sh -r"$nrow" -f"text/omedetou.txt"                                 |

  # ロボットを上書き
  displaytrack.sh -c"$ncol" -r"$nrow" -p"crd/robot.txt" -w70                   |
  
  # アスキーエスケープシーケンスに変換
  color2escseq.sh                                                              |

  # 出力位置を調整
  resetcursor.sh -r"$nrow"                                                     |
  
  # 出力速度を調整
  linevalve -m"$msec" -r"$nrow" -w"$wtime"
) &

################################################################################
# キー入力を制御
################################################################################

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

################################################################################
# 後始末
################################################################################

clear_screen
close_screen
quit_tty
