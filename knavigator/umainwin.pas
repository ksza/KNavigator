unit UMainWin; { Contine clasa TMainWin }

interface
  uses crt, UbWin;
  const LV = 179; { Linie verticala }
        LO = 196; { Linie orizontala }
        CL = 193; { Realizeaza intersectia intre liniile vertic si cele oriz}
  type TMainWin=object(TBorderedWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer);
         procedure draw;
         destructor done;

         private
           FWidth: integer;
       end;

implementation
  constructor TMainWin.init;
    begin
      inherited init(ITopx, ITopy, IWidth, IHeight, Blue, White);

      FWidth:=IWidth;
      draw;
    end;

  procedure TMainWin.draw;
    var lin, col: integer;
    begin
      textcolor(White); textbackground(blue);

      { Deseneaza liniile despartitoare verticale }
      col:=1;
      for lin:=2 to 15 do begin
        gotoxy(col + 13, lin); write(chr(LV));
        gotoxy(col + 13 + 13, lin); write(chr(LV));
      end;

      { Deseneaza liniile despartitoare orizontale }
      lin:=16;
      for col:=2 to FWidth - 1 do begin
        gotoxy(col, lin);
        if (col in [14, 27]) then write(chr(CL))
        else write(chr(LO));
      end;

      col:=2; textcolor(yellow);
      repeat
        gotoxy(col, 2); write('    Nume    ');
        inc(col, 13);
      until col > 28; textcolor(white);
    end;

  destructor TMainWin.done;
    begin
      inherited done;
    end;

end.