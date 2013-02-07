unit UMain; { Contine clasele TMainForm - Unitul principal; TInformation }

interface
  uses crt, dos, UMainWin;
  const CO=205; { Caracter orizontal }
  type reper = ^element;
       element = record
                   name, real_name: string[8 + 1];
                   ext, real_ext: string[3];
                   tip: char;
                   selected: boolean;
                   {Attr: byte;}
                   Time, Size: longint;
                   ant, link: reper;
                 end;
       inregistrare = record
                        selectat, exista: boolean;
                      end;
       vector=array['A'..'Z']of inregistrare;
       TMainForm=object(TMainWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer;
                          ICurent_Dir: String);
         destructor done;

         constructor BuildSortedContent(var santin1, santin2: reper; Sort: byte);
         constructor ini;
         procedure ShowSortedContent;
         destructor DestructSortedContent(var santin1, santin2: reper);

         procedure FindDrives(var v: vector);
         procedure ShowDrives1;
         procedure ShowDrives2;

         procedure ShowCurentDir(culoare: byte);
         procedure ShowItem;
         procedure ShowCurentDiskFree;
         procedure ShowSelectedInfo;

         procedure refresh;
         procedure refreshFTS(IFTS: Word);  { IFTS = IFile Types }

         constructor BuildCursor;
         destructor DestructCursor;
         procedure MoveCursorUp;
         procedure MoveCursorDown;
         procedure MoveCursorLeft;
         procedure MoveCursorRight;
         procedure Select_FD;
         procedure OnClickEvent(sir: string);
         procedure ClearMainWin;

         function FileExists(FileName: String): boolean;
         function ValidFileAttr(NumeFisier: string; Attr: word): boolean;
         procedure SetFileAttr(NumeFisier: string; Attr: word);
         function SelectedFilesExist: boolean;

         public
           sant1, sant2, k, k_aux, selectie: reper;
           X, Y, hei: integer;
           Cale: string;
           drives: vector;
           curent_drive: char;
           SelectedItmNr, SelectedItmSize: Longint;
           FTS: Word; { File Types }
           Sortare: byte;
       end;

