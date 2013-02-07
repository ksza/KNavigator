unit UPrompt;

interface
  uses crt, UBwin, UShadow, UButton;
  type vect = array[1..10]of string;
       TPromptWin = object(TBorderedWin)
         constructor init(ITopx, ITopy: integer; Text: string; Button_Nr: integer; Buttons: vect;
                          BgColor: word; ITitle: string);
         function Select: String;
         destructor done;

         public
           Shadow: TShadow;
           Button: array[1..10]of TButton;
           CurrentButton, BtnNr: 1..10;
           Bt: vect;
       end;

implementation
  constructor TPromptWin.init(ITopx, ITopy: integer; Text: string; Button_Nr: integer; Buttons: vect;
                              BgColor: word; ITitle: string);
    type reper = ^element;
         element = record
           text: string;
           ant, link: reper;
         end;
    var sa1, sa2, p: reper;
        s, s1: string;
        i, nr, k, k1: integer;
        q, w: integer;
    begin
      new(sa1); new(sa2);
      sa1^.link:=sa2; sa2^.ant:=sa1;

      nr:=0; i:=1; s:=''; s1:='';
      while (i <= length(Text)) do begin
        while (Text[i] <> ' ')and(i <= length(Text)) do begin
          s1:=s1 + Text[i]; inc(i);
          if Text[i] = ' ' then s1:=s1 + Text[i];
        end;
        if ((length(s) + length(s1)) > 34)or(i > length(Text)) then begin
          if (i > length(Text)) then s:=s + s1;

          p:=sa2; p^.text:=s;
          new(sa2); p^.link:=sa2; sa2^.ant:=p;

          s:=s1; s1:=''; inc(nr); inc(i);
        end
        else begin
          s:=s + s1;
          s1:=''; inc(i);
        end;
      end;

      Shadow.init(ITopx + 1, ITopy + 1, 40, nr + 7);
      inherited init(ITopx, ITopy, 40, nr + 7, BgColor, White);

      ITitle:=' ' + ITitle + ' ';
      q:=20; w:=length(ITitle);
      while (q > (42 - (q + w - 1))) do
        dec(q);
      gotoxy(q ,1); write(ITitle);

      textcolor(black);
      p:=sa1^.link; i:=2;
      while p <> sa2 do begin
        inc(i); gotoxy(4, i); write(p^.text);
        p:=p^.link;
      end;

      p:=sa1^.link;
      while p <> sa2 do begin
        sa1^.link:=p^.link;
        dispose(p); p:=sa1^.link;
      end;
      dispose(sa1); dispose(sa2);

      BtnNr:=Button_Nr;
      Bt:=Buttons;
      k1:=0;
      for i:=1 to BtnNr do
        k1:=k1 + length(Buttons[i]);
      k:=(38 - k1) div (BtnNr + 1);
      k1:=1;
      for i:=1 to BtnNr do begin
        if (i = 1) then k1:=k1 + k
        else k1:=k1 + length(Buttons[i]) + k;
        Button[i].init(k1, nr + 4, Buttons[i], LightGray);
      end;

      CurrentButton:=1; Button[CurrentButton].SetFocus;
    end;

  function TPromptWin.Select: String;
    var c: char;
    begin
      repeat
        c:=readkey;
        case c of
          #75: begin
                 dec(CurrentButton);
                 if CurrentButton = 0 then begin
                   Button[CurrentButton + 1].Out;
                   CurrentButton:=BtnNr;
                 end
                 else Button[CurrentButton + 1].Out;
                 Button[CurrentButton].SetFocus;
               end;
          #77: begin
                 inc(CurrentButton);
                 if CurrentButton > BtnNr then begin
                   Button[CurrentButton - 1].Out;
                   CurrentButton:=1;
                 end
                 else Button[CurrentButton - 1].Out;
                 Button[CurrentButton].SetFocus;
               end;
          #13: begin
                 Select:=Bt[CurrentButton];
                 c:=#27;
               end;
          #27: Select:='';
        end;
      until c = #27;
    end;

  destructor TPromptWin.done;
    var i: integer;
    begin
      for i:=1 to BtnNr do
        Button[i].done;
      inherited done;
      Shadow.done;
    end;

end.