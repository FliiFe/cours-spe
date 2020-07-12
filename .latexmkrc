# vim: syntax=perl
$out_dir = 'build';
$pdflatex = "xelatex --shell-escape -interaction=nonstopmode %O %S -file-line-error";
$makeindex  = 'makeindex -s indexstyle.ist %O -o %D %S';
