unit USort;

interface

uses crt, UBWin, UShadow;
const v: array[1..4]of string = ('&Nume      ',
                                 '&Extensie  ',
                                 '&Dimensiune',
                                 '&Data      ');
      VCount = 4;
type TSort = object(TBorderedWin)
       constructor init(ITopx, ITopy: integer);
       procedure afisare(lin, col: integer; s: string; TBColor: word);
       function Navigate: byte;
       destructor done;

       public
         Shadow: TShadow;
     end;

implementation
  constructor TSort.init(ITopx, ITopy: integer);
    var lin, col, K, IHeight, IWidth: integer;
    begin
      IWidth:=14; IHeight:=3 + VCount;

      Shadow.init(Itopx + 1, ITopy + 1, IWidth, IHeight);
      inherited init(ITopx, ITopy, IWidth, IHeight, LightGray, Black);

      K:=IHeight - 1;

      textcolor(black);
      { Deseneaza colturile }
      gotoxy(1, 1); write(chr(CSS));
      gotoxy(IWidth, 1); write(chr(CDS));
      gotoxy(1, K); write(chr(CSJ));
      gotoxy(IWidth, K); write(chr(CDJ));

      { Deseneaza caracterele orizontale }
      for col:=2 to IWidth - 1 do begin
        gotoxy(col, 1); write(chr(CO));
        gotoxy(col, K); write(chr(CO));
      end;

      { Deseneaza caracterele verticale }
      for lin:=2 to k - 1 do begin
        gotoxy(1, lin); write(chr(CV));
        gotoxy(IWidth, lin); write(chr(CV));
      end;

      for lin:=1 to VCount do
        afisare(lin + 1, 3, v[lin], LightGray);

    end;

  procedure TSort.afisare(lin, col: integer; s: string; TBColor: word);
    var i: integer;
    begin
      gotoxy(col, lin); textbackground(TBColor);
      i:=0;
      repeat
        inc(i);
        if s[i] = '&' then begin
          textcolor(red);
          inc(i);
          write(s[i]);
          textcolor(black);
        end
        else write(s[i]);
      until i = length(s);
      textbackground(LightGray);
    end;

  function TSort.Navigate: byte;
    var lin, col, j, nr: integer;
        s: string;
        c: char;
    begin
      lin:=2; col:=3; nr:=1;
      afisare(lin, col, v[nr], Green);
      repeat
        c:=readkey;
        case c of
          #72: begin
                 afisare(lin, col, v[nr], LightGray);
                 dec(nr);
                 if nr = 0 then begin
                   nr:=VCount;
                   lin:=1 + VCount;
                 end
                 else dec(lin);
                 afisare(lin, col, v[nr], Green);
               end;
          #80: begin
                 afisare(lin, col, v[nr], LightGray);
                 inc(nr);
                 if nr > VCount then begin
                   nr:=1;
                   lin:=2;
                 end
                 else inc(lin);
                 afisare(lin, col, v[nr], Green);
               end;
          #13: Navigate:=nr;
          #27: Navigate:=0;
        end;
      until (c = #27)or(c = #13);

      done;
    end;

  destructor TSort.done;
    begin
      inherited done;
      Shadow.done;
    end;
end.