implementation

  procedure TMainForm.ShowDrives1;
    var dr: char;
        i: integer;
    begin
      SetColor(Blue, White);
      i:=2;
      gotoxy(i, hei - 1); write('[ '); inc(i, 2);
      for dr:='A' to 'Z' do
        if drives[dr].exista = true then begin
          if drives[dr].selectat = true then
            SetColor(Blue, Yellow);
          if i = 4 then begin
            gotoxy(i, Hei - 1); write(dr); inc(i);
          end
          else begin
            gotoxy(i, Hei - 1); inc(i, 2); write(' ',dr);
          end;
          SetColor(Blue, White);
        end;
      gotoxy(i, Hei - 1); write(' ]');
      ShowCurentDiskFree;
    end;

  procedure TMainForm.ShowDrives2;
    var dr: char;
        i: integer;
    begin
      SetColor(Blue, White);
      i:=2;
      for dr:='A' to 'Z' do
        if drives[dr].exista = true then begin
          if i = 2 then begin
            gotoxy(i, Hei - 1); write('[ ', dr); inc(i, 3);
          end
          else begin
            gotoxy(i, Hei - 1); inc(i, 2); write(' ',dr);
          end;
          SetColor(Blue, White);
        end;
      gotoxy(i, hei - 1); write(' ]');
      ShowCurentDiskFree;
    end;

  constructor TMainForm.init;
    type inregistrare=record
           tip: word;
           selectat: boolean;
         end;
    var f: file of inregistrare;
        curent_inreg: inregistrare;
        i: 0..5;
    begin
      inherited init(ITopx, ITopy, IWidth, IHeight);

      assign(f, ICurent_Dir + '\Res\FTypes.res'); reset(f);
        FTS:=0; Sortare:=1;
        for i:=1 to 5 do begin
          read(f, curent_inreg);
          if curent_inreg.selectat = true then
            FTS:=FTS + Curent_Inreg.tip;
        end;
      close(f);
      hei:=IHeight;
      FindDrives(drives);
      Curent_drive:=ICurent_Dir[1]; drives[curent_drive].selectat:=true;
      Cale:=ICurent_Dir; ChDir(Cale);
      SelectedItmNr:=0; SelectedItmSize:=0;
      BuildSortedContent(sant1, sant2, Sortare);
      ini;
      ShowSortedContent; ShowCurentDir(blue); ShowItem;
    end;

  destructor TMainForm.done;
    begin
      inherited done;
    end;

  constructor TMainForm.BuildSortedContent(var santin1, santin2: reper; Sort: byte);
    var DirInfo: SearchRec;     { For Windows, use TSearchRec }
        s, sa: string;
        s1, s2: reper;
        p, w, t: reper;
        i, j: integer;
    begin
      { Gaseste si memoreaza directoarele }
      SelectedItmNr:=0; SelectedItmSize:=0;

      new(santin1); new(santin2); santin1^.link:=santin2;
      santin2^.ant:=santin1;
      new(s1); new(s2); s1^.link:=s2; s2^.ant:=s1;

      FindFirst('*', Directory, DirInfo); { Same as DIR *.PAS }
        while DosError = 0 do begin
          if (DirInfo.Name <> '.')and(DirInfo.Name <> '..') then begin
            s:=DirInfo.Name;
            p:=santin1^.link;
            case Sort of
              1, 2, 3: while (p<>santin2)and(p^.Name < s) do p:=p^.link;
              4: while (p<>santin2)and(p^.Time <> DirInfo.Time) do p:=p^.link;
            end;

            if (p = santin2)and(Sort = 4) then begin
              p:=santin1^.link;
              while (p <> santin2)and(p^.Time < DirInfo.Time) do p:=p^.link;
            end;

            if (p <> santin2)and(Sort = 4) then
              while (p^.Name < DirInfo.Name)and(p^.Time = DirInfo.Time)and(p <> santin2) do p:=p^.link;

              if p=santin2 then begin
                w:=santin2;
                w^.Name:=s; w^.ext:='';
                w^.Real_Name:=s; w^.Real_ext:='';
                w^.Time:=DirInfo.Time;
                w^.tip:='D';
                w^.selected:=false;
                {w^.Attr:=DirInfo.Attr;}
                 w^.Size:=0;
                new(santin2); w^.link:=santin2; santin2^.ant:=w;
              end
              else begin
                new(w); w^.Name:=s; w^.ext:='';
                w^.Real_Name:=s; w^.Real_ext:='';
                w^.Time:=DirInfo.Time;
                w^.tip:='D';
                w^.selected:=false;
                {w^.Attr:=DirInfo.Attr;}
                 w^.Size:=0;
                t:=p^.ant;
                t^.link:=w; w^.ant:=t;
                p^.ant:=w; w^.link:=p;
              end;
          end;
            FindNext(DirInfo);
        end;

        if length(Cale) > 3 then begin
          p:=santin1;
          p^.Name:='..'; p^.ext:='';
          p^.Real_Name:='..'; p^.Real_ext:='';
          p^.tip:='D';
          p^.selected:=false;
          {p^.Attr:=DirInfo.Attr; p^.Time:=DirInfo.Time;}
           p^.Size:=0;
          new(santin1); santin1^.link:=p; p^.ant:=santin1;
        end;

          { Gaseste si memoreaza fisierele - cu atributele FTS}
            FindFirst('*.*', FTS, DirInfo); { Same as DIR *.PAS }
            while DosError = 0 do begin
              s:=''; j:=0;
              repeat
                inc(j);
                if DirInfo.Name[j]<>'.' then s:=s + DirInfo.Name[j];
              until DirInfo.Name[j]='.';

              sa:='';
              repeat
                inc(j);
                sa:=sa + DirInfo.Name[j];
              until j>=length(DirInfo.Name);

              p:=s1^.link;
              case Sort of
                1: while (p<>s2)and(p^.Name < s) do p:=p^.link;
                2: while (p<>s2)and(p^.ext <> sa) do p:=p^.link;
                3: while (p<>s2)and(p^.Size <> DirInfo.Size) do p:=p^.link;
                4: while (p<>s2)and(p^.Time <> DirInfo.Time) do p:=p^.link;
              end;

              if (p=s2)and(Sort <> 1) then begin
                p:=s1^.link;
                case Sort of
                  2: while (p<>s2)and(p^.ext < sa) do p:=p^.link;
                  3: while (p<>s2)and(p^.Size < DirInfo.Size) do p:=p^.link;
                  4: while (p<>s2)and(p^.Time < DirInfo.Time) do p:=p^.link;
                end;
                if p=s2 then begin
                  w:=s2;
                  w^.Name:=s; w^.ext:=sa;
                  w^.Real_Name:=s; w^.Real_ext:=sa;
                  w^.tip:='F';
                  w^.selected:=false;
                  {w^.Attr:=DirInfo.Attr;} w^.Time:=DirInfo.Time;
                  w^.Size:=DirInfo.Size;
                  new(s2); w^.link:=s2; s2^.ant:=w;
                end
                else begin
                  new(w); w^.Name:=s; w^.ext:=sa;
                  w^.Real_Name:=s; w^.Real_ext:=sa;
                  w^.tip:='F';
                  w^.selected:=false;
                  {w^.Attr:=DirInfo.Attr;} w^.Time:=DirInfo.Time;
                  w^.Size:=DirInfo.Size;
                  t:=p^.ant;
                  t^.link:=w; w^.ant:=t;
                  p^.ant:=w; w^.link:=p;
                end;
              end
              else begin
                case Sort of
                  2: while (p^.Name < s)and(p^.ext = sa) do p:=p^.link;
                  3: while (p^.Name < s)and(p^.Size = DirInfo.Size) do p:=p^.link;
                  4: while (p^.Name < s)and(p^.Time = DirInfo.Time) do p:=p^.link;
                end;

                new(w); w^.Name:=s; w^.ext:=sa;
                w^.Real_Name:=s; w^.Real_ext:=sa;
                w^.tip:='F';
                w^.selected:=false;
                {w^.Attr:=DirInfo.Attr;} w^.Time:=DirInfo.Time;
                w^.Size:=DirInfo.Size;
                t:=p^.ant;
                t^.link:=w; w^.ant:=t;
                p^.ant:=w; w^.link:=p;
                   end;

            FindNext(DirInfo);
                                  end;

          { Lipirea cozilor }
            t:=santin2^.ant; w:=s1^.link;
            t^.link:=w; w^.ant:=t;
            dispose(santin2); dispose(s1);
            santin2:=s2;

          p:=santin1;
          while p<>santin2 do begin
            {if (p^.name='.')or(p^.name='..') then begin
              t:=p^.link;
              p^.ant^.link:=t; t^.ant:=p^.ant;
              dispose(p); p:=t;
                                                  end;}
            if p^.tip='F' then begin
              for i:=1 to length(p^.name) do
                if p^.name[i] in ['A'..'Z'] then
                  p^.name[i]:=chr(ord(UpCase(p^.name[i])) + 32);
              for i:=1 to length(p^.real_name) do
                if p^.real_name[i] in ['A'..'Z'] then
                  p^.real_name[i]:=chr(ord(UpCase(p^.real_name[i])) + 32);
              for i:=1 to length(p^.ext) do
                if p^.ext[i] in ['A'..'Z'] then
                  p^.ext[i]:=chr(ord(UpCase(p^.ext[i])) + 32);
              for i:=1 to length(p^.real_ext) do
                if p^.real_ext[i] in ['A'..'Z'] then
                  p^.real_ext[i]:=chr(ord(UpCase(p^.real_ext[i])) + 32);
                               end;

            for i:=length(p^.name) + 1 to 8 + 1 do
              p^.name:=p^.name + ' ';
            for i:=length(p^.ext) + 1 to 3 do
              p^.ext:=' ' + p^.ext;

            p:=p^.link;
                            end;
        end;

  constructor TMainForm.ini;
    begin
    { Initializeaza poziitiile }
      k:=sant1^.link; X:=3; Y:=2;
    end;

  destructor TMainForm.DestructSortedContent(var santin1, santin2: reper);
    var p, t: reper;
    begin
      { Distrugerea vectorului }
      while (santin1^.link <> santin2) do begin
        p:=santin1^.link; t:=p^.link;
        santin1^.link:=t; t^.ant:=santin1;
        dispose(p);
      end;
      dispose(santin1); dispose(santin2);
    end;

  procedure TMainForm.ShowSortedContent;
    var p: reper;
        lin, col, i: integer;
    begin
      p:=k; lin:=2; col:=2;
      while (p<>sant2) do begin
        if lin=15 then begin
          lin:=2; col:=col + 13;
          if col=41 then break;
        end;

        if p^.selected = true then textcolor(yellow)
        else if (p^.Real_ext='exe')or(p^.Real_ext='bat')or(p^.Real_ext='com') then
               textcolor(LightCyan);
        inc(lin); gotoxy(col, lin);
        write(p^.name, p^.ext); textcolor(White);

        p:=p^.link;
      end;
    end;

  procedure TMainForm.FindDrives(var v: vector);
    var drive: char;
        director: string[3];
    begin
      for drive:='A' to 'Z' do begin
        v[drive].selectat:=false;
        director:=drive + ':\';
        {$I-}
        ChDir(director);
        {$I+}
        if IOResult <> 0 then v[drive].exista:=false
        else v[drive].exista:=true;
      end;
    end;

  procedure TMainForm.ShowCurentDir(culoare: byte);
    var contor: 0..40;
        aux_cale, a1: string;
        i, j: integer;
    begin
      SetColor(culoare, white);
      aux_cale:=cale;
      if length(aux_cale) > 38 then begin
        i:=6;
        repeat
          inc(i);
        until (length(aux_cale) - i <= 31);
        a1:='';
        for j:=i to length(aux_cale) do
          a1:=a1 + aux_cale[j];
        aux_cale:=copy(aux_cale, 1, 3);
        aux_cale:=aux_cale + '...' + a1;
      end;
      gotoxy(2, 1); write(aux_cale);
      SetColor(blue, white);
      for contor:=length(aux_cale) + 2 to 39 do begin
        gotoxy(contor, 1); write(Chr(CO));
      end;
    end;

  procedure TMainForm.ShowSelectedInfo;
    var De_Afisat, Dimensiune: string;
        ind1, ind2: integer;
    begin
      textbackground(blue);
      if SelectedItmNr = 0 then De_Afisat:='Nici un fisier selectat'
      else begin
        Str(SelectedItmSize, Dimensiune);
        ind1:=length(Dimensiune); ind2:=0;
        while (ind1 > 1) do begin
          inc(ind2);
          if ind2 = 3 then begin
            Insert(',' , Dimensiune, ind1);
            ind2:=0;
          end;
          dec(ind1);
        end;
        De_Afisat:=Dimensiune;
        Str(SelectedItmNr, Dimensiune);
        De_Afisat:=De_Afisat + ' biti in ' + Dimensiune + ' fisiere selectate';
      end;

      while length(De_Afisat) > 38 do
        Delete(De_Afisat, length(De_Afisat), 1);

      while (length(De_Afisat) + 2) <= 38 do
        De_Afisat:=' ' + De_Afisat + ' ';

      gotoxy(2, 18);
      write('                                      '); { 38 spatii pt sters }
      textcolor(yellow);
      gotoxy(2, 18); write(De_Afisat);
      textcolor(LightCyan);
    end;

  procedure TMainForm.ShowItem;
    var dataora: DateTime;
        De_Afisat, an, minut, dimensiune: String;
        ind1, ind2: integer;
    begin
      SetColor(blue, LightCyan);
      gotoxy(2, 17); write('            '); { 12 spatii pt stergere }
      gotoxy(2, 17);
      if k^.tip = 'F' then
        write(k^.real_name, '.', k^.real_ext)
      else write(k^.real_name);

      gotoxy(14, 17);
      write('                          '); { 26 spatii pt stergere }
      gotoxy(16, 17);
      if k^.tip = 'D' then
        if k^.real_name = '..' then write('<UP--DIR>')
        else begin
          unpacktime(k^.time, dataora);

          De_Afisat:='';

          Str(DataOra.Day, Dimensiune);
          De_Afisat:=De_Afisat + Dimensiune + '-';

          Str(DataOra.Month, Dimensiune);
          De_Afisat:=De_Afisat + Dimensiune + '-';

          Str(DataOra.Year, Dimensiune);
          Delete(Dimensiune, 1, Length(Dimensiune) - 2);
          De_Afisat:=De_Afisat + Dimensiune + ' ';

          Str(DataOra.Hour, Dimensiune);
          if Dimensiune = '0' then Dimensiune:='00';
          De_Afisat:=De_Afisat + Dimensiune + ':';

          Str(DataOra.Min, Dimensiune);
          if Length(Dimensiune) = 1 then Dimensiune:='0' + Dimensiune
          else if length(Dimensiune) > 2 then Dimensiune:=Dimensiune[1] + Dimensiune[2];
          De_Afisat:=De_Afisat + Dimensiune;

          ind2:=length(De_Afisat);
          for ind1:=ind2 to 13 do
            De_Afisat:=' ' + De_Afisat;


          write('<SUB-DIR>', ' ', De_Afisat);
        end
      else begin
        unpacktime(k^.time, dataora);

        Str(k^.size, Dimensiune);
          ind1:=length(Dimensiune); ind2:=0;
          while (ind1 > 1) do begin
            inc(ind2);
            if ind2 = 3 then begin
              Insert(',' , Dimensiune, ind1);
              ind2:=0;
            end;
            dec(ind1);
          end;
        De_Afisat:=Dimensiune;

        Str(DataOra.Day, Dimensiune);
        De_Afisat:=De_Afisat + ' ' + Dimensiune + '-';

        Str(DataOra.Month, Dimensiune);
        De_Afisat:=De_Afisat + Dimensiune + '-';

        Str(DataOra.Year, Dimensiune);
        Delete(Dimensiune, 1, Length(Dimensiune) - 2);
        De_Afisat:=De_Afisat + Dimensiune + ' ';

        Str(DataOra.Hour, Dimensiune);
        if Dimensiune = '0' then Dimensiune:='00';
        De_Afisat:=De_Afisat + Dimensiune + ':';

        Str(DataOra.Min, Dimensiune);
        if Length(Dimensiune) = 1 then Dimensiune:='0' + Dimensiune
        else if length(Dimensiune) > 2 then Dimensiune:=Dimensiune[1] + Dimensiune[2];
        De_Afisat:=De_Afisat + Dimensiune;

        ind2:=length(De_Afisat);
        for ind1:=ind2 to 25 do
          De_Afisat:=' ' + De_Afisat;

        gotoxy(14, 17);
        write(De_Afisat);
      end;

      ShowSelectedInfo;
    end;

  procedure TMainForm.ShowCurentDiskFree;
    var Drive_Size: String;
        ind1, ind2: integer;
    begin
      Str(DiskFree(Ord(Curent_Drive) - 64), Drive_Size);
      ind1:=length(Drive_Size); ind2:=0;
      while (ind1 > 1) do begin
        inc(ind2);
        if ind2 = 3 then begin
          Insert(',' , Drive_Size, ind1);
          ind2:=0;
        end;
        dec(ind1);
      end;
      Drive_Size:=Drive_Size + ' biti liberi pe drive ' + Curent_Drive + ':';
      while (Length(Drive_Size) + 2 <= 38) do
        Drive_Size:=' ' + Drive_Size + ' ';

      gotoxy(2, 19);
      write('                                      '); { 38 spatii pt sters }
      gotoxy(2, 19);
      write(Drive_Size);
    end;

  procedure TMainForm.Refresh;
    begin
      SetFocus;
      textbackground(blue);
      ClrScr;
      DrawBorders; Draw;
      ini; { Initializeaza cursorul si pozitia sa }
      ShowSortedContent;
      ShowItem;
      ShowDrives1;
    end;

  procedure TMainForm.RefreshFTS(IFTS: Word);
    begin
      if IFTS <> 0 then FTS:=IFTS;

      DestructCursor;
      ClearMainWin;
      DestructSortedContent(sant1, sant2);
      ChDir(Cale);
      BuildSortedContent(sant1, sant2, Sortare);
      textbackground(blue);
      ClrScr;
      DrawBorders; Draw;
      ini;
      ShowSortedContent;
      ShowItem;
      ShowDrives1;
    end;

