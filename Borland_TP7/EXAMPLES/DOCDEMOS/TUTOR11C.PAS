{************************************************}
{                                                }
{   Turbo Vision 2.0 Demo                        }
{   Copyright (c) 1992 by Borland International  }
{                                                }
{************************************************}

program Tutor11c;

uses Memory, TutConst, Drivers, Objects, Views, Menus, App, Dialogs,
  Editors, StdDlg, Validate;

type
  POrder = ^TOrder;
  TOrder = record
    OrderNum: string[8];
    OrderDate: string[8];
    StockNum: string[8];
    Quantity: string[5];
    Payment, Received, MemoLen: Word;
    MemoText: array[0..255] of Char;
  end;

  POrderObj = ^TOrderObj;
  TOrderObj = object(TObject)
    TransferRecord: TOrder;
    constructor Load(var S: TStream);
    procedure Store(var S: TStream);
  end;

  POrderWindow = ^TOrderWindow;
  TOrderWindow = object(TDialog)
    constructor Init;
    destructor Done; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

  TTutorApp = object(TApplication)
    ClipboardWindow: PEditWindow;
    OrderWindow: POrderWindow;
    constructor Init;
    destructor Done; virtual;
    procedure CancelOrder;
    procedure DoAboutBox;
    procedure EnterNewOrder;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure LoadDesktop;
    procedure NewWindow;
    procedure OpenOrderWindow;
    procedure OpenWindow;
    procedure SaveDesktop;
    procedure SaveOrderData;
    procedure ShowOrder(AOrderNum: Integer);
  end;

var
  ResFile: TResourceFile;
  OrderInfo: TOrder;
  OrderColl: PCollection;
  CurrentOrder: Integer;
  TempOrder: POrderObj;

const
  ROrderObj: TStreamRec = (
     ObjType: 15000;
     VmtLink: Ofs(TypeOf(TOrderObj)^);
     Load:    @TOrderObj.Load;
     Store:   @TOrderObj.Store
  );


procedure TutorStreamError(var S: TStream); far;
var
  ErrorMessage: String;
begin
  case S.Status of
    stError: ErrorMessage := 'Stream access error';
    stInitError: ErrorMessage := 'Cannot initialize stream';
    stReadError: ErrorMessage := 'Read beyond end of stream';
    stWriteError: ErrorMessage := 'Cannot expand stream';
    stGetError: ErrorMessage := 'Unregistered type read from stream';
    stPutError: ErrorMessage := 'Unregistered type written to stream';
    end;
  DoneVideo;
  PrintStr('Error: ' + ErrorMessage);
  Halt(Abs(S.Status));
end;

procedure LoadOrders;
var
  OrderFile: TBufStream;
begin
  OrderFile.Init('ORDERS.DAT', stOpenRead, 1024);
  OrderColl := PCollection(OrderFile.Get);
  OrderFile.Done;
end;

procedure SaveOrders;
var
  OrderFile: TBufStream;
begin
  OrderFile.Init('ORDERS.DAT', stOpenWrite, 1024);
  OrderFile.Put(OrderColl);
  OrderFile.Done;
end;

constructor TOrderObj.Load(var S: TStream);
begin
  inherited Init;
  S.Read(TransferRecord, SizeOf(TransferRecord));
end;

procedure TOrderObj.Store(var S: TStream);
begin
  S.Write(TransferRecord, SizeOf(TransferRecord));
end;

constructor TOrderWindow.Init;
var
  R: TRect;
  Field: PInputLine;
  Cluster: PCluster;
  Memo: PMemo;
