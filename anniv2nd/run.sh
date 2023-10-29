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

ncol=90    # フレームの幅
nrow=40    # フレームの高さ
msec=60    # フレームあたりの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）
nrep=90   # 数字あたりのフレーム数

######################################################################
# 本体処理
######################################################################

# サブプロセスに切り離して描画を実行
(
  {
    # しばらく黒画
    canbas.sh -r"$nrow" -c"$ncol" -p"Ｋ"                             |
    repeat.sh -n'100'

    # 黒画→タイトル
    canbas.sh -r"$nrow" -c"$ncol" -p"Ｋ"                             |
    repeat.sh -n"$nrep"                                              |
    transform.sh -r"$nrow" -c"$ncol" -a'txt/title.txt' -n'50' -m

    # タイトル→おめでとう
    cat 'txt/title.txt'                                              |
    repeat.sh -n"$nrep"                                              |
    transform.sh -r"$nrow" -c"$ncol" -a'txt/omedetou.txt' -n'50' -m

    # おめでとう＋花火
    canbas.sh -r"$nrow" -c"$ncol" -p"Ｋ"                             |
    repeat.sh -n"$nrep"                                              |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w3  -o"10,41" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w11 -o"30,15" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w36 -o"9,9"   |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w32 -o"12,39" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w30 -o"18,23" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w35 -o"6,33"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w12 -o"45,13" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w0  -o"36,16" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w13 -o"77,26" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w27 -o"11,26" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w40 -o"72,6"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w26 -o"64,18" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w6  -o"52,5"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w1  -o"29,21" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w34 -o"80,31" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w31 -o"53,29" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w25 -o"85,32" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w16 -o"74,21" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w1  -o"54,3"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w33 -o"85,12" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w27 -o"74,31" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w18 -o"31,3"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w33 -o"30,11" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w27 -o"63,14" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w33 -o"25,19" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w25 -o"77,41" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w28 -o"10,23" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w17 -o"20,40" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w16 -o"53,13" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w1  -o"16,41" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w37 -o"26,32" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w13 -o"57,42" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w31 -o"22,33" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w25 -o"62,42" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w8  -o"41,41" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w16 -o"76,22" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w40 -o"68,41" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w12 -o"53,11" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w32 -o"77,4"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w9  -o"30,31" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w24 -o"11,42" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w7  -o"39,20" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w34 -o"80,6"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w7  -o"58,13" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w1  -o"52,40" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w14 -o"61,23" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w1  -o"40,9"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w33 -o"74,23" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w35 -o"78,37" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w34 -o"38,18" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w3  -o"50,17" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w3  -o"41,17" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w32 -o"68,10" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w5  -o"67,4"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w40 -o"31,31" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w18 -o"59,34" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w30 -o"47,32" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w25 -o"60,40" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w16 -o"19,26" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w29 -o"23,37" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w36 -o"81,3"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w27 -o"36,25" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w40 -o"18,11" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w3  -o"15,9"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w20 -o"85,6"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w2  -o"13,24" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w9  -o"59,24" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w20 -o"76,39" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w19 -o"58,4"  |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w24 -o"65,29" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w9  -o"32,29" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireg.txt"  -w3  -o"58,16" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireo.txt"  -w18 -o"34,28" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w13 -o"38,24" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w14 -o"66,24" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w26 -o"51,34" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/fireb.txt"  -w10 -o"49,40" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firebg.txt" -w27 -o"43,38" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firer.txt"  -w38 -o"30,25" |
    displayseries.sh -c"$ncol" -r"$nrow" -p"crd/firerp.txt" -w26 -o"11,32" |
    overwrite.sh -c"$ncol" -r"$nrow" -t"Ｋ" -f'txt/omedetou.txt'

    # しばらく黒画
    canbas.sh -r"$nrow" -c"$ncol" -p"Ｋ"                             |
    repeat.sh -n'30'
  }                                                                  |

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