{ ----------------------Subprogramele pentru evenimente--------------------- }

{ Subprogramele pentru Initializarea, Mutarea si Distrugerea cursorului
  ferestrelor principale }

  constructor TMainForm.BuildCursor;
    begin
      SetFocus;
      if k^.selected = true then SetColor(Cyan, Yellow)
      else SetColor(Cyan, Black);
      gotoxy(Y, X); write(k^.name, k^.ext);
      SetColor(Blue, White);
    end;

  destructor TMainForm.DestructCursor;
    begin
      SetFocus;
      if k^.selected = true then SetColor(Blue, Yellow)
      else if (k^.real_ext='exe')or(k^.real_ext='bat')or(k^.real_ext='com') then
             SetColor(Blue, LightCyan)
           else SetColor(Blue, White);
        gotoxy(Y, X); write(k^.name, k^.ext);
    end;

  procedure TMainForm.MoveCursorUp;
    var p: reper;
        lin, col: integer;
    begin
      if (k^.ant)<>sant1 then begin
        if (X=3)and(Y=2) then begin
          k:=k^.ant;
          {SetColor(Blue, White);}
          p:=k; lin:=2; col:=2;
          while (p<>sant2) do begin
            if lin=15 then begin
              lin:=2; col:=col + 13;
              if col=41 then break;
            end;
            if p^.selected = true then textcolor(yellow)
            else if (p^.real_ext='exe')or(p^.real_ext='bat')or(p^.real_ext='com') then
                   textcolor(LightCyan);
            inc(lin); gotoxy(col, lin);
            write(p^.name, p^.ext); textcolor(White);

            p:=p^.link;
          end;
              if k^.selected = true then SetColor(Cyan, Yellow)
              else SetColor(Cyan, Black);
              gotoxy(Y, X); write(k^.name, k^.ext);
        end
        else begin
          if k^.selected = true then SetColor(Blue, Yellow)
          else if (k^.real_ext='exe')or(k^.real_ext='bat')or(k^.real_ext='com') then
                 SetColor(Blue, LightCyan)
               else SetColor(Blue, White);
          gotoxy(Y, X); write(k^.name, k^.ext);

          if X=3 then begin
            X:=15; Y:=Y - 13;
          end
          else dec(X);
          k:=k^.ant;
          if k^.selected = true then SetColor(Cyan, Yellow)
          else SetColor(Cyan, Black);
          gotoxy(Y, X); write(k^.name, k^.ext);
        end;
      end;
      ShowItem;
    end;

  procedure TMainForm.MoveCursorDown;
    var i: integer;
        h, p: reper;
        lin, col: integer;
    begin
      if (k^.link)<>sant2 then begin
        if (X=15)and(Y=28) then begin
          k:=k^.link;
          h:=k;
          for i:=1 to 38 do h:=h^.ant;
          {SetColor(Blue, White);}
          p:=h; lin:=2; col:=2;
          while (p<>k) do begin
            if lin=15 then begin
              lin:=2; col:=col + 13;
              if col=41 then break;
            end;
            if p^.selected = true then SetColor(Blue, yellow)
            else if (p^.real_ext='exe')or(p^.real_ext='bat')or(p^.real_ext='com') then
                   SetColor(Blue, LightCyan)
                 else SetColor(Blue, White);
            inc(lin); gotoxy(col, lin);
            write(p^.name, p^.ext); textcolor(White);

            p:=p^.link;
          end;
          if k^.selected = true then SetColor(Cyan, Yellow)
          else SetColor(Cyan, Black);
          gotoxy(Y, X); write(k^.name, k^.ext);
        end
        else begin
          if k^.selected = true then SetColor(Blue, Yellow)
          else if (k^.real_ext='exe')or(k^.real_ext='bat')or(k^.real_ext='com') then
                 SetColor(Blue, LightCyan)
               else SetColor(Blue, White);
          gotoxy(Y, X); write(k^.name, k^.ext);

          if X=15 then begin
            X:=3; Y:=Y + 13;
          end
          else inc(X);

          k:=k^.link;
          if k^.selected = true then SetColor(Cyan, Yellow)
          else SetColor(Cyan, Black);
          gotoxy(Y, X); write(k^.name, k^.ext);
        end;
      end;
      ShowItem;
    end;

  procedure TMainForm.MoveCursorLeft;
    var i: integer;
    begin
      if (Y>2) then begin
        if k^.selected = true then SetColor(Blue, yellow)
        else if (k^.real_ext='exe')or(k^.real_ext='bat')or(k^.real_ext='com') then
               SetColor(Blue, LightCyan)
             else SetColor(Blue, White);
        gotoxy(Y, X); write(k^.name, k^.ext);

        i:=1;
        while (i<=13)and(k^.ant<>sant1) do begin
          if (X = 3) then begin
            X:=15; Y:=Y-13;
          end
          else dec(X);
          inc(i); k:=k^.ant;
        end;

        if k^.selected = true then SetColor(Cyan, Yellow)
        else SetColor(Cyan, Black);
        gotoxy(Y, X); write(k^.name, k^.ext);
      end;
      ShowItem;
    end;

  procedure TMainForm.MoveCursorRight;
    var i: integer;
    begin
      if (Y<28) then begin
        if k^.selected = true then SetColor(Blue, yellow)
        else if (k^.real_ext='exe')or(k^.real_ext='bat')or(k^.real_ext='com') then
               SetColor(Blue, LightCyan)
             else SetColor(Blue, White);
        gotoxy(Y, X); write(k^.name, k^.ext);

        i:=1;
        while (i<=13)and(k^.link<>sant2) do begin
          if X = 15 then begin
            X:=3; Y:=Y + 13;
          end
          else inc(X);
          inc(i); k:=k^.link;
        end;

        if k^.selected = true then SetColor(Cyan, Yellow)
        else SetColor(Cyan, Black);
        gotoxy(Y, X); write(k^.name, k^.ext);
      end;
      ShowItem;
    end;

  procedure TMainForm.Select_FD;
    begin
      if k^.real_name <> '..' then
        k^.selected:=not k^.selected;

      if k^.real_name <> '..' then
        case k^.selected of
          true: begin
                  inc(SelectedItmNr);
                  SelectedItmSize:=SelectedItmSize + k^.size;
                end;
          false: begin
                   dec(SelectedItmNr);
                   SelectedItmSize:=SelectedItmSize - k^.size;
                 end;
        end;

      if k^.tip = 'F' then
        if k^.selected = true then
          k^.name[8 + 1]:=chr(251) { radical }
        else k^.name[8 + 1]:=' ';

      if k^.link = sant2 then
        case k^.selected of
          true: begin
                  SetColor(Cyan, Yellow);
                  gotoxy(Y, X); write(k^.name, k^.ext);
                  ShowSelectedInfo;
                end;
          false: begin
                  SetColor(Cyan, White);
                  gotoxy(Y, X); write(k^.name, k^.ext);
                  ShowSelectedInfo;
                 end;
        end
      else MoveCursorDown;
    end;

  procedure TMainForm.ClearMainWin;
    const sir='            ';
    var lin, col: integer;
    begin
      SetColor(Blue, Blue);
      lin:=2; col:=2;
      repeat
        if lin=15 then begin
          lin:=2; col:=col + 13;
        end;
        inc(lin);
        gotoxy(col, lin); write(sir);
      until (col=28)and(lin=15);
      SetColor(Blue, White);
    end;

  procedure TMainForm.OnClickEvent(sir: string);
    var Ca: string;
        i: integer;
    begin
      if sir = '' then begin
        GetDir(0, Ca);
        if k^.Real_Name='..' then begin
          for i:=length(Ca) downto 1 do
            if Ca[i]='\' then begin
              delete(Ca, i, length(Ca) - i + 1);
              break;
            end
            else;
          if length(Ca)=2 then Ca:=Ca + '\';
        end
        else if (k^.Real_ext='') then
          if length(Ca)=3 then Ca:=Ca + k^.Real_Name
          else Ca:=Ca + '\' + k^.Real_Name;
        {$I-}
        ChDir(Ca);
        {$I+}
        if (IOResult = 0) then
          Cale:=Ca;
      end
      else if sir = 'refresh' then
           else begin
             {$I-}
             ChDir(sir);
             {$I+}
             Cale:=sir;
           end;

      if IOresult = 0 then begin
        DestructCursor;
        ClearMainWin;
        DestructSortedContent(sant1, sant2);
        BuildSortedContent(sant1, sant2, Sortare);
        ini;
        ShowSortedContent; ShowCurentDir(cyan);
        BuildCursor;
      end;
      ShowItem;
    end;

  function TMainForm.FileExists(FileName: String): boolean;
    var kk: reper;
    begin
      kk:=sant1^.link;
      while (kk <> sant2)and((kk^.real_name + '.' + kk^.real_ext) <> FileName) do
        kk:=kk^.link;
      if kk <> sant2 then FileExists:=true
      else FileExists:=false;
    end;

  function TMainForm.ValidFileAttr(NumeFisier: string; Attr: word): boolean;
    var F: file;
        Atribute: word;
    begin
      assign(F, NumeFisier);
      GetFAttr(F, Atribute);

      if (Atribute and Attr) <> 0  then ValidFileAttr:=true
      else ValidFileAttr:=false;
    end;

  procedure TMainForm.SetFileAttr(NumeFisier: string; Attr: word);
    var F: file;
    begin
      assign(F, NumeFisier);
      SetFAttr(F, Attr);
    end;

  function TMainForm.SelectedFilesExist: boolean;
    var ww: reper;
        exista: boolean;
    begin
      ww:=sant1^.link; exista:=false;
      while (ww <> sant2) do begin
        if (ww^.tip = 'F') then begin
          exista:=true;
          break;
        end;
        ww:=ww^.link;
      end;

      SelectedFilesExist:=exista;
    end;
end.