begin
  R.Assign(0, 0, 60, 17);
  inherited Init(R, 'Orders');
  Options := Options or ofCentered;
  HelpCtx := $F000;

  R.Assign(13, 2, 23, 3);
  Field := New(PInputLine, Init(R, 8));
  Field^.SetValidator(New(PRangeValidator, Init(1, 99999)));
  Insert(Field);
  R.Assign(2, 2, 12, 3);
  Insert(New(PLabel, Init(R, '~O~rder #:', Field)));

  R.Assign(43, 2, 53, 3);
  Field := New(PInputLine, Init(R, 8));
  Field^.SetValidator(New(PPXPictureValidator,
    Init('{#[#]}/{#[#]}/{##[##]}', True)));
  Insert(Field);
  R.Assign(26, 2, 41, 3);
  Insert(New(PLabel, Init(R, '~D~ate of order:', Field)));

  R.Assign(13, 4, 23, 5);
  Field := New(PInputLine, Init(R, 8));
  Field^.SetValidator(New(PPXPictureValidator, Init('&&&-####', True)));
  Insert(Field);
  R.Assign(2, 4, 12, 5);
  Insert(New(PLabel, Init(R, '~S~tock #:', Field)));

  R.Assign(46, 4, 53, 5);
  Field := New(PInputLine, Init(R, 5));
  Field^.SetValidator(New(PRangeValidator, Init(1, 99999)));
  Insert(Field);
  R.Assign(26, 4, 44, 5);
  Insert(New(PLabel, Init(R, '~Q~uantity ordered:', Field)));

  R.Assign(3, 7, 57, 8);
  Cluster := New(PRadioButtons, Init(R,
    NewSItem('Cash   ',
    NewSItem('Check  ',
    NewSItem('P.O.   ',
    NewSItem('Account', nil))))));
  Insert(Cluster);
  R.Assign(2, 6, 21, 7);
  Insert(New(PLabel, Init(R, '~P~ayment method:', Cluster)));

  R.Assign(22, 8, 37, 9);
  Cluster := New(PCheckBoxes, Init(R, NewSItem('~R~eceived', nil)));
  Insert(Cluster);

  R.Assign(3, 10, 57, 13);
  Memo := New(PMemo, Init(R, nil, nil, nil, 255));
  Insert(Memo);
  R.Assign(2, 9, 9, 10);
  Insert(New(PLabel, Init(R, 'Notes:', Memo)));

  R.Assign(2, 14, 12, 16);
  Insert(New(PButton, Init(R, '~N~ew', cmOrderNew, bfNormal)));
  R.Assign(13, 14, 23, 16);
  Insert(New(PButton, Init(R, '~S~ave', cmOrderSave, bfDefault)));
  R.Assign(24, 14, 34, 16);
  Insert(New(PButton, Init(R, 'Re~v~ert', cmOrderCancel, bfNormal)));
  R.Assign(35, 14, 45, 16);
  Insert(New(PButton, Init(R, 'N~e~xt', cmOrderNext, bfNormal)));
  R.Assign(46, 14, 56, 16);
  Insert(New(PButton, Init(R, '~P~rev', cmOrderPrev, bfNormal)));
  SelectNext(False);
end;

destructor TOrderWindow.Done;
begin
  DisableCommands([cmOrderNext, cmOrderPrev, cmOrderSave]);
  inherited Done;
end;

procedure TOrderWindow.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and
    (Event.Command = cmFindOrderWindow) then
    ClearEvent(Event);
end;

constructor TTutorApp.Init;
var
  R: TRect;
begin
  MaxHeapSize := 8192;
  EditorDialog := StdEditorDialog;
  StreamError := @TutorStreamError;
  RegisterMenus;
  RegisterObjects;
  RegisterViews;
  RegisterApp;
  RegisterEditors;
  RegisterDialogs;
  RegisterValidate;
  RegisterType(ROrderObj);
  ResFile.Init(New(PBufStream, Init('TUTORIAL.TVR', stOpenRead, 1024)));
  inherited Init;
  DisableCommands([cmStockWin, cmSupplierWin]);
  Desktop^.GetExtent(R);
  ClipboardWindow := New(PEditWindow, Init(R, '', wnNoNumber));
  if ValidView(ClipboardWindow) <> nil then
  begin
    ClipboardWindow^.Hide;
    InsertWindow(ClipboardWindow);
    Clipboard := ClipboardWindow^.Editor;
    Clipboard^.CanUndo := False;
  end;
  LoadOrders;
  CurrentOrder := 0;
  OrderInfo := POrderObj(OrderColl^.At(CurrentOrder))^.TransferRecord;
  DisableCommands([cmOrderNext, cmOrderPrev, cmOrderCancel, cmOrderSave]);
end;

destructor TTutorApp.Done;
begin
  ResFile.Done;
  inherited Done;
end;

procedure TTutorApp.CancelOrder;
begin
  if CurrentOrder < OrderColl^.Count then
    ShowOrder(CurrentOrder)
  else
  begin
    Dispose(TempOrder, Done);
    ShowOrder(CurrentOrder - 1);
  end;
end;

procedure TTutorApp.DoAboutBox;
begin
  ExecuteDialog(PDialog(ResFile.Get('ABOUTBOX')), nil);
end;

procedure TTutorApp.EnterNewOrder;
begin
  OpenOrderWindow;
  CurrentOrder := OrderColl^.Count;
  TempOrder := New(POrderObj, Init);
  OrderInfo := TempOrder^.TransferRecord;
  OrderWindow^.SetData(OrderInfo);
  DisableCommands([cmOrderNext, cmOrderPrev, cmOrderNew]);
  EnableCommands([cmOrderCancel, cmOrderSave]);
end;

