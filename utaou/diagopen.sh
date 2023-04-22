#!/bin/sh
set -eu

######################################################################
# 設定
######################################################################

print_usage_and_exit () {
  cat <<-USAGE 1>&2
	Usage   : ${0##*/} -c<列数> -r<行数> [コンテンツファイル]
	Options :

	コンテンツを斜め方向から徐々に表示する。

	-cオプションでコンテンツの列数を指定する。
	-rオプションでコンテンツのフレームの行数を指定する。
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

# 引数をパース
i=1
for arg in ${1+"$@"}
do
  case "$arg" in
    -h|--help|--version) print_usage_and_exit ;;
    -c*)                 opt_c=${arg#-c}      ;;
    -r*)                 opt_r=${arg#-r}      ;;

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

# パラメータを決定
content=$opr
width=$opt_c
height=$opt_r

######################################################################
# 本体処理
######################################################################

gawk -v FS='' '
BEGIN {
  # パラメータ設定
  width  = '"${width}"';
  height = '"${height}"';

  # ステップパラメータを初期化  
  rowstep   = 1; # 行単位のスライド数
  framestep = 1; # フレーム単位のスライド数

  # 行インデックスを初期化
  ridx = 1;

  # フレーム内の末尾未到達行の存在を記録（フレームで共有）
  isreachend = "yes";

  # 境界インデックスを初期化
  resetbound(curbound, height, rowstep);
}

{
  # 開始列を決定
  if   (curbound[ridx] < 1) { scol = 1;              }
  else                      { scol = curbound[ridx]; }

  # 現在行が末尾に到達していないことを記録
  if (scol <= width) { isreachend = "no"; }

  # 通常通りに表示する
  for (i = 1;    i <  scol;  i++) { printf "%s", $i;   }
  # 塗りつぶす
  for (i = scol; i <= width; i++) { printf "%s", "□"; }

  # 出力
  print "";

  # 次のアクションを判断
  if   (ridx < height) {
    # フレームの途中なので継続

    ridx++;
  }
  else                 {
    # フレームを完了

    if (isreachend == "yes") {
      # すべての行が末尾に到達したら終了

      exit; 
    } else {
      # 末尾に到達していない行があるので次フレームに継続

      updatebound(curbound, height, framestep);
      ridx = 1;
      isreachend = "yes";
    }
  }
}

# 境界インデックスをリセット
function resetbound (bound,height,rowstep,   i) {
  for (i=1; i<=height; i++) { bound[i] = rowstep*(-1)*i - 10; }
}

# 境界インデックスを更新
function updatebound (bound,height,framestep,   i) {
  for (i=1; i<=height; i++) { bound[i] = bound[i] + framestep; }
}
' ${content:+"$content"}
