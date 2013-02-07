unit UCDM; { Copy, Delete, Move }

interface
  uses crt, UBWin, UShadow;
  type TCDM = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; ITitle, ICale1, ICale2: string; INr_Fisiere: LongInt);
         procedure ShowMessage(Message: string);
         procedure afisare(lin, col: integer; s: string; TColor: word);
         destructor done;

         public
           Shadow: TShadow;
           Progress, Progress_Value, Salt: integer;
           Title, Cale1, Cale2, s1: string;
           Nr_Fisiere, Fisiere_Prelucrate: LongInt;
       end;

implementation
  constructor TCDM.init(ITopx, ITopy: integer; ITitle, ICale1, ICale2: string; INr_Fisiere: LongInt);
    var k, l: integer;
        SubTitle, aux: string;
    begin
      Shadow.init(ITopx + 1, ITopy + 1, 56, 8);
      inherited init(ITopx, ITopy, 56, 8, LightGray, White);

      Title:=ITitle;
      ITitle:=' ' + ITitle + ' ';
      k:=56 div 2; l:=length(ITitle);
      while (k > (56 - (k + l - 1))) do
        dec(k);
      gotoxy(k ,1); write(ITitle);

      str(INr_Fisiere, aux);
      SubTitle:=' ' + 'Total' + ' ' + aux + ' ' + 'fisiere' + ' ';
      k:=56 div 2; l:=length(SubTitle);
      while (k > (56 - (k + l - 1))) do
        dec(k);
      gotoxy(k, 7); write(SubTitle);

      Progress:=0; Fisiere_Prelucrate:=-1;
      Nr_Fisiere:=INr_Fisiere;
      Cale1:=ICale1; Cale2:=ICale2;
      if (Nr_Fisiere > 50) then begin
        Salt:=Nr_Fisiere div 50;
        Progress_Value:=1
      end
      else begin
        Salt:=1;
        Progress_Value:=50 div Nr_Fisiere;
      end;

      for l:=1 to 50 do
        afisare(4, 3 + l, chr(177), Black);
    end;

  procedure TCDM.ShowMessage(Message: string);
    var i, j: integer;
        s2, aux: string;
    begin
      SetFocus;

      aux:=Cale1 + Message; s1:='';
      if (length(aux) > 19) then begin
        s1:=copy(aux, 1, 3);
        s1:=s1 + '...';
        i:=length(aux);
        while (length(aux) - i + 1) < (19 - length(s1)) do
          dec(i);
        s1:=s1 + copy(aux, i, (length(aux) - i + 1));
      end
      else s1:=aux;

      aux:=Cale2 + Message; s2:='';
      if (length(aux) > 20) then begin
        s2:=copy(aux, 1, 3);
        s2:=s2 + '...';
        i:=length(aux);
        while (length(aux) - i + 1) < (20 - length(s2)) do
          dec(i);
        s2:=s2 + copy(aux, i, (length(aux) - i + 1));
      end
      else s2:=aux;

      afisare(3, 4, '                                                 ', Black);
      if (Title = 'Copiere') then
        afisare(3, 4, 'Copiaza' + ' ' + s1 + ' ' + 'in' + ' ' + s2, Black)
      else if (Title = 'Stergere') then
             afisare(3, 4, 'Sterge' + ' ' + s1, Black)
           else if (Title = 'Mutare') then
                  afisare(3, 4, 'Muta' + ' ' + s1 + ' ' + 'in' + ' ' + s2, Black);

      inc(Fisiere_Prelucrate);
      if ((Fisiere_Prelucrate mod Salt) = 0)and(Progress < 50) then begin
        j:=Progress;
        Progress:=Progress + Progress_Value;
        for i:=(j + 1) to Progress do
          afisare(4, 3 + i, chr(219), Black);
      end;

      s1:=''; s2:='';
      str(Fisiere_Prelucrate + 1, s1);
      str(Progress * 2, s2);
      afisare(5, 4, '                                                 ', Black);
      if (Title = 'Copiere') then
        afisare(5, 4, s1 + ' ' + 'fisiere copiate' + '(' + s2 + '%' + ')', Black)
      else if (Title = 'Stergere') then
             afisare(5, 4, s1 + ' ' + 'fisiere sterse' + '(' + s2 + '%' + ')', Black)
           else if (Title = 'Mutare') then
                  afisare(5, 4, s1 + ' ' + 'fisiere mutate' + '(' + s2 + '%' + ')', Black)
    end;

  procedure TCDM.afisare(lin, col: integer; s: string; TColor: word);
    begin
      if (length(s) > 0) then begin
        gotoxy(col, lin); textcolor(TColor);
        write(s);
      end;
    end;

  destructor TCDM.done;
    begin
      inherited done;
      Shadow.done;
    end;

end.