#!/usr/bin/env fish

function svg-opt
   inkscape --verb=EditSelectAll --verb=AlignHorizontalCenter --verb=AlignVerticalCenter --verb=FitCanvasToSelectionOrDrawing --verb=FileSave --verb=FileQuit $argv
   npx svgo $argv
end

svg-opt $argv
