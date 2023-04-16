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

# コマンド参照パスを設定
export PATH="$(pwd)/bin:${PATH}"

ncol=177   # フレームの幅
nrow=42    # フレームの高さ
msec=80    # フレームあたりの表示時間（ミリ秒）
wtime=1000 # 起動時の待ち時間（ミリ秒）
nrep=100   # フレームの繰り返し回数

######################################################################
# 本体処理
######################################################################

# サブプロセスに切り離して描画を実行
(
  # ベースのテキストを入力
  repeat.sh -n"$nrep" "text/koi.txt"                                 |

  # 対象文字をランダムな色（または透明）に変換
  gawk -v FS='' -v OFS='' '
    BEGIN {
      srand();

      # 候補の文字列とその長さを設定（'　'は透明を表現）
      candstr = "　　　　　　　　　　　　　　　　　ＰＣＯＷＹＲＧＢＭ";
      candnum = split(candstr, candary, "");
    }

    {
      # すべての要素を走査して対象文字なら変換
      for (i=1;i<=NF;i++) { if ($i == "■") { $i = randchar(); } }

      # 変換後に出力
      print;
    }

    function randchar() {
      return candary[(int(rand() * 1000) % candnum) + 1];
    }
  '                                                                  |

  # 色アルファベットに変換
  tr '　' 'Ｋ'                                                       |
  tr '■' 'Ｗ'                                                       |
  tr '□' 'Ｋ'                                                       |
  
  # アスキーエスケープに変換
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
