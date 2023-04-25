#!/bin/sh
set -eu

######################################################################
# 設定
######################################################################

print_usage_and_exit () {
  cat <<-USAGE 1>&2
	Usage   : ${0##*/} -r<行数> [テキストファイル]
	Options : -n<太さ>

	マーカー文字の領域の色を時間的に変化させる。
	変化は斜め方向（右下から右上）に変化させる。

	-nオプションで各色の太さを指定できる。デフォルトは1。
	USAGE
  exit 1
}

######################################################################
# パラメータ
######################################################################

# 変数を初期化
opr=''
opt_r=''
opt_n='1'

# 引数をパース
i=1
for arg in ${1+"$@"}
do
  case "$arg" in
    -h|--help|--version) print_usage_and_exit ;;
    -r*)                 opt_r=${arg#-r}      ;;
    -n*)                 opt_n=${arg#-n}      ;;
    *)
      if [ $i -eq $# ] && [ -z "$opr" ]; then
        opr=$arg
      else
        echo "${0##*/}: invalid args" 1>&2
        exit 11
      fi
      ;;
  esac

  i=$((i + 1))
done

# 読み取り可能な通常ファイルまたは標準入力であることを確認
if   [ "_$opr" = '_' ] || [ "_$opr" = '_-' ]; then     
  opr=''
elif [ ! -f "$opr"   ] || [ ! -r "$opr"    ]; then
  echo "${0##*/}: \"$opr\" cannot be opened" 1>&2
  exit 21
else
  :
fi

# 有効な数値であることを確認
if ! printf '%s\n' "$opt_r" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_r\" invalid number" 1>&2
  exit 31
fi

# 有効な数値であることを確認
if ! printf '%s\n' "$opt_n" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_n\" invalid number" 1>&2
  exit 41
fi

# パラメータを決定
content=$opr
height=$opt_r
thin=$opt_n

######################################################################
# 本体処理
######################################################################

gawk -v FS='' -v OFS='' '
BEGIN {
  # パラメータを設定
  height = '"${height}"';  # フレームの高さ
  thin   = '"${thin}"';    # 各色の幅

  # 基本色。この順で遷移
  bcnum = 12;
  bc[ 1] = "Ｒ";
  bc[ 2] = "Ｏ";
  bc[ 3] = "Ｙ";
  bc[ 4] = "Ｚ";
  bc[ 5] = "Ｇ";
  bc[ 6] = "Ｈ";
  bc[ 7] = "Ｃ";
  bc[ 8] = "Ｂ";
  bc[ 9] = "Ｑ";
  bc[10] = "Ｐ";
  bc[11] = "Ｓ";
  bc[12] = "Ｍ";

  # フレーム単位の色基準
  gidx = 1;

  # 行単位の色基準。フレーム単位の色基準から設定
  lidx = 1;

  # （幅を反映した）表示色の作成
  cnum = bcnum * thin;
  for (i = 1; i <= bcnum; i++) {
    for (j = 1; j <= thin; j++) {
      c[(i-1)*thin + j] = bc[i];
    }
  }

  # 行インデックスを初期化
  rowidx = 1;
}

{
  # 現在行の色基準。行単位の色基準から生成
  cidx = lidx;

  for (i = 1; i <= NF; i++) {
    if ($i == "■") { $i = c[cidx]; }

    
    cidx++;
    if (cidx > cnum) { cidx = 1; }
  }

  # 出力
  print;

  # 次行の色基準を計算
  lidx++;
  if (lidx > cnum) { lidx = 1; }

  # 行インデックスを更新
  rowidx++;
  if (rowidx > height) {
    # フレームが終了した場合

    # 行インデックスを初期化
    rowidx = 1;

    # フレームの色基準を更新
    gidx++;
    if (gidx > cnum) { gidx = 1; }

    # フレームの色基準を行の色基準に設定
    lidx = gidx;
  }
}
' ${content:+"$content"}
