unit Uwindow; { version_01 }

interface
  uses crt;
  type TWin=object
              constructor init(ITopx, ITopy, IWidth, IHeight: integer;
                               IBackColor, IDrawColor: byte);
              destructor done;
              procedure show;
              procedure hide;
              procedure clear;
              procedure setColor(IBackColor, IDrawColor: byte);
              procedure setFocus;
              procedure writeString(st: string);
              procedure memorize;

              private
                FTopx, FTopy, FWidth, FHeight: integer;
                FBackColor, FDrawColor: byte;
                FCursorx, FCursory: integer;
            end;

implementation
  constructor TWin.init(ITopx, ITopy, IWidth, IHeight: integer;
                               IBackColor, IDrawColor: byte);
    begin
      FTopx:=ITopx; FTopy:=ITopy;
      FWidth:=IWidth; FHeight:=IHeight;
      FBackColor:=IBackColor; FDrawColor:=IDrawColor;
      FCursorx:=1; FCursory:=1;

      show;
    end;

  destructor TWin.done;
    begin
      hide;
    end;

  procedure TWin.show;
    begin
      clear;
    end;

  procedure TWin.hide;
    begin
      setFocus;
      textAttr:=$07;
      clrscr;
    end;

  procedure TWin.clear;
    begin
      setFocus;
      clrscr;
      memorize;
    end;

  procedure TWin.writeString(st: string);
    begin
      setFocus;
      write(st);
      memorize;
    end;

  procedure TWin.setColor(IBackColor, IDrawColor: byte);
    begin
      FBackColor:=IBackColor;
      FDrawColor:=IDrawColor;
      setFocus;
    end;

  procedure TWin.setFocus;
    begin
      window(FTopx, FTopy, FTopx+FWidth-1, FTopy+FHeight-1);
      textBackground(FBackColor); textcolor(FDrawColor);
      gotoxy(FCursorx, FCursory);
    end;

  procedure TWin.memorize;
    begin
      FCursorX:=Wherex;
      FCursorY:=WhereY;
    end;

begin
end.