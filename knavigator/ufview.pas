unit UFView;

interface
  uses crt, dos, UBWin, UShadow, UButton;
  const cursor = Chr(26);
        BgColor: byte = LightGray;
        TxtColor: byte = White;
        t: array[1..5]of string[8] = ('ReadOnly', 'Hidden', 'SysFile',
                                      'Archive', 'AnyFile');
        width = 26;
        height = 13;
  type inregistrare=record
         tip: word;
         selectat: boolean;
       end;
       vector=array[1..5]of inregistrare;
       TFileView=object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; cale: string);
         function GetFileTypes: word;
         destructor done;

         private
           Shadow: TShadow;
           TipFisier: vector;
           Button1, Button2: TButton;
           CurentWin, CurentButton: 1..3;
           f: file of inregistrare;
           FCale: string;
       end;

implementation
  constructor TFileView.init;
    const LO = 196; { Linie orizontala }
    var i: integer;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, width, height);
      inherited init(ITopx, ITopy, width, height, BgColor, TxtColor);

      FCale:=Cale + '\Res\FTypes.res';
      textcolor(TxtColor); gotoxy(5, 1); write(' Tipuri de fisiere ');
      assign(f, FCale); reset(f);
        for i:=1 to 5 do
          read(f, TipFisier[i]);
      close(f);

      for i:=2 to Width - 1 do begin
        gotoxy(i, 8); write(Char(LO));
      end;

      Button1.init(4, 10, 'OK', BgColor);
      Button2.init(14, 10, 'Cancel', BgColor);
      SetFocus; CurentWin:=1; CurentButton:=1;

      for i:=1 to 5 do begin
        gotoxy(3, i + 1);

        with TipFisier[i] do
          if selectat = true then write('[x] ', t[i])
          else write('[ ] ', t[i]);
      end;
    end;

  function TFileView.GetFileTypes: word;
    var lin, col, i: byte;
        c: char;
        GFT: Word; { Get File Types }
    begin
      lin:=2; col:=2;
      gotoxy(col, lin); textcolor(white); write(cursor);

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
                       {SetFocus;}
                       gotoxy(col, lin); textcolor(TxtColor); write(cursor);
                     end;
                  2: begin
                       {SetFocus;}
                       gotoxy(col, lin); textcolor(BgColor); write(cursor);
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
          #72: if (not (CurentWin in [2..3])) then begin
                   gotoxy(col, lin); textcolor(BgColor); write(Cursor);
                   dec(lin);
                   if lin < 2 then lin:=6;
                   gotoxy(col, lin); textcolor(white); write(cursor);
                 end;
          #80: if (not (CurentWin in [2..3])) then begin
                 gotoxy(col, lin); textcolor(BgColor); write(Cursor);
                 inc(lin);
                 if lin > 6 then lin:=2;
                 gotoxy(col, lin); textcolor(white); write(cursor);
               end;
          #13: begin
                 case CurentWin of
                   1: with TipFisier[lin - 1] do begin
                        selectat:=not selectat;
                        gotoxy(col + 2, lin);
                        if selectat = true then
                          if (lin - 1) = 5 then begin
                            textcolor(TxtColor);
                            for i:=1 to 5 do begin
                              TipFisier[i].selectat:=true;
                              gotoxy(col + 2, i + 1); write('x');
                            end;
                          end
                          else begin
                            textcolor(white); write('x');
                          end
                        else begin
                          textcolor(BgColor); write(' ');
                        end;
                      end;
                   2: begin
                        assign(f, FCale); rewrite(f);
                          for i:=1 to 5 do
                            write(f, TipFisier[i]);
                        close(f);
                          {Button1.onClick(BgColor);}
                        GFT:=0;
                        if TipFisier[5].selectat = true then
                          GFT:=TipFisier[5].tip
                        else
                          for i:=1 to 4 do
                            if TipFisier[i].selectat = true then
                              GFT:=GFT + TipFisier[i].tip;
                        GetFileTypes:=GFT;
                        SetFocus; done; break;
                      end;
                   {3: begin
                        {Button2.onClick(BgColor);}
                        {SetFocus;
                        GetFileTypes:=0;
                        done; break;
                      end;}
                 end;
               end;
        end;
      until c = #27;

      if c=#27 then begin
        GetFileTypes:=0;
        done;
      end;
    end;

  destructor TFileView.done;
    begin
      Button1.done; Button2.done;

      inherited done; Shadow.done;
    end;

end.