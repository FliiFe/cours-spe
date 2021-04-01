# vim: syntax=perl
$out_dir = 'build';
$pdflatex = "pdflatex -interaction=nonstopmode %O %S -file-line-error";
$makeindex  = 'makeindex -s indexstyle.ist %O -o %D %S';
$pdf_mode = 1
