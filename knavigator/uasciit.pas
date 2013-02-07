unit UAsciiT; { contine clasa TAsciiT }

interface
  uses crt, UBWin, UShadow;
  const Cursor_Color = Green;
  type TAsciiT = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer);
         function Baza16(n: integer): integer;
         procedure Navigate;
         destructor done;

         public
           Shadow: TShadow;
           CursorX, CursorY, Poz: integer;
       end;

implementation
  constructor TAsciiT.init(ITopx, ITopy: integer);
    var i: integer;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 53, 10);
      inherited init(ITopx, ITopy, 53, 10, LightGray, Black);

      gotoxy(20, 1); write(' Tabela ASCII ');

      CursorX:=2; CursorY:=2;
      textbackground(LightGray); textcolor(black);
      for i:=1 to 255 do begin
        gotoxy(CursorX, CursorY); write(Chr(i));
        inc(CursorX);
        if (i mod 51) = 0 then begin
          CursorX:=2; inc(CursorY);
        end;
      end;

      CursorX:=2; CursorY:=2; Poz:=1;

      gotoxy(CursorX, CursorY); textbackground(Cursor_Color);
      write(chr(Poz));

      textbackground(LightGray); textcolor(white);
      for i:=2 to 52 do begin
        gotoxy(i, 7); write(Chr(196));
      end;

      gotoxy(2, 8);
      write('      Caracter:        Dec:          Hex:          ');
      gotoxy(18, 8); write(Chr(Poz));
      gotoxy(30, 8); write('   '); gotoxy(30, 8); write(Poz);
      gotoxy(44, 8); write('   '); gotoxy(44, 8); write(Baza16(Poz));


      Navigate;
    end;

  function TAsciiT.Baza16(n: integer): integer;
    begin
      Baza16:=0; { de rezolvat }
    end;

  procedure TAsciiT.Navigate;
    var c: char;
    begin
      repeat
        c:=readkey;

        case c of
          #72: begin  { up }
                 if CursorY > 2 then begin
                   gotoxy(CursorX, CursorY); textbackground(LightGray);
                   textcolor(black); write(Chr(Poz));

                   dec(CursorY); Poz:=Poz - 51; gotoxy(CursorX, CursorY);
                   textbackground(Cursor_Color); write(Chr(Poz));

                   textbackground(LightGray); textcolor(white);
                   gotoxy(18, 8); write(Chr(Poz));
                   gotoxy(30, 8); write('   '); gotoxy(30, 8); write(Poz);
                   gotoxy(44, 8); write('   '); gotoxy(44, 8); write(Baza16(Poz));
                 end;
               end;
          #80: begin  { down }
                 if CursorY < 6 then begin
                   gotoxy(CursorX, CursorY); textbackground(LightGray);
                   textcolor(black); write(Chr(Poz));

                   inc(CursorY); Poz:=Poz + 51; gotoxy(CursorX, CursorY);
                   textbackground(Cursor_Color); write(Chr(Poz));

                   textbackground(LightGray); textcolor(white);
                   gotoxy(18, 8); write(Chr(Poz));
                   gotoxy(30, 8); write('   '); gotoxy(30, 8); write(Poz);
                   gotoxy(44, 8); write('   '); gotoxy(44, 8); write(Baza16(Poz));
                 end;
               end;
          #75: begin  { left }
                 if CursorX > 2 then begin
                   gotoxy(CursorX, CursorY); textbackground(LightGray);
                   textcolor(black); write(Chr(Poz));

                   dec(CursorX); Poz:=Poz - 1; gotoxy(CursorX, CursorY);
                   textbackground(Cursor_Color); write(Chr(Poz));

                   textbackground(LightGray); textcolor(white);
                   gotoxy(18, 8); write(Chr(Poz));
                   gotoxy(30, 8); write('   '); gotoxy(30, 8); write(Poz);
                   gotoxy(44, 8); write('   '); gotoxy(44, 8); write(Baza16(Poz));
                 end;
               end;
          #77: begin  { right }
                 if CursorX < 52 then begin
                   gotoxy(CursorX, CursorY); textbackground(LightGray);
                   textcolor(black); write(Chr(Poz));

                   inc(CursorX); Poz:=Poz + 1; gotoxy(CursorX, CursorY);
                   textbackground(Cursor_Color); write(Chr(Poz));

                   textbackground(LightGray); textcolor(white);
                   gotoxy(18, 8); write(Chr(Poz));
                   gotoxy(30, 8); write('   '); gotoxy(30, 8); write(Poz);
                   gotoxy(44, 8); write('   '); gotoxy(44, 8); write(Baza16(Poz));
                 end;
               end;
        end;
      until c = #27;
    end;

  destructor TAsciiT.done;
    begin
      inherited done;
      Shadow.done;
    end;

end.