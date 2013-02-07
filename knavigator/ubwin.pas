unit UBWin; { Contine clasa TBorderedWin }

interface
  uses crt, UWindow;
  const BGColor: byte = blue;   { Constante pt culorile ferestrei }
        TXTColor: byte = white;
        CSS=201; { Colt stanga sus }
        CDS=187; { Colt dreapta sus }
        CSJ=200; { Colt stanga jos }
        CDJ=188; { Colt drepta jos }
        CO=205; { Caracter orizontal }
        CV=186; { Caracter vertical }
  type TBorderedWin=object(TWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer; IBgColor, ITxtColor: byte);
         procedure DrawBorders;
         destructor done;

         private
           FWidth, K: integer;
       end;

implementation
  constructor TBorderedWin.init;
    var s: string;
        ca: char;
    begin
      inherited init(ITopx, ITopy, IWidth, IHeight, IBgColor, ITxtColor);

      FWidth:=IWidth;
      K:=IHeight - 1;

      DrawBorders;
    end;

  procedure TBorderedWin.DrawBorders;
    var lin, col: integer;
    begin
      textcolor(White);

      { Deseneaza colturile }
      gotoxy(1, 1); write(chr(CSS));
      gotoxy(FWidth, 1); write(chr(CDS));
      gotoxy(1, K); write(chr(CSJ));
      gotoxy(FWidth, K); write(chr(CDJ));

      { Deseneaza caracterele orizontale }
      for col:=2 to FWidth - 1 do begin
        gotoxy(col, 1); write(chr(CO));
        gotoxy(col, K); write(chr(CO));
      end;

      { Deseneaza caracterele verticale }
      for lin:=2 to k - 1 do begin
        gotoxy(1, lin); write(chr(CV));
        gotoxy(FWidth, lin); write(chr(CV));
      end;
    end;

  destructor TBorderedWin.done;
    begin
      inherited done;
    end;
end.