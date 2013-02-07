unit USubMnBr;

interface
  uses crt, UWindow;
  const MenuItemsCount = 2;
        MenuItems: array[1..MenuItemsCount]of string=('&F&3Ajutor',
                                                      '&F&1&0Meniu');
  type TSubMenuBar=object(TWin)
         constructor BuildSubMenuBar;
         destructor DestructSubMenuBar;

         private
           x, y, nr: integer;
           BigWin: TWin;
       end;

implementation
  constructor TSubMenuBar.BuildSubMenuBar;
    var i, j: integer;
        Item: string;
    begin
      BigWin.init(1, 23, 80, 1, LightGray, Black);
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
      while y<79 do begin
        inc(y); gotoxy(y, x); write(' ');
                    end;
    end;

  destructor TSubMenuBar.DestructSubMenuBar;
    begin
      textbackground(black); textcolor(black);
      gotoxy(1, 1);
      ClrEol; { sterge tot de la caracterul curent la sfarsitul liniei }
      BigWin.done;
    end;

end.