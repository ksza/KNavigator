unit UChDrive; { Contine clasa TChDriveWin - pt schimbarea drive-ului }

interface
  uses crt, UWindow, UMain;
  const CSS = 201; { Colt stanga sus }
        CDS = 187; { Colt dreapta sus }
        CSJ = 200; { Colt stanga jos }
        CDJ = 188; { Colt drepta jos }
        CO = 205; { Caracter orizontal }
        CV = 186; { Caracter vertical }
  type vector2 = array[1..50]of char;
       TShadow = object(TWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer);
         destructor done;
       end;
       TChDriveWin = object(TWin)
         constructor init(ITopx, ITopy: integer; v: vector);
         function SelectDrive: Char;
         destructor done;

         public
           drives: vector2;
           DrivesCount: 0..50;

           Shadow: TShadow;
       end;

implementation

{-----Metodele clasei TChDriveWin - Fereastra de schimbare a Drive-urilor----}
  constructor TChDriveWin.init;
    var lin, col, K, IHeight, IWidth: integer;
        s: string;
        ca: char;
    begin
      DrivesCount:=0;
      for ca:='A' to 'Z' do
        if v[ca].exista = true then begin
          inc(DrivesCount);
          drives[DrivesCount]:=ca;
        end;

      IWidth:=8; IHeight:=3 + DrivesCount;

      Shadow.init(Itopx + 1, ITopy + 1, IWidth, IHeight);
      inherited init(ITopx, ITopy, 8, 3 + DrivesCount, LightGray, Black);

      K:=IHeight - 1;

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
    end;

  function TChDriveWin.SelectDrive;
    var drive: 0..50;
        lin, col: integer;
        s: string;
        c: char;
    begin
      lin:=2; col:=2;
      for drive:=1 to DrivesCount do begin
          s:='  ' + drives[drive] + ':  ';
          gotoxy(col, lin); textcolor(red); write(s); textcolor(white);
          inc(lin);
      end;

      lin:=2; col:=2; drive:=1;
      gotoxy(col, lin);
      s:='  ' + drives[drive] + ':  ';
      textbackground(green); textcolor(red); write(s);

      repeat
        c:=readkey;
        case c of
          #72: begin
                 gotoxy(col, lin);
                 s:='  ' + drives[drive] + ':  ';
                 textbackground(LightGray); textcolor(red); write(s);
                 dec(drive);
                 if drive < 1 then begin
                   drive:=DrivesCount; lin:=DrivesCount + 1;
                 end
                 else dec(lin);

                 gotoxy(col, lin);
                 s:='  ' + drives[drive] + ':  ';
                 textbackground(Green); textcolor(red); write(s);
               end;

          #80: begin
                 gotoxy(col, lin);
                 s:='  ' + drives[drive] + ':  ';
                 textbackground(LightGray); textcolor(red); write(s);
                 inc(drive);
                 if drive > DrivesCount then begin
                   drive:=1; lin:=2;
                 end
                 else inc(lin);

                 gotoxy(col, lin);
                 s:='  ' + drives[drive] + ':  ';
                 textbackground(Green); textcolor(red); write(s);

               end;
          #13: begin
                 SelectDrive:=drives[drive];
                 break;
               end;
        end;
      until c = #27;
      if c = #27 then SelectDrive:='0';
      done;
    end;

  destructor TChDriveWin.done;
    begin
      inherited done;
    end;

{------Metodele clasei TShadow - Reprezinta umbra ferestrei TChDriveWin------}
  constructor TShadow.init;
    begin
      inherited init(ITopx, ITopy, IWidth, IHeight, Black, Black)
    end;

  destructor TShadow.done;
    begin
      inherited done;
    end;
end.

