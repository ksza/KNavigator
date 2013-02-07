unit UOsInfo;

interface
  uses crt, UBWin, UWindow;
  type TOsInfoWin = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; ITitle: string);
         procedure refresh;
         destructor done;

         public
           InfoWin: TWin;
           Title: string;
       end;

implementation
  constructor TOsInfoWin.init(ITopx, ITopy: integer; ITitle: string);
    var k, l: integer;
    begin
      inherited init(Itopx, ITopy, 80, 10, Black, White);
        Title:=ITitle;
        ITitle:=' ' + ITitle + ' ';
        k:=40; l:=length(ITitle);
        while (k > (82 - (k + l - 1))) do
          dec(k);
        gotoxy(k ,1); write(ITitle);

      InfoWin.init(ITopx + 1, ITopy + 1, 78, 7, Black, White);
    end;

  procedure TOsInfoWin.refresh;
    var ITitle: string;
        k, l: integer;
    begin
      SetFocus;
      DrawBorders;
      ITitle:=' ' + Title + ' ';
      k:=40; l:=length(ITitle);
      while (k > (82 - (k + l - 1))) do
        dec(k);
      gotoxy(k ,1); write(ITitle);
    end;

  destructor TOsInfoWin.done;
    begin
      InfoWin.done;
      inherited done;
    end;
end.