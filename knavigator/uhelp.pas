unit UHelp;

interface
  uses crt, dos, UBWin, UShadow;
  type inregistrare = record
         Sir: string;
       end;
       THelp = object(TBorderedWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer; IFisier, ITemp: string);
         procedure Navigate;
         procedure MoveCursorUp;
         procedure MoveCursorDown;
         procedure ClearWin;
         procedure afisare(Text: string; xx, yy: integer);
         procedure ExecCommand(Command: string);
         destructor done;

         public
           Shadow: TShadow;
           LungimeFisier, Cursor: LongInt;
           Cale_Fisier, BlankLine: string;
           FTemporar: file of inregistrare;
           Fisier: text;
           Height: integer;
       end;

implementation
  constructor THelp.init(ITopx, ITopy, IWidth, IHeight: integer; IFisier, ITemp: string);
    var LinieCurenta, Title: string;
        k, l: integer;
        aux: inregistrare;
        j: LongInt;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, IWidth, IHeight);
      inherited init(ITopx, ITopy, IWidth, IHeight, White, LightGray);

      Title:=' ' + 'Ajutor' + ' ';
      k:=IWidth div 2; l:=length(Title);
      while (k > (IWidth - (k + l - 1))) do
        dec(k);
      gotoxy(k ,1); write(Title);

      BlankLine:='';
      for j:=2 to (IWidth - 1) do
        BlankLine:=BlankLine + ' ';

      Cale_Fisier:=IFisier; Height:=IHeight;

      assign(Fisier, Cale_Fisier); reset(Fisier);
        assign(FTemporar, ITemp + 'help.tmp'); rewrite(FTemporar);
          while (not Eof(Fisier)) do begin
            Readln(Fisier, aux.sir);
            write(FTemporar, aux);
          end;
        close(FTemporar);
      close(Fisier);


      assign(FTemporar, ITemp + 'help.tmp'); reset(FTemporar);
        LungimeFisier:=FileSize(FTemporar); Cursor:=0;
        j:=Cursor;
        while (j <= (LungimeFisier - 1))and((j - Cursor) <= (Height - 4)) do begin
          Seek(FTemporar, j); Read(FTemporar, aux);
          afisare(aux.sir, 2, j - Cursor + 2);
          inc(j);
        end;

        Navigate;
      close(FTemporar);
      ExecCommand('del' + ' ' + ITemp + 'help.tmp');
    end;

  procedure THelp.Navigate;
    var c: char;
    begin
      repeat
        c:=readkey;
        case c of
          #72: MoveCursorUp;
          #80: MoveCursorDown;
        end;
      until c = #27;
    end;

  procedure THelp.MoveCursorUp;
    var j: LongInt;
        aux: inregistrare;
    begin
      if (Cursor > 0) then begin
        ClearWin;
        dec(Cursor); j:=Cursor;
        while (j <= (LungimeFisier - 1))and((j - Cursor) <= (Height - 4)) do begin
          Seek(FTemporar, j); Read(FTemporar, aux);
          afisare(aux.sir, 2, j - Cursor + 2);
          inc(j);
        end;
      end;
    end;

  procedure THelp.MoveCursorDown;
    var j: LongInt;
        aux: inregistrare;
    begin
      if (Cursor < (LungimeFisier - 1))and((LungimeFisier - Cursor) > (Height - 3)) then begin
        ClearWin;
        inc(Cursor); j:=Cursor;
        while (j <= (LungimeFisier - 1))and((j - Cursor) <= (Height - 4)) do begin
          Seek(FTemporar, j); Read(FTemporar, aux);
          afisare(aux.sir, 2, j - Cursor + 2);
          inc(j);
        end;
      end;
    end;

  procedure THelp.ClearWin;
    var j: integer;
    begin
      TextColor(LightGray); TextBackground(LightGray);
      for j:=2 to (Height - 2) do begin
        gotoxy(2, j); write(BlankLine);
      end;
    end;

  procedure THelp.ExecCommand(Command: String);
    begin
      if Command <> '' then
        Command := '/C ' + Command;
      SwapVectors;
      Exec(GetEnv('COMSPEC'), Command);
      SwapVectors;
      if DosError <> 0 then
        Writeln('Could not execute COMMAND.COM');
    end;

  procedure THelp.afisare(Text: string; xx, yy: integer);
    begin
      if Text[1] = '&' then begin
        TextColor(White);
        delete(Text, 1, 1);
      end
      else TextColor(Black);

      gotoxy(xx, yy); write(Text);
    end;

  destructor THelp.done;
    begin
      inherited done;
      Shadow.done;
    end;

end.