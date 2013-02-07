unit UAbout;

interface
  uses crt, UBWin, UButton, UShadow;
  type TAbout = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer);
         procedure WriteString(sir: string; lin: integer);
         procedure Select;
         destructor done;

         public
           Shadow: TShadow;
           Button: TBUtton;
       end;

implementation
  constructor TAbout.init(ITopx, ITopy: integer);
    var Title: string;
        q, w: integer;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 30, 16);
      inherited init(ITopx, ITopy, 30, 16, LightGray, White);

      Title:='Despre';
      Title:=' ' + Title + ' ';
      q:=15; w:=length(Title);
      while (q > (32 - (q + w - 1))) do
        dec(q);
      gotoxy(q ,1); write(Title);

      WriteString('K - Navigator', 3);
      WriteString('Versiunea 1.11', 5);
      WriteString('May 19, 2004', 6);
      WriteString('Copyright (C) 2004', 8);
      WriteString('Sz' + Chr(134) + 'nt' + Chr(149) + ' ' + 'K' + Chr(134) + 'roly', 9);
      WriteString(Chr(247) + ' ' + 'Atestat' + ' ' + Chr(247), 11);

      Button.init(13, 13, 'OK', LightGray);
      Button.SetFocus;
    end;

  procedure TAbout.WriteString(sir: string; lin: integer);
    begin
      while (Length(sir) + 2 <= 28) do
        sir:=' ' + sir + ' ';

      gotoxy(2, lin); write(sir);
    end;

  procedure TAbout.Select;
    var Key: char;
    begin
      repeat
        Key:=readkey;
      until (Key = #13)or(Key = #27);
      done;
    end;

  destructor TAbout.done;
    begin
      Button.done;
      inherited done;
      Shadow.done;
    end;
end.