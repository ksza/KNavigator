unit UInfo; { contine clasa TInformation }

interface
  uses crt, dos, UBwin, UMain;
  const CSS=201; { Colt stanga sus }
        CDS=187; { Colt dreapta sus }
        CSJ=200; { Colt stanga jos }
        CDJ=188; { Colt drepta jos }
        CO=205; { Caracter orizontal }
        CV=186; { Caracter vertical }
  type TInformation = object
         constructor init(CDir: string; Drv: char; sant1, sant2: reper);
         procedure GetInfo(sant1, sant2: reper);
         procedure Refresh;
         procedure WriteString(sir: string; lin: integer);
         function ShowSpace(Drv: char; x: integer): string;
         procedure DrawBorders;
         destructor done;

         public
           DirNr, FisNr, FisSize: LongInt;
           CurentDir: string;
           Drive: char;
       end;

implementation
  constructor TInformation.init(CDir: string; Drv: char; sant1, sant2: reper);
    var s1: string;
        i, j: integer;
    begin
      CurentDir:=CDir; Drive:=Drv;
      gotoxy(13, 1); write(' Informatii ');

      if length(CurentDir) > 38 then begin
        i:=6;
        repeat
          inc(i);
        until (length(CurentDir) - i <= 31);
        s1:='';
        for j:=i to length(CurentDir) do
          s1:=s1 + CurentDir[j];
        CurentDir:=copy(CurentDir, 1, 3);
        CurentDir:=CurentDir + '...' + s1;
      end;

      GetInfo(sant1, sant2);

      Refresh;
    end;

  procedure TInformation.GetInfo(sant1, sant2: reper);
    var p: reper;
    begin
      p:=sant1^.link; DirNr:=0; FisNr:=0; FisSize:=0;
      while p <> sant2 do begin
        if (p^.tip = 'D')and(p^.real_name <> '..') then inc(DirNr)
        else if (p^.tip = 'F') then begin
          inc(FisNr); FisSize:=FisSize + p^.size;
        end;
        p:=p^.link;
      end;
    end;

  procedure TInformation.Refresh;
    var s1, s2: string;
        ind1, ind2: integer;
    begin
      ClrScr; DrawBorders;
      gotoxy(13, 1); write(' Informatii ');

      WriteString('Directorul curent', 7);
      WriteString(CurentDir, 8);
      s1:='';
      Str(DirNr, s1);
      WriteString(s1 + ' subdirectoare', 9);
      s1:=''; s2:='';
      Str(FisNr, s1); Str(FisSize, s2);

      ind1:=length(s2); ind2:=0;
      while (ind1 > 1) do begin
        inc(ind2);
        if ind2 = 3 then begin
          Insert(',' , s2, ind1);
          ind2:=0;
        end;
        dec(ind1);
      end;

      WriteString(s1 + ' fisiere cu ' + s2 + ' bytes', 10);

      { spatiu }

      WriteString(ShowSpace(Drive, 1), 12);
      WriteString(ShowSpace(Drive, 2), 13);
    end;

  procedure TInformation.WriteString(sir: string; lin: integer);
    begin
      while (Length(sir) + 2 <= 38) do
        sir:=' ' + sir + ' ';

      gotoxy(2, lin); write(sir);
    end;

  function TInformation.ShowSpace(Drv: char; x: integer): string;
    var Drive_Size: string;
        ind1, ind2: integer;
    begin
      case x of
        1: Str(DiskFree(Ord(Drv) - 64), Drive_Size);
        2: Str(DiskSize(Ord(Drv) - 64), Drive_Size);
      end;

      ind1:=length(Drive_Size); ind2:=0;
      while (ind1 > 1) do begin
        inc(ind2);
        if ind2 = 3 then begin
          Insert(',' , Drive_Size, ind1);
          ind2:=0;
        end;
        dec(ind1);
      end;

      case x of
        1: Drive_Size:=Drive_Size + ' biti liberi in drive ' + Drive + ':';
        2: Drive_Size:=Drive_Size + ' total biti in drive ' + Drive + ':';
      end;
      ShowSpace:=Drive_Size;
    end;

  procedure TInformation.DrawBorders;
    var lin, col: integer;
    begin
      textcolor(White);

      { Deseneaza colturile }
      gotoxy(1, 1); write(chr(CSS));
      gotoxy(40, 1); write(chr(CDS));
      gotoxy(1, 21); write(chr(CSJ));
      gotoxy(40, 21); write(chr(CDJ));

      { Deseneaza caracterele orizontale }
      for col:=2 to 40 - 1 do begin
        gotoxy(col, 1); write(chr(CO));
        gotoxy(col, 21); write(chr(CO));
      end;

      { Deseneaza caracterele verticale }
      for lin:=2 to 21 - 1 do begin
        gotoxy(1, lin); write(chr(CV));
        gotoxy(40, lin); write(chr(CV));
      end;
    end;

  destructor TInformation.done;
    begin
      ClrScr;
    end;
end.