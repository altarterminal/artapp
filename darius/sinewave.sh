#!/bin/sh
set -eu

######################################################################
# 設定
######################################################################

print_usage_and_exit () {
  cat <<-USAGE 1>&2
	Usage   : ${0##*/} -r<行数> -c<列数> -a<軸列> [図形ファイル]
	Options : -n<？？？>

	図形ファイル中の対象文字を軸列を中心に3次元回転させる。

	-nオプションで？？？
	USAGE
  exit 1
}

######################################################################
# パラメータ
######################################################################

# 変数を初期化
opr=''
opt_r=''
opt_c=''
opt_a=''
opt_n='1'

# 引数をパース
i=1
for arg in ${1+"$@"}
do
  case "$arg" in
    -h|--help|--version) print_usage_and_exit ;;
    -r*)                 opt_r=${arg#-r}      ;;
    -c*)                 opt_c=${arg#-c}      ;;
    -a*)                 opt_a=${arg#-a}      ;;
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
if ! printf '%s\n' "$opt_c" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_c\" invalid number" 1>&2
  exit 41
fi

# 有効な数値であることを確認
if ! printf '%s\n' "$opt_a" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_a\" invalid number" 1>&2
  exit 51
fi

# 有効な数値であることを確認
if ! printf '%s\n' "$opt_n" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_n\" invalid number" 1>&2
  exit 61
fi

# パラメータを決定
content=$opr
height=$opt_r
width=$opt_c
axis=$opt_a
#thin=$opt_n

######################################################################
# 本体処理
######################################################################

gawk -v FS='' -v OFS='' '
BEGIN {
  # パラメータを設定
  height = '"${height}"';  # フレームの高さ
  width  = '"${width}"';   # フレームの幅
  axis   = '"${axis}"';    # 軸の列番号

  # 対象文字を決定
  tchar = "■";
  bchar = "□";

  # パラメータを初期化
  t  = 0; # 現在の角度
  t0 = 7; # 角度の増分

  # 定数
  pi = 3.141592;
}

{
  ####################################################################
  # 計算
  ####################################################################
  
  # 角度を更新
  t = (t + t0) % 360;

  # 三角関数の値を計算
  st = sin((t * pi) / 180);
  ct = cos((t * pi) / 180);

  # パラメータを初期化
  pn = 0;

  ####################################################################
  # 入力
  ####################################################################

  # 第一行を入力バッファに保存
  for (i = 1; i <= NF; i++) {
    if ($i != bchar) {
      pn++; px[pn] = i; py[pn] = 1; pc[pn] = $i;
      buf[1,i] = bchar;
    } else {
      buf[1,i] = $i;
    }
  }

  # 第二から最終行を入力バッファに保存
  rowcnt = 1;
  while (rowcnt < height) {
    # 入力がなければ終了
    if (getline <= 0) { exit; }

    # 入力した行をバッファに保存
    rowcnt++;
    for (i = 1; i <= NF; i++) {
      if ($i != bchar) {
        pn++; px[pn] = i; py[pn] = rowcnt; pc[pn] = $i;
        buf[rowcnt,i] = bchar;
      } else {
        buf[rowcnt,i] = $i;
      }
    }
  }

  ####################################################################
  # 回転処理
  ####################################################################

  for (i = 1; i <= pn; i++) {
    cx = px[i];
    cy = py[i];

    cxn = round((cx - axis) * ct) + axis;

    buf[cy, cxn] = pc[i];
  }

  ####################################################################
  # 出力
  ####################################################################

  # バッファを出力
  for (j = 1; j <= height; j++) {
    for (i = 1; i <= width; i++) { printf "%s", buf[j,i]; }
    print ""
  }
}

function round(x) {
  if (x >= 0) { return int(x+0.5);         }
  else        { return -1 * int(-1*x+0.5); }
}

function abs(x) {
  return x >= 0 ? x : x*(-1);
}

END {
  for (i = 1; i <= pn; i++) {
#    print px[i] "," py[i];
  }
}
' ${content:+"$content"}
