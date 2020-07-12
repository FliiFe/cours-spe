# vim: syntax=perl
$out_dir = '.';
$pdflatex = "xelatex --shell-escape -interaction=nonstopmode %O %S";
$makeindex  = 'makeindex -s indexstyle.ist %O -o %D %S';