procedure TTutorApp.HandleEvent(var Event: TEvent);
var
  R: TRect;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmOrderNew:
        begin
          EnterNewOrder;
          ClearEvent(Event);
        end;
      cmOrderCancel:
        begin
          CancelOrder;
          ClearEvent(Event);
        end;
      cmOrderNext:
        begin
          ShowOrder(CurrentOrder + 1);
          ClearEvent(Event);
        end;
      cmOrderPrev:
        begin
          ShowOrder(CurrentOrder - 1);
          ClearEvent(Event);
        end;
      cmOrderSave:
        begin
          SaveOrderData;
          ClearEvent(Event);
        end;
      cmOrderWin:
        begin
          OpenOrderWindow;
          ClearEvent(Event);
        end;
      cmOptionsLoad:
        begin
          LoadDesktop;
          ClearEvent(Event);
        end;
      cmOptionsSave:
        begin
          SaveDesktop;
          ClearEvent(Event);
        end;
      cmClipShow:
        with ClipboardWindow^ do
        begin
          Select;
          Show;
          ClearEvent(Event);
        end;
      cmNew:
        begin
          NewWindow;
          ClearEvent(Event);
        end;
      cmOpen:
        begin
          OpenWindow;
          ClearEvent(Event);
        end;
      cmOptionsVideo:
        begin
          SetScreenMode(ScreenMode xor smFont8x8);
          ClearEvent(Event);
        end;
      cmAbout:
        begin
          DoAboutBox;
          ClearEvent(Event);
        end;
    end;
  end;
end;

procedure TTutorApp.InitMenuBar;
begin
  MenuBar := PMenuBar(ResFile.Get('MAINMENU'));
end;

procedure TTutorApp.InitStatusLine;
var
  R: TRect;
begin
  StatusLine := PStatusLine(ResFile.Get('STATUS'));
  GetExtent(R);
  StatusLine^.MoveTo(0, R.B.Y - 1);
end;

procedure TTutorApp.LoadDesktop;
var
  DesktopFile: TBufStream;
  TempDesktop: PDesktop;
  R: TRect;
begin
  DesktopFile.Init('DESKTOP.TUT', stOpenRead, 1024);
  TempDesktop := PDesktop(DesktopFile.Get);
  DesktopFile.Done;
  if ValidView(TempDesktop) <> nil then
  begin
    Desktop^.Delete(ClipboardWindow);
    Delete(Desktop);
    Dispose(Desktop, Done);
    Desktop := TempDesktop;
    Insert(Desktop);
    GetExtent(R);
    R.Grow(0, -1);
    Desktop^.Locate(R);
    InsertWindow(ClipboardWindow);
  end;
end;

procedure TTutorApp.NewWindow;
var
  R: TRect;
  TheWindow: PEditWindow;
begin
  R.Assign(0, 0, 60, 20);
  TheWindow := New(PEditWindow, Init(R, '', wnNoNumber));
  InsertWindow(TheWindow);
end;

procedure TTutorApp.OpenOrderWindow;
begin
  if Message(Desktop, evBroadcast, cmFindOrderWindow, nil) = nil then
  begin
    OrderWindow := New(POrderWindow, Init);
    InsertWindow(OrderWindow);
  end
  else
    if PView(OrderWindow) <> Desktop^.TopView then OrderWindow^.Select;
  ShowOrder(0);
end;

procedure TTutorApp.OpenWindow;
var
  R: TRect;
  FileDialog: PFileDialog;
  TheFile: FNameStr;
const
  FDOptions: Word = fdOKButton or fdOpenButton;
begin
  TheFile := '*.*';
  New(FileDialog, Init(TheFile, 'Open file', '~F~ile name',
    FDOptions, 1));
  if ExecuteDialog(FileDialog, @TheFile) <> cmCancel then
  begin
    R.Assign(0, 0, 75, 20);
    InsertWindow(New(PEditWindow, Init(R, TheFile, wnNoNumber)));
  end;
end;

procedure TTutorApp.SaveDesktop;
var
  DesktopFile: TBufStream;
begin
  Desktop^.Delete(ClipboardWindow);
  DesktopFile.Init('DESKTOP.TUT', stCreate, 1024);
  DesktopFile.Put(Desktop);
  DesktopFile.Done;
  InsertWindow(ClipboardWindow);
end;

procedure TTutorApp.SaveOrderData;
begin
  if OrderWindow^.Valid(cmClose) then
  begin
    OrderWindow^.GetData(OrderInfo);
    if CurrentOrder = OrderColl^.Count then
    begin
      TempOrder^.TransferRecord := OrderInfo;
      OrderColl^.Insert(TempOrder);
    end
    else POrderObj(OrderColl^.At(CurrentOrder))^.TransferRecord := OrderInfo;
    SaveOrders;
    EnableCommands([cmOrderPrev, cmOrderNew]);
  end;
end;

procedure TTutorApp.ShowOrder(AOrderNum: Integer);
begin
  CurrentOrder := AOrderNum;
  OrderInfo := POrderObj(OrderColl^.At(CurrentOrder))^.TransferRecord;
  OrderWindow^.SetData(OrderInfo);
  if CurrentOrder > 0 then EnableCommands([cmOrderPrev])
  else DisableCommands([cmOrderPrev]);
  if OrderColl^.Count > 0 then EnableCommands([cmOrderNext]);
  if CurrentOrder >= OrderColl^.Count - 1 then DisableCommands([cmOrderNext]);
  EnableCommands([cmOrderSave, cmOrderNew]);
end;

var
  TutorApp: TTutorApp;

begin
  TutorApp.Init;
  TutorApp.Run;
  TutorApp.Done;
end.
