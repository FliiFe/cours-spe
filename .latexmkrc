# vim: syntax=perl
$out_dir = 'build';
$xelatex = "xelatex -interaction=nonstopmode %O %S -file-line-error";
$makeindex  = 'makeindex -s indexstyle.ist %O -o %D %S';
$pdf_mode = 5
