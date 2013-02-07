unit USearchF; { Search For Files }

interface
  uses crt, dos, UBWin, UShadow, UPrompt;
  const max = 5;
        CursorColor: word = Cyan;
  type reper2 = ^element2;
       element2 = record
         director, val_init: string;
         link: reper2;
       end;
       inregistrare = record
         sir, cale, nume_fisier: string;
       end;
       fisier = file of inregistrare;

       TSearchForFiles = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; IFileMask, Dir, Dir_Curent: string);
         procedure ExecCommand(Command: String);
         procedure AddFiles(FileMask: string; var fis: fisier);
         function Navigate(var FileName: string): string;
         procedure MoveCursorUp(Nr: LongInt);
         procedure MoveCursorDown(Nr: LongInt);
         procedure afisare(xx, yy: integer; TxtColor, BgColor: word; Text: string);
         procedure CentreazaTitlu(Titlu: string; linie: integer);
         procedure CentreazaText(Text: string);
         destructor done;

         public
           Structura: fisier;
           Shadow: TShadow;
           k: LongInt;
           Block: inregistrare;
           x, y, rr: integer;
           Curent_Directory: string;
           numar: LongInt;
       end;


implementation
  constructor TSearchForFiles.init(ITopx, ITopy: integer; IFileMask, Dir, Dir_Curent: string);
    var Stiva, p, vf: reper2;
        D: SearchRec;
        j, q, w: integer;
        inreg: inregistrare;
        Title, nr, DirCautareCurenta: string;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 70, 10);
      inherited init(ITopx, ITopy, 70, 10, White, LightGray);

      CentreazaTitlu('Cautare:' + ' ' + IFileMask, 1);
      numar:=0;
      CentreazaTitlu('0 fisiere gasite', 9);

      if (length(Dir_Curent) > 3) then
        Dir_Curent:=Dir_Curent + '\';
      DirCautareCurenta:=Dir;
      if length(DirCautareCurenta) > 3 then
        DirCautareCurenta:=DirCautareCurenta + '\';
      Curent_Directory:=Dir_Curent;
      assign(Structura, Dir_Curent + 'sortare.tmp'); rewrite(Structura);
      ChDir(Dir);
      j:=length(Dir);
      while (Dir[j] <> '\')and(j > 0) do
        dec(j);
      delete(Dir, 1, j);
      new(Stiva); new(vf);
      Stiva^.director:=''; Stiva^.val_init:='';
      vf^.director:=Dir; vf^.val_init:=''; vf^.link:=Stiva;
      repeat
        FindFirst('*', Directory, D);
        FindNext(D);
        while ((D.name <> vf^.val_init)and(DosError = 0)) do
          FindNext(D);
        if (DosError <> 0) then begin
          FindFirst('*', Directory, D);
          FindNext(D);
          FindNext(D);
        end
        else
          FindNext(D);
        if (DosError = 0) then begin
          {$I-}
          ChDir(D.name);
          {$I+}
          if (IOResult = 0) then begin
            new(p); p^.director:=D.name;
            p^.link:=vf; vf^.val_init:=D.name; vf:=p;
            {if length(DirCautareCurenta) > 3 then
              DirCautareCurenta:=DirCautareCurenta + '\';}
            DirCautareCurenta:=DirCautareCurenta + D.name + '\';
            CentreazaText(DirCautareCurenta);
          end
          else
            vf^.val_init:=D.name;
        end
        else begin
          AddFiles(IFileMask, Structura);
          ExecCommand('CD..');
          if length(DirCautareCurenta) > 3 then begin
            rr:=length(DirCautareCurenta) - 1;
            while (DirCautareCurenta[rr] <> '\') do
              dec(rr);
            delete(DirCautareCurenta, rr + 1, length(DirCautareCurenta) - rr);
          end;
          CentreazaText(DirCautareCurenta);
          p:=vf; vf:=vf^.link; dispose(p);
        end;
      until (vf = Stiva);
      dispose(Stiva); close(Structura);
    end;

  function TSearchForFiles.Navigate(var FileName: string): string;
    var c: char;
        inreg: inregistrare;
        NrInreg: LongInt;
        aux: LongInt;
        Butoane: vect;
        PromptWin: TPromptWin;
        Prompt_Value, nr: string;
        q: integer;
    begin
      if (numar <> 0) then begin
        textcolor(White); textbackground(LightGray);

        str(numar, nr);
        CentreazaTitlu(nr + ' ' + 'fisiere gasite', 9);

        gotoxy(7, 2); write('Nr');
        gotoxy(20, 2); write('Nume');
        gotoxy(49, 2); write('Cale');

        for q:=2 to 69 do begin
          gotoxy(q, 3); write(chr(196));
        end;

      gotoxy(14, 2); write(chr(179));
      gotoxy(30, 2); write(chr(179));

      gotoxy(14, 3); write(chr(197));
      gotoxy(30, 3); write(chr(197));

      for q:=4 to 8 do begin
        gotoxy(2, q); write(chr(179));
      end;

        k:=0; x:=4; y:=2;
        assign(Structura, Curent_Directory + 'sortare.tmp'); reset(Structura);
          NrInreg:=FileSize(Structura);

          seek(Structura, k); read(Structura, inreg);
          afisare(y, x, White, CursorColor, inreg.sir);

          aux:=k + 1;
          while ((aux <= 4)and(aux <= (NrInreg - 1))) do begin
            seek(Structura, aux); read(Structura, inreg);
            afisare(y, x + aux, White, LightGray, inreg.sir);
            inc(aux);
          end;
          seek(Structura, k);
          repeat
            c:=readkey;
            case c of
              #72: MoveCursorUp(NrInreg);
              #80: MoveCursorDown(NrInreg);
              #13: begin
                     seek(Structura, k); read(Structura, Block);
                     nr:=Block.cale;
                     if length(nr) > 3 then
                       delete(nr, length(nr), 1);
                     Navigate:=nr; FileName:=Block.nume_fisier;
                     close(Structura);
                     if (Length(Curent_Directory) > 3) then
                       delete(Curent_Directory, Length(Curent_Directory), 1);
                     ChDir(Curent_Directory);
                     ExecCommand('del' + ' ' + 'sortare.tmp');
                     done; c:=#27;
                   end;
              #27: begin
                     Navigate:=''; FileName:='';
                     close(Structura);
                     if (Length(Curent_Directory) > 3) then
                       delete(Curent_Directory, Length(Curent_Directory), 1);
                     ChDir(Curent_Directory);
                     ExecCommand('del' + ' ' + 'sortare.tmp');
                     done;
                   end;
            end;
          until (c = #27);
        end
        else begin
          Butoane[1]:='OK';
          PromptWin.init(21, 4, 'Nici un fisier gasit !', 1, Butoane, LightGray, 'Interogare');
          Prompt_Value:=PromptWin.Select;
          PromptWin.done;
        end;
    end;

  procedure TSearchForFiles.MoveCursorUp(Nr: LongInt);
    var i: integer;
        aux: inregistrare;
    begin
      if (k = 0) then
      else begin
        seek(Structura, k); read(Structura, Block);
        afisare(y, x, White, LightGray, Block.sir);
        dec(x); dec(k);
        if (x = 3) then begin
          x:=4;
          seek(Structura, k); read(Structura, Block);
          afisare(y, x, White, CursorColor, Block.sir);
          i:=k + 1;
          while (i <= (Nr - 1))and((i - k) <= 4) do begin
            seek(Structura, i); read(Structura, aux);
            afisare(y, x + (i - k), White, LightGray, aux.sir);
            inc(i);
          end;
        end
        else begin
          seek(Structura, k); read(Structura, Block);
          afisare(y, x, White, CursorColor, Block.sir);
        end;
      end;
    end;

  procedure TSearchForFiles.MoveCursorDown(Nr: LongInt);
    var i: integer;
        aux: inregistrare;
    begin
      if (k = (Nr - 1)) then
      else begin
        seek(Structura, k); read(Structura, Block);
        afisare(y, x, White, LightGray, Block.sir);
        inc(x); inc(k);
        if (x = 9) then begin
          x:=8;
          seek(Structura, k); read(Structura, Block);
          afisare(y, x, White, CursorColor, Block.sir);
          i:=k - 4;
          while (i <= (k - 1)) do begin
            seek(Structura, i); read(Structura, aux);
            afisare(y, x + (i - k), White, LightGray, aux.sir);
            inc(i);
          end;
        end
        else begin
          seek(Structura, k); read(Structura, Block);
          afisare(y, x, White, CursorColor, Block.sir);
        end;
      end;
    end;

  procedure TSearchForFiles.afisare(xx, yy: integer; TxtColor, BgColor: word; Text: string);
    begin
      textcolor(TxtColor); textbackground(BgColor);
      gotoxy(xx, yy); write(Text);
    end;

  procedure TSearchForFiles.ExecCommand(Command: String);
    begin
      if Command <> '' then
        Command := '/C ' + Command;
      SwapVectors;
      Exec(GetEnv('COMSPEC'), Command);
      SwapVectors;
      if DosError <> 0 then
        Writeln('Could not execute COMMAND.COM');
    end;

  procedure TSearchForFiles.AddFiles(FileMask: string; var fis: fisier);
    var FileInfo: SearchRec;
        f: File;
        s, sa, num: string;
        D: DirStr;
        N: NameStr;
        E: ExtStr;
        i, j: integer;
        inreg: inregistrare;
    begin
      FindFirst(FileMask, Archive + ReadOnly + SysFile + Hidden, FileInfo);
      while DosError = 0 do begin
        inc(numar);
        str(numar, num);
        CentreazaTitlu(num + ' ' + 'fisiere gasite', 9);
        s:=FileInfo.name;
        for i:=1 to length(s) do
          if s[i] in ['A'..'Z'] then
            s[i]:=chr(ord(UpCase(s[i])) + 32);

        str(Numar, num);
        for i:=length(num) to 9 do
          num:=num + ' ';
        for i:=length(s) to 12 do
          s:=s + ' ';
        with inreg do begin
          sir:='';
          sir:=sir + ' ' + num + ' ' + chr(179) + ' ' + s + ' ' + chr(179);
          FSplit(FExpand(FileInfo.name), D, N, E);

          num:=D;
          if length(num) > 36 then begin
            i:=6;
            repeat
              inc(i);
            until (length(num) - i <= 29);
            s:='';
            for j:=i to length(num) do
              s:=s + num[j];
            num:=copy(num, 1, 3);
            num:=num + '...' + s;
          end
          else
            for i:=length(num) to 36 do
              num:=num + ' ';

          sir:=sir + ' ' + num + ' ';
          cale:=D;
          nume_fisier:=FileInfo.name;
          for i:=1 to length(nume_fisier) do
            if nume_fisier[i] in ['A'..'Z'] then
              nume_fisier[i]:=chr(ord(UpCase(nume_fisier[i])) + 32);

        end;
        write(fis, inreg);

        FindNext(FileInfo);
      end;
    end;

  procedure TSearchForFiles.CentreazaTitlu(Titlu: string; linie: integer);
    var q, w: integer;
    begin
      Titlu:=' ' + Titlu + ' ';
      q:=35; w:=length(Titlu);
      while (q > (72 - (q + w - 1))) do
        dec(q);
      gotoxy(q, linie); write(Titlu);
    end;

  procedure TSearchForFiles.CentreazaText(Text: string);
    var s: string;
        i, j: integer;
    begin
      if length(Text) > 68 then begin
        i:=6;
        repeat
          inc(i);
        until (length(Text) - i <= 61);
        s:='';
        for j:=i to length(Text) do
          s:=s + Text[j];
        Text:=copy(Text, 1, 3);
        Text:=Text + '...' + s;
      end
      else
        while (Length(Text) + 2 <= 68) do
          Text:=' ' + Text + ' ';

      gotoxy(2, 4); write(Text);
    end;

  destructor TSearchForFiles.done;
    begin
      inherited done;
      Shadow.done;
    end;
end.