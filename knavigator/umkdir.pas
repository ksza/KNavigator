unit UMkDir;

interface
  uses crt, UBWin, UShadow, UButton, UWindow;
  type TMkDir=object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; ITitle, IStri: string);
         function GetDir(DirInitial: string): string;
         destructor done;

         private
           Shadow: TShadow;
           GetDirWin: TWin;
           Button1, Button2: TButton;
           Dir, Title, Stri: string;
           CurentWin, CurentButton: 1..3;
           bb: boolean;
       end;

implementation
  constructor TMkDir.init;
    var q, w: integer;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 30, 9);
      inherited init(ITopx, ITopy, 30, 9, LightGray, White);
      textcolor(white);

      Stri:=IStri;
      Title:=ITitle;
      Title:=' ' + Title + ' ';
      q:=15; w:=length(Title);
      while (q > (32 - (q + w - 1))) do
        dec(q);
      gotoxy(q ,1); write(Title);

      gotoxy(4, 2); write(Stri);

      GetDirWin.init(ITopx + 3, ITopy + 2, 20, 1, blue, white);
      SetFocus;
      Button1.init(5, 6, 'OK', LightGray);
      Button2.init(15, 6, 'Cancel', LightGray);

      GetDirWin.SetFocus; CurentWin:=1; CurentButton:=1;
    end;

  function TMkDir.GetDir;
    var c: char;
    begin
      Dir:=DirInitial;
      gotoxy(2, 1); textbackground(green); write(Dir); bb:=true;
      repeat
        c:=readkey;
        case c of
          #9: begin
                inc(CurentWin);
                if CurentWin = 3 then CurentWin:=1;
                case CurentWin of
                  1: begin
                       case CurentButton of
                         1: Button1.Out;
                         2: Button2.Out;
                       end;
                       SetFocus; gotoxy(4, 2);
                       textcolor(white); write(Stri);
                       GetDirWin.SetFocus;
                       gotoxy(2, 1);
                       textcolor(red); write('                      ');
                       gotoxy(2, 1);
                       textcolor(white); textbackground(green); write(dir);
                       bb:=true;
                     end;
                  2: begin
                       gotoxy(2, 1); textbackground(blue); write(Dir);
                       SetFocus; gotoxy(4, 2);
                       textcolor(Black); write(Stri);
                       case CurentButton of
                         1: Button1.SetFocus;
                         2: Button2.SetFocus;
                       end;
                     end;
                  {3: begin
                       Button1.Out;
                       Button2.SetFocus;
                     end;}
                end;
              end;
          #75: if CurentWin = 2 then begin
                 inc(CurentButton);
                 if CurentButton = 3 then CurentButton:=1;
                 case CurentButton of
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
          #77: if CurentWin = 2 then begin
                 dec(CurentButton);
                 if CurentButton = 0 then CurentButton:=2;
                 case CurentButton of
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

          #13: begin
                 case CurentWin of
                   1: begin
                        gotoxy(2, 1); textbackground(blue); write(Dir);
                        SetFocus;
                        CurentButton:=1;
                        Button1.SetFocus; CurentWin:=2;
                      end;
                   2: begin
                        GetDir:=Dir;
                        SetFocus; done; break;
                      end;
                   {3: begin
                        GetDir:='';
                        SetFocus; done; break;
                      end;}
                 end;
               end;
          else
            if (CurentWin = 1)and((ord(c) in [48..57])or
               (ord(c) in [65..90])or(ord(c) in [97..122])or
               (ord(c) in [31, 40, 41, 42, 46, 91, 93, 123, 125])or(c = #8))and
               (ord(c) <> 0) then
              if c = #8 then begin
                if bb = true then begin
                  Dir:=''; bb:=false;
                end
                else delete(Dir, length(Dir), 1);
                textbackground(blue);
                gotoxy(2, 1); write('                     ');
                gotoxy(2, 1); write(Dir);
              end
              else
                if (length(dir) < 12) then begin
                  dir:=dir + char(c); textbackground(blue);
                  if bb = true then begin
                    gotoxy(2, 1); write(Dir); bb:=false;
                  end
                  else write(char(c));
                end;
        end;
      until c = #27;

      if c = #27 then begin
        GetDir:=''; done;
      end;
    end;

  destructor TMkDir.done;
    begin
      GetDirWin.done; Button1.done; Button2.done;
      inherited done;
      Shadow.done;
    end;

end.