unit UMnBar; { MenuBar }

interface

  uses crt, UWindow;
  const MenuItemsCount = 7;
        MenuItems: array[1..MenuItemsCount]of string=('&ð', '&Fisier' ,
                                         '&Discheta' , '&Utilitare' ,
                                         '&Panel' , '&Manager' ,
                                         '&Optiuni');
  type TMenuBar=object(TWin)
         constructor init(curent_dir: string);

         constructor InitWin(Item, i, j: integer; var l: char; var Rezultat: String);
         function Navigate: String;
         procedure ShowItem(Item: string; i, j: integer);
         function SelectItems: String;

         destructor done;
         destructor WinDone;

         private
           x, y, nr: integer;
           Fisier: text;
           BigWin, BlackWin: TWin;
           V: array[1..30]of string;
           bool: boolean;
           Cale: string;
           HotKeys: array[1..20]of char;
       end;

implementation
  constructor TMenuBar.init;
    var i, j: integer;
        Item: string;
    begin
      Cale:=curent_dir;
      BigWin.init(1, 1, 80, 1, LightGray, Black);
      textbackground(LightGray);
      x:=1; y:=0;
      inc(y); gotoxy(y, x); write(' ');
      inc(y); gotoxy(y, x); write(' ');
      for i:=1 to MenuItemsCount do begin
        Item:=MenuItems[i];
        textcolor(black);
        j:=0;
        repeat
          inc(j);
          inc(y); gotoxy(y, x);
          if Item[j]='&' then begin
            textcolor(red);
            write(Item[j+1]);
            inc(j); textcolor(black);
          end
          else write(Item[j]);
        until j=length(Item);
        inc(y); gotoxy(y, x); write(' ');
        inc(y); gotoxy(y, x); write(' ');
      end;
      repeat
        inc(y); gotoxy(y, x); write(' ');
      until y=79;
    end;

  constructor TMenuBar.InitWin(Item, i, j: integer; var l: char; var Rezultat: String);
    var cale_aux, V1: string;
        r, t, Max, ini, hot: integer;
        lin, col: integer;
        Hot_Exists: boolean;
    begin
      t:=0; cale_aux:=MenuItems[Item];
      for r:=1 to length(cale_aux) do
        if cale_aux[r]='&' then begin
          delete(cale_aux, r, 1); break;
        end;
      if cale_aux = 'ð' then cale_aux:='TLinii';
      cale_aux:=Cale + '\' + cale_aux + '.itm';
      Assign(Fisier, cale_aux); Reset(Fisier);
      readln(Fisier, nr); Max:=0;
      for t:=1 to nr do begin
        readln(Fisier, V[t]);
        if Max < length(V[t]) then Max:=length(V[t]);
      end;
      Close(Fisier);

      for t:=1 to nr do
        if (V[t] = '-') then HotKeys[t]:='0'
        else begin
          Hot_Exists:=false; hot:=0;
          repeat
            inc(hot);
            if (V[t][hot] = '&') then Hot_Exists:=true;
          until (hot = length(V[t]))or(Hot_Exists = true);
          if (Hot_Exists = true) then
            if ((V[t][hot + 1] in ['A'..'Z'])or(V[t][hot + 1] in ['a'..'z'])) then
              HotKeys[t]:=UpCase(V[t][hot + 1])
            else HotKeys[t]:='0'
          else;
        end;

      for t:=1 to nr do begin
        if (V[t] <> '-') then begin
          for r:=length(v[t]) to Max do V[t]:=v[t] + ' ';
            V[t]:=' ' + V[t];
        end;
      end;

      ini:=j; bool:=false;
      while ((ini + ( Max + 6)) > 81) do
        dec(ini);
      if ((ini + ( Max + 6)) < 81) then begin
        inherited init(ini + 2, i + 2, Max + 6, nr + 2, Black, White);
          bool:=true;
      end;

      inherited init(ini, i + 1, Max + 6, nr + 2, LightGray, Black);

      for r:=1 to nr do
        if V[r]='-' then begin
          V1:='';
          for t:=1 to Max + 4 do V1:=V1 + chr(196);
          ShowItem(V1, r + 1, 1);
        end
        else ShowItem(V[r], r + 1, 2);

      gotoxy(2, 1); write(chr(218));
      gotoxy(Max + 5, 1); write(chr(191));
      gotoxy(2, nr + 2); write(chr(192));
      gotoxy(Max + 5, nr + 2); write(chr(217));

      lin:=1; col:=2;
      repeat
        inc(col);
        gotoxy(col, lin); write(chr(196));
        gotoxy(col, nr + 2); write(chr(196));
      until col = Max + 4;

      col:=2; lin:=1;
      repeat
        inc(lin);
        gotoxy(col, lin); write(chr(179));
        gotoxy(max + 5, lin); write(chr(179));
      until lin = nr + 1;

      Rezultat:=Navigate; l:=#27;
    end;

  function TMenuBar.Navigate: String;
    var li, co, Itm, hot: integer;
        c: char;
        sir: string;
        Hot_Exists: boolean;
    begin
      Itm:=1;
      li:=2; co:=2;
      textbackground(green); ShowItem(V[Itm], li, co);

      repeat
        c:=readkey;
        case c of
          #80: begin
                 textbackground(LightGray); ShowItem(V[Itm], li, co);
                 if Itm = nr then begin
                   Itm:=1; li:=2;
                 end
                 else
                   if V[Itm + 1] = '-' then begin
                     Itm:=Itm + 2; li:=li + 2;
                   end
                   else begin
                     inc(Itm); inc(li);
                   end;
                 textbackground(Green); ShowItem(V[Itm], li, co);
               end;
          #72: begin
                 textbackground(LightGray); ShowItem(V[Itm], li, co);
                 if Itm = 1 then begin
                   Itm:=nr; li:=nr + 1;
                 end
                 else
                   if V[Itm - 1] = '-' then begin
                     Itm:=Itm - 2; li:=li - 2;
                   end
                   else begin
                     dec(Itm); dec(li);
                   end;
                 textbackground(Green); ShowItem(V[Itm], li, co);
               end;
          #13: begin
                 Sir:=V[itm];

                 li:=length(sir);
                 while sir[li] = ' ' do
                   dec(li);
                 Delete(sir, li + 1, length(sir) - li);

                 li:=1;
                 while sir[li] = ' ' do
                   inc(li);
                 Delete(sir, li - 1, li - 1);

                 li:=1;
                 while li <= length(sir) do begin
                   if (sir[li] = '&') then begin
                     Delete(sir, li, 1);
                     dec(li);
                   end;
                   inc(li);
                 end;

                 Navigate:=Sir; c:=#27;
               end;
          else
            if (UpCase(Char(c)) in ['A'..'Z']) then
                       begin
                                Hot_Exists:=false; hot:=0;
                                repeat
                                  inc(hot);
                                  if (HotKeys[hot] = UpCase(Char(c))) then
                                    Hot_Exists:=true;
                                until ((hot = nr)or(Hot_Exists = true));
                                if (Hot_Exists = true) then begin
                                  Sir:=V[hot];

                                  li:=length(sir);
                                  while sir[li] = ' ' do
                                    dec(li);
                                  Delete(sir, li + 1, length(sir) - li);

                                  li:=1;
                                  while sir[li] = ' ' do
                                    inc(li);
                                  Delete(sir, li - 1, li - 1);

                                  li:=1;
                                  while li <= length(sir) do begin
                                    if (sir[li] = '&') then begin
                                      Delete(sir, li, 1);
                                      dec(li);
                                    end;
                                    inc(li);
                                  end;

                                  Navigate:=Sir; c:=#27;
                                end;
                              end;

        end;
      until c=#27;
    end;

  procedure TMenuBar.ShowItem(Item: string; i, j: integer);
    var Cursor: string;
        k, j1: integer;
    begin
      Cursor:=Item;
      k:=0; j1:=j;
      repeat
        inc(k); inc(j1); gotoxy(j1, i);
        if Cursor[k]='&' then begin
          textcolor(red);
          write(Cursor[k+1]);
          inc(k); textcolor(black);
        end
        else write(Cursor[k]);
      until k=length(Cursor);
    end;

  function TMenuBar.SelectItems: String;
    var car: char;
        Item, i, j, w: integer;
        l: char;
        Rezultat: String;
    begin
      Item:=1;
      i:=1; j:=1;
      textbackground(green); ShowItem(' ' + MenuItems[Item] + ' ', i, j);

      repeat
        car:=readkey;
        case car of
          #75: begin
                 textbackground(LightGray); ShowItem(' ' + MenuItems[Item] + ' ', i, j);
                 if Item=1 then begin
                   Item:=MenuItemsCount; j:=0;
                   for w:=1 to MenuItemsCount-1 do
                     j:=j + 2 + (length(MenuItems[w]) - 1);
                   inc(j);
                 end
                 else begin
                   dec(Item);
                   j:=j - 2 - (length(MenuItems[Item]) - 1);
                 end;
                 textbackground(green); ShowItem(' ' + MenuItems[Item] + ' ', i, j);
               end;
          #77: begin
                 textbackground(LightGray); ShowItem(' ' + MenuItems[Item] + ' ', i, j);
                 if Item=MenuItemsCount then begin
                   Item:=1;
                   j:=1;
                 end
                 else begin
                   j:=j + length(MenuItems[Item]) + 1;
                   inc(Item);
                 end;
                 textbackground(green); ShowItem(' ' + MenuItems[Item] + ' ', i, j);
               end;
          #27: begin
                 textbackground(LightGray);
                 ShowItem(' ' + MenuItems[Item] + ' ', i, j);
               end;
          #13: begin
                 InitWin(Item, i, j, l, Rezultat); WinDone;
                 if bool=true then BlackWin.done;
                 BigWin.SetFocus;
                 if l=#27 then car:=#27;

                 SelectItems:=Rezultat;
               end;
          #27: SelectItems:='';
        end;
      until car=#27;
    end;

  destructor TMenuBar.done;
    begin
      textbackground(black); textcolor(black);
      gotoxy(1, 1);
      ClrEol; { sterge tot de la caracterul curent la sfarsitul liniei }
      BigWin.done;
    end;

  destructor TMenuBar.WinDone;
    begin
      inherited done;
    end;
end.