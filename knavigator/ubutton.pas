unit UButton;

interface
    uses crt;
    type TButton=object
           constructor init(ITopx, ITopy: integer; TCaption: string; TColor: byte);
           procedure SetFocus;
           procedure out;
           destructor done;

           private
             Caption: string;
             x, y: integer;
             Color: byte;
         end;
implementation
  constructor TButton.init;
    begin
      Caption:='  ' + TCaption + '  '; x:=ITopx; y:=ITopy;
      Color:=TColor;
      textcolor(black); gotoxy(ITopx, ITopy);
      write(Caption);
    end;

  procedure TButton.SetFocus;
    begin
      gotoxy(x, y); textcolor(white); textbackground(green);
      write(Caption);
    end;

  procedure TButton.Out;
    begin
      gotoxy(x, y); textcolor(black); textbackground(color);
      write(Caption);
    end;

  destructor TButton.done;
    begin
      gotoxy(x, y); textcolor(color); textbackground(color);
      write(caption);
    end;

end.