unit UShadow;

interface
  uses crt, UWindow;
  type TShadow = object(TWin)
         constructor init(ITopx, ITopy, IWidth, IHeight: integer);
         destructor done;
       end;

implementation
  constructor TShadow.init;
    begin
      inherited init(ITopx, ITopy, IWidth, IHeight, Black, Black)
    end;

  destructor TShadow.done;
    begin
      inherited done;
    end;
end.