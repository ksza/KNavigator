unit USearch;

interface
  uses crt, UBWin, UShadow, UButton, UWindow;
  const VCount = 4;
        v: array[1..VCount]of string = ('&File mask', '&Text to find', 'Options', 'Scope');
  type inregistrare = record
         selectat: boolean;
         poz_x, poz_y: integer;
         s: string;
       end;
       vector = array[1..3]of inregistrare;
       TSearch = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer);
         procedure afisare(lin, col: integer; s: string; TColor: word);
         procedure Navigate(var s1, s2, s3, s4: string);
         destructor done;

         public
           Shadow: TShadow;
           FileMaskWin, TextToFindWin: TWin;
           Button1, Button2: TButton;
           v1, v2: vector;
           CurrentWin: 0..6;
           CurrentButton: 0..3;
           WinCursor3: 0..3;
           WinCursor4: 0..4;
       end;

implementation
  constructor TSearch.init(ITopx, ITopy: integer);
    var Title: string;
        q, w: integer;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 50, 16);
      inherited init(ITopx, ITopy, 50, 16, LightGray, white);

      Title:='Cutare';
      Title:=' ' + Title + ' ';
      q:=25; w:=length(Title);
      while (q > (52 - (q + w - 1))) do
        dec(q);
      gotoxy(q ,1); write(Title);


      v1[1].selectat:=false; v1[1].s:='[ ] Fragment din cuvant';
      v1[1].poz_x:=7; v1[1].poz_y:=6;
      v1[2].selectat:=true; v1[2].s:='[x] Tot cuvantul';
      v1[2].poz_x:=8; v1[2].poz_y:=6;
      WinCursor3:=2;

      v2[1].selectat:=false; v2[1].s:='( ) Tot discul';
      v2[1].poz_x:=11; v2[1].poz_y:=6;
      v2[2].selectat:=true; v2[2].s:='(*) Director curent';
      v2[2].poz_x:=12; v2[2].poz_y:=6;
      v2[3].selectat:=false; v2[3].s:='( ) Toate drive-urile';
      v2[3].poz_x:=11; v2[3].poz_y:=26;
      WinCursor4:=2;

      afisare(2, 4, v[1], White);
      FileMaskWin.init(ITopx  + 4 + (length(v[1]) - 1) + 1, ITopy + 1, 20, 1, blue, white);
      SetFocus;
      afisare(4, 4, v[2], Black);
      TextToFindWin.init(ITopx + 4 + (length(v[2]) - 1) + 1, ITopy + 3 , 20, 1, blue, white);
      SetFocus;

      afisare(6, 4, v[3], Black);
        afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, Black);
        afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, Black);

      afisare(10, 4, v[4], Black);
        afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, Black);
        afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, Black);
        afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, Black);

      button1.init(17, 14, 'OK', LightGray);
      button2.init(29, 14, 'Cancel', LightGray);

      CurrentWin:=1; CurrentButton:=1;
      FileMaskWin.SetFocus;
    end;

  procedure TSearch.Navigate(var s1, s2, s3, s4: string);
    var c: char;
        i: integer;
        FileMaskStr, FileNameStr: string;
        bb, bbb: boolean;
    begin
      FileMaskStr:=''; FileNameStr:=''; bb:=true; bbb:=true;
      repeat
        c:=readkey;
        case c of
          #9: begin
                inc(CurrentWin);
                if CurrentWin = 6 then CurrentWin:=1;

                case CurrentWin of
                  1: begin
                       if (CurrentButton = 1) then Button1.Out
                       else Button2.Out;

                       SetFocus;
                       afisare(2, 4, v[1], White);
                       FileMaskWin.SetFocus;
                       clrscr; gotoxy(2, 1);
                       textcolor(white); textbackground(green);
                       write(FileMaskStr); bb:=true;
                     end;
                  2: begin
                       gotoxy(2, 1); textbackground(blue);
                       write(FileMaskStr);
                       SetFocus;
                       afisare(2, 4, v[1], Black);

                       afisare(4, 4, v[2], White);
                       TextToFindWin.SetFocus;
                       clrscr; gotoxy(2, 1);
                       textcolor(white); textbackground(green);
                       write(FileNameStr); bbb:=true;
                     end;
                  3: begin
                       gotoxy(2, 1); textbackground(blue);
                       write(FileNameStr);
                       SetFocus;
                       afisare(4, 4, v[2], Black);

                       WinCursor3:=1;
                       afisare(6, 4, v[3], White);
                         for i:=1 to 2 do
                           with v1[i] do
                             if (i = WinCursor3) then
                               afisare(poz_x, poz_y, s, White)
                             else afisare(poz_x, poz_y, s, Black);
                     end;
                  4: begin
                       afisare(6, 4, v[3], Black);
                         afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, Black);
                         afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, Black);

                         WinCursor4:=1;
                         afisare(10, 4, v[4], White);
                           for i:=1 to 3 do
                             with v2[i] do
                               if (i = WinCursor4) then
                                 afisare(poz_x, poz_y, s, White)
                               else afisare(poz_x, poz_y, s, Black);
                     end;
                  5: begin
                         afisare(10, 4, v[4], Black);
                           afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, Black);
                           afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, Black);
                           afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, Black);

                         case CurrentButton of
                           1: Button1.SetFocus;
                           2: Button2.SetFocus;
                         end;
                     end;
                end;
              end;
          #72: case CurrentWin of
                 3: begin
                      dec(WinCursor3);
                      if (WinCursor3 = 0) then WinCursor3:=2;

                      case WinCursor3 of
                        1:  begin
                              afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, Black);
                              afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, White);
                            end;
                        2: begin
                              afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, Black);
                              afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, White);
                           end;
                      end;
                    end;
                 4:begin
                      dec(WinCursor4);
                      if (WinCursor4 = 0) then WinCursor4:=3;

                      case WinCursor4 of
                        1:  begin
                              afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, Black);
                              afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, White);
                            end;
                        2: begin
                              afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, Black);
                              afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, White);
                           end;
                        3: begin
                              afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, Black);
                              afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, White);
                           end;
                      end;
                    end;
               end;
          #80: case CurrentWin of
                 3: begin
                      inc(WinCursor3);
                      if (WinCursor3 = 3) then WinCursor3:=1;

                      case WinCursor3 of
                        1:  begin
                              afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, Black);
                              afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, White);
                            end;
                        2: begin
                              afisare(v1[1].poz_x, v1[1].poz_y, v1[1].s, Black);
                              afisare(v1[2].poz_x, v1[2].poz_y, v1[2].s, White);
                           end;
                      end;
                    end;
                 4:begin
                      inc(WinCursor4);
                      if (WinCursor4 = 4) then WinCursor4:=1;

                      case WinCursor4 of
                        1:  begin
                              afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, Black);
                              afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, White);
                            end;
                        2: begin
                              afisare(v2[1].poz_x, v2[1].poz_y, v2[1].s, Black);
                              afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, White);
                           end;
                        3: begin
                              afisare(v2[2].poz_x, v2[2].poz_y, v2[2].s, Black);
                              afisare(v2[3].poz_x, v2[3].poz_y, v2[3].s, White);
                           end;
                      end;
                    end;
               end;
          #75: case CurrentWin of
                 5: begin
                      dec(CurrentButton);
                      if (CurrentButton = 0) then CurrentButton:=2;

                      case CurrentButton of
                        1: begin
                             Button2.Out;
                             Button1.SetFocus;
                           end;
                        2: begin
                             Button1.Out;
                             Button2.SetFocus;
                           end;
                      end;
                    end;
               end;
          #77: case CurrentWin of
                 5: begin
                      inc(CurrentButton);
                      if (CurrentButton = 3) then CurrentButton:=1;

                      case CurrentButton of
                        1: begin
                             Button2.Out;
                             Button1.SetFocus;
                           end;
                        2: begin
                             Button1.Out;
                             Button2.SetFocus;
                           end;
                      end;
                    end;
               end;
        #13: case CurrentWin of
               1: begin
                    gotoxy(2, 1); textbackground(blue); write(FileMaskStr);

                    SetFocus;
                    afisare(2, 4, v[1], Black);
                    CurrentButton:=1;
                    Button1.SetFocus; CurrentWin:=5;
                  end;
               2: begin
                    gotoxy(2, 1); textbackground(blue); write(FileNameStr);

                    SetFocus;
                    afisare(4, 4, v[2], Black);
                    CurrentButton:=1;
                    Button1.SetFocus; CurrentWin:=5;
                  end;
               3: begin
                    for i:=1 to 2 do
                      if (v1[i].selectat = true) then begin
                        v1[i].selectat:=false;
                        v1[i].s[2]:=' ';
                        afisare(v1[i].poz_x, v1[i].poz_y, v1[i].s, Black);
                      end;

                    with v1[WinCursor3] do begin
                      selectat:=true;
                      s[2]:='x';
                      afisare(poz_x, poz_y, s, White);
                    end;
                  end;
               4: begin
                    for i:=1 to 3 do
                      if (v2[i].selectat = true) then begin
                        v2[i].selectat:=false;
                        v2[i].s[2]:=' ';
                        afisare(v2[i].poz_x, v2[i].poz_y, v2[i].s, Black);
                      end;

                    with v2[WinCursor4] do begin
                      selectat:=true;
                      s[2]:='*';
                      afisare(poz_x, poz_y, s, White);
                    end;
                  end;
               5: case CurrentButton of
                    1: begin
                         s1:=FileMaskStr;
                         s2:=FileNameStr;
                         for i:=1 to 2 do
                           if (v1[i].selectat = true) then begin
                             s3:=copy(v1[i].s, 5, length(v1[i].s) - 4);
                             break;
                           end;
                         for i:=1 to 3 do
                           if (v2[i].selectat = true) then begin
                             s4:=copy(v2[i].s, 5, length(v2[i].s) - 4);
                             break
                           end;
                         done;
                         exit;
                       end;
                    2: begin
                         done;
                         exit;
                       end;
                  end;
             end;
          else
            case CurrentWin of
              1: if ((ord(c) in [48..57])or(ord(c) in [65..90])or
                    (ord(c) in [97..122])or
                    (ord(c) in [31, 40, 41, 42, 46, 91, 93, 123, 125])or
                    (c = #8))and(ord(c) <> 0) then
              if c = #8 then begin
                if bb = true then begin
                  FileMaskStr:=''; bb:=false;
                end
                else delete(FileMaskStr, length(FileMaskStr), 1);
                textbackground(blue);
                gotoxy(2, 1); write('                     ');
                gotoxy(2, 1); write(FileMaskStr);
              end
              else
                if (length(FileMaskStr) < 12) then begin
                  FileMaskStr:=FileMaskStr + char(c); textbackground(blue);
                  if bb = true then begin
                    gotoxy(2, 1); write(FileMaskStr); bb:=false;
                  end
                  else write(char(c));
                end;
              2: if ((ord(c) in [48..57])or(ord(c) in [65..90])or
                    (ord(c) in [97..122])or
                    (ord(c) in [31, 40, 41, 42, 46, 91, 93, 123, 125])or
                    (c = #8))and(ord(c) <> 0) then
              if c = #8 then begin
                if bbb = true then begin
                  FileNameStr:=''; bbb:=false;
                end
                else delete(FileNameStr, length(FileNameStr), 1);
                textbackground(blue);
                gotoxy(2, 1); write('                     ');
                gotoxy(2, 1); write(FileNameStr);
              end
              else
                if (length(FileNameStr) < 12) then begin
                  FileNameStr:=FileNameStr + char(c); textbackground(blue);
                  if bbb = true then begin
                    gotoxy(2, 1); write(FileNameStr); bbb:=false;
                  end
                  else write(char(c));
                end;
            end;
        end;
      until c = #27;
    end;

  procedure TSearch.afisare(lin, col: integer; s: string; TColor: word);
    var i: integer;
    begin
    if (length(s) > 0) then begin
      gotoxy(col, lin); textcolor(TColor);
      i:=0;
      repeat
        inc(i);
        if s[i] = '&' then begin
          textcolor(yellow);
          inc(i);
          write(s[i]);
          textcolor(TColor);
        end
        else write(s[i]);
      until i = length(s);
    end;
    end;

  destructor TSearch.done;
    begin
      FileMaskWin.done; TextToFindWin.done;
      button1.done; button2.done;
      inherited done;
      Shadow.done;
    end;

end.