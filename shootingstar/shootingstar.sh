#!/bin/sh
set -eu

######################################################################
# 設定
######################################################################

print_usage_and_exit () {
  cat <<-USAGE 1>&2
	Usage   : ${0##*/} -c<列数> -r<行数> -p<座標ファイル> [背景ファイル]
	Options : -w<待ち時間> -l

	背景上に流れ星を描画する。

	-cオプションでフレームの列数を指定する。
	-rオプションでフレームの行数を指定する。
	-pオプションで流れ星が通過する座標（整数）が記載されたファイルを指定する。
	-wオプションで開始までの待ち時間を指定できる。デフォルトは0。
	-lオプションでループ実行を指定できる。デフォルトはループしない。
	USAGE
  exit 1
}

######################################################################
# パラメータ
######################################################################

# 変数を初期化
opr=''
opt_c=''
opt_r=''
opt_p=''
opt_w='0'
opt_l='no'

# 引数をパース
i=1
for arg in ${1+"$@"}
do
  case "$arg" in
    -h|--help|--version) print_usage_and_exit ;;
    -c*)                 opt_c=${arg#-c}      ;;
    -r*)                 opt_r=${arg#-r}      ;;
    -p*)                 opt_p=${arg#-p}      ;;
    -w*)                 opt_w=${arg#-w}      ;;
    -l*)                 opt_l='yes'          ;;
    *)
      if [ $i -eq $# ] && [ -z "$opr" ]; then
        opr=$arg
      else
        echo "${0##*/}: invalid args"
        exit 11
      fi
      ;;
  esac

  i=$((i + 1))
done

# 標準入力または読み取り可能な通常ファイルであるか判定
if   [ "_$opr" = '_' ] || [ "_$opr" = '_-' ]; then     
  opr=''
elif [ ! -f "$opr"   ] || [ ! -r "$opr"    ]; then
  echo "${0##*/}: \"$opr\" cannot be opened" 1>&2
  exit 21
else
  :
fi

# 有効な数値であるか判定
if ! printf '%s\n' "$opt_r" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_r\" invalid number" 1>&2
  exit 31
fi

# 有効な数値であるか判定
if ! printf '%s\n' "$opt_c" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_c\" invalid number" 1>&2
  exit 41
fi

# 標準入力または読み取り可能な通常ファイルであるか判定
if   [ "_$opt_p" = '_' ] || [ "_$opt_p" = '_-' ]; then     
  echo "${0##*/}: coord file must be specified" 1>&2
  exit 51
elif [ ! -f "$opt_p"   ] || [ ! -r "$opt_p"    ]; then
  echo "${0##*/}: \"$opt_p\" cannot be opened" 1>&2
  exit 52
else
  :
fi

# 有効な数値であるか判定
if ! printf '%s\n' "$opt_w" | grep -Eq '^[0-9]+$'; then
  echo "${0##*/}: \"$opt_w\" invalid number" 1>&2
  exit 61
fi

# パラメータを決定
backfile=$opr
width=$opt_c
height=$opt_r
pfile=$opt_p
waittime=$opt_w
isloop=$opt_l

######################################################################
# 本体処理
######################################################################

gawk -v FS='' -v OFS='' '
BEGIN {
  # パラメータを設定
  width    = '"${width}"';
  height   = '"${height}"';
  pfile    = "'"${pfile}"'";
  waittime = '"${waittime}"';
  isloop   = "'"${isloop}"'";

  # 座標をすべて読み込む
  pn = 0;
  while ((getline line < pfile) > 0) {
    pn++;
    split(line, coord, " ");
    x[pn] = coord[1];
    y[pn] = coord[2];
  }

  # ランダム色を生成
  cn = 12;
  c[ 1] = "Ｒ"
  c[ 2] = "Ｏ"
  c[ 3] = "Ｙ"
  c[ 4] = "Ｚ"
  c[ 5] = "Ｇ"
  c[ 6] = "Ｈ"
  c[ 7] = "Ｃ"
  c[ 8] = "Ｂ"
  c[ 9] = "Ｑ"
  c[10] = "Ｐ"
  c[11] = "Ｓ"
  c[12] = "Ｍ"

  # 流れ星を生成（先頭のみランダム）
  sn = 10;
  s[ 1] = c[('"${RANDOM}"' % cn) + 1];
  s[ 2] = "Ｗ"
  s[ 3] = "Ｗ"
  s[ 4] = "Ｗ"
  s[ 5] = "Ｗ"
  s[ 6] = "Ｗ"
  s[ 7] = "Ｗ"
  s[ 8] = "Ｗ"
  s[ 9] = "Ｗ"
  s[10] = "Ｗ"

  # 待ち時間の有無により遷移先を決定
  if (waittime > 0) { state = "s_wait"; wcnt = waittime; }
  else              { state = "s_run";  sidx = 1;        }
}

state == "s_wait" {
  # フレームをそのまま出力
  print;
  for (i = 2; i <= height; i++) {
    if   (getline > 0) { print; }
    else               { exit;  }
  }

  # 待ち時間をすべて消費したら線分を描画する状態へ移行
  wcnt--;
  if (wcnt == 0) { state = "s_run"; sidx = 1; next; }
}

state == "s_run" {
  # フレームを入力
  for (j = 1; j <= width; j++) { buf[1, j] = $j; }
  for (i = 2; i <= height; i++) {
    if (getline line <= 0) { exit; }
    split(line, ary, "");
    for (j = 1; j <= width; j++) { buf[i, j] = ary[j]; }
  }

  # 上書き範囲を確認
  headidx = (sidx > pn) ? pn : sidx;                      # 先頭部分
  tailidx = (1 > (sidx - sn + 1)) ? 1 : (sidx - sn + 1);  # 末尾部分

  # 流れ星を上書き
  for (i=headidx;i>=tailidx;i--) {buf[y[i],x[i]]=s[sidx - i + 1];}

  # フレームを出力
  for (i = 1; i <= height; i++) {
    for (j = 1; j <= width; j++) { printf "%s", buf[i,j]; }
    print "";
  }

  # インデックスを更新
  sidx++;
  # 流れ星がフレーム外に消えたら終了
  if ((pn + sn) < sidx) {
    # 線分の出力をもう一度最初から行う
    if (isloop == "yes") {
      if (waittime > 0) { state = "s_wait"; wcnt = waittime; next; }
      else              { state = "s_run";  sidx = 1;        next; }
    }

    # 線分の出力を完了し、残りのデータはそのまま出力
    else {
                        { state = "s_fin";                   next; }
    }
  }
}

state == "s_fin" {
  print;
}
' ${backfile:+"$backfile"